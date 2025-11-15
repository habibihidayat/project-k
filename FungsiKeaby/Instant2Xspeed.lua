-- ⚡ ULTRA SPEED AUTO FISHING v29.5 (No Auto-Start / Controlled by GUI)
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
    CurrentCycle = 0,
    TotalFish = 0,
    LastCastTime = 0,
    TimeoutTask = nil, -- Track timeout task
    FallbackTask = nil, -- Track fallback task
    Connections = {},
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.15,
        HookDetectionDelay = 0.01,
        RetryDelay = 0.40,
        MaxWaitTime = 1.0, -- Timeout lebih ketat untuk speed
        FallbackTime = 0.70, -- Fallback cepat
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

-- Cleanup timeout tasks
local function cleanupTimeouts()
    if fishing.TimeoutTask then
        task.cancel(fishing.TimeoutTask)
        fishing.TimeoutTask = nil
    end
    if fishing.FallbackTask then
        task.cancel(fishing.FallbackTask)
        fishing.FallbackTask = nil
    end
end

-- Force reset state
local function forceResetState()
    cleanupTimeouts()
    fishing.WaitingHook = false
    
    pcall(function()
        RF_CancelFishingInputs:InvokeServer()
    end)
end

-- Fungsi utama cast dengan improved timeout
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

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
        log("🎯 Hooked!")

        -- ⚡ IMPROVED DUAL FALLBACK SYSTEM
        -- Fallback 1: Quick reel (gentle, cepat)
        fishing.FallbackTask = task.delay(fishing.Settings.FallbackTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚡ Quick reel...")
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
            end
        end)

        -- Fallback 2: Hard timeout (force reset)
        fishing.TimeoutTask = task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚠️ Force reset")
                
                -- Hard reset
                forceResetState()
                
                -- Immediate retry
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end)
    end)

    if not castSuccess then
        log("❌ Cast failed, quick retry...")
        forceResetState()
        task.wait(fishing.Settings.RetryDelay * 0.5)
        if fishing.Running then
            fishing.Cast()
        end
    end
end

-- Handle catch yang lebih responsif
local function handleCatch()
    if not fishing.Running then return end
    
    cleanupTimeouts()
    fishing.WaitingHook = false
    
    pcall(function()
        RE_FishingCompleted:FireServer()
        log("✅ Reeling!")
    end)
    
    task.wait(fishing.Settings.CancelDelay)
    
    pcall(function()
        RF_CancelFishingInputs:InvokeServer()
        log("🔄 Reset")
    end)
    
    task.wait(fishing.Settings.FishingDelay)
    if fishing.Running then
        fishing.Cast()
    end
end

-- Start / Stop Functions
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.LastCastTime = 0

    log("🚀 AUTO FISHING STARTED!")
    log("⚡ Improved cycle consistency active")
    disableFishingAnim()

    -- Minigame state detector (paling responsif)
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local stateLower = string.lower(state)
            if string.find(stateLower, "hook") or 
               string.find(stateLower, "bite") or 
               string.find(stateLower, "catch") or
               string.find(stateLower, "reel") then
                handleCatch()
            end
        end
    end)

    -- Fish caught detector (backup)
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            cleanupTimeouts()
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            
            local weight = data and data.Weight or 0
            local cycleTime = tick() - fishing.LastCastTime
            log("🐟 " .. tostring(name) .. " (" .. string.format("%.2f", weight) .. "kg) | Total: " .. fishing.TotalFish .. " | " .. string.format("%.2f", cycleTime) .. "s")

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

    -- Animation disabler
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.1)
        end
    end)

    -- Watchdog: deteksi stuck cycle
    fishing.Connections.Watchdog = task.spawn(function()
        while fishing.Running do
            task.wait(2.0)
            
            if fishing.Running and fishing.WaitingHook then
                local stuckTime = tick() - fishing.LastCastTime
                if stuckTime > 1.8 then
                    log("🔧 Stuck detected (" .. string.format("%.1f", stuckTime) .. "s) - Recovery")
                    forceResetState()
                    task.wait(fishing.Settings.FishingDelay)
                    if fishing.Running then
                        fishing.Cast()
                    end
                end
            end
        end
    end)

    -- Auto cast loop untuk memastikan tidak ada idle
    fishing.Connections.AutoCast = task.spawn(function()
        while fishing.Running do
            task.wait(0.05)
            if fishing.Running and not fishing.WaitingHook then
                local idleTime = tick() - fishing.LastCastTime
                if idleTime > 0.5 then -- Jika idle lebih dari 0.5s
                    log("🔄 Auto re-cast")
                    fishing.Cast()
                end
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

    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            task.cancel(conn)
        end
    end
    fishing.Connections = {}

    local avgCycle = fishing.TotalFish > 0 and (tick() - fishing.LastCastTime) / fishing.TotalFish or 0
    log("🛑 STOPPED | Total: " .. fishing.TotalFish .. " fish | Avg: " .. string.format("%.2f", avgCycle) .. "s")
end

-- 🎯 COMMANDS FOR GUI:
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()
-- _G.FishingScript.TotalFish (read total fish caught)
-- _G.FishingScript.Running (check if running)
--
-- FINE TUNING:
-- _G.FishingScript.Settings.FallbackTime = 0.70
-- _G.FishingScript.Settings.MaxWaitTime = 1.0
-- _G.FishingScript.Settings.RetryDelay = 0.40

return fishing
