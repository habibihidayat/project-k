-- ⚡ ULTRA FAST AUTO FISHING v39.0 PREMIUM (Maximum Speed + Spam Cast)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.1)
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
    LastCastTime = 0,
    
    -- Advanced tracking
    ServerDelays = {},
    AverageServerDelay = 0.05,
    FastMode = true,
    SpamCast = true,
    
    Settings = {
        -- ULTRA FAST TIMING - Optimized untuk kecepatan maksimal
        CastDelay = 0.001,              -- Hampir instant cast
        ResetDelay = 0.03,              -- Minimal reset time
        HookResponseDelay = 0.005,      -- Instant hook response
        TimeoutDuration = 1.2,          -- Shorter timeout
        
        -- CHARGE TIMING - Zero delay untuk spam
        ChargeHoldTime = 0,             -- NO HOLD = instant
        PreMinigameDelay = 0,           -- NO DELAY
        PostMinigameWait = 0.02,        -- Minimal wait
        
        -- SPAM SETTINGS
        ParallelCasts = false,          -- Cast paralel (risky tapi cepat)
        AggressiveMode = true,          -- Mode agresif
        SkipAnimations = true,          -- Skip semua animasi
        InstantPull = true,             -- Instant pull tanpa delay
        
        -- Animation
        AnimCheckInterval = 0.05,
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[⚡Fish] " .. msg))
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
            task.wait(0.01)
            return isRodReady()
        end
    end
    return false
end

local function killAnims()
    if not fishing.Settings.SkipAnimations then return end
    for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
        track:Stop(0)
    end
end

-- ULTRA FAST CAST - Zero delay optimized
function fishing.DoCast()
    if fishing.Locked or not fishing.Running then 
        return 
    end
    
    if not fishing.Settings.ParallelCasts and fishing.WaitingForHook then
        return
    end
    
    if not ensureRod() then
        return
    end
    
    fishing.Locked = true
    fishing.CurrentCycle += 1
    local cycle = fishing.CurrentCycle
    
    task.spawn(function()
        local castStart = tick()
        local success, err = pcall(function()
            
            -- INSTANT CHARGE + MINIGAME REQUEST
            local timestamp = tick()
            
            -- Parallel execution untuk speed
            local chargeTask = task.spawn(function()
                RF_ChargeFishingRod:InvokeServer({[1] = timestamp})
            end)
            
            -- Tunggu minimal (atau skip jika aggressive)
            if fishing.Settings.ChargeHoldTime > 0 then
                task.wait(fishing.Settings.ChargeHoldTime)
            end
            
            -- INSTANT minigame request
            if fishing.Settings.PreMinigameDelay > 0 then
                task.wait(fishing.Settings.PreMinigameDelay)
            end
            
            RF_RequestMinigame:InvokeServer(1, 0, timestamp)
            
            -- Minimal wait
            if fishing.Settings.PostMinigameWait > 0 then
                task.wait(fishing.Settings.PostMinigameWait)
            end
            
            -- Unlock ASAP
            fishing.Locked = false
            fishing.WaitingForHook = true
            fishing.LastCastTime = castStart
            
            if cycle % 10 == 0 then
                log("🎯 Cast #" .. cycle)
            end
            
            -- AGGRESSIVE TIMEOUT
            task.delay(fishing.Settings.TimeoutDuration, function()
                if fishing.WaitingForHook and fishing.Running then
                    fishing.WaitingForHook = false
                    
                    -- Fast cleanup
                    task.spawn(function()
                        pcall(function()
                            RE_FishingCompleted:FireServer()
                        end)
                    end)
                    
                    task.wait(fishing.Settings.ResetDelay)
                    
                    task.spawn(function()
                        pcall(function()
                            RF_CancelFishingInputs:InvokeServer()
                        end)
                    end)
                    
                    task.wait(fishing.Settings.CastDelay)
                    
                    if fishing.Running and not fishing.Locked then
                        fishing.DoCast()
                    end
                end
            end)
        end)
        
        if not success then
            fishing.Locked = false
            fishing.WaitingForHook = false
            task.wait(0.05)
            if fishing.Running then
                fishing.DoCast()
            end
        end
    end)
end

-- SPAM CAST LOOP - Untuk mode agresif
function fishing.SpamCastLoop()
    while fishing.Running and fishing.Settings.ParallelCasts do
        if not fishing.Locked then
            fishing.DoCast()
        end
        task.wait(0.1) -- Spam interval
    end
end

function fishing.Start()
    if fishing.Running then return end
    
    log("🚀 PREMIUM MODE STARTING...")
    
    if not ensureRod() then
        log("❌ No fishing rod!")
        return
    end
    
    fishing.Running = true
    fishing.Locked = false
    fishing.WaitingForHook = false
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.ServerDelays = {}
    
    killAnims()
    
    -- ULTRA FAST HOOK DETECTION
    fishing.Connections.Hook = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if not fishing.WaitingForHook or not fishing.Running then return end
        
        if typeof(state) == "string" then
            local s = string.lower(state)
            if s:find("hook") or s:find("bite") or s:find("catch") or s:find("pull") or s:find("!") then
                fishing.WaitingForHook = false
                
                local hookTime = tick() - (fishing.LastCastTime or tick())
                
                -- INSTANT PULL - NO DELAY
                task.spawn(function()
                    pcall(function()
                        RE_FishingCompleted:FireServer()
                    end)
                end)
                
                if fishing.Settings.InstantPull then
                    -- Skip all delays untuk instant pull
                    task.wait(0.01)
                else
                    task.wait(fishing.Settings.HookResponseDelay)
                    task.wait(fishing.Settings.ResetDelay)
                end
                
                task.spawn(function()
                    pcall(function()
                        RF_CancelFishingInputs:InvokeServer()
                    end)
                end)
                
                task.wait(fishing.Settings.CastDelay)
                
                if fishing.Running and not fishing.Locked then
                    fishing.DoCast()
                end
            end
        end
    end)
    
    -- FISH CAUGHT - Instant recast
    fishing.Connections.Catch = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        
        fishing.WaitingForHook = false
        fishing.TotalFish += 1
        
        if fishing.TotalFish % 5 == 0 then
            local weight = data and data.Weight or 0
            log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)")
        end
        
        -- MINIMAL DELAY untuk instant recast
        task.wait(fishing.Settings.ResetDelay * 0.5)
        
        task.spawn(function()
            pcall(function()
                RF_CancelFishingInputs:InvokeServer()
            end)
        end)
        
        task.wait(fishing.Settings.CastDelay)
        
        if fishing.Running and not fishing.Locked then
            fishing.DoCast()
        end
    end)
    
    -- AGGRESSIVE ANIM KILLER
    if fishing.Settings.SkipAnimations then
        fishing.Connections.Anim = RunService.Heartbeat:Connect(function()
            if fishing.Running then
                killAnims()
            end
        end)
    end
    
    log("✅ PREMIUM MODE ACTIVE!")
    log("⚙️ Aggressive: " .. tostring(fishing.Settings.AggressiveMode))
    log("⚙️ InstantPull: " .. tostring(fishing.Settings.InstantPull))
    
    -- Start spam loop if enabled
    if fishing.Settings.ParallelCasts then
        task.spawn(function()
            fishing.SpamCastLoop()
        end)
    end
    
    -- First cast
    task.wait(0.05)
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
    
    log("🛑 STOPPED | Total Fish: " .. fishing.TotalFish)
