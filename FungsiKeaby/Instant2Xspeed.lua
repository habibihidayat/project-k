-- ⚡ ULTRA SPEED AUTO FISHING v29.2 (OPTIMIZED - No Auto-Start / Controlled by GUI)
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

-- Modul utama
local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    LastHookTime = 0,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,        -- Delay setelah cast
        CancelDelay = 0.15,         -- Delay sebelum cancel (dikurangi)
        HookDetectionDelay = 0.02,  -- Delay setelah hook (dikurangi)
        RetryDelay = 0.05,          -- Delay retry (dikurangi)
        MaxWaitTime = 1.0,          -- Max waktu tunggu hook (dikurangi)
        MinCycleDelay = 0.08,       -- Delay minimum antar cycle
        ForceResetTime = 0.7,       -- Waktu untuk force reset
    }
}

_G.FishingScript = fishing

-- Logging ringkas
local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

-- Fungsi disable animasi yang lebih agresif
local function disableFishingAnim()
    pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            local name = track.Name:lower()
            if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") then
                track:Stop(0)
            end
        end
    end)

    -- Posisi rod diperbaiki
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

-- Fungsi utama cast yang lebih responsif
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    local cycleStart = tick()
    
    log("⚡ Lempar pancing (Cycle: " .. fishing.CurrentCycle .. ")")

    local castSuccess = pcall(function()
        RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        task.wait(0.05)  -- Delay dikurangi
        RF_RequestMinigame:InvokeServer(1, 0, tick())
        fishing.WaitingHook = true
        fishing.LastHookTime = tick()
        log("🎯 Menunggu hook...")

        -- Timeout protection yang lebih agresif
        local forceResetTime = fishing.Settings.ForceResetTime
        
        -- Early detection untuk hook yang cepat
        task.delay(forceResetTime * 0.3, function()
            if fishing.WaitingHook and fishing.Running and (tick() - fishing.LastHookTime) > forceResetTime * 0.3 then
                log("⚡ Early reset attempt...")
                fishing.WaitingHook = false
                pcall(function()
                    RE_FishingCompleted:FireServer()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                
                task.wait(fishing.Settings.RetryDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end)

        -- Force reset utama
        task.delay(forceResetTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⏰ Force reset - lanjut cast!")
                fishing.WaitingHook = false
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                    task.wait(0.03)
                    RF_CancelFishingInputs:InvokeServer()
                end)

                -- Pastikan ada delay minimum antar cycle
                local elapsed = tick() - cycleStart
                local remainingDelay = math.max(0, fishing.Settings.MinCycleDelay - elapsed)
                
                if remainingDelay > 0 then
                    task.wait(remainingDelay)
                end
                
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end)
    end)

    if not castSuccess then
        log("❌ Gagal cast, retrying...")
        task.wait(fishing.Settings.RetryDelay)
        if fishing.Running then
            fishing.Cast()
        end
    end
end

-- Deteksi hook yang lebih responsif
local function setupHookDetection()
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local stateLower = string.lower(state)
            if string.find(stateLower, "hook") or string.find(stateLower, "bite") or string.find(stateLower, "catch") or string.find(stateLower, "!") then
                fishing.WaitingHook = false
                fishing.TotalFish += 1
                fishing.LastHookTime = tick()
                
                log("✅ Hook terdeteksi — ikan ditarik! (Total: " .. fishing.TotalFish .. ")")
                
                -- Response lebih cepat untuk hook
                task.wait(fishing.Settings.HookDetectionDelay)
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)

                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                -- Langsung cast lagi tanpa delay tambahan
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end
    end)
end

-- Start / Stop Functions
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.LastHookTime = 0

    log("🚀 AUTO FISHING STARTED! (2x Speed Optimized)")
    disableFishingAnim()

    -- Setup hook detection
    setupHookDetection()

    -- Disable animasi lebih agresif
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.08)  -- Lebih sering disable animasi
        end
    end)

    -- Safety monitor untuk mencegah stuck
    fishing.Connections.SafetyMonitor = task.spawn(function()
        while fishing.Running do
            task.wait(0.5)
            if fishing.WaitingHook and (tick() - fishing.LastHookTime) > fishing.Settings.ForceResetTime + 0.5 then
                log("🔄 Safety reset - terdeteksi stuck!")
                fishing.WaitingHook = false
                pcall(function()
                    RE_FishingCompleted:FireServer()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                task.wait(0.1)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end
    end)

    -- Start casting setelah delay singkat
    task.wait(0.15)
    if fishing.Running then
        fishing.Cast()
    end
end

function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.WaitingHook = false

    -- Putuskan semua koneksi aktif
    for name, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            task.cancel(conn)
        end
    end
    fishing.Connections = {}

    log("🛑 AUTO FISHING STOPPED - Total Ikan: " .. fishing.TotalFish)
end

return fishing
