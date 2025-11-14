-- ⚡ ULTRA SPEED AUTO FISHING v38.0 (Server-Synced Perfect Timing)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.15)
end

local netFolder = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")
local RE_FishCaught = netFolder:WaitForChild("RE/FishCaught")

local fishing = {
    Running = false,
    Locked = false,
    WaitingForHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    Connections = {},
    
    -- Server sync tracking
    LastServerResponseTime = 0,
    AverageServerDelay = 0.08,
    ServerDelays = {},
    
    Settings = {
        -- Core timing - DIATUR DARI GUI
        CastDelay = 0.002,
        ResetDelay = 0.08,
        HookResponseDelay = 0.01,
        TimeoutDuration = 1.5,
        
        -- Charge timing - CRITICAL untuk cast quality
        ChargeHoldTime = 0.001,        -- Waktu hold sebelum release (instant)
        PreMinigameDelay = 0.001,      -- Delay sebelum minigame request
        PostMinigameWait = 0.05,       // Tunggu server ready
        
        -- Animation
        AnimCheckInterval = 0.1,
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[Fish] " .. msg))
end

local function isRodReady()
    local rod = Character:FindFirstChild("Rod") or Character:FindFirstChildWhichIsA("Tool")
    return rod and rod:FindFirstChild("Handle") and rod.Handle.Parent ~= nil
end

local function ensureRod()
    if isRodReady() then return true end
    local bp = localPlayer:FindFirstChild("Backpack")
    if bp then
        local rod = bp:FindFirstChild("Rod")
        if rod then
            Humanoid:EquipTool(rod)
            task.wait(0.02)
            return isRodReady()
        end
    end
    return false
end

local function killAnims()
    for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
        local n = track.Name:lower()
        if n:find("fish") or n:find("rod") or n:find("cast") or n:find("reel") then
            track:Stop(0)
        end
    end
end

-- CORE CAST FUNCTION - Simplified & Synced
function fishing.DoCast()
    if fishing.Locked or fishing.WaitingForHook or not fishing.Running then 
        return 
    end
    
    if not ensureRod() then
        log("❌ No rod")
        return
    end
    
    fishing.Locked = true
    fishing.CurrentCycle += 1
    local cycle = fishing.CurrentCycle
    
    killAnims()
    log("⚡ Cast #" .. cycle)
    
    task.spawn(function()
        local castStart = tick()
        local success, err = pcall(function()
            -- PHASE 1: CHARGE (with server sync compensation)
            local chargeTimestamp = tick()
            
            -- Invoke charge - server starts tracking
            local chargeResult = RF_ChargeFishingRod:InvokeServer({[1] = chargeTimestamp})
            
            -- Track server response time
            local serverResponseTime = tick() - chargeTimestamp
            table.insert(fishing.ServerDelays, serverResponseTime)
            if #fishing.ServerDelays > 10 then
                table.remove(fishing.ServerDelays, 1)
            end
            
            -- Calculate average server delay
            local sum = 0
            for _, d in ipairs(fishing.ServerDelays) do
                sum = sum + d
            end
            fishing.AverageServerDelay = #fishing.ServerDelays > 0 and (sum / #fishing.ServerDelays) or 0.08
            
            -- TINY hold untuk cast quality
            task.wait(fishing.Settings.ChargeHoldTime)
            
            -- PHASE 2: REQUEST MINIGAME
            -- Compensate untuk server delay
            task.wait(fishing.Settings.PreMinigameDelay)
            
            -- Request dengan SAME timestamp untuk perfect sync
            local minigameResult = RF_RequestMinigame:InvokeServer(1, 0, chargeTimestamp)
            
            -- Wait untuk server process
            task.wait(fishing.Settings.PostMinigameWait)
            
            -- PHASE 3: WAIT FOR HOOK
            fishing.Locked = false
            fishing.WaitingForHook = true
            fishing.LastCastTime = castStart
            
            log("🎯 Wait hook #" .. cycle .. " [Srv: " .. string.format("%.0f", fishing.AverageServerDelay * 1000) .. "ms]")
            
            -- Timeout handler
            task.delay(fishing.Settings.TimeoutDuration, function()
                if fishing.WaitingForHook and fishing.Running then
                    fishing.WaitingForHook = false
                    log("⏰ Timeout #" .. cycle)
                    
                    pcall(function()
                        RE_FishingCompleted:FireServer()
                    end)
                    
                    task.wait(fishing.Settings.ResetDelay)
                    
                    pcall(function()
                        RF_CancelFishingInputs:InvokeServer()
                    end)
                    
                    task.wait(fishing.Settings.CastDelay)
                    
                    if fishing.Running and not fishing.Locked then
                        fishing.DoCast()
                    end
                end
            end)
        end)
        
        if not success then
            log("❌ Error: " .. tostring(err))
            fishing.Locked = false
            fishing.WaitingForHook = false
            task.wait(0.1)
            if fishing.Running then
                fishing.DoCast()
            end
        end
    end)
end

function fishing.Start()
    if fishing.Running then return end
    
    log("🚀 Starting...")
    
    if not ensureRod() then
        log("❌ No fishing rod found!")
        return
    end
    
    fishing.Running = true
    fishing.Locked = false
    fishing.WaitingForHook = false
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.ServerDelays = {}
    fishing.AverageServerDelay = 0.08
    
    killAnims()
    
    -- HOOK DETECTION
    fishing.Connections.Hook = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if not fishing.WaitingForHook or not fishing.Running then return end
        
        if typeof(state) == "string" then
            local s = string.lower(state)
            if s:find("hook") or s:find("bite") or s:find("catch") or s:find("pull") or s:find("!") then
                fishing.WaitingForHook = false
                
                local hookTime = tick() - (fishing.LastCastTime or tick())
                log("🎣 HOOK! (" .. string.format("%.2f", hookTime) .. "s)")
                
                -- INSTANT PULL
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                task.wait(fishing.Settings.HookResponseDelay)
                task.wait(fishing.Settings.ResetDelay)
                
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                
                task.wait(fishing.Settings.CastDelay)
                
                if fishing.Running and not fishing.Locked then
                    fishing.DoCast()
                end
            end
        end
    end)
    
    -- FISH CAUGHT
    fishing.Connections.Catch = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        
        fishing.WaitingForHook = false
        fishing.TotalFish += 1
        
        local weight = data and data.Weight or 0
        log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)")
        
        task.wait(fishing.Settings.ResetDelay)
        
        pcall(function()
            RF_CancelFishingInputs:InvokeServer()
        end)
        
        task.wait(fishing.Settings.CastDelay)
        
        if fishing.Running and not fishing.Locked then
            fishing.DoCast()
        end
    end)
    
    -- ANIM KILLER
    fishing.Connections.Anim = RunService.Heartbeat:Connect(function()
        if fishing.Running then
            killAnims()
        end
    end)
    
    log("✅ Started!")
    
    -- First cast
    task.wait(0.1)
    if fishing.Running then
        fishing.DoCast()
    end
end

function fishing.Stop()
    if not fishing.Running then return end
    
    fishing.Running = false
    fishing.Locked = false
    fishing.WaitingForHook = false
    
    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            pcall(function() conn:Disconnect() end)
        end
    end
    fishing.Connections = {}
    
    log("🛑 Stopped | Fish: " .. fishing.TotalFish .. " | Avg srv: " .. string.format("%.0f", fishing.AverageServerDelay * 1000) .. "ms")
end

function fishing.UpdateSettings(new)
    for k, v in pairs(new) do
        if fishing.Settings[k] ~= nil then
            fishing.Settings[k] = v
            log("⚙️ " .. k .. " = " .. tostring(v))
        end
    end
end

function fishing.GetSettings()
    return fishing.Settings
end

function fishing.GetStats()
    return {
        Running = fishing.Running,
        TotalFish = fishing.TotalFish,
        CurrentCycle = fishing.CurrentCycle,
        WaitingForHook = fishing.WaitingForHook,
        AverageServerDelay = fishing.AverageServerDelay,
    }
end

return fishing
