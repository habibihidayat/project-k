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
    Requested = false,
    Phase = "Idle",
    Settings = {
        FishingDelay = 0.5,
        CancelDelay = 0.2,
        FallbackDelay = 5.0,
        RequestDelay = 1.3,
        PostRequestDelay = 1.3,
        Timeout = 0.26,
        SafeCooldown = 0.25,
    }
}
_G.FishingScript = fishing

local function log(msg)
    print("[Fishing] " .. msg)
end

local function resetCycle()
    fishing.WaitingHook = false
    fishing.Requested = false
    fishing.Phase = "Idle"
end

-- 🪝 Lempar kail
function fishing.Cast()
    if not fishing.Running or fishing.Phase ~= "Idle" then return end
    fishing.Phase = "Casting"
    fishing.CurrentCycle += 1
    log("⚡ Lempar pancing.")

    task.spawn(function()
        pcall(function()
            RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        end)

        task.wait(fishing.Settings.RequestDelay)
        if not fishing.Running then return end

        if not fishing.Requested then
            fishing.Requested = true
            RF_RequestMinigame:InvokeServer(1, 0, tick())
            log("🎯 Menunggu hook...")
            fishing.WaitingHook = true
            fishing.Phase = "Waiting"
        end

        -- Timeout fallback
        task.delay(fishing.Settings.FallbackDelay, function()
            if fishing.Running and fishing.WaitingHook then
                fishing.WaitingHook = false
                fishing.Phase = "Pulling"
                log("⚠️ Timeout pendek — fallback tarik cepat.")
                RE_FishingCompleted:FireServer()
                task.wait(fishing.Settings.CancelDelay)
                pcall(function() RF_CancelFishingInputs:InvokeServer() end)
                task.wait(fishing.Settings.FishingDelay)
                resetCycle()
                task.wait(fishing.Settings.SafeCooldown)
                if fishing.Running then fishing.Cast() end
            end
        end)
    end)
end

-- 🎯 Hook detection
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if not fishing.Running or not fishing.WaitingHook then return end
    if typeof(state) == "string" and string.find(string.lower(state), "hook") then
        fishing.WaitingHook = false
        fishing.Phase = "Pulling"
        task.wait(1.0)
        RE_FishingCompleted:FireServer()
        log("✅ Hook terdeteksi — ikan ditarik.")
        task.wait(fishing.Settings.CancelDelay)
        pcall(function() RF_CancelFishingInputs:InvokeServer() end)
        task.wait(fishing.Settings.FishingDelay)
        resetCycle()
        task.wait(fishing.Settings.SafeCooldown)
        if fishing.Running then fishing.Cast() end
    end
end)

-- 🐟 Ikan tertangkap
RE_FishCaught.OnClientEvent:Connect(function(name)
    if not fishing.Running then return end
    fishing.TotalFish += 1
    fishing.WaitingHook = false
    fishing.Phase = "Cooldown"
    log("🐟 Ikan tertangkap: " .. tostring(name))
    task.wait(fishing.Settings.CancelDelay)
    pcall(function() RF_CancelFishingInputs:InvokeServer() end)
    task.wait(fishing.Settings.FishingDelay)
    resetCycle()
    task.wait(fishing.Settings.SafeCooldown)
    if fishing.Running then fishing.Cast() end
end)

-- 🚀 Start / Stop
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    resetCycle()
    log("🚀 FISHING STARTED!")
    fishing.Cast()
end

function fishing.Stop()
    fishing.Running = false
    fishing.WaitingHook = false
    fishing.Requested = false
    fishing.Phase = "Idle"
    log("🛑 FISHING STOPPED")
end

return fishing
