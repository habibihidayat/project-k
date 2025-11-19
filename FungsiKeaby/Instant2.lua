-- ⚡ ULTRA PERFECT CAST AUTO FISHING v34.0
-- 🎯 FIXED HOOK DETECTION & TIMING
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
        FishingDelay = 0.1,            -- ⚡ OPTIMAL: Delay antar cast
        CancelDelay = 0.2,             -- ⚡ OPTIMAL: Delay cancel input  
        HookDetectionDelay = 0.05,     -- ⚡ OPTIMAL: Delay deteksi hook
        RetryDelay = 0.3,              -- ⚡ OPTIMAL: Delay retry jika gagal
        MaxWaitTime = 3.0,             -- ⚡ OPTIMAL: Max wait untuk hook
        
        -- 🎯 PERFECT/AMAZING CAST SETTINGS
        PerfectChargeTime = 0.8,       -- ⚡ OPTIMAL: Charge time lebih pendek
        PerfectReleaseDelay = 0.005,   -- ⚡ OPTIMAL: Release delay
        PerfectPower = 0.95,           -- ⚡ OPTIMAL: Power value untuk Perfect/Amazing
        
        -- ⚡ HOOK DETECTION SETTINGS
        UseMultiDetection = true,      -- Multiple detection methods
        UseVisualDetection = true,     -- Visual cue detection
        UseSoundDetection = false,     -- Sound cue detection
    }
}

_G.FishingScript = fishing

-- Logging dengan emoji
local function log(msg, isError)
    local prefix = isError and "❌" or "✅"
    print(("[%s Fishing] %s"):format(prefix, msg))
end

-- Fungsi disable animasi
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

-- 🎯 FUNGSI CAST PERFECT/AMAZING - IMPROVED
function fishing.PerfectCast()
    if not fishing.Running or fishing.WaitingHook then 
        log("⚠️ Skip cast - already waiting for hook")
        return 
    end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    
    log("🎯 Cast Attempt #" .. fishing.CurrentCycle)

    local castSuccess = pcall(function()
        -- ===== STRATEGY: SIMPLE & RELIABLE =====
        local startTime = tick()
        
        -- Mulai charge
        local chargeData = {[1] = startTime}
        local chargeResult = RF_ChargeFishingRod:InvokeServer(chargeData)
        
        if not chargeResult then
            error("Charge fishing rod failed")
        end
        
        -- Tunggu charge time yang lebih pendek
        local waitTime = fishing.Settings.PerfectChargeTime
        local endTime = tick() + waitTime
        
        while tick() < endTime and fishing.Running do
            task.wait(0.01)
        end
        
        -- Release dengan delay minimal
        task.wait(fishing.Settings.PerfectReleaseDelay)
        
        local releaseTime = tick()
        local actualCharge = releaseTime - startTime
        
        -- Power optimal
        local perfectPower = fishing.Settings.PerfectPower
        
        -- Kirim request fishing
        local minigameResult = RF_RequestMinigame:InvokeServer(
            perfectPower,
            0,
            releaseTime
        )
        
        if not minigameResult then
            error("Request minigame failed")
        end
        
        fishing.WaitingHook = true
        log(string.format("⚡ Cast Success! (Charge: %.2fs, Power: %.2f)", actualCharge, perfectPower))
        
        -- ⚡ IMPROVED HOOK DETECTION SYSTEM
        local hookDetected = false
        local detectionStart = tick()
        
        -- Method 1: Event-based detection (utama)
        local eventDetection = RE_MinigameChanged.OnClientEvent:Connect(function(state)
            if fishing.WaitingHook and typeof(state) == "string" then
                local stateLower = state:lower()
                if stateLower:find("hook") or stateLower:find("bite") or stateLower:find("catch") or stateLower == "!" then
                    hookDetected = true
                    eventDetection:Disconnect()
                    
                    fishing.WaitingHook = false
                    log("🎣 HOOK DETECTED! - Reeling in")
                    
                    task.wait(fishing.Settings.HookDetectionDelay)
                    pcall(function()
                        RE_FishingCompleted:FireServer()
                    end)

                    task.wait(fishing.Settings.CancelDelay)
                    pcall(function()
                        RF_CancelFishingInputs:InvokeServer()
                    end)

                    -- Quick recast
                    task.wait(fishing.Settings.FishingDelay)
                    if fishing.Running then
                        fishing.PerfectCast()
                    end
                end
            end
        end)
        
        -- Method 2: Timeout fallback
        task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                if not hookDetected then
                    fishing.WaitingHook = false
                    eventDetection:Disconnect()
                    
                    log("⏰ No hook - Timeout recovery", true)
                    
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

-- Start Function - SIMPLIFIED
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.PerfectCasts = 0
    fishing.AmazingCasts = 0

    log("🚀 AUTO FISHING STARTED!")
    log("⚡ Improved hook detection system")
    disableFishingAnim()

    -- Fish caught handler - SIMPLE & FAST
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            
            local weight = data and data.Weight or 0
            local rarity = data and data.Rarity or "Common"
            local castResult = data and data.CastResult or "Unknown"
            
            if castResult == "Perfect" then
                fishing.PerfectCasts += 1
                log(string.format("🌟 PERFECT! %s (%.2fkg)", tostring(name), weight))
            elseif castResult == "Amazing" then
                fishing.AmazingCasts += 1
                log(string.format("💫 AMAZING! %s (%.2fkg)", tostring(name), weight))
            else
                log(string.format("🎣 %s! %s (%.2fkg)", castResult, tostring(name), weight))
            end

            -- Fast reset setelah catch
            task.wait(fishing.Settings.CancelDelay)
            pcall(function()
                RF_CancelFishingInputs:InvokeServer()
            end)

            -- Immediate recast
            task.wait(fishing.Settings.FishingDelay)
            if fishing.Running then
                fishing.PerfectCast()
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
                log(string.format("📊 %d fish | %.1f%% PERFECT | %.1f%% AMAZING", 
                    fishing.TotalFish, perfectRate, amazingRate))
            end
        end
    end)

    task.wait(0.3)
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
    log(string.format("🛑 STOPPED | %d fish | %d PERFECT | %d AMAZING | %.1f%% Good", 
        fishing.TotalFish, fishing.PerfectCasts, fishing.AmazingCasts, successRate))
end

-- 🎯 QUICK TUNING COMMANDS:
-- _G.FishingScript.Settings.PerfectChargeTime = 0.8    -- Standard
-- _G.FishingScript.Settings.PerfectPower = 0.95        -- Standard
-- _G.FishingScript.Settings.MaxWaitTime = 3.0          -- Hook wait time

return fishing
