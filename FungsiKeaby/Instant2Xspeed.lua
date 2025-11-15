-- ⚡ ULTRA SPEED AUTO FISHING v30.0 (Fix: no overlap, tokenized cycles, safe timers)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Stop previous
if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.05)
end

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

-- Config
local PREDICTED_HOOK_TIME = 1.22 -- bisa diubah di GUI nanti

local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    LastHookTime = 0,
    Connections = {},
    PendingTimers = {},    -- simpan handles timer untuk dibatalkan
    ActiveCycleId = nil,   -- token untuk cycle sekarang
    CastLock = false,      -- mencegah overlap
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.12,
        HookDetectionDelay = 0.01,
        RetryDelay = 0.05,
        MinCycleDelay = 0.08,
        ForceResetTime = 0.7,
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

local function cancelPendingTimers()
    for _, t in ipairs(fishing.PendingTimers) do
        pcall(function() task.cancel(t) end)
    end
    fishing.PendingTimers = {}
end

local function addPendingTimer(thread)
    table.insert(fishing.PendingTimers, thread)
end

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

-- safe Fire wrapper
local function safeFire(remote, ...)
    pcall(function() remote:FireServer(...) end)
end

-- Create a unique cycle token
local function newCycleId()
    -- use tick + counter to reduce collision chance
    return tostring(tick()) .. "-" .. tostring(fishing.CurrentCycle)
end

-- CAST (no overlap, tokenized)
function fishing.Cast()
    if not fishing.Running then return end
    if fishing.CastLock then return end
    if fishing.WaitingHook then return end

    fishing.CastLock = true
    fishing.CurrentCycle = fishing.CurrentCycle + 1
    local cycleId = newCycleId()
    fishing.ActiveCycleId = cycleId
    fishing.WaitingHook = true
    fishing.LastHookTime = tick()
    fishing.PredictTriggered = false
    local cycleStart = tick()

    log("⚡ Lempar pancing (Cycle: " .. fishing.CurrentCycle .. " | id:" .. cycleId .. ")")

    -- Kirim non-blocking kedua remote secara cepat (FireServer)
    safeFire(RF_ChargeFishingRod, {[1] = tick(), cycle = cycleId})
    -- very short wait to keep ordering but non-blocking
    task.wait(0.01)
    safeFire(RF_RequestMinigame, 1, 0, tick(), cycleId)

    -- Predictive timer: kita simpan handle supaya bisa dibatalkan
    local predThread = task.delay(PREDICTED_HOOK_TIME, function()
        if fishing.Running and fishing.WaitingHook and fishing.ActiveCycleId == cycleId then
            fishing.PredictTriggered = true
            -- (opsional) tampilkan indicator GUI internal di sini
            log("⚡ Predictive hook triggered (id:" .. cycleId .. ")")
        end
    end)
    addPendingTimer(predThread)

    -- Early reset timer (kurangi false positives)
    local earlyThread = task.delay(fishing.Settings.ForceResetTime * 0.3, function()
        if fishing.Running and fishing.WaitingHook and fishing.ActiveCycleId == cycleId and (tick() - fishing.LastHookTime) > (fishing.Settings.ForceResetTime * 0.3) then
            log("⚡ Early reset attempt (id:" .. cycleId .. ")")
            -- clear state & cancel pending timers
            fishing.WaitingHook = false
            fishing.ActiveCycleId = nil
            cancelPendingTimers()
            pcall(function()
                safeFire(RE_FishingCompleted)
                safeFire(RF_CancelFishingInputs)
            end)
            task.wait(fishing.Settings.RetryDelay)
            fishing.CastLock = false
            if fishing.Running then fishing.Cast() end
        end
    end)
    addPendingTimer(earlyThread)

    -- Main force reset
    local mainReset = task.delay(fishing.Settings.ForceResetTime, function()
        if fishing.Running and fishing.WaitingHook and fishing.ActiveCycleId == cycleId then
            log("⏰ Force reset (id:" .. cycleId .. ")")
            fishing.WaitingHook = false
            fishing.ActiveCycleId = nil
            cancelPendingTimers()
            pcall(function()
                safeFire(RE_FishingCompleted)
                task.wait(0.03)
                safeFire(RF_CancelFishingInputs)
            end)
            local elapsed = tick() - cycleStart
            local rem = math.max(0, fishing.Settings.MinCycleDelay - elapsed)
            if rem > 0 then task.wait(rem) end
            fishing.CastLock = false
            if fishing.Running then fishing.Cast() end
        end
    end)
    addPendingTimer(mainReset)

    -- release cast lock if nothing else (safety after tiny wait)
    task.delay(0.035, function()
        fishing.CastLock = false
    end)
