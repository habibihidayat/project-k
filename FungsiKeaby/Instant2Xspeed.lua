-- ⚡ ULTRA SPEED AUTO FISHING v29.7 (Fixed Loop Consistency)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Hentikan script lama jika masih aktif
if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.1)
end

-- Inisialisasi koneksi network
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

-- Modul utama
local fishing = {
    Running = false,
    WaitingHook = false,
    IsCasting = false,
    IsResetting = false, -- NEW: Prevent concurrent resets
    CurrentCycle = 0,
    TotalFish = 0,
    LastCastTime = 0,
    LastResetTime = 0, -- NEW: Track last reset
    TimeoutTask = nil,
    FallbackTask = nil,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.10,
        HookDetectionDelay = 0.01,
        MaxWaitTime = 1.2, -- Slightly longer for stability
        FallbackTime = 0.80, -- Fixed: was 0.75,// 
        MinCastInterval = 0.05, -- NEW: Minimum time between casts
    }
}

_G.FishingScript = fishing

-- Logging ringkas
local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

-- Fungsi disable animasi
local function disableFishingAnim()
    pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            local name = track.Name:lower()
            if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") then
                track:Stop(0)
            end
        end
    end)

    task.spawn(function()
        local rod = Character:FindFirstChild("Rod") or Character:FindFirstChildWhichIsA("Tool")
        if rod and rod:FindFirstChild("Handle") then
            local handle = rod.Handle
            local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("Motor6D")
            if weld then
                weld.C0 = CFrame.new(0, -1, -1.2) * CFrame.Angles(math.rad(-10), 0, 0)
            end
        end
    end)
end

-- Cleanup timeout tasks (SAFE version)
local function cleanupTimeouts()
    -- Cancel tasks but don't interfere with their execution
    if fishing.TimeoutTask then
        pcall(function() task.cancel(fishing.TimeoutTask) end)
        fishing.TimeoutTask = nil
    end
    if fishing.FallbackTask then
        pcall(function() task.cancel(fishing.FallbackTask) end)
        fishing.FallbackTask = nil
    end
end

-- Safe reset with debounce
local function safeReset()
    if fishing.IsResetting then return end
    fishing.IsResetting = true
    
    local now = tick()
    -- Prevent reset spam (minimum 50ms between resets)
    if now - fishing.LastResetTime < 0.05 then
        fishing.IsResetting = false
        return
    end
    fishing.LastResetTime = now
    
    cleanupTimeouts()
    fishing.WaitingHook = false
    fishing.IsCasting = false
    
    pcall(function()
        RF_CancelFishingInputs:InvokeServer()
    end)
    
    fishing.IsResetting = false
end

-- Scheduled cast (prevents immediate double-casting)
local function scheduleCast(delay)
    delay = delay or 0.01
    task.delay(delay, function()
        if fishing.Running and not fishing.WaitingHook and not fishing.IsCasting then
            fishing.Cast()
        end
    end)
end

-- Fungsi cast dengan PROPER state management
function fishing.Cast()
    -- Multi-layer prevention
    if not fishing.Running then return end
    if fishing.WaitingHook then return end
    if fishing.IsCasting then return end
    if fishing.IsResetting then return end
    
    -- Debounce: minimum interval between casts
    local now = tick()
    if now - fishing.LastCastTime < fishing.Settings.MinCastInterval then
        return
    end

    fishing.IsCasting = true
    cleanupTimeouts()
    disableFishingAnim()
    
    fishing.CurrentCycle += 1
    fishing.LastCastTime = tick()
    log("⚡ Cast #" .. fishing.CurrentCycle)

    local castSuccess = pcall(function()
        local startTime = tick()
        RF_ChargeFishingRod:InvokeServer({[1] = startTime})
        
        task.wait(0.07)
        RF_RequestMinigame:InvokeServer(1, 0, tick())
        
        fishing.WaitingHook = true
        fishing.IsCasting = false
        log("🎯 Hooked!")

        -- Fallback 1: Gentle quick reel
        fishing.FallbackTask = task.delay(fishing.Settings.FallbackTime, function()
            if not fishing.WaitingHook or not fishing.Running then return end
            
            log("⚡ Quick reel")
            pcall(function()
                RE_FishingCompleted:FireServer()
            end)
        end)

        -- Fallback 2: Hard timeout with SAFE recovery
        fishing.TimeoutTask = task.delay(fishing.Settings.MaxWaitTime, function()
            if not fishing.WaitingHook or not fishing.Running then return end
            
            log("⏰ Timeout recovery")
            
            -- Fire completion
            pcall(function()
                RE_FishingCompleted:FireServer()
            end)
            
            -- Small delay to let server respond
            task.wait(0.05)
            
            -- Safe reset
            safeReset()
            
            -- Schedule next cast (prevents immediate collision)
            scheduleCast(0.02)
        end)
    end)

    if not castSuccess then
        log("❌ Cast failed")
        fishing.IsCasting = false
        safeReset()
        scheduleCast(0.1) -- Slightly longer delay on error
    end
