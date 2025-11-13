local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")
local RE_FishCaught = netFolder:WaitForChild("RE/FishCaught")

local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    LockCycle = false,
    Settings = {
        FishingDelay = 0.3,
        CancelDelay = 0.05,
        FallbackDelay = 0.35,
        RequestDelay = 0.15,
        PostRequestDelay = 0.05,
        MinigameDelay = 0.08, -- extra delay biar Request gak spam
    },
}
_G.FishingScript = fishing

local function log(msg)
    print("[Fishing] " .. msg)
end

-- 🔄 Reset lock aman antar siklus
local function resetCycle()
    fishing.WaitingHook = false
    fishing.LockCycle = false
end

-- 🪝 Fungsi utama lempar kail
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook or fishing.LockCycle then return end
    fishing.LockCycle = true
    fishing.CurrentCycle += 1

    pcall(function()
        RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        log("⚡ Lempar pancing.")
        task.wait(fishing.Settings.RequestDelay)
        RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        log("⚡ Lempar pancing.")

        task.wait(1.6 + fishing.Settings.MinigameDelay)
        RF_RequestMinigame:InvokeServer(1, 0, tick())
        task.wait(fishing.Settings.PostRequestDelay)
        log("🎯 Menunggu hook...")

        fishing.WaitingHook = true
    end)

    -- Timeout fallback
    task.delay(4.0, function()
        if fishing.WaitingHook and fishing.Running then
            fishing.WaitingHook = false
            log("⚠️ Timeout pendek — fallback tarik cepat.")
            RE_FishingCompleted:FireServer()
            task.wait(fishing.Settings.CancelDelay)
            pcall(function() RF_CancelFishingInputs:InvokeServer() end)
            task.wait(fishing.Settings.FishingDelay)
            resetCycle()
            if fishing.Running then fishing.Cast() end
        end
    end)
end

-- 🎯 Hook detection
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if not fishing.Running or not fishing.WaitingHook then return end
    if typeof(state) == "string" and string.find(string.lower(state), "hook") then
        fishing.WaitingHook = false
        task.wait(1.1)
        RE_FishingCompleted:FireServer()
        log("✅ Hook terdeteksi — ikan ditarik.")
        task.wait(fishing.Settings.CancelDelay)
        pcall(function() RF_CancelFishingInputs:InvokeServer() end)
        task.wait(fishing.Settings.FishingDelay)
        resetCycle()
        if fishing.Running then fishing.Cast() end
    end
end)

-- 🐟 Ikan tertangkap
RE_FishCaught.OnClientEvent:Connect(function(name, data)
    if not fishing.Running then return end
    fishing.TotalFish += 1
    fishing.WaitingHook = false
    log("🐟 Ikan tertangkap: " .. tostring(name))
    task.wait(fishing.Settings.CancelDelay)
    pcall(function() RF_CancelFishingInputs:InvokeServer() end)
    task.wait(fishing.Settings.FishingDelay)
    resetCycle()
    if fishing.Running then fishing.Cast() end
end)

-- 🚀 Start / Stop
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    log("🚀 FISHING STARTED!")
    fishing.Cast()
end

function fishing.Stop()
    fishing.Running = false
    fishing.WaitingHook = false
    fishing.LockCycle = false
    log("🛑 FISHING STOPPED")
end

return fishing
