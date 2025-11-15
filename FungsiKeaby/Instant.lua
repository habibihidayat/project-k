-- ⚡💀 INSTANT HOOK GODMODE v32.0 (ZERO LIMITS - MAXIMUM CHAOS MODE)
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
        FishingDelay = 0,
        CancelDelay = 0.03,
        HookDetectionDelay = 0,
        RetryDelay = 0.05,
        MaxWaitTime = 0.4,
        FallbackTime = 0.08,
        -- ⭐💀 ABSOLUTE ZERO LIMITS
        CastMode = "chaos",
        ChargeTime = 0.05, -- ALMOST INSTANT!
        ReleaseDelay = 0,
        PreHookCall = true,
        MultipleMinigameCalls = true,
        SpamMinigame = true,
        InstantCast = true,
        -- 🔥💀 CHAOS MODE SETTINGS
        ParallelSpam = true,
        PreChargeSpam = true,
        ContinuousSpam = true,
        SpamInterval = 0.001, -- SPAM TIAP 0.001s = 1000 req/s!
        SpamDuration = 0.5,
        -- 💀 NEW: NUCLEAR OPTIONS
        ZeroDelayMode = true, -- ZERO delay di semua tempat
        InstantMinigame = true, -- Panggil minigame SEBELUM charge
        NuclearSpam = true, -- Spam dengan SEMUA method sekaligus
        SpamThreads = 20, -- 20 thread spam parallel!
        RequestsPerCycle = 100, -- 100+ requests per cast!
    }
}

_G.FishingScript = fishing

-- Preset timing - ABSOLUTE MAXIMUM CHAOS
local CAST_PRESETS = {
    chaos = {
        chargeTime = 0.05, -- ALMOST ZERO!
        releaseDelay = 0,
        power = 0.8,
        earlyMinigame = true,
        spamCount = 20 -- 20x SPAM!
    },
    nuclear = {
        chargeTime = 0.08,
        releaseDelay = 0,
        power = 0.82,
        earlyMinigame = true,
        spamCount = 15
    },
    godmode = {
        chargeTime = 0.1,
        releaseDelay = 0,
        power = 0.85,
        earlyMinigame = true,
        spamCount = 12
    },
    insane = {
        chargeTime = 0.15,
        releaseDelay = 0,
        power = 0.88,
        earlyMinigame = true,
        spamCount = 10
    },
    hyper = {
        chargeTime = 0.2,
        releaseDelay = 0,
        power = 0.9,
        earlyMinigame = true,
        spamCount = 8
    },
    extreme = {
        chargeTime = 0.3,
        releaseDelay = 0,
        power = 0.92,
        earlyMinigame = true,
        spamCount = 6
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

-- ⚡💀 NUCLEAR SPAM - ABSOLUTE MAXIMUM CHAOS
local function aggressiveMinigameCall(power, releaseTime, spamCount)
    spamCount = spamCount or 10
    
    -- 💀 NUCLEAR OPTION: Spam dengan jumlah thread maksimal
    local totalThreads = fishing.Settings.SpamThreads or 20
    
    for thread = 1, totalThreads do
        task.spawn(function()
            -- 🔥 Method 1: INSTANT FLOOD
            for i = 1, math.floor(fishing.Settings.RequestsPerCycle / totalThreads) do
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                end)
            end
        end)
    end
    
    -- 🔥 Method 2: ZERO DELAY LOOP
    if fishing.Settings.ZeroDelayMode then
        for thread = 1, 5 do
            task.spawn(function()
                local spamStart = tick()
                while fishing.WaitingHook and (tick() - spamStart) < fishing.Settings.SpamDuration do
                    pcall(function()
                        RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                    end)
                    -- ZERO WAIT!
                end
            end)
        end
    end
    
    -- 🔥 Method 3: RENDERSTEP SPAM (EVERY FRAME)
    if fishing.Settings.NuclearSpam then
        local spamStart = tick()
        for i = 1, 3 do
            task.spawn(function()
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
            end)
        end
    end
    
    -- 🔥 Method 4: HEARTBEAT SPAM
    for i = 1, 3 do
        task.spawn(function()
            local spamStart = tick()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if fishing.WaitingHook and (tick() - spamStart) < fishing.Settings.SpamDuration then
                    pcall(function()
                        RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                    end)
                else
                    conn:Disconnect()
                end
            end)
        end)
    end
    
    -- 🔥 Method 5: STEPPED SPAM
    for i = 1, 3 do
        task.spawn(function()
            local spamStart = tick()
            local conn
            conn = RunService.Stepped:Connect(function()
                if fishing.WaitingHook and (tick() - spamStart) < fishing.Settings.SpamDuration then
                    pcall(function()
                        RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                    end)
                else
                    conn:Disconnect()
                end
            end)
        end)
    end
    
    -- 🔥 Method 6: RAPID FIRE WITH MINIMAL DELAY
    for i = 1, spamCount * 3 do
        task.spawn(function()
            local iterations = 0
            while fishing.WaitingHook and iterations < 50 do
                pcall(function()
                    RF_RequestMinigame:InvokeServer(power, 0, releaseTime)
                end)
                task.wait(fishing.Settings.SpamInterval)
                iterations += 1
            end
        end)
    end
    
    -- 🔥 Method 7: PRE-EMPTIVE SPAM (Spam di berbagai waktu)
    for i = 0, 10 do
        task.delay(i * 0.01, function()
            if fishing.WaitingHook then
                for j = 1, 3 do
                    task.spawn(function()
                        pcall(function()
                            RF_RequestMinigame:InvokeServer(power, 0, releaseTime + (i * 0.01))
                        end)
                    end)
                end
            end
        end)
    end
