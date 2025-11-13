-- ⚡ ULTRA SPEED AUTO FISHING v30.5 (Fish It Roblox - Maximum Speed)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Hentikan script lama jika masih aktif
if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.05)
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

-- Modul utama dengan settings yang bisa diubah dari GUI
local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    Connections = {},
    
    -- Settings yang bisa diubah dari GUI
    Settings = {
        FishingDelay = 0.005,
        CancelDelay = 0.1,
        HookDetectionDelay = 0.01,
        RetryDelay = 0.05,
        MaxWaitTime = 1.0,
        ChargeTime = 0.03,
        AnimDisableInterval = 0.08,
        FastFallback = 0.45,
    }
}

_G.FishingScript = fishing

-- Logging ringkas
local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

-- Fungsi disable animasi (optimized untuk Fish It)
local function disableFishingAnim()
    task.spawn(function()
        pcall(function()
            for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") or name:find("throw") then
                    track:Stop(0)
                    track.TimePosition = 0
                end
            end
        end)

        -- Posisi rod diperbaiki untuk Fish It
        pcall(function()
            local rod = Character:FindFirstChild("Rod") or Character:FindFirstChildWhichIsA("Tool")
            if rod and rod:FindFirstChild("Handle") then
                local handle = rod.Handle
                local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("Motor6D")
                if weld then
                    weld.C0 = CFrame.new(0, -1, -1.2) * CFrame.Angles(math.rad(-10), 0, 0)
                end
            end
        end)
    end)
end

-- Fungsi utama cast (MAXIMUM SPEED untuk Fish It)
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    log("⚡ Cast #" .. fishing.CurrentCycle)

    local castSuccess = pcall(function()
        local timestamp = tick()
        
        -- PARALLEL REQUEST - Kirim charge dan minigame hampir bersamaan
        -- Ini membuat server Fish It merespons lebih cepat
        task.spawn(function()
            pcall(function()
                RF_ChargeFishingRod:InvokeServer({[1] = timestamp})
            end)
        end)
        
        -- Delay minimal sebelum request minigame
        task.wait(fishing.Settings.ChargeTime)
        
        -- Request minigame dengan timestamp yang sama untuk sinkronisasi
        task.spawn(function()
            pcall(function()
                RF_RequestMinigame:InvokeServer(1, 0, timestamp)
            end)
        end)
        
        fishing.WaitingHook = true

        -- Fast Fallback - Cek hook lebih awal
        task.delay(fishing.Settings.FastFallback, function()
            if fishing.WaitingHook and fishing.Running then
                task.spawn(function()
                    pcall(function()
                        RE_FishingCompleted:FireServer()
                    end)
                end)
            end
        end)

        -- Timeout Protection
        task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                fishing.WaitingHook = false
                log("⚠️ Timeout - Force pull")
                
                task.spawn(function()
                    pcall(function()
                        RE_FishingCompleted:FireServer()
                    end)
                    task.wait(fishing.Settings.RetryDelay)
                    pcall(function()
                        RF_CancelFishingInputs:InvokeServer()
                    end)
                    task.wait(fishing.Settings.FishingDelay)
                    if fishing.Running then
                        fishing.Cast()
                    end
                end)
            end
        end)
    end)

    if not castSuccess then
        log("❌ Cast failed, retry...")
        task.wait(fishing.Settings.RetryDelay)
        if fishing.Running then
            fishing.Cast()
        end
    end
end

-- Start Function (OPTIMIZED untuk Fish It Roblox)
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0

    log("🚀 TURBO FISHING ACTIVATED!")
    disableFishingAnim()

    -- Hook Detection Handler (INSTANT RESPONSE)
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local stateLower = string.lower(state)
            -- Deteksi berbagai state hook di Fish It
            if string.find(stateLower, "hook") or 
               string.find(stateLower, "bite") or 
               string.find(stateLower, "catch") or
               string.find(stateLower, "pull") or
               string.find(stateLower, "reel") then
                
                fishing.WaitingHook = false
                
                -- INSTANT PULL - Tidak ada delay
                task.spawn(function()
                    pcall(function()
                        RE_FishingCompleted:FireServer()
                    end)
                end)

                -- Minimal delay untuk deteksi
                task.wait(fishing.Settings.HookDetectionDelay)

                -- Reset dengan parallel execution
                task.spawn(function()
                    task.wait(fishing.Settings.CancelDelay)
                    pcall(function()
                        RF_CancelFishingInputs:InvokeServer()
                    end)
                    task.wait(fishing.Settings.FishingDelay)
                    if fishing.Running then
                        fishing.Cast()
                    end
                end)
            end
        end
    end)

    -- Fish Caught Handler (FAST RESET)
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            local weight = data and data.Weight or 0
            log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)")

            -- Parallel reset untuk kecepatan maksimal
            task.spawn(function()
                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end)
        end
    end)

    -- Animation Disabler (Fast Loop)
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(fishing.Settings.AnimDisableInterval)
        end
    end)

    -- Start casting immediately
    task.wait(0.001)
    fishing.Cast()
end

-- Stop Function
function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.WaitingHook = false

    -- Disconnect all connections
    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            task.cancel(conn)
        end
    end
    fishing.Connections = {}

    log("🛑 STOPPED | Total: " .. fishing.TotalFish .. " fish caught")
end

-- Fungsi untuk update settings dari GUI
function fishing.UpdateSettings(newSettings)
    for key, value in pairs(newSettings) do
        if fishing.Settings[key] ~= nil then
            fishing.Settings[key] = value
            log("⚙️ Updated " .. key .. " = " .. tostring(value))
        end
    end
end

-- Fungsi untuk get current settings (untuk GUI)
function fishing.GetSettings()
    return fishing.Settings
end

return fishing
