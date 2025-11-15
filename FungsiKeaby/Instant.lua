-- ⚡ ULTRA FAST HOOK AUTO FISHING v30.0 (Optimized Hook Speed)
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
    TimeoutTask = nil,
    FallbackTask = nil,
    LastCastTime = 0,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.12,
        HookDetectionDelay = 0.005,
        RetryDelay = 0.35,
        MaxWaitTime = 1.0,
        FallbackTime = 0.5, -- Lebih cepat
        -- ⭐ HOOK SPEED OPTIMIZATION
        CastMode = "instant",
        ChargeTime = 0.85, -- Lebih pendek untuk hook lebih cepat
        ReleaseDelay = 0.0001, -- Minimal delay
        PreHookCall = true, -- Panggil minigame sebelum charge selesai
        MultipleMinigameCalls = true, -- Panggil minigame berkali-kali
    }
}

_G.FishingScript = fishing

-- Preset timing dengan fokus kecepatan hook
local CAST_PRESETS = {
    instant = {
        chargeTime = 0.75, -- Sangat pendek
        releaseDelay = 0.0001,
        power = 0.95,
        earlyMinigame = true
    },
    ultrafast = {
        chargeTime = 0.8,
        releaseDelay = 0.001,
        power = 0.96,
        earlyMinigame = true
    },
    fast = {
        chargeTime = 0.85,
        releaseDelay = 0.005,
        power = 0.97,
        earlyMinigame = false
    },
    perfect = {
        chargeTime = 1.0,
        releaseDelay = 0.001,
        power = 1,
        earlyMinigame = false
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

-- Fungsi force reset state
local function forceResetState()
    cleanupTimeouts()
    fishing.WaitingHook = false
    
    pcall(function()
        RF_CancelFishingInputs:InvokeServer()
    end)
end

-- ⚡ AGGRESSIVE MINIGAME CALLER - Panggil berkali-kali untuk hook lebih cepat
local function aggressiveMinigameCall(power, releaseTime)
    if not fishing.Settings.MultipleMinigameCalls then
        RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
        return
    end
    
    -- Strategi 1: Panggil segera
    task.spawn(function()
        pcall(function()
            RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
        end)
    end)
    
    -- Strategi 2: Panggil lagi setelah delay minimal
    task.delay(0.05, function()
        if fishing.WaitingHook then
            pcall(function()
                RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
            end)
        end
    end)
    
    -- Strategi 3: Panggil sekali lagi untuk memastikan
    task.delay(0.1, function()
        if fishing.WaitingHook then
            pcall(function()
                RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
            end)
        end
    end)
end

-- Fungsi cast dengan ULTRA FAST HOOK optimization
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    cleanupTimeouts()
    disableFishingAnim()
    fishing.CurrentCycle += 1
    fishing.LastCastTime = tick()
    
    local preset = CAST_PRESETS[fishing.Settings.CastMode] or CAST_PRESETS.instant
    log("⚡ Cast #" .. fishing.CurrentCycle .. " [Mode: " .. fishing.Settings.CastMode:upper() .. "]")

    local castSuccess = pcall(function()
        local startTime = tick()
        
        -- Strategy 1: Charge dengan timing minimal
        local chargeData = {[1] = startTime}
        RF_ChargeFishingRod:InvokeServer(chargeData)
        
        -- ⚡ EARLY MINIGAME CALL - Panggil SEBELUM charge selesai jika enabled
        if preset.earlyMinigame and fishing.Settings.PreHookCall then
            task.delay(preset.chargeTime * 0.6, function()
                if fishing.Running and not fishing.WaitingHook then
                    local earlyTime = tick()
                    pcall(function()
                        RF_RequestMinigame:InvokeServer(preset.power, 0, earlyTime)
                        log("🎯 Early minigame call!")
                    end)
                end
            end)
        end
        
        -- Strategy 2: Wait minimal dengan RenderStepped untuk timing tercepat
        local elapsed = 0
        local targetTime = preset.chargeTime
        local connection
        
        connection = RunService.RenderStepped:Connect(function()
            elapsed = tick() - startTime
            if elapsed >= targetTime or not fishing.Running then
                connection:Disconnect()
            end
        end)
        
        repeat
            task.wait()
            elapsed = tick() - startTime
        until elapsed >= targetTime or not fishing.Running
        
        if connection then connection:Disconnect() end
        
        -- Strategy 3: Release dengan delay MINIMAL
        task.wait(preset.releaseDelay)
        
        -- Strategy 4: AGGRESSIVE minigame request
        local releaseTime = tick()
        local totalCharge = releaseTime - startTime
        
        aggressiveMinigameCall(preset.power, releaseTime)
        
        fishing.WaitingHook = true
        log("🎯 Hooked! (Charge: " .. string.format("%.3f", totalCharge) .. "s)")

        -- ⚡ ULTRA FAST FALLBACK - Lebih agresif
        fishing.FallbackTask = task.delay(fishing.Settings.FallbackTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚡ Ultra fast reel...")
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
            end
        end)

        -- Fallback 2: Force timeout
        fishing.TimeoutTask = task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚠️ Force timeout")
                forceResetState()
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

-- Fungsi handle catch yang lebih responsif
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
    fishing.PerfectCasts = 0
    fishing.LastCastTime = 0

    log("🚀 ULTRA FAST HOOK FISHING STARTED!")
    log("⭐ Cast Mode: " .. fishing.Settings.CastMode:upper())
    log("⚡ Hook optimization: " .. (fishing.Settings.PreHookCall and "ENABLED" or "DISABLED"))
    log("⚡ Multiple calls: " .. (fishing.Settings.MultipleMinigameCalls and "ENABLED" or "DISABLED"))
    disableFishingAnim()

    -- Minigame state detector - LEBIH SENSITIF
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local stateLower = string.lower(state)
            if string.find(stateLower, "hook") or 
               string.find(stateLower, "bite") or 
               string.find(stateLower, "catch") or
               string.find(stateLower, "reel") or
               string.find(stateLower, "!") then -- Deteksi tanda seru
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

    log("🛑 STOPPED | Total: " .. fishing.TotalFish .. " fish")
end

-- 🎯 QUICK COMMANDS:
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()
-- 
-- 🔥 HOOK SPEED MODES (dari tercepat ke normal):
-- _G.FishingScript.Settings.CastMode = "instant"    -- TERCEPAT! Hook muncul 0.75s
-- _G.FishingScript.Settings.CastMode = "ultrafast"  -- Sangat cepat (0.8s)
-- _G.FishingScript.Settings.CastMode = "fast"       -- Cepat (0.85s)
-- _G.FishingScript.Settings.CastMode = "perfect"    -- Normal (1.0s)
--
-- ⚡ ADVANCED HOOK OPTIMIZATION:
-- _G.FishingScript.Settings.PreHookCall = true          -- Panggil minigame lebih awal
-- _G.FishingScript.Settings.MultipleMinigameCalls = true -- Panggil berkali-kali
-- _G.FishingScript.Settings.ChargeTime = 0.7            -- Semakin kecil = semakin cepat (min 0.5)
-- _G.FishingScript.Settings.FallbackTime = 0.4          -- Waktu fallback (min 0.3)

return fishing
