-- ⚡ ULTRA SPEED AUTO FISHING v29.2 (OPTIMIZED + Predictive Hook + Parallel Trigger)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

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

-- PREDIKSI TANDA SERU CEPAT (ubah sesuai rod)
local PREDICTED_HOOK_TIME = 1.22  -- slider manual nanti bisa ditambah

local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    LastHookTime = 0,
    PredictTriggered = false,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.15,
        HookDetectionDelay = 0.02,
        RetryDelay = 0.05,
        MaxWaitTime = 1.0,
        MinCycleDelay = 0.08,
        ForceResetTime = 0.7,
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

local function disableFishingAnim()
    pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            local n = track.Name:lower()
            if n:find("fish") or n:find("rod") or n:find("cast") or n:find("reel") then
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

---------------------------------------------------------
-- 🔥 PARALLEL CAST + PREDICTIVE HOOK
---------------------------------------------------------

function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    fishing.PredictTriggered = false
    local cycleStart = tick()

    log("⚡ Lempar pancing (Cycle: " .. fishing.CurrentCycle .. ")")

    local castSuccess = pcall(function()

        ----------------------------------------------------------------------------
        -- 🎯 **Parallel Fire: ChargeRod dan RequestMinigame dikirim bersamaan**
        ----------------------------------------------------------------------------
        task.spawn(function()
            RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        end)

        task.spawn(function()
            RF_RequestMinigame:InvokeServer(1, 0, tick())
        end)

        fishing.WaitingHook = true
        fishing.LastHookTime = tick()

        log("🎯 Menunggu hook... (Parallel requests)")

        ----------------------------------------------------------------------------
        -- ⚡ PREDICTIVE HOOK — Tanda seru muncul lebih cepat dari server
        ----------------------------------------------------------------------------
        task.delay(PREDICTED_HOOK_TIME, function()
            if fishing.WaitingHook and fishing.Running then
                fishing.PredictTriggered = true
                log("⚡ Predictive hook triggered lebih cepat!")
            end
        end)
        ----------------------------------------------------------------------------

        -------------------------------------------------------------------------
        -- Early Reset
        -------------------------------------------------------------------------
        local forceResetTime = fishing.Settings.ForceResetTime

        task.delay(forceResetTime * 0.3, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚡ Early reset attempt...")
                fishing.WaitingHook = false
                pcall(function()
                    RE_FishingCompleted:FireServer()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                task.wait(fishing.Settings.RetryDelay)
                if fishing.Running then fishing.Cast() end
            end
        end)

        -------------------------------------------------------------------------
        -- Main Force Reset
        -------------------------------------------------------------------------
        task.delay(forceResetTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⏰ Force reset - lanjut cast!")
                fishing.WaitingHook = false
                pcall(function()
                    RE_FishingCompleted:FireServer()
                    task.wait(0.03)
                    RF_CancelFishingInputs:InvokeServer()
                end)

                local elapsed = tick() - cycleStart
                local rem = math.max(0, fishing.Settings.MinCycleDelay - elapsed)
                if rem > 0 then task.wait(rem) end

                if fishing.Running then fishing.Cast() end
            end
        end)

    end)

    if not castSuccess then
        log("❌ Gagal cast, retrying...")
        task.wait(fishing.Settings.RetryDelay)
        if fishing.Running then fishing.Cast() end
    end
end


---------------------------------------------------------
-- 🔥 HOOK DETECTION (Priority: Server OR Predict)
---------------------------------------------------------

local function setupHookDetection()
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if not fishing.WaitingHook then return end
        if typeof(state) ~= "string" then return end

        local s = string.lower(state)
        if not (s:find("hook") or s:find("bite") or s:find("catch") or s:find("!")) then return end

        fishing.WaitingHook = false
        fishing.TotalFish += 1
        fishing.LastHookTime = tick()

        if fishing.PredictTriggered then
            log("✅ Server hook (confirm) — prediksi sudah tampil")
        else
            log("✅ Server hook terdeteksi — tanpa prediksi")
        end

        task.wait(fishing.Settings.HookDetectionDelay)
        pcall(function() RE_FishingCompleted:FireServer() end)

        task.wait(fishing.Settings.CancelDelay)
        pcall(function() RF_CancelFishingInputs:InvokeServer() end)

        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then fishing.Cast() end
    end)
end


---------------------------------------------------------
-- START / STOP
---------------------------------------------------------

function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.LastHookTime = 0

    log("🚀 AUTO FISHING STARTED! (Predictive + Parallel)")

    disableFishingAnim()
    setupHookDetection()

    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.08)
        end
    end)

    fishing.Connections.SafetyMonitor = task.spawn(function()
        while fishing.Running do
            task.wait(0.5)
            if fishing.WaitingHook and (tick() - fishing.LastHookTime) > fishing.Settings.ForceResetTime + 0.5 then
                log("🔄 Safety reset - terdeteksi STUCK!")
                fishing.WaitingHook = false
                pcall(function()
                    RE_FishingCompleted:FireServer()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                task.wait(0.1)
                if fishing.Running then fishing.Cast() end
            end
        end
    end)

    task.wait(0.15)
    if fishing.Running then fishing.Cast() end
end

function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.WaitingHook = false

    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect()
        elseif typeof(conn) == "thread" then task.cancel(conn)
        end
    end
    fishing.Connections = {}

    log("🛑 STOPPED - Total Ikan: " .. fishing.TotalFish)
end

return fishing
