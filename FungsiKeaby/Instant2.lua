-- ⚡ ULTRA PERFECT CAST AUTO FISHING v32.0
-- 🎯 ALWAYS PERFECT/AMAZING - OPTIMIZED TIMING
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
    AmazingCasts = 0,
    Connections = {},
    Settings = {
        FishingDelay = 0.15,           -- ⚡ OPTIMAL: Delay antar cast
        CancelDelay = 0.25,            -- ⚡ OPTIMAL: Delay cancel input  
        HookDetectionDelay = 0.05,     -- ⚡ OPTIMAL: Delay deteksi hook
        RetryDelay = 0.5,              -- ⚡ OPTIMAL: Delay retry jika gagal
        MaxWaitTime = 2.0,             -- ⚡ OPTIMAL: Max wait untuk hook (dinaikkan)
        
        -- 🎯 PERFECT/AMAZING CAST SETTINGS (Optimized)
        PerfectChargeTime = 1.0,       -- ⚡ OPTIMAL: Charge time untuk Perfect/Amazing
        PerfectReleaseDelay = 0.01,    -- ⚡ OPTIMAL: Release delay
        PerfectPower = 1.0,            -- ⚡ OPTIMAL: Power value untuk Perfect/Amazing
        UseAdaptiveTiming = false,     -- ⚡ NON-ACTIVE: Sementara matikan adaptive
        
        -- ⚡ OPTIMIZED FISHING
        ImmediateRecast = true,        -- ⚡ LANGSUNG lempar setelah dapat ikan
        QuickCancel = false,           -- ⚡ NON-ACTIVE: Cancel inputs normal dulu
        UsePreciseHookDetection = true,-- ⚡ AKTIFKAN: Deteksi hook lebih akurat
    }
}

_G.FishingScript = fishing

-- Logging dengan emoji
local function log(msg, isError)
    local prefix = isError and "❌" or "✅"
    print(("[%s Fishing] %s"):format(prefix, msg))
end

-- Fungsi disable animasi (lebih aggressive)
local function disableFishingAnim()
    pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            local name = track.Name:lower()
            if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") then
                track:Stop(0)
                track.TimePosition = 0
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

-- 🎯 FUNGSI CAST PERFECT/AMAZING - FIXED TIMING
function fishing.PerfectCast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    
    log("🎯 PERFECT/AMAZING Cast #" .. fishing.CurrentCycle)

    local castSuccess = pcall(function()
        -- ===== STRATEGY 1: CONSISTENT TIMING =====
        local startTime = tick()
        
        -- Mulai charge dengan timestamp akurat
        local chargeData = {[1] = startTime}
        local chargeResult = RF_ChargeFishingRod:InvokeServer(chargeData)
        
        -- ===== STRATEGY 2: PRECISE WAIT =====
        local targetCharge = fishing.Settings.PerfectChargeTime
        
        -- ⚡ GUNAKAN WAIT BIASA UNTUK KONSISTENSI
        task.wait(targetCharge)
        
        -- ===== STRATEGY 3: OPTIMAL RELEASE =====
        task.wait(fishing.Settings.PerfectReleaseDelay)
        
        -- ===== STRATEGY 4: PERFECT POWER =====
        local releaseTime = tick()
        local actualCharge = releaseTime - startTime
        
        -- ⚡ POWER OPTIMAL untuk Perfect/Amazing
        local perfectPower = fishing.Settings.PerfectPower
        
        -- Kirim request dengan parameter optimal
        local minigameResult = RF_RequestMinigame:InvokeServer(
            perfectPower,  -- Power (1.0 = optimal untuk Perfect)
            0,             -- Direction (0 = straight)
            releaseTime    -- Release timestamp
        )
        
        fishing.WaitingHook = true
        log(string.format("⚡ Cast Released! (Charge: %.3fs, Power: %.2f)", actualCharge, perfectPower))
        
        -- ===== STRATEGY 5: IMPROVED HOOK DETECTION =====
        local hookDetected = false
        
        -- Multiple hook detection methods
        if fishing.Settings.UsePreciseHookDetection then
            -- Method 1: Event-based detection
            local hookConnection
            hookConnection = RE_MinigameChanged.OnClientEvent:Connect(function(state)
                if fishing.WaitingHook and typeof(state) == "string" then
                    local stateLower = string.lower(state)
                    if stateLower:find("hook") or stateLower:find("bite") or stateLower:find("catch") then
                        hookDetected = true
                        hookConnection:Disconnect()
                    end
                end
            end)
            
            -- Method 2: Visual/audio detection (placeholder)
            task.delay(0.5, function()
                if fishing.WaitingHook and not hookDetected then
                    -- Check for visual cues
                    pcall(function()
                        -- Tambahkan detection tambahan di sini jika diperlukan
                    end)
                end
            end)
        end

        -- ⚡ IMPROVED TIMEOUT PROTECTION
        local timeoutThread = task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                fishing.WaitingHook = false
                
                if not hookDetected then
                    log("⏰ No hook detected - Timeout", true)
                else
                    log("🎣 Hook processed - Completing")
                end
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)

                task.wait(fishing.Settings.RetryDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.PerfectCast()
                end
            end
        end)
    end)

    if not castSuccess then
        log("❌ Cast failed, retrying...", true)
        task.wait(fishing.Settings.RetryDelay)
        if fishing.Running then
            fishing.PerfectCast()
        end
    end
