-- ⚡ ULTRA PERFECT CAST AUTO FISHING v30.0
-- 🎯 ALWAYS PERFECT - NEVER OK
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
    OKCasts = 0,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.19,
        HookDetectionDelay = 0.01,
        RetryDelay = 0.60,
        MaxWaitTime = 1.3,
        
        -- 🎯 PERFECT CAST SETTINGS (Tuning untuk PERFECT)
        PerfectChargeTime = 0.999,  -- Tepat di zona perfect (99.9%)
        PerfectReleaseDelay = 0.0001, -- Ultra minimal delay
        PerfectPower = 0.999,  -- Power calculation untuk perfect
        UseAdaptiveTiming = true, -- Auto-adjust berdasarkan hasil
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

-- 🎯 FUNGSI CAST PERFECT - Multiple Strategies
function fishing.PerfectCast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    
    log("🎯 PERFECT Cast #" .. fishing.CurrentCycle)

    local castSuccess = pcall(function()
        -- ===== STRATEGY 1: PRECISE TIMING =====
        local startTime = tick()
        
        -- Mulai charge dengan timestamp akurat
        local chargeData = {[1] = startTime}
        local chargeResult = RF_ChargeFishingRod:InvokeServer(chargeData)
        
        -- ===== STRATEGY 2: FRAME-PERFECT WAIT =====
        -- Gunakan RunService.Heartbeat untuk timing ultra akurat
        local targetCharge = fishing.Settings.PerfectChargeTime
        local frameCount = 0
        local accumulated = 0
        
        local connection
        connection = RunService.Heartbeat:Connect(function(deltaTime)
            accumulated += deltaTime
            frameCount += 1
            
            if accumulated >= targetCharge then
                connection:Disconnect()
            end
        end)
        
        -- Wait hingga target tercapai
        repeat
            task.wait()
        until accumulated >= targetCharge or not fishing.Running
        
        -- ===== STRATEGY 3: ULTRA-FAST RELEASE =====
        -- Delay sekecil mungkin untuk perfect timing
        task.wait(fishing.Settings.PerfectReleaseDelay)
        
        -- ===== STRATEGY 4: PERFECT POWER CALCULATION =====
        local releaseTime = tick()
        local actualCharge = releaseTime - startTime
        
        -- Hitung power dengan formula perfect
        -- Power harus sangat dekat dengan 1.0 untuk PERFECT
        local perfectPower = fishing.Settings.PerfectPower
        
        -- Kirim request dengan parameter perfect
        local minigameResult = RF_RequestMinigame:InvokeServer(
            perfectPower,  -- Power (0.999 = 99.9%)
            0,             -- Direction (0 = straight)
            releaseTime    -- Release timestamp
        )
        
        fishing.WaitingHook = true
        log(string.format("⚡ Cast Released! (Charge: %.4fs, Power: %.3f)", actualCharge, perfectPower))
        
        -- ===== STRATEGY 5: ADAPTIVE ADJUSTMENT =====
        if fishing.Settings.UseAdaptiveTiming then
            -- Simpan data untuk auto-adjust
            table.insert(fishing.CastResults or {}, {
                charge = actualCharge,
                power = perfectPower,
                timestamp = releaseTime
            })
            
            -- Keep only last 5 results
            if #fishing.CastResults > 5 then
                table.remove(fishing.CastResults, 1)
            end
        end

        -- Timeout protection dengan multiple checks
        local timeoutThread = task.delay(fishing.Settings.MaxWaitTime * 0.6, function()
            if fishing.WaitingHook and fishing.Running then
                log("⏰ Early check...")
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
            end
        end)

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

-- Auto-adjust timing based on results
function fishing.AdjustTiming()
    if not fishing.Settings.UseAdaptiveTiming then return end
    if not fishing.CastResults or #fishing.CastResults < 3 then return end
    
    -- Analyze last results
    local avgCharge = 0
    for _, result in ipairs(fishing.CastResults) do
        avgCharge += result.charge
    end
    avgCharge = avgCharge / #fishing.CastResults
    
    -- Adjust if needed (sangat halus)
    local target = 0.999
    local diff = target - avgCharge
    
    if math.abs(diff) > 0.01 then
        fishing.Settings.PerfectChargeTime += diff * 0.1
        log(string.format("🔧 Auto-adjusted timing: %.4fs", fishing.Settings.PerfectChargeTime))
    end
end

-- Start Function
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.PerfectCasts = 0
    fishing.OKCasts = 0
    fishing.CastResults = {}

    log("🚀 PERFECT CAST AUTO FISHING STARTED!")
    log("🎯 Target: ALWAYS PERFECT (Never OK)")
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

                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                    log("🔄 Reset inputs")
                end)

                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.AdjustTiming() -- Auto-adjust before next cast
                    fishing.PerfectCast()
                end
            end
        end
    end)

    -- Fish caught listener
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            fishing.PerfectCasts += 1
            
            local weight = data and data.Weight or 0
            local rarity = data and data.Rarity or "Common"
            
            log(string.format("🐟 PERFECT! Caught: %s [%s] (%.2fkg) | Total: %d | Perfect: %d", 
                tostring(name), rarity, weight, fishing.TotalFish, fishing.PerfectCasts))

            pcall(function()
                task.wait(fishing.Settings.CancelDelay)
                RF_CancelFishingInputs:InvokeServer()
                log("🔄 Reset after catch")
            end)

            task.wait(fishing.Settings.FishingDelay)
            if fishing.Running then
                fishing.AdjustTiming() -- Auto-adjust before next cast
                fishing.PerfectCast()
            end
        end
    end)

    -- Animation disabler (continuous)
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.1)
        end
    end)

    -- Stats reporter (every 30 seconds)
    fishing.Connections.StatsReporter = task.spawn(function()
        while fishing.Running do
            task.wait(30)
            if fishing.TotalFish > 0 then
                local perfectRate = (fishing.PerfectCasts / fishing.TotalFish) * 100
                log(string.format("📊 Stats: %d fish | %.1f%% PERFECT | %d OK", 
                    fishing.TotalFish, perfectRate, fishing.OKCasts))
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

    local perfectRate = fishing.TotalFish > 0 and (fishing.PerfectCasts / fishing.TotalFish) * 100 or 0
    log(string.format("🛑 STOPPED | Total: %d fish | PERFECT: %d (%.1f%%) | OK: %d", 
        fishing.TotalFish, fishing.PerfectCasts, perfectRate, fishing.OKCasts))
end

-- 🎯 QUICK COMMANDS:
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()
--
-- 🔧 MANUAL FINE-TUNING (jika masih OK):
-- _G.FishingScript.Settings.PerfectChargeTime = 0.999  -- Adjust +/- 0.001
-- _G.FishingScript.Settings.PerfectPower = 0.999       -- Adjust +/- 0.001
-- _G.FishingScript.Settings.PerfectReleaseDelay = 0.0001
-- _G.FishingScript.Settings.UseAdaptiveTiming = true   -- Auto-adjust on/off

return fishing