end

-- Handle catch yang lebih safe
local function handleCatch()
    if not fishing.Running then return end
    if not fishing.WaitingHook then return end
    
    cleanupTimeouts()
    fishing.WaitingHook = false
    fishing.IsCasting = false
    
    pcall(function()
        RE_FishingCompleted:FireServer()
        log("✅ Reel")
    end)
    
    task.wait(fishing.Settings.CancelDelay)
    
    pcall(function()
        RF_CancelFishingInputs:InvokeServer()
    end)
    
    task.wait(fishing.Settings.FishingDelay)
    scheduleCast() -- Use scheduled cast
end

-- Start / Stop Functions
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.LastCastTime = 0
    fishing.LastResetTime = 0
    fishing.IsCasting = false
    fishing.IsResetting = false

    log("🚀 AUTO FISHING STARTED!")
    log("⚡ Fixed loop consistency system active")
    disableFishingAnim()

    -- Minigame state detector
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if not fishing.WaitingHook then return end
        if typeof(state) ~= "string" then return end
        
        local stateLower = string.lower(state)
        if string.find(stateLower, "hook") or 
           string.find(stateLower, "bite") or 
           string.find(stateLower, "catch") or
           string.find(stateLower, "reel") then
            handleCatch()
        end
    end)

    -- Fish caught detector
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        
        cleanupTimeouts()
        fishing.WaitingHook = false
        fishing.IsCasting = false
        fishing.TotalFish += 1
        
        local weight = data and data.Weight or 0
        local cycleTime = tick() - fishing.LastCastTime
        log("🐟 " .. tostring(name) .. " (" .. string.format("%.2f", weight) .. "kg) | #" .. fishing.TotalFish .. " | " .. string.format("%.2f", cycleTime) .. "s")

        task.wait(fishing.Settings.CancelDelay)
        
        pcall(function()
            RF_CancelFishingInputs:InvokeServer()
        end)

        task.wait(fishing.Settings.FishingDelay)
        scheduleCast() -- Use scheduled cast
    end)

    -- Animation disabler
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.15)
        end
    end)

    -- Watchdog: ONLY for extreme stuck cases (2.5s+)
    fishing.Connections.Watchdog = task.spawn(function()
        while fishing.Running do
            task.wait(2.5) -- Much longer interval
            
            if not fishing.Running then break end
            if not fishing.WaitingHook then continue end
            
            local stuckTime = tick() - fishing.LastCastTime
            if stuckTime > 2.5 then -- Higher threshold
                log("🔧 Critical stuck " .. string.format("%.1f", stuckTime) .. "s")
                safeReset()
                scheduleCast(0.1)
            end
        end
    end)

    task.wait(0.3)
    fishing.Cast()
end

function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    
    cleanupTimeouts()
    fishing.WaitingHook = false
    fishing.IsCasting = false
    fishing.IsResetting = false

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

-- 🎯 COMMANDS FOR GUI:
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()
-- _G.FishingScript.TotalFish
-- _G.FishingScript.Running
--
-- FINE TUNING:
-- _G.FishingScript.Settings.FallbackTime = 0.80
-- _G.FishingScript.Settings.MaxWaitTime = 1.2
-- _G.FishingScript.Settings.MinCastInterval = 0.05

return fishing
