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
        FishingDelay = 0.005,
        CancelDelay = 0.08,
        HookDetectionDelay = 0.001,
        RetryDelay = 0.25,
        MaxWaitTime = 0.8,
        FallbackTime = 0.25, -- SANGAT CEPAT
        -- ⭐ EXTREME HOOK SPEED OPTIMIZATION
        CastMode = "hyper",
        ChargeTime = 0.5, -- MINIMAL untuk hook tercepat
        ReleaseDelay = 0, -- ZERO DELAY
        PreHookCall = true, -- Panggil minigame sebelum charge selesai
        MultipleMinigameCalls = true, -- Panggil minigame berkali-kali
        SpamMinigame = true, -- SPAM request minigame
        InstantCast = true, -- Cast instant tanpa charge penuh
    }
}

_G.FishingScript = fishing

-- Preset timing dengan fokus kecepatan hook MAKSIMAL
local CAST_PRESETS = {
    hyper = {
        chargeTime = 0.4, -- SANGAT PENDEK!
        releaseDelay = 0,
        power = 0.9,
        earlyMinigame = true,
        spamCount = 5 -- Spam 5x
    },
    extreme = {
        chargeTime = 0.5,
        releaseDelay = 0,
        power = 0.92,
        earlyMinigame = true,
        spamCount = 4
    },
    instant = {
        chargeTime = 0.6,
        releaseDelay = 0.0001,
        power = 0.95,
        earlyMinigame = true,
        spamCount = 3
    },
    ultrafast = {
        chargeTime = 0.75,
        releaseDelay = 0.001,
        power = 0.96,
        earlyMinigame = true,
        spamCount = 2
    },
    fast = {
        chargeTime = 0.85,
        releaseDelay = 0.005,
        power = 0.97,
        earlyMinigame = false,
        spamCount = 1
    },
    perfect = {
        chargeTime = 1.0,
        releaseDelay = 0.001,
        power = 1,
        earlyMinigame = false,
        spamCount = 1
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

-- ⚡ EXTREME MINIGAME SPAM - Panggil berkali-kali untuk hook SUPER CEPAT
local function aggressiveMinigameCall(power, releaseTime, spamCount)
    spamCount = spamCount or 3
    
    -- Strategi 1: INSTANT SPAM - Panggil berkali-kali tanpa delay
    for i = 1, spamCount do
        task.spawn(function()
            pcall(function()
                RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
            end)
        end)
    end
    
    -- Strategi 2: Delayed spam dengan interval super cepat
    for i = 1, spamCount do
        task.delay(i * 0.02, function() -- Setiap 0.02s
            if fishing.WaitingHook then
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                end)
            end
        end)
    end
    
    -- Strategi 3: Continuous spam selama 0.2 detik
    if fishing.Settings.SpamMinigame then
        local spamStart = tick()
        task.spawn(function()
            while fishing.WaitingHook and (tick() - spamStart) < 0.2 do
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                end)
                task.wait(0.01) -- Spam setiap 0.01s
            end
        end)
    end
end

-- Fungsi cast dengan EXTREME SPEED optimization
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    cleanupTimeouts()
    disableFishingAnim()
    fishing.CurrentCycle += 1
    fishing.LastCastTime = tick()
    
    local preset = CAST_PRESETS[fishing.Settings.CastMode] or CAST_PRESETS.hyper
    log("⚡ Cast #" .. fishing.CurrentCycle .. " [Mode: " .. fishing.Settings.CastMode:upper() .. "]")

    local castSuccess = pcall(function()
        local startTime = tick()
        
        -- Strategy 1: Charge dengan timing MINIMAL
        local chargeData = {[1] = startTime}
        RF_ChargeFishingRod:InvokeServer(chargeData)
        
        -- ⚡ INSTANT MINIGAME SPAM - Panggil SEGERA tanpa nunggu charge!
        if fishing.Settings.InstantCast then
            task.spawn(function()
                task.wait(0.05) -- Delay minimal
                local instantTime = tick()
                aggressiveMinigameCall(preset.power, instantTime, preset.spamCount)
                log("⚡ INSTANT minigame spam!")
            end)
        end
        
        -- ⚡ EARLY MINIGAME CALL - Panggil saat 40% charge (lebih awal!)
        if preset.earlyMinigame and fishing.Settings.PreHookCall then
            task.delay(preset.chargeTime * 0.4, function()
                if fishing.Running and not fishing.WaitingHook then
                    local earlyTime = tick()
                    aggressiveMinigameCall(preset.power, earlyTime, preset.spamCount)
                    log("🎯 Early spam (40%)!")
                end
            end)
        end
        
        -- Strategy 2: ZERO wait time jika hyper mode
        local elapsed = 0
        local targetTime = preset.chargeTime
        
        if fishing.Settings.CastMode == "hyper" or fishing.Settings.CastMode == "extreme" then
            -- Hyper mode: minimal wait
            task.wait(targetTime)
        else
            -- Normal mode: precise timing
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
        end
        
        -- Strategy 3: ZERO release delay
        if preset.releaseDelay > 0 then
            task.wait(preset.releaseDelay)
        end
        
        -- Strategy 4: MASSIVE minigame spam
        local releaseTime = tick()
        local totalCharge = releaseTime - startTime
        
        aggressiveMinigameCall(preset.power, releaseTime, preset.spamCount)
        
        fishing.WaitingHook = true
        log("🎯 Hooked! (Charge: " .. string.format("%.3f", totalCharge) .. "s)")

        -- ⚡ HYPER FAST FALLBACK
        fishing.FallbackTask = task.delay(fishing.Settings.FallbackTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚡ Hyper reel...")
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
            end
        end)

        -- Fallback 2: Force timeout (lebih cepat)
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
        log("❌ Cast failed, instant retry...")
        forceResetState()
        task.wait(fishing.Settings.RetryDelay)
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
