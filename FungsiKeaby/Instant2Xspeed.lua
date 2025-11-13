-- ⚡ ULTRA CONSISTENT AUTO FISHING v2 (Stable Cycle System)
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
    CycleLock = false,
    CurrentCycle = 0,
    TotalFish = 0,
    Settings = {
        FishingDelay = 0.25,
        CancelDelay = 0.05,
        FallbackDelay = 0.35,
        RequestDelay = 0.15,
        PostRequestDelay = 0.05,
        Timeout = 4.2,
    },
}
_G.FishingScript = fishing

local function log(msg)
    print(string.format("[Fishing] %s", msg))
end

-- 🪝 Core fishing cycle
function fishing.Cast()
    if not fishing.Running or fishing.CycleLock then return end
    fishing.CycleLock = true
    fishing.CurrentCycle += 1

    pcall(function()
        -- 🔹 Double throw (dua kali untuk konsistensi visual)
        RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        log("⚡ Lempar pancing.")
        task.wait(0.08)
        RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        log("⚡ Lempar pancing.")

        -- 🔹 Tunggu kail benar-benar dilempar
        task.wait(1.65 + fishing.Settings.RequestDelay)

        -- 🔹 Dua kali request untuk sinkronisasi hook
        RF_RequestMinigame:InvokeServer(1, 0, tick())
        log("🎯 Menunggu hook...")
        task.wait(0.08)
        RF_RequestMinigame:InvokeServer(1, 0, tick())
        log("🎯 Menunggu hook...")

        fishing.WaitingHook = true

        -- 🔹 Timeout fallback
        task.delay(fishing.Settings.Timeout, function()
            if fishing.WaitingHook and fishing.Running then
                task.wait(fishing.Settings.FallbackDelay)
                if not fishing.WaitingHook or not fishing.Running then return end
                fishing.WaitingHook = false
                RE_FishingCompleted:FireServer()
                log("⚠️ Timeout — fallback tarik.")
                task.wait(fishing.Settings.CancelDelay)
                pcall(function() RF_CancelFishingInputs:InvokeServer() end)
                task.wait(fishing.Settings.FishingDelay)
                fishing.CycleLock = false
                if fishing.Running then fishing.Cast() end
            end
        end)
    end)
end

-- 🎣 Hook detected
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if fishing.WaitingHook and typeof(state) == "string" and string.find(string.lower(state), "hook") then
        fishing.WaitingHook = false
        task.wait(1.05)
        RE_FishingCompleted:FireServer()
        log("🐟 Ikan tertangkap: Bandit Angelfish") -- log dummy biar konsisten urutan
        task.wait(fishing.Settings.CancelDelay)
        pcall(function() RF_CancelFishingInputs:InvokeServer() end)
        task.wait(fishing.Settings.FishingDelay)
        fishing.CycleLock = false
        if fishing.Running then fishing.Cast() end
    end
end)

-- 🐠 Real fish caught confirmation
RE_FishCaught.OnClientEvent:Connect(function(name)
    if not fishing.Running then return end
    fishing.WaitingHook = false
    fishing.TotalFish += 1
    log("🐟 Ikan tertangkap: " .. tostring(name))
    task.wait(fishing.Settings.CancelDelay)
    pcall(function() RF_CancelFishingInputs:InvokeServer() end)
    task.wait(fishing.Settings.FishingDelay)
    fishing.CycleLock = false
    if fishing.Running then fishing.Cast() end
end)

-- 🚀 Start / Stop
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    log("🚀 FISHING STARTED")
    fishing.Cast()
end

function fishing.Stop()
    fishing.Running = false
    fishing.WaitingHook = false
    fishing.CycleLock = false
    log("🛑 FISHING STOPPED")
end

return fishing
