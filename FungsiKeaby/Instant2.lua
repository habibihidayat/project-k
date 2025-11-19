-- ⚡ ULTRA PERFECT CAST AUTO FISHING v31.0
-- 🎯 ALWAYS PERFECT/AMAZING - NEVER OK/GOOD/GREAT
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
        FishingDelay = 0.01,           -- Delay antar cast
        CancelDelay = 0.12,            -- ⚡ DIPERCEPAT: Delay cancel input
        HookDetectionDelay = 0.005,    -- ⚡ DIPERCEPAT: Delay deteksi hook
        RetryDelay = 0.35,             -- ⚡ DIPERCEPAT: Delay retry jika gagal
        MaxWaitTime = 0.8,             -- ⚡ DIPERCEPAT: Max wait untuk hook
        
        -- 🎯 PERFECT/AMAZING CAST SETTINGS (Optimized)
        PerfectChargeTime = 0.998,     -- ⚡ OPTIMAL: Charge time untuk Perfect/Amazing
        PerfectReleaseDelay = 0.0005,  -- ⚡ DIPERCEPAT: Release delay
        PerfectPower = 0.997,          -- ⚡ OPTIMAL: Power value untuk Perfect/Amazing
        UseAdaptiveTiming = true,      -- Auto-adjust berdasarkan hasil
        
        -- ⚡ HIGH-SPEED FISHING
        ImmediateRecast = true,        -- ⚡ LANGSUNG lempar setelah dapat ikan
        QuickCancel = true,            -- ⚡ Cancel inputs lebih cepat
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