end

-- Fungsi cast dengan ABSOLUTE CHAOS MODE
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    cleanupTimeouts()
    disableFishingAnim()
    fishing.CurrentCycle += 1
    fishing.LastCastTime = tick()
    
    local preset = CAST_PRESETS[fishing.Settings.CastMode] or CAST_PRESETS.chaos
    log("💀 CAST #" .. fishing.CurrentCycle .. " [" .. fishing.Settings.CastMode:upper() .. "]")

    local castSuccess = pcall(function()
        local startTime = tick()
        
        -- 💀 INSTANT MINIGAME - Panggil SEBELUM charge!
        if fishing.Settings.InstantMinigame then
            aggressiveMinigameCall(preset.power, startTime, preset.spamCount)
            log("💀 INSTANT MINIGAME!")
        end
        
        -- Charge dengan timing MINIMAL
        local chargeData = {[1] = startTime}
        RF_ChargeFishingRod:InvokeServer(chargeData)
        
        -- 💀 ZERO DELAY SPAM - Panggil segera tanpa delay
        task.spawn(function()
            aggressiveMinigameCall(preset.power, startTime, preset.spamCount)
            log("💥 ZERO DELAY SPAM!")
        end)
        
        -- 💀 IMMEDIATE SPAM (0.001s)
        task.delay(0.001, function()
            if fishing.Running then
                aggressiveMinigameCall(preset.power, tick(), preset.spamCount)
                log("⚡ 0.001s SPAM!")
            end
        end)
        
        -- 💀 CONTINUOUS SPAM - Spam setiap milidetik
        if fishing.Settings.ZeroDelayMode then
            for i = 1, 10 do
                task.delay(i * 0.005, function()
                    if fishing.Running then
                        aggressiveMinigameCall(preset.power, tick(), preset.spamCount)
                    end
                end)
            end
        end
        
        -- ZERO wait untuk charge
        if fishing.Settings.ZeroDelayMode then
            -- Langsung skip ke release
        else
            task.wait(preset.chargeTime)
        end
        
        -- 💀 NUCLEAR FINAL SPAM
        local releaseTime = tick()
        local totalCharge = releaseTime - startTime
        
        aggressiveMinigameCall(preset.power, releaseTime, preset.spamCount * 3) -- TRIPLE SPAM!
        
        fishing.WaitingHook = true
        log("💀 HOOKED! (" .. string.format("%.3f", totalCharge) .. "s)")

        -- 💀 INSTANT FALLBACK
        fishing.FallbackTask = task.delay(fishing.Settings.FallbackTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("💥 INSTANT REEL!")
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                -- SPAM reel multiple times
                for i = 1, 5 do
                    task.spawn(function()
                        pcall(function()
                            RE_FishingCompleted:FireServer()
                        end)
                    end)
                end
            end
        end)

        -- Timeout super cepat
        fishing.TimeoutTask = task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("💀 FORCE RESET")
                forceResetState()
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end)
    end)

    if not castSuccess then
        log("💀 ERROR - INSTANT RETRY")
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

    log("💀🔥 CHAOS MODE ACTIVATED!")
    log("💥 Mode: " .. fishing.Settings.CastMode:upper() .. " (" .. CAST_PRESETS[fishing.Settings.CastMode].chargeTime .. "s)")
    log("💀 Spam threads: " .. fishing.Settings.SpamThreads)
    log("💀 Requests/cycle: " .. fishing.Settings.RequestsPerCycle .. "+")
    log("💀 Zero delay: " .. (fishing.Settings.ZeroDelayMode and "ON" or "OFF"))
    log("💀 Nuclear spam: " .. (fishing.Settings.NuclearSpam and "ON" or "OFF"))
    log("💀 WARNING: EXTREME SPAM - BAN RISK HIGH!")
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
                if stuckTime > 0.7 then
                    log("💀 STUCK - NUCLEAR RESET")
                    forceResetState()
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
-- 💀🔥 CHAOS MODE SPEED LEVELS (ABSOLUTE MAXIMUM - NO BAN PROTECTION):
-- _G.FishingScript.Settings.CastMode = "chaos"      -- 💀💀💀 CHAOS! 0.05s + 20x SPAM + 100+ REQUESTS!
-- _G.FishingScript.Settings.CastMode = "nuclear"    -- 💀💀 NUCLEAR! 0.08s + 15x SPAM
-- _G.FishingScript.Settings.CastMode = "godmode"    -- 💀 GODMODE! 0.1s + 12x SPAM
-- _G.FishingScript.Settings.CastMode = "insane"     -- ⚡⚡⚡ INSANE! 0.15s + 10x SPAM
-- _G.FishingScript.Settings.CastMode = "hyper"      -- ⚡⚡ HYPER! 0.2s + 8x SPAM
-- _G.FishingScript.Settings.CastMode = "extreme"    -- ⚡ EXTREME! 0.3s + 6x SPAM
--
-- 💀 CHAOS MODE FEATURES (ENABLED BY DEFAULT):
-- • 20+ parallel spam threads
-- • 100+ requests per cast cycle
-- • 7 different spam methods simultaneously
-- • Spam interval: 0.001s (1000 requests/second)
-- • Zero delay mode: Instant everything
-- • Nuclear spam: Every RunService event
-- • Pre-charge minigame calls
-- • Continuous spam loops
--
-- ⚡💀 NUCLEAR TOGGLES:
-- _G.FishingScript.Settings.ZeroDelayMode = true      -- Remove ALL delays
-- _G.FishingScript.Settings.InstantMinigame = true    -- Call BEFORE charge
-- _G.FishingScript.Settings.NuclearSpam = true        -- ALL spam methods
-- _G.FishingScript.Settings.SpamThreads = 50          -- 50 parallel threads! (default 20)
-- _G.FishingScript.Settings.RequestsPerCycle = 200    -- 200 requests/cast! (default 100)
--
-- 🎮 ABSOLUTE MAXIMUM TUNING:
-- _G.FishingScript.Settings.ChargeTime = 0.01        -- 0.01s = ALMOST INSTANT!
-- _G.FishingScript.Settings.SpamInterval = 0.0001    -- 0.0001s = 10,000 req/s!
-- _G.FishingScript.Settings.SpamDuration = 1.0       -- Spam for 1 full second
-- _G.FishingScript.Settings.FallbackTime = 0.05      -- Instant fallback
-- _G.FishingScript.Settings.FishingDelay = 0         -- ZERO delay between casts
-- _G.FishingScript.Settings.SpamThreads = 100        -- 100 THREADS!
--
-- ⚠️💀 EXTREME WARNING: 
-- MODE "CHAOS" WILL:
-- • Send 1000+ requests per second to server
-- • Use 20-100 parallel threads
-- • Spam EVERY RunService event (RenderStepped, Heartbeat, Stepped)
-- • Hook appears in 0.05-0.1 seconds (ALMOST INSTANT)
-- • VERY HIGH ban risk - use at your own risk!
-- • May cause client/server lag or crash
-- • Absolutely NO anti-detection measures
--
-- 💡 IF YOU GET BANNED:
-- You were warned! This is the absolute maximum possible speed.
-- Nothing faster exists without directly modifying game files.
--
-- 🔥 YOLO MODE (EVEN MORE EXTREME):
_G.FishingScript.Settings.ChargeTime = 0.01
_G.FishingScript.Settings.SpamThreads = 100
_G.FishingScript.Settings.RequestsPerCycle = 500
_G.FishingScript.Settings.SpamInterval = 0.0001
_G.FishingScript.Start()

return fishing
