-- ⚡ ULTIMATE INSTANT HOOK AUTO FISHING v31.0 (MAXIMUM SPEED - ALL LIMITERS REMOVED)
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
        FishingDelay = 0.001,
        CancelDelay = 0.05,
        HookDetectionDelay = 0,
        RetryDelay = 0.15,
        MaxWaitTime = 0.6,
        FallbackTime = 0.15, -- INSTANT
        -- ⭐ ULTIMATE MAXIMUM SPEED
        CastMode = "godmode",
        ChargeTime = 0.2, -- SUPER MINIMAL!
        ReleaseDelay = 0, -- ZERO
        PreHookCall = true,
        MultipleMinigameCalls = true,
        SpamMinigame = true,
        InstantCast = true,
        -- 🔥 NEW: INSANE OPTIMIZATIONS
        ParallelSpam = true, -- Spam parallel tanpa waiting
        PreChargeSpam = true, -- Spam SEBELUM charge dimulai
        ContinuousSpam = true, -- Spam terus menerus
        SpamInterval = 0.005, -- Spam tiap 0.005s (super cepat!)
        SpamDuration = 0.3, -- Spam selama 0.3s
    }
}

_G.FishingScript = fishing

-- Preset timing dengan MAXIMUM SPEED - NO LIMITS!
local CAST_PRESETS = {
    godmode = {
        chargeTime = 0.15, -- INSANELY FAST!
        releaseDelay = 0,
        power = 0.85,
        earlyMinigame = true,
        spamCount = 10 -- SPAM 10x!
    },
    insane = {
        chargeTime = 0.2,
        releaseDelay = 0,
        power = 0.88,
        earlyMinigame = true,
        spamCount = 8
    },
    hyper = {
        chargeTime = 0.3,
        releaseDelay = 0,
        power = 0.9,
        earlyMinigame = true,
        spamCount = 6
    },
    extreme = {
        chargeTime = 0.4,
        releaseDelay = 0,
        power = 0.92,
        earlyMinigame = true,
        spamCount = 5
    },
    instant = {
        chargeTime = 0.6,
        releaseDelay = 0,
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

-- ⚡ ULTIMATE MINIGAME SPAM - MAXIMUM SPEED NO LIMITS
local function aggressiveMinigameCall(power, releaseTime, spamCount)
    spamCount = spamCount or 5
    
    -- 🔥 STRATEGY 0: PRE-SPAM - Spam SEBELUM function dipanggil
    if fishing.Settings.PreChargeSpam then
        for i = 1, 3 do
            task.spawn(function()
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime - 0.1)
                end)
            end)
        end
    end
    
    -- 🔥 STRATEGY 1: INSTANT PARALLEL SPAM - Semua sekaligus tanpa delay
    if fishing.Settings.ParallelSpam then
        for i = 1, spamCount * 2 do -- Double spam count!
            task.spawn(function()
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                end)
            end)
        end
    end
    
    -- 🔥 STRATEGY 2: RAPID FIRE - Spam dengan interval super cepat
    for i = 1, spamCount * 2 do
        task.delay(i * fishing.Settings.SpamInterval, function()
            if fishing.WaitingHook then
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                end)
            end
        end)
    end
    
    -- 🔥 STRATEGY 3: CONTINUOUS SPAM LOOP - Loop terus menerus
    if fishing.Settings.ContinuousSpam then
        local spamStart = tick()
        task.spawn(function()
            while fishing.WaitingHook and (tick() - spamStart) < fishing.Settings.SpamDuration do
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                end)
                -- ZERO delay untuk max speed
                RunService.Heartbeat:Wait()
            end
        end)
    end
    
    -- 🔥 STRATEGY 4: RENDER STEP SPAM - Spam tiap frame!
    if fishing.Settings.SpamMinigame then
        local spamStart = tick()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if fishing.WaitingHook and (tick() - spamStart) < fishing.Settings.SpamDuration then
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                end)
            else
                conn:Disconnect()
            end
        end)
    end
    
    -- 🔥 STRATEGY 5: HEARTBEAT SPAM - Backup spam method
    task.spawn(function()
        local spamStart = tick()
        while fishing.WaitingHook and (tick() - spamStart) < fishing.Settings.SpamDuration do
            pcall(function()
                RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
            end)
            RunService.Heartbeat:Wait()
        end
    end)
end

