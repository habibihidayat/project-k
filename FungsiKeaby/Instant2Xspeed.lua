-- ⚡ ULTRA SPEED AUTO FISHING v29.0 (Tanpa GUI Internal & Tanpa Toggle Key - Untuk Integrasi dengan LynxGUI)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

-- Auto-stop any previous fishing scripts
if _G.FishingScript then
    _G.FishingScript.Stop()
    if _G.FishingScript.GUI then
        _G.FishingScript.GUI:Destroy()
    end
    task.wait(0.1)
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
local RE_FishCaught = netFolder:WaitForChild("RE/FishCaught")

-- Fishing settings
local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    
    -- ⚙️ 2 SLIDER UNTUK FLEXIBILITAS
    Settings = {
        FishingDelay = 0.3,    -- Delay setelah cancel inputs sebelum recast
        CancelDelay = 0.05,    -- Delay untuk cancel inputs
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

-- 🎯 HOOK DETECTION
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if fishing.WaitingHook and typeof(state) == "string" and string.find(string.lower(state), "hook") then
        fishing.WaitingHook = false
        
        -- ⚡ TARIK IKAN DULU - PASTIKAN IKAN NAIK
        task.wait(0.30) -- respon super cepat
        RE_FishingCompleted:FireServer()
        log("✅ Hook terdeteksi — ikan ditarik.")
        
        -- CANCEL INPUTS SETELAH BERHASIL TARIK IKAN
        task.wait(fishing.Settings.CancelDelay)
        pcall(function()
            RF_CancelFishingInputs:InvokeServer()
            log("🔄 Cancel inputs - reset cepat!")
        end)
        
        -- ⏳ TUNGGU FISHING DELAY YANG DIATUR, BARU RECAST
        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then
            fishing.Cast()
        end
    end
end)

-- 🐟 FISH CAUGHT
RE_FishCaught.OnClientEvent:Connect(function(name, data)
    if fishing.Running then
        fishing.WaitingHook = false
        fishing.TotalFish = fishing.TotalFish + 1
        local weight = data and data.Weight or 0
        log("🐟 Ikan tertangkap: " .. tostring(name) .. " (" .. string.format("%.2f", weight) .. " kg)")
        
        -- CANCEL INPUTS SETELAH IKAN MASUK INVENTORY
        task.wait(fishing.Settings.CancelDelay)
        pcall(function()
            RF_CancelFishingInputs:InvokeServer()
            log("🔄 Cancel inputs - reset cepat!")
        end)
        
        -- ⏳ TUNGGU FISHING DELAY YANG DIATUR, BARU RECAST
        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then
            fishing.Cast()
        end
    end
end)

-- 🎣 CAST FUNCTION
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end
    
    fishing.CurrentCycle = fishing.CurrentCycle + 1
    
    pcall(function()
        -- 1️⃣ LEMPAR KAIL
        RF_ChargeFishingRod:InvokeServer({[22] = tick()})
        log("⚡ Lempar pancing.")
        task.wait(0.07) -- lempar cepat banget

        -- 2️⃣ MULAI MINIGAME & TUNGGU TANDA SERU
        RF_RequestMinigame:InvokeServer(9, 0, tick())
        log("🎯 Menunggu hook...")
        fishing.WaitingHook = true

        -- 3️⃣ FALLBACK SUPER CEPAT (1.1 detik)
        task.delay(1.1, function()
            if fishing.WaitingHook and fishing.Running then
                fishing.WaitingHook = false
                RE_FishingCompleted:FireServer()
                log("⚠️ Timeout pendek — fallback tarik cepat.")
                
                -- CANCEL INPUTS PADA TIMEOUT
                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                    log("🔄 Cancel timeout - reset cepat!")
                end)
                
                -- ⏳ TUNGGU FISHING DELAY YANG DIATUR, BARU RECAST
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end)
    end)
end

-- ▶️ Start Fishing
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    log("🚀 FISHING STARTED!")
    fishing.Cast()
end

-- ⏹️ Stop Fishing
function fishing.Stop()
    fishing.Running = false
    fishing.WaitingHook = false
    log("🛑 FISHING STOPPED")
end

-- 🔄 Toggle Fishing
function fishing.Toggle()
    if fishing.Running then
        fishing.Stop()
    else
        fishing.Start()
    end
end

-- Set Fishing Delay
function fishing.SetFishingDelay(delay)
    fishing.Settings.FishingDelay = delay
    log("Fishing Delay diatur ke: " .. delay)
end

-- Set Cancel Delay  
function fishing.SetCancelDelay(delay)
    fishing.Settings.CancelDelay = delay
    log("Cancel Delay diatur ke: " .. delay)
end

log("🔧 Ultra Speed Fishing Loaded - Tanpa GUI Internal & Tanpa Toggle Key")
log("🎣 Siap diintegrasikan dengan LynxGUI!")
log("⚙️ Gunakan fungsi Start(), Stop(), SetFishingDelay(), dan SetCancelDelay() untuk kontrol")

return fishing
