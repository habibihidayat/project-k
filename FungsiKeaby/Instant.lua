-- ⚡ ULTRA SPEED AUTO FISHING v29.4 (Improved Cycle Consistency)
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
    PerfectCasts = 0,
    TimeoutTask = nil, -- Track timeout task untuk dibatalkan
    FallbackTask = nil, -- Track fallback task
    LastCastTime = 0,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.15, -- Kurangi sedikit
        HookDetectionDelay = 0.01,
        RetryDelay = 0.45, -- Kurangi retry delay
        MaxWaitTime = 1.1, -- Kurangi max wait
        FallbackTime = 0.75, -- Waktu fallback lebih cepat
        -- ⭐ Multiple timing modes
        CastMode = "perfect",
        ChargeTime = 1.0,
        ReleaseDelay = 0.001,
    }
}

_G.FishingScript = fishing

-- Preset timing untuk berbagai mode
local CAST_PRESETS = {
    perfect = {
        chargeTime = 1.0,
        releaseDelay = 0.001,
        power = 1
    },
    amazing = {
        chargeTime = 0.98,
        releaseDelay = 0.005,
        power = 0.99
    },
    fast = {
        chargeTime = 0.95,
        releaseDelay = 0.01,
        power = 0.98
    }
}

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

-- Fungsi cleanup timeout tasks
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

-- Fungsi force reset state (lebih agresif)
local function forceResetState()
    cleanupTimeouts()
    fishing.WaitingHook = false
    
    pcall(function()
        RF_CancelFishingInputs:InvokeServer()
    end)
end

-- Fungsi cast dengan improved timeout handling
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    -- Cleanup previous timeouts
    cleanupTimeouts()
    
    disableFishingAnim()
    fishing.CurrentCycle += 1
    fishing.LastCastTime = tick()
    
    local preset = CAST_PRESETS[fishing.Settings.CastMode] or CAST_PRESETS.perfect
    log("⚡ Cast #" .. fishing.CurrentCycle .. " [Mode: " .. fishing.Settings.CastMode:upper() .. "]")

    local castSuccess = pcall(function()
        local startTime = tick()
        
        -- Strategy 1: Charge dengan timing presisi
        local chargeData = {[1] = startTime}
        RF_ChargeFishingRod:InvokeServer(chargeData)
        
        -- Strategy 2: Wait dengan RunService untuk timing akurat
        local elapsed = 0
        local targetTime = preset.chargeTime
        
        repeat
            RunService.Heartbeat:Wait()
            elapsed = tick() - startTime
        until elapsed >= targetTime or not fishing.Running
        
        -- Strategy 3: Release dengan delay minimal
        task.wait(preset.releaseDelay)
        
        -- Strategy 4: Send minigame request
        local releaseTime = tick()
        local totalCharge = releaseTime - startTime
        
        RF_RequestMinigame:InvokeServer(preset.power, 0, releaseTime)
        
        fishing.WaitingHook = true
        log("🎯 Hooked! (Charge: " .. string.format("%.3f", totalCharge) .. "s)")

        -- ⚡ IMPROVED FALLBACK SYSTEM
        -- Fallback 1: Quick check (lebih cepat, lebih gentle)
        fishing.FallbackTask = task.delay(fishing.Settings.FallbackTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚡ Quick reel attempt...")
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
            end
        end)

        -- Fallback 2: Force timeout (sebagai last resort)
        fishing.TimeoutTask = task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚠️ Force timeout - Hard reset")
                
                -- Hard reset sequence
                forceResetState()
                
                -- Immediate retry tanpa delay berlebihan
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
        task.wait(fishing.Settings.RetryDelay * 0.5) -- Retry lebih cepat
        if fishing.Running then
            fishing.Cast()
        end
    end
end

-- Fungsi handle catch yang lebih responsif
local function handleCatch()
    if not fishing.Running then return end
    
    cleanupTimeouts()
    fishing.WaitingHook = false
    
    -- Quick reset
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
    fishing.PerfectCasts = 0
    fishing.LastCastTime = 0

    log("🚀 AUTO FISHING STARTED!")
    log("⭐ Cast Mode: " .. fishing.Settings.CastMode:upper())
    log("⚡ Improved cycle consistency active")
    disableFishingAnim()

    -- Minigame state detector
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

    -- Fish caught detector
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            cleanupTimeouts()
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            fishing.PerfectCasts += 1
            
            local weight = data and data.Weight or 0
            local cycleTime = tick() - fishing.LastCastTime
            log("🐟 Caught: " .. tostring(name) .. " (" .. string.format("%.2f", weight) .. "kg) | Total: " .. fishing.TotalFish .. " | Cycle: " .. string.format("%.2f", cycleTime) .. "s")

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
            task.wait(0.15)
        end
    end)

    -- Watchdog untuk deteksi stuck cycle
    fishing.Connections.Watchdog = task.spawn(function()
        while fishing.Running do
            task.wait(2.5) -- Check setiap 2.5 detik
            
            if fishing.Running and fishing.WaitingHook then
                local stuckTime = tick() - fishing.LastCastTime
                if stuckTime > 2.0 then
                    log("🔧 Stuck detected (" .. string.format("%.1f", stuckTime) .. "s) - Force recovery")
                    forceResetState()
                    task.wait(fishing.Settings.FishingDelay)
                    if fishing.Running then
                        fishing.Cast()
                    end
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

    log("🛑 STOPPED | Total: " .. fishing.TotalFish .. " fish | Avg cycle: " .. string.format("%.2f", (fishing.TotalFish > 0 and (tick() - fishing.LastCastTime) / fishing.TotalFish or 0)) .. "s")
end

-- 🎯 QUICK COMMANDS:
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()
-- _G.FishingScript.Settings.CastMode = "perfect" -- atau "amazing" atau "fast"
--
-- ADVANCED TUNING:
-- _G.FishingScript.Settings.FallbackTime = 0.75 -- Waktu fallback check
-- _G.FishingScript.Settings.MaxWaitTime = 1.1 -- Max timeout
-- _G.FishingScript.Settings.RetryDelay = 0.45 -- Delay retry saat error

return fishing