end

-- Hook detection: only respond to active cycle and only once
local function setupHookDetection()
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if not fishing.Running then return end
        if not fishing.WaitingHook then return end
        if typeof(state) ~= "string" then return end

        local s = string.lower(state)
        if not (s:find("hook") or s:find("bite") or s:find("catch") or s:find("!")) then return end

        -- capture current active id (we don't trust server to echo id, but we only accept if WaitingHook true)
        local capturedId = fishing.ActiveCycleId

        -- mark finished immediately and cancel timers tied to cycle
        fishing.WaitingHook = false
        fishing.ActiveCycleId = nil
        cancelPendingTimers()

        fishing.TotalFish = fishing.TotalFish + 1
        fishing.LastHookTime = tick()

        if fishing.PredictTriggered then
            log("✅ Hook terdeteksi (server confirm) - prediksi aktif (Total: " .. fishing.TotalFish .. ")")
        else
            log("✅ Hook terdeteksi (server) (Total: " .. fishing.TotalFish .. ")")
        end

        -- RESPOND FAST: Fire non-blocking
        task.wait(fishing.Settings.HookDetectionDelay)
        pcall(function() safeFire(RE_FishingCompleted) end)

        task.wait(fishing.Settings.CancelDelay)
        pcall(function() safeFire(RF_CancelFishingInputs) end)

        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then
            -- ensure a tiny gap to avoid immediate race with server
            task.wait(math.max(0.01, fishing.Settings.MinCycleDelay))
            fishing.Cast()
        end
    end)
end

-- START / STOP
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.LastHookTime = 0
    fishing.ActiveCycleId = nil
    fishing.PredictTriggered = false
    fishing.PendingTimers = {}
    fishing.CastLock = false

    log("🚀 AUTO FISHING STARTED (v30.0 - safe)")

    disableFishingAnim()
    setupHookDetection()

    -- Anim disabler
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.08)
        end
    end)

    -- Safety monitor with stricter conditions
    fishing.Connections.SafetyMonitor = task.spawn(function()
        while fishing.Running do
            task.wait(0.45)
            if fishing.WaitingHook and (tick() - fishing.LastHookTime) > (fishing.Settings.ForceResetTime + 0.5) then
                log("🔄 Safety reset - stuck detected")
                fishing.WaitingHook = false
                fishing.ActiveCycleId = nil
                cancelPendingTimers()
                pcall(function()
                    safeFire(RE_FishingCompleted)
                    safeFire(RF_CancelFishingInputs)
                end)
                task.wait(0.12)
                fishing.CastLock = false
                if fishing.Running then fishing.Cast() end
            end
        end
    end)

    task.wait(0.12)
    if fishing.Running then fishing.Cast() end
end

function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.WaitingHook = false
    fishing.ActiveCycleId = nil
    cancelPendingTimers()

    for k, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            pcall(function() task.cancel(conn) end)
        end
    end
    fishing.Connections = {}
    fishing.PendingTimers = {}

    log("🛑 AUTO FISHING STOPPED - Total Ikan: " .. fishing.TotalFish)
end

return fishing