-- Fungsi cast dengan GODMODE SPEED - ALL LIMITERS OFF
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    cleanupTimeouts()
    disableFishingAnim()
    fishing.CurrentCycle += 1
    fishing.LastCastTime = tick()
    
    local preset = CAST_PRESETS[fishing.Settings.CastMode] or CAST_PRESETS.godmode
    log("⚡ Cast #" .. fishing.CurrentCycle .. " [" .. fishing.Settings.CastMode:upper() .. "]")

    local castSuccess = pcall(function()
        local startTime = tick()
        
        -- 🔥 STRATEGY 0: PRE-CHARGE SPAM - Spam SEBELUM charge dimulai!
        if fishing.Settings.PreChargeSpam then
            aggressiveMinigameCall(preset.power, startTime, 3)
            log("💥 PRE-CHARGE SPAM!")
        end
        
        -- Strategy 1: Charge dengan timing SUPER MINIMAL
        local chargeData = {[1] = startTime}
        RF_ChargeFishingRod:InvokeServer(chargeData)
        
        -- 🔥 STRATEGY 1: INSTANT SPAM - Panggil SEGERA (0.01s)
        if fishing.Settings.InstantCast then
            task.spawn(function()
                task.wait(0.01) -- SUPER minimal
                local instantTime = tick()
                aggressiveMinigameCall(preset.power, instantTime, preset.spamCount)
                log("⚡ INSTANT SPAM (0.01s)!")
            end)
        end
        
        -- 🔥 STRATEGY 2: ULTRA EARLY CALL - Panggil saat 20% charge!
        if preset.earlyMinigame and fishing.Settings.PreHookCall then
            task.delay(preset.chargeTime * 0.2, function()
                if fishing.Running then
                    local earlyTime = tick()
                    aggressiveMinigameCall(preset.power, earlyTime, preset.spamCount)
                    log("💥 ULTRA EARLY (20%)!")
                end
            end)
        end
        
        -- 🔥 STRATEGY 3: MID SPAM - Panggil di tengah charge
        task.delay(preset.chargeTime * 0.5, function()
            if fishing.Running then
                local midTime = tick()
                aggressiveMinigameCall(preset.power, midTime, preset.spamCount)
                log("💥 MID SPAM (50%)!")
            end
        end)
        
        -- Strategy 4: ZERO wait - Langsung ke release
        task.wait(preset.chargeTime)
        
        -- Strategy 5: MASSIVE FINAL SPAM
        local releaseTime = tick()
        local totalCharge = releaseTime - startTime
        
        aggressiveMinigameCall(preset.power, releaseTime, preset.spamCount * 2) -- DOUBLE SPAM!
        
        fishing.WaitingHook = true
        log("🎯 HOOKED! (" .. string.format("%.2f", totalCharge) .. "s)")

        -- ⚡ INSTANT FALLBACK
        fishing.FallbackTask = task.delay(fishing.Settings.FallbackTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚡ INSTANT REEL!")
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
            end
        end)

        -- Timeout super cepat
        fishing.TimeoutTask = task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚠️ FORCE RESET")
                forceResetState()
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end)
    end)

    if not castSuccess then
        log("❌ ERROR - INSTANT RETRY")
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

    log("🚀 GODMODE SPEED ACTIVATED!")
    log("💥 Cast Mode: " .. fishing.Settings.CastMode:upper() .. " (" .. CAST_PRESETS[fishing.Settings.CastMode].chargeTime .. "s)")
    log("⚡ Pre-charge spam: " .. (fishing.Settings.PreChargeSpam and "ON" or "OFF"))
    log("⚡ Parallel spam: " .. (fishing.Settings.ParallelSpam and "ON" or "OFF"))
    log("⚡ Continuous spam: " .. (fishing.Settings.ContinuousSpam and "ON" or "OFF"))
    log("💥 ALL LIMITERS: REMOVED")
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
                if stuckTime > 1.0 then
                    log("🔧 STUCK (" .. string.format("%.1f", stuckTime) .. "s) - FORCE RECOVERY")
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
-- 🔥💥 GODMODE SPEED LEVELS (ABSOLUTE MAXIMUM SPEED):
-- _G.FishingScript.Settings.CastMode = "godmode"    -- 💀💥 GODMODE! 0.15s + 10x SPAM + ALL STRATEGIES
-- _G.FishingScript.Settings.CastMode = "insane"     -- ⚡⚡⚡ INSANE! 0.2s + 8x SPAM
-- _G.FishingScript.Settings.CastMode = "hyper"      -- ⚡⚡ HYPER! 0.3s + 6x SPAM
-- _G.FishingScript.Settings.CastMode = "extreme"    -- ⚡ EXTREME! 0.4s + 5x SPAM
-- _G.FishingScript.Settings.CastMode = "instant"    -- Instant (0.6s)
-- _G.FishingScript.Settings.CastMode = "ultrafast"  -- Sangat cepat (0.75s)
--
-- ⚡💥 GODMODE OPTIMIZATION TOGGLES (ALL ENABLED BY DEFAULT):
-- _G.FishingScript.Settings.PreChargeSpam = true      -- Spam SEBELUM charge!
-- _G.FishingScript.Settings.ParallelSpam = true       -- Multi-thread spam parallel
-- _G.FishingScript.Settings.ContinuousSpam = true     -- Loop spam terus menerus
-- _G.FishingScript.Settings.InstantCast = true        -- Instant cast (0.01s)
-- _G.FishingScript.Settings.SpamMinigame = true       -- RenderStepped spam
--
-- 🎮 GODMODE MANUAL TUNING (FOR ABSOLUTE MAXIMUM):
-- _G.FishingScript.Settings.ChargeTime = 0.1         -- MINIMUM! (0.1-0.15s)
-- _G.FishingScript.Settings.FallbackTime = 0.1       -- INSTANT fallback
-- _G.FishingScript.Settings.SpamInterval = 0.001     -- Spam tiap 0.001s (INSANE!)
-- _G.FishingScript.Settings.SpamDuration = 0.5       -- Spam selama 0.5s
-- _G.FishingScript.Settings.FishingDelay = 0         -- ZERO delay antar cycle
--
-- ⚠️ WARNING: 
-- Mode "godmode" dan "insane" SANGAT EKSTREM dan mungkin crash/banned!
-- Jika tidak stabil, gunakan "hyper" atau "extreme"
-- Mode ini akan SPAM server dengan ratusan request per detik!
--
-- 💡 RECOMMENDED SAFE MODE:
-- _G.FishingScript.Settings.CastMode = "hyper"  -- Sangat cepat tapi stabil

return fishing
