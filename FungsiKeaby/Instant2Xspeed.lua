-- ⚡ ULTRA STABLE AUTO FISHING (Consistent Minigame Timing)
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
    LastRequest = 0, -- 🕒 untuk anti-spam request
    Settings = {
        FishingDelay = 0.3,
        CancelDelay = 0.05,
        FallbackDelay = 0.35, -- 🕒 delay sebelum fallback tarik
        RequestDelay = 0.15,  -- ⏳ delay sebelum RequestMinigame (setelah kail dilempar)
        PostRequestDelay = 0.05, -- ⏳ delay sesudah request agar event stabil
        RequestCooldown = 0.3, -- 🧩 tambahan: jeda minimum antar RequestMinigame
    },
}
_G.FishingScript = fishing

local function log(msg)
    print(string.format("[%s] [Fishing] %s", os.date("!%X"), msg))
end

-- 🎯 Hook detection
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if fishing.WaitingHook and typeof(state) == "string" and string.find(string.lower(state), "hook") then
        fishing.WaitingHook = false
        task.wait(1.1)
        RE_FishingCompleted:FireServer()
        log("✅ Hook terdeteksi — ikan ditarik.")
        task.wait(fishing.Settings.CancelDelay)
        pcall(function() RF_CancelFishingInputs:InvokeServer() end)
        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then fishing.Cast() end
    end
end)

-- 🐟 Ikan tertangkap
RE_FishCaught.OnClientEvent:Connect(function(name, data)
    if fishing.Running then
        fishing.WaitingHook = false
        fishing.TotalFish += 1
        log("🐟 Ikan tertangkap: " .. tostring(name))
        task.wait(fishing.Settings.CancelDelay)
        pcall(function() RF_CancelFishingInputs:InvokeServer() end)
        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then fishing.Cast() end
    end
end)

-- 🧩 Fungsi aman untuk RequestMinigame agar tidak spam
local function SafeRequestMinigame()
    local now = tick()
    if now - fishing.LastRequest < fishing.Settings.RequestCooldown then
        -- ⛔ skip karena masih cooldown
        return false
    end
    fishing.LastRequest = now

    task.wait(fishing.Settings.RequestDelay)
    pcall(function()
        RF_RequestMinigame:InvokeServer(1, 0, tick())
    end)
    task.wait(fishing.Settings.PostRequestDelay)
    log("🎯 Request minigame dikirim (stabil).")
    return true
end

-- 🪝 Fungsi utama lempar kail
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end
    fishing.CurrentCycle += 1

    pcall(function()
        RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        log("⚡ Lempar pancing.")
        
        -- Tunggu agar kail benar-benar jatuh ke air
        task.wait(1.6)

        -- 🧠 Hanya kirim request jika belum cooldown dan masih running
        if fishing.Running and not fishing.WaitingHook then
            local ok = SafeRequestMinigame()
            if ok then
                fishing.WaitingHook = true
                log("🎯 Menunggu hook...")
            else
                log("🕒 Skip RequestMinigame (masih cooldown).")
            end
        end

        -- 🕒 Delay fallback aman (hanya tarik jika hook tidak muncul)
        task.delay(4.2, function()
            if fishing.WaitingHook and fishing.Running then
                task.wait(fishing.Settings.FallbackDelay)
                if not fishing.WaitingHook or not fishing.Running then return end
                fishing.WaitingHook = false
                RE_FishingCompleted:FireServer()
                log("⚠️ Timeout — fallback tarik.")
                task.wait(fishing.Settings.CancelDelay)
                pcall(function() RF_CancelFishingInputs:InvokeServer() end)
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then fishing.Cast() end
            end
        end)
    end)
end

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
    log("🛑 FISHING STOPPED")
end

return fishing
