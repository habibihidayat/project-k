-- ⚡ ULTRA PERFECT CAST AUTO FISHING v30.1 (Rebuilt)
-- 🎯 ALWAYS PERFECT / AMAZING - Force-stable power approach
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Hentikan script lama jika masih aktif
if _G.FishingScript then
    pcall(function() _G.FishingScript.Stop() end)
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
        FishingDelay = 0.01,           -- Delay antar cast
        CancelDelay = 0.19,            -- Delay cancel input
        HookDetectionDelay = 0.01,     -- Delay deteksi hook
        RetryDelay = 0.60,             -- Delay retry jika gagal
        MaxWaitTime = 1.3,             -- Max wait untuk hook

        -- FORCE PERFECT SETTINGS (stable values)
        ForcePerfectPower = 0.987,     -- Recommended 0.985 - 0.990 (stable PERFECT/AMAZING)
        UseForcePower = true,          -- jika false, fallback ke original logic
        RequireChargeInvoke = true,    -- tetap panggil Charge (server expects it)
    }
}

_G.FishingScript = fishing

-- Logging kecil
local function log(msg, isError)
    local prefix = isError and "❌" or "✅"
    print(("[%s Fishing] %s"):format(prefix, msg))
end

-- Fungsi disable animasi (lebih aggressive)
local function disableFishingAnim()
    pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            local name = (track.Name or ""):lower()
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

-- SAFE helper to invoke remote and ignore errors
local function safeInvoke(fn, ...)
    local ok, res = pcall(fn.InvokeServer, fn, ...)
    return ok, res
end

-- NEW: Force-perfect cast (stable, minimal timing reliance)
function fishing.PerfectCast()
    if not fishing.Running or fishing.WaitingHook then return end
    fishing.CurrentCycle = fishing.CurrentCycle + 1
    disableFishingAnim()
    log("🎯 FORCED PERFECT Cast #" .. fishing.CurrentCycle)

    local ok, err = pcall(function()
        -- 1) Optional: call charge to satisfy server expectations
        if fishing.Settings.RequireChargeInvoke then
            -- provide a simple timestamp array as original script did
            local t = tick()
            safeInvoke(RF_ChargeFishingRod, {[1] = t})
        end

        -- 2) Decide power
        local powerToSend
        if fishing.Settings.UseForcePower then
            powerToSend = fishing.Settings.ForcePerfectPower or 0.987
        else
            powerToSend = fishing.Settings.PerfectPower or 0.999
        end

        -- 3) Minimal release timing - small wait to allow server to register charge invoke
        task.wait(0.005)

        -- 4) Send request minigame with forced power
        local releaseTime = tick()
        safeInvoke(RF_RequestMinigame, powerToSend, 0, releaseTime)
        fishing.WaitingHook = true
        log(string.format("⚡ Sent request (Power: %.3f)", powerToSend))

        -- 5) Timeout safeguard: if no hook within MaxWaitTime, force complete and retry
        task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.Running and fishing.WaitingHook then
                fishing.WaitingHook = false
                log("⚠️ Timeout - forcing complete", true)
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)

                -- small delay then cancel inputs to reset
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

    if not ok then
        log("❌ Error during PerfectCast, retrying... (" .. tostring(err) .. ")", true)
        task.wait(fishing.Settings.RetryDelay)
        if fishing.Running then
            fishing.PerfectCast()
        end
    end
end

-- Keep AdjustTiming but make it conservative and non-invasive
function fishing.AdjustTiming()
    -- this function will only tweak ForcePerfectPower slightly if UseForcePower == false
    if fishing.Settings.UseForcePower then return end
    if not fishing.CastResults or #fishing.CastResults < 3 then return end

    local avg = 0
    for _, r in ipairs(fishing.CastResults) do
        avg = avg + (r.charge or 0)
    end
    avg = avg / #fishing.CastResults

    -- target near 0.99 if using non-forced method
    local target = 0.99
    local diff = target - avg
    if math.abs(diff) > 0.005 then
        fishing.Settings.PerfectChargeTime = (fishing.Settings.PerfectChargeTime or 0.999) + diff * 0.05
        log(string.format("🔧 Adjusted PerfectChargeTime -> %.4f", fishing.Settings.PerfectChargeTime))
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
    log("🎯 Target: ALWAYS PERFECT / AMAZING (forced power)")
    disableFishingAnim()

    -- Hook detection listener (minigame notifications)
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
                    -- no heavy auto-adjust here; keep stable
                    fishing.PerfectCast()
                end
            end
        end
    end)

    -- Fish caught listener (confirm perfect)
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        fishing.WaitingHook = false
        fishing.TotalFish = fishing.TotalFish + 1
        fishing.PerfectCasts = fishing.PerfectCasts + 1

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
            fishing.PerfectCast()
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
            pcall(function() conn:Disconnect() end)
        elseif typeof(conn) == "thread" then
            pcall(function() task.cancel(conn) end)
        end
    end
    fishing.Connections = {}

    local perfectRate = fishing.TotalFish > 0 and (fishing.PerfectCasts / fishing.TotalFish) * 100 or 0
    log(string.format("🛑 STOPPED | Total: %d fish | PERFECT: %d (%.1f%%) | OK: %d",
        fishing.TotalFish, fishing.PerfectCasts, perfectRate, fishing.OKCasts))
end

-- Quick commands reminder (leave as comments)
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()
-- Adjust ForcePerfectPower if you want slightly different bias:
-- _G.FishingScript.Settings.ForcePerfectPower = 0.986

return fishing