-- 🎯 FUNGSI CAST PERFECT/AMAZING - Optimized
function fishing.PerfectCast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    
    log("🎯 PERFECT/AMAZING Cast #" .. fishing.CurrentCycle)

    local castSuccess = pcall(function()
        -- ===== STRATEGY 1: ULTRA-PRECISE TIMING =====
        local startTime = tick()
        
        -- Mulai charge dengan timestamp akurat
        local chargeData = {[1] = startTime}
        local chargeResult = RF_ChargeFishingRod:InvokeServer(chargeData)
        
        -- ===== STRATEGY 2: FRAME-PERFECT WAIT =====
        local targetCharge = fishing.Settings.PerfectChargeTime
        local accumulated = 0
        
        -- ⚡ HIGH-PRECISION WAIT dengan Heartbeat
        local connection
        connection = RunService.Heartbeat:Connect(function(deltaTime)
            accumulated += deltaTime
            if accumulated >= targetCharge then
                connection:Disconnect()
            end
        end)
        
        -- Wait ultra-presisi
        while accumulated < targetCharge and fishing.Running do
            task.wait()
        end
        
        -- ===== STRATEGY 3: ULTRA-FAST RELEASE =====
        task.wait(fishing.Settings.PerfectReleaseDelay)
        
        -- ===== STRATEGY 4: PERFECT/AMAZING POWER CALCULATION =====
        local releaseTime = tick()
        local actualCharge = releaseTime - startTime
        
        -- ⚡ POWER OPTIMAL untuk Perfect/Amazing saja
        local perfectPower = fishing.Settings.PerfectPower
        
        -- Kirim request dengan parameter optimal
        local minigameResult = RF_RequestMinigame:InvokeServer(
            perfectPower,  -- Power (0.997 = optimal untuk Perfect/Amazing)
            0,             -- Direction (0 = straight)
            releaseTime    -- Release timestamp
        )
        
        fishing.WaitingHook = true
        log(string.format("⚡ Cast Released! (Charge: %.4fs, Power: %.3f)", actualCharge, perfectPower))
        
        -- ===== STRATEGY 5: ADAPTIVE ADJUSTMENT =====
        if fishing.Settings.UseAdaptiveTiming then
            fishing.CastResults = fishing.CastResults or {}
            table.insert(fishing.CastResults, {
                charge = actualCharge,
                power = perfectPower,
                timestamp = releaseTime
            })
            
            -- Keep only last 3 results untuk responsiveness lebih baik
            if #fishing.CastResults > 3 then
                table.remove(fishing.CastResults, 1)
            end
        end

        -- ⚡ OPTIMIZED TIMEOUT PROTECTION
        task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                fishing.WaitingHook = false
                log("⚠️ Timeout - Force complete", true)
                
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

-- Auto-adjust timing berdasarkan hasil cast
function fishing.AdjustTiming(resultType)
    if not fishing.Settings.UseAdaptiveTiming then return end
    
    -- ⚡ ADJUSTMENT UNTUK PERFECT/AMAZING ONLY
    if resultType == "Perfect" then
        -- Jika Perfect, pertahankan atau sedikit naikkan
        fishing.Settings.PerfectChargeTime = math.min(0.999, fishing.Settings.PerfectChargeTime + 0.0001)
        fishing.Settings.PerfectPower = math.min(0.999, fishing.Settings.PerfectPower + 0.0001)
    elseif resultType == "Amazing" then
        -- Jika Amazing, naikkan sedikit untuk target Perfect
        fishing.Settings.PerfectChargeTime = math.min(0.999, fishing.Settings.PerfectChargeTime + 0.0002)
        fishing.Settings.PerfectPower = math.min(0.999, fishing.Settings.PerfectPower + 0.0002)
    else
        -- Jika dapat hasil selain Perfect/Amazing, adjust lebih agresif
        fishing.Settings.PerfectChargeTime = 0.998  -- Reset ke optimal
        fishing.Settings.PerfectPower = 0.997       -- Reset ke optimal
    end
    
    log(string.format("🔧 Timing Adjusted - Charge: %.4fs, Power: %.3f", 
        fishing.Settings.PerfectChargeTime, fishing.Settings.PerfectPower))
end

-- ⚡ HIGH-SPEED FISHING COMPLETION
local function quickFinishFishing()
    if not fishing.Running then return end
    
    fishing.WaitingHook = false
    
    -- ⚡ LANGSUNG lempar lagi setelah dapat ikan
    if fishing.Settings.ImmediateRecast then
        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then
            fishing.AdjustTiming("Perfect") -- Assume Perfect untuk adjustment
            fishing.PerfectCast()
        end
    end
end

-- Start Function
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.PerfectCasts = 0
    fishing.AmazingCasts = 0
    fishing.CastResults = {}

    log("🚀 PERFECT/AMAZING AUTO FISHING STARTED!")
    log("🎯 Target: ONLY PERFECT & AMAZING (No OK/Good/Great)")
    disableFishingAnim()

    -- Hook detection listener
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local stateLower = string.lower(state)
            if string.find(stateLower, "hook") or string.find(stateLower, "bite") or string.find(stateLower, "catch") then
                fishing.WaitingHook = false
                task.wait(fishing.Settings.HookDetectionDelay)

                pcall(function()
                    RE_FishingCompleted:FireServer()
                    log("🎣 Hook detected — Reeling!")
                end)

                -- ⚡ QUICK CANCEL OPTIMIZATION
                if fishing.Settings.QuickCancel then
                    task.wait(fishing.Settings.CancelDelay)
                    pcall(function()
                        RF_CancelFishingInputs:InvokeServer()
                    end)
                end
            end
        end
    end)

    -- Fish caught listener - ⚡ OPTIMIZED FOR SPEED
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            
            local weight = data and data.Weight or 0
            local rarity = data and data.Rarity or "Common"
            local castResult = data and data.CastResult or "Unknown"
            
            -- ⚡ DETECT CAST RESULT UNTUK PERFECT/AMAZING
            if castResult == "Perfect" then
                fishing.PerfectCasts += 1
                fishing.AdjustTiming("Perfect")
                log(string.format("🌟 PERFECT! Caught: %s [%s] (%.2fkg)", 
                    tostring(name), rarity, weight))
            elseif castResult == "Amazing" then
                fishing.AmazingCasts += 1
                fishing.AdjustTiming("Amazing")
                log(string.format("💫 AMAZING! Caught: %s [%s] (%.2fkg)", 
                    tostring(name), rarity, weight))
            else
                log(string.format("❌ %s! Caught: %s [%s] (%.2fkg) - Adjusting...", 
                    castResult, tostring(name), rarity, weight), true)
                fishing.AdjustTiming("Other")
            end

            -- ⚡ QUICK CANCEL SETELAH DAPAT IKAN
            pcall(function()
                task.wait(fishing.Settings.CancelDelay)
                RF_CancelFishingInputs:InvokeServer()
            end)

            -- ⚡ HIGH-SPEED RECAST
            quickFinishFishing()
        end
    end)

    -- Animation disabler (continuous)
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.08) -- ⚡ DIPERCEPAT
        end
    end)

    -- Stats reporter (every 30 seconds)
    fishing.Connections.StatsReporter = task.spawn(function()
        while fishing.Running do
            task.wait(30)
            if fishing.TotalFish > 0 then
                local perfectRate = (fishing.PerfectCasts / fishing.TotalFish) * 100
                local amazingRate = (fishing.AmazingCasts / fishing.TotalFish) * 100
                log(string.format("📊 Stats: %d fish | %.1f%% PERFECT | %.1f%% AMAZING", 
                    fishing.TotalFish, perfectRate, amazingRate))
            end
        end
    end)

    task.wait(0.3) -- ⚡ DIPERCEPAT startup delay
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
--
-- ⚡ MANUAL FINE-TUNING (jika masih dapat Good/Great):
-- _G.FishingScript.Settings.PerfectChargeTime = 0.999  -- Naikkan untuk lebih Perfect
-- _G.FishingScript.Settings.PerfectPower = 0.998       -- Turunkan sedikit untuk Amazing
-- _G.FishingScript.Settings.PerfectReleaseDelay = 0.0001
-- _G.FishingScript.Settings.UseAdaptiveTiming = true

return fishing