end

function fishing.UpdateSettings(new)
    for k, v in pairs(new) do
        if fishing.Settings[k] ~= nil then
            fishing.Settings[k] = v
            log("⚙️ " .. k .. " = " .. tostring(v))
        end
    end
end

function fishing.SetPreset(preset)
    if preset == "ULTRA_FAST" then
        fishing.Settings.CastDelay = 0.001
        fishing.Settings.ResetDelay = 0.02
        fishing.Settings.ChargeHoldTime = 0
        fishing.Settings.PreMinigameDelay = 0
        fishing.Settings.PostMinigameWait = 0.01
        fishing.Settings.InstantPull = true
        fishing.Settings.AggressiveMode = true
        log("🔥 ULTRA FAST preset activated!")
        
    elseif preset == "SPAM" then
        fishing.Settings.CastDelay = 0
        fishing.Settings.ResetDelay = 0.01
        fishing.Settings.ChargeHoldTime = 0
        fishing.Settings.PreMinigameDelay = 0
        fishing.Settings.PostMinigameWait = 0
        fishing.Settings.ParallelCasts = true
        fishing.Settings.InstantPull = true
        log("💥 SPAM preset activated!")
        
    elseif preset == "SAFE" then
        fishing.Settings.CastDelay = 0.05
        fishing.Settings.ResetDelay = 0.1
        fishing.Settings.ChargeHoldTime = 0.001
        fishing.Settings.PreMinigameDelay = 0.001
        fishing.Settings.PostMinigameWait = 0.05
        fishing.Settings.ParallelCasts = false
        fishing.Settings.InstantPull = false
        log("🛡️ SAFE preset activated!")
    end
end

function fishing.GetStats()
    return {
        Running = fishing.Running,
        TotalFish = fishing.TotalFish,
        CurrentCycle = fishing.CurrentCycle,
        FishPerMinute = fishing.TotalFish > 0 and (fishing.TotalFish / ((tick() - (fishing.StartTime or tick())) / 60)) or 0,
    }
end

-- Set start time
fishing.StartTime = tick()

return fishing
