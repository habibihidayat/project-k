-- ⚡ ULTRA SPEED AUTO FISHING v32.0 (Anti-Jeda & Anti-Double Cast)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Hentikan script lama
if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.05)
end

-- Network connections
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

-- Main module dengan MUTEX LOCK
local fishing = {
    Running = false,
    Locked = false,  -- MUTEX LOCK untuk mencegah double cast
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    Connections = {},
    CastQueue = 0,  -- Counter untuk track pending casts
    
    Settings = {
        FishingDelay = 0.003,
        CancelDelay = 0.08,
        HookDetectionDelay = 0.01,
        MaxWaitTime = 1.0,
        ChargeDelay = 0.02,
        PostCastDelay = 0.04,
        AnimDisableInterval = 0.08,
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

-- Disable animations
local function disableFishingAnim()
    task.spawn(function()
        pcall(function()
            for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") or name:find("throw") then
                    track:Stop(0)
                    track.TimePosition = 0
                end
            end
        end)

        pcall(function()
            local rod = Character:FindFirstChild("Rod") or Character:FindFirstChildWhichIsA("Tool")
            if rod and rod:FindFirstChild("Handle") then
                local handle = rod.Handle
                local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("Motor6D")
                if weld then
                    weld.C0 = CFrame.new(0, -1, -1.2) * CFrame.Angles(math.rad(-10), 0, 0)
                end
            end
        end)
    end)
end

-- MUTEX LOCK untuk Cast - Mencegah double execution
function fishing.Cast()
    -- Check lock PERTAMA sebelum apapun
    if fishing.Locked or fishing.WaitingHook or not fishing.Running then
        return
    end
    
    -- ACQUIRE LOCK
    fishing.Locked = true
    fishing.CurrentCycle += 1
    
    disableFishingAnim()
    
    local cycleNum = fishing.CurrentCycle
    log("⚡ Cast #" .. cycleNum)

    local success = pcall(function()
        local timestamp = tick()
        
        -- ATOMIC CAST SEQUENCE
        -- Step 1: Charge
        local chargeOK = pcall(function()
            RF_ChargeFishingRod:InvokeServer({[1] = timestamp})
        end)
        
        if not chargeOK then
            log("❌ Charge failed")
            fishing.Locked = false
            task.wait(0.05)
            if fishing.Running then fishing.Cast() end
            return
        end
        
        -- Step 2: Wait minimal
        task.wait(fishing.Settings.ChargeDelay)
        
        -- Step 3: Request Minigame
        local minigameOK = pcall(function()
            RF_RequestMinigame:InvokeServer(1, 0, timestamp)
        end)
        
        if not minigameOK then
            log("❌ Minigame request failed")
            fishing.Locked = false
            task.wait(0.05)
            if fishing.Running then fishing.Cast() end
            return
        end
        
        -- Step 4: Post-cast delay
        task.wait(fishing.Settings.PostCastDelay)
        
        -- RELEASE LOCK sebelum waiting hook
        fishing.Locked = false
        fishing.WaitingHook = true
        log("🎯 Waiting hook #" .. cycleNum)
        
        -- Single fallback timer
        local fallbackTimer = task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                fishing.WaitingHook = false
                log("⏰ Timeout #" .. cycleNum)
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                task.wait(fishing.Settings.CancelDelay)
                
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running and not fishing.Locked then
                    fishing.Cast()
                end
            end
        end)
    end)
    
    if not success then
        log("❌ Cast error")
        fishing.Locked = false
        fishing.WaitingHook = false
        task.wait(0.05)
        if fishing.Running then
            fishing.Cast()
        end
    end
end

-- Start Function dengan SINGLE THREAD control
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.Locked = false
    fishing.WaitingHook = false
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.CastQueue = 0

    log("🚀 SPAM FISHING - NO JEDA MODE!")
    disableFishingAnim()

    -- Hook Detection - PRIORITY EVENT
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if not fishing.WaitingHook or not fishing.Running then return end
        
        if typeof(state) == "string" then
            local stateLower = string.lower(state)
            if string.find(stateLower, "hook") or 
               string.find(stateLower, "bite") or 
               string.find(stateLower, "catch") or
               string.find(stateLower, "pull") or
               string.find(stateLower, "reel") or
               string.find(stateLower, "!") then
                
                fishing.WaitingHook = false
                log("🎣 HOOK!")
                
                -- Instant pull
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                task.wait(fishing.Settings.HookDetectionDelay)
                
                -- Reset & recast IMMEDIATELY
                task.spawn(function()
                    task.wait(fishing.Settings.CancelDelay)
                    pcall(function()
                        RF_CancelFishingInputs:InvokeServer()
                    end)
                    
                    task.wait(fishing.Settings.FishingDelay)
                    
                    -- Pastikan tidak double cast
                    if fishing.Running and not fishing.Locked and not fishing.WaitingHook then
                        fishing.Cast()
                    end
                end)
            end
        end
    end)

    -- Fish Caught Handler
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        
        fishing.WaitingHook = false
        fishing.TotalFish += 1
        local weight = data and data.Weight or 0
        log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)")

        task.spawn(function()
            task.wait(fishing.Settings.CancelDelay)
            pcall(function()
                RF_CancelFishingInputs:InvokeServer()
            end)
            
            task.wait(fishing.Settings.FishingDelay)
            
            -- Pastikan tidak double cast
            if fishing.Running and not fishing.Locked and not fishing.WaitingHook then
                fishing.Cast()
            end
        end)
    end)

    -- Animation Disabler
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(fishing.Settings.AnimDisableInterval)
        end
    end)

    -- SINGLE initial cast
    task.wait(0.05)
    if fishing.Running and not fishing.Locked then
        fishing.Cast()
    end
end

-- Stop Function
function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.Locked = false
    fishing.WaitingHook = false

    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            task.cancel(conn)
        end
    end
    fishing.Connections = {}

    log("🛑 STOPPED | Total: " .. fishing.TotalFish .. " fish")
end

-- Update settings
function fishing.UpdateSettings(newSettings)
    for key, value in pairs(newSettings) do
        if fishing.Settings[key] ~= nil then
            fishing.Settings[key] = value
            log("⚙️ " .. key .. " = " .. tostring(value))
        end
    end
end

function fishing.GetSettings()
    return fishing.Settings
end

return fishing
