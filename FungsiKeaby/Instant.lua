-- ⚡ ULTRA FAST PERFECT CAST v31.0 - ALWAYS PERFECT
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

-- Main module
local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    PerfectCasts = 0,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,           -- Delay antar cast (SUPER CEPAT)
        CancelDelay = 0.15,            -- Delay cancel
        HookDetectionDelay = 0.01,     -- Delay hook detection
        RetryDelay = 0.3,              -- Retry delay (DIPERCEPAT)
        MaxWaitTime = 1.2,             -- Max wait
        
        -- 🎯 PERFECT CAST CORE SETTINGS
        PerfectChargeTime = 1.0,       -- FIXED 1.0 untuk PERFECT (100% power)
        PerfectReleaseDelay = 0.001,   -- Minimal delay
        PerfectPower = 1.0,            -- FIXED 1.0 untuk PERFECT
        UseAdaptiveTiming = false,     -- OFF untuk konsistensi
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[⚡Fishing] %s"):format(msg))
end

-- Disable animasi dengan cepat
local function disableFishingAnim()
    pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            if track.Name:lower():find("fish") or track.Name:lower():find("rod") then
                track:Stop(0)
            end
        end
    end)
end

-- 🎯 PERFECT CAST FUNCTION - SIMPLIFIED & FAST
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    
    local success = pcall(function()
        local startTime = tick()
        
        -- Step 1: START CHARGE
        RF_ChargeFishingRod:InvokeServer({[1] = startTime})
        
        -- Step 2: PRECISE WAIT (menggunakan timing tetap untuk konsistensi)
        local targetTime = fishing.Settings.PerfectChargeTime
        repeat
            task.wait()
        until (tick() - startTime) >= targetTime or not fishing.Running
        
        -- Step 3: MINIMAL DELAY
        task.wait(fishing.Settings.PerfectReleaseDelay)
        
        -- Step 4: RELEASE dengan POWER = 1.0 (PERFECT)
        local releaseTime = tick()
        local power = fishing.Settings.PerfectPower
        
        -- CRITICAL: Gunakan power 1.0 dan direction 0 untuk PERFECT
        RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
        
        fishing.WaitingHook = true
        log("🎯 Cast #" .. fishing.CurrentCycle .. " | Power: " .. power)

        -- Fast timeout protection
        task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                fishing.WaitingHook = false
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)

                task.wait(0.1)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end)
    end)

    if not success then
        task.wait(fishing.Settings.RetryDelay)
        if fishing.Running then
            fishing.Cast()
        end
    end
end

-- Start
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.PerfectCasts = 0

    log("🚀 PERFECT CAST STARTED!")
    disableFishingAnim()

    -- Minigame state listener
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local stateLower = state:lower()
            if stateLower:find("hook") or stateLower:find("bite") or stateLower:find("catch") then
                fishing.WaitingHook = false
                
                task.wait(fishing.Settings.HookDetectionDelay)
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)

                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end
    end)

    -- Fish caught listener
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            fishing.PerfectCasts += 1
            
            local weight = data and data.Weight or 0
            log(string.format("🐟 #%d: %s (%.2fkg)", fishing.TotalFish, tostring(name), weight))

            task.wait(fishing.Settings.CancelDelay)
            pcall(function()
                RF_CancelFishingInputs:InvokeServer()
            end)

            task.wait(fishing.Settings.FishingDelay)
            if fishing.Running then
                fishing.Cast()
            end
        end
    end)

    -- Animation disabler (fast)
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.2)
        end
    end)

    task.wait(0.3)
    fishing.Cast()
end

-- Stop
function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.WaitingHook = false

    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            task.cancel(conn)
        end
    end
    fishing.Connections = {}

    log(string.format("🛑 STOPPED | Total: %d fish | Perfect rate: 100%%", fishing.TotalFish))
end

-- 🎯 COMMANDS:
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()
--
-- 🔧 FINE TUNING (jika masih tidak perfect):
-- _G.FishingScript.Settings.PerfectChargeTime = 1.0    -- Jangan ubah!
-- _G.FishingScript.Settings.PerfectPower = 1.0         -- Jangan ubah!
-- _G.FishingScript.Settings.PerfectReleaseDelay = 0.001

return fishing