end

-- Start Function - OPTIMIZED
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.PerfectCasts = 0
    fishing.AmazingCasts = 0

    log("🚀 PERFECT/AMAZING AUTO FISHING STARTED!")
    log("🎯 Target: PERFECT & AMAZING Casts")
    log("⚡ Optimized for consistency and speed")
    disableFishingAnim()

    -- ⚡ IMPROVED HOOK DETECTION SYSTEM
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local stateLower = string.lower(state)
            if stateLower:find("hook") or stateLower:find("bite") or stateLower:find("catch") or stateLower:find("!") then
                fishing.WaitingHook = false
                log("🎣 Hook detected — Reeling in!")

                task.wait(fishing.Settings.HookDetectionDelay)
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)

                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                -- ⚡ QUICK RECAST AFTER HOOK
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.PerfectCast()
                end
            end
        end
    end)

    -- ⚡ OPTIMIZED FISH CAUGHT HANDLER
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            
            local weight = data and data.Weight or 0
            local rarity = data and data.Rarity or "Common"
            local castResult = data and data.CastResult or "Unknown"
            
            -- ⚡ DETECT CAST RESULT
            if castResult == "Perfect" then
                fishing.PerfectCasts += 1
                log(string.format("🌟 PERFECT! %s [%s] (%.2fkg)", 
                    tostring(name), rarity, weight))
            elseif castResult == "Amazing" then
                fishing.AmazingCasts += 1
                log(string.format("💫 AMAZING! %s [%s] (%.2fkg)", 
                    tostring(name), rarity, weight))
            else
                log(string.format("🎣 %s! %s [%s] (%.2fkg)", 
                    castResult, tostring(name), rarity, weight))
            end

            -- ⚡ FAST RECAST AFTER CATCH
            if fishing.Settings.ImmediateRecast then
                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.PerfectCast()
                end
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

    -- Stats reporter
    fishing.Connections.StatsReporter = task.spawn(function()
        while fishing.Running do
            task.wait(30)
            if fishing.TotalFish > 0 then
                local perfectRate = (fishing.PerfectCasts / fishing.TotalFish) * 100
                local amazingRate = (fishing.AmazingCasts / fishing.TotalFish) * 100
                local totalGood = perfectRate + amazingRate
                log(string.format("📊 Stats: %d fish | %.1f%% PERFECT | %.1f%% AMAZING | %.1f%% TOTAL GOOD", 
                    fishing.TotalFish, perfectRate, amazingRate, totalGood))
            end
        end
    end)

    task.wait(0.5)
    fishing.PerfectCast()
end

-- Stop Function
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

    local totalGoodCasts = fishing.PerfectCasts + fishing.AmazingCasts
    local successRate = fishing.TotalFish > 0 and (totalGoodCasts / fishing.TotalFish) * 100 or 0
    log(string.format("🛑 STOPPED | Total: %d fish | PERFECT: %d | AMAZING: %d | Success: %.1f%%", 
        fishing.TotalFish, fishing.PerfectCasts, fishing.AmazingCasts, successRate))
end

-- 🎯 QUICK COMMANDS:
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()

-- ⚡ MANUAL TUNING JIKA PERLU:
-- _G.FishingScript.Settings.PerfectChargeTime = 1.0    -- Standard Perfect
-- _G.FishingScript.Settings.PerfectPower = 1.0         -- Standard Perfect  
-- _G.FishingScript.Settings.MaxWaitTime = 2.0          -- Tunggu hook lebih lama
-- _G.FishingScript.Settings.FishingDelay = 0.15        -- Delay antar cast

return fishing
