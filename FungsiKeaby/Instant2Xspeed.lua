-- ⚡ ULTRA SPEED AUTO FISHING v31.0 (Fish It - Anti Miss & Sync Fixed)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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

-- Modul utama
local fishing = {
    Running = false,
    WaitingHook = false,
    IsCasting = false,
    CurrentCycle = 0,
    TotalFish = 0,
    LastCastTime = 0,
    Connections = {},
    
    Settings = {
        FishingDelay = 0.005,
        CancelDelay = 0.1,
        HookDetectionDelay = 0.01,
        RetryDelay = 0.05,
        MaxWaitTime = 1.2,
        ChargeWaitTime = 0.025,
        MinigameRequestDelay = 0.015,
        AnimDisableInterval = 0.08,
        CastCooldown = 0.1,  -- Cooldown minimum antar cast
        SyncDelay = 0.05,    -- Delay sinkronisasi charge-minigame
    }
}

_G.FishingScript = fishing

-- Logging
local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

-- Anti-spam cast detector
local function canCast()
    local currentTime = tick()
    if currentTime - fishing.LastCastTime < fishing.Settings.CastCooldown then
        return false
    end
    return true
end

-- Disable animasi
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

-- Fungsi Cast dengan SYNC PERFECT untuk Fish It
function fishing.Cast()
    if not fishing.Running or fishing.IsCasting or fishing.WaitingHook then 
        return 
    end
    
    if not canCast() then
        log("⏳ Cooldown aktif, tunggu...")
        return
    end

    fishing.IsCasting = true
    fishing.LastCastTime = tick()
    fishing.CurrentCycle += 1
    
    disableFishingAnim()
    log("⚡ Cast #" .. fishing.CurrentCycle)

    task.spawn(function()
        local success, err = pcall(function()
            local timestamp = tick()
            
            -- PHASE 1: Charge Rod (SINKRON)
            local chargeSuccess = false
            local chargeAttempt = 0
            
            repeat
                chargeAttempt += 1
                local result = pcall(function()
                    RF_ChargeFishingRod:InvokeServer({[1] = timestamp})
                end)
                
                if result then
                    chargeSuccess = true
                    log("✓ Charge OK (attempt " .. chargeAttempt .. ")")
                else
                    task.wait(0.01)
                end
            until chargeSuccess or chargeAttempt >= 3
            
            if not chargeSuccess then
                log("❌ Charge gagal setelah 3x")
                fishing.IsCasting = false
                task.wait(fishing.Settings.RetryDelay)
                if fishing.Running then fishing.Cast() end
                return
            end
            
            -- DELAY SINKRONISASI - Penting untuk Fish It agar server siap
            task.wait(fishing.Settings.SyncDelay)
            
            -- PHASE 2: Request Minigame (SYNCHRONIZED)
            local minigameSuccess = false
            local minigameAttempt = 0
            
            repeat
                minigameAttempt += 1
                local result = pcall(function()
                    RF_RequestMinigame:InvokeServer(1, 0, timestamp)
                end)
                
                if result then
                    minigameSuccess = true
                    log("✓ Minigame requested (attempt " .. minigameAttempt .. ")")
                else
                    task.wait(0.01)
                end
            until minigameSuccess or minigameAttempt >= 3
            
            if not minigameSuccess then
                log("❌ Minigame request gagal")
                fishing.IsCasting = false
                task.wait(fishing.Settings.RetryDelay)
                if fishing.Running then fishing.Cast() end
                return
            end
            
            -- PHASE 3: Waiting Hook
            fishing.IsCasting = false
            fishing.WaitingHook = true
            log("🎯 Waiting hook...")
            
            -- Multi-stage fallback untuk anti-miss
            local fallbackStages = {
                {time = 0.3, name = "Quick Check"},
                {time = 0.6, name = "Mid Check"},
                {time = 0.9, name = "Late Check"},
            }
            
            for _, stage in ipairs(fallbackStages) do
                task.delay(stage.time, function()
                    if fishing.WaitingHook and fishing.Running then
                        log("⏰ " .. stage.name)
                        task.spawn(function()
                            pcall(function()
                                RE_FishingCompleted:FireServer()
                            end)
                        end)
                    end
                end)
            end
            
            -- Final timeout
            task.delay(fishing.Settings.MaxWaitTime, function()
                if fishing.WaitingHook and fishing.Running then
                    fishing.WaitingHook = false
                    log("⚠️ Timeout - Force reset")
                    
                    task.spawn(function()
                        pcall(function()
                            RE_FishingCompleted:FireServer()
                        end)
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
        end)
        
        if not success then
            log("❌ Cast error: " .. tostring(err))
            fishing.IsCasting = false
            fishing.WaitingHook = false
            task.wait(fishing.Settings.RetryDelay)
            if fishing.Running then
                fishing.Cast()
            end
        end
    end)
end

-- Start Function
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.IsCasting = false
    fishing.WaitingHook = false
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.LastCastTime = 0

    log("🚀 PERFECT SYNC FISHING ACTIVATED!")
    disableFishingAnim()

    -- HOOK DETECTION dengan prioritas tinggi
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if not fishing.WaitingHook then return end
        
        if typeof(state) == "string" then
            local stateLower = string.lower(state)
            local hookDetected = string.find(stateLower, "hook") or 
                               string.find(stateLower, "bite") or 
                               string.find(stateLower, "catch") or
                               string.find(stateLower, "pull") or
                               string.find(stateLower, "reel") or
                               string.find(stateLower, "!") -- Untuk tanda seru
            
            if hookDetected then
                fishing.WaitingHook = false
                log("🎣 HOOK! (" .. state .. ")")
                
                -- INSTANT PULL
                task.spawn(function()
                    pcall(function()
                        RE_FishingCompleted:FireServer()
                    end)
                end)
                
                task.wait(fishing.Settings.HookDetectionDelay)
                
                -- Reset sequence
                task.spawn(function()
                    task.wait(fishing.Settings.CancelDelay)
                    pcall(function()
                        RF_CancelFishingInputs:InvokeServer()
                    end)
                    task.wait(fishing.Settings.FishingDelay)
                    if fishing.Running and not fishing.IsCasting then
                        fishing.Cast()
                    end
                end)
            end
        end
    end)

    -- FISH CAUGHT HANDLER
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        
        fishing.WaitingHook = false
        fishing.TotalFish += 1
        local weight = data and data.Weight or 0
        log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)")

        task.spawn(function()
            task.wait(fishing.Settings.CancelDelay)
            pcall(function()
                RF_CancelFishingInputs:InvokeServer()
            end)
            task.wait(fishing.Settings.FishingDelay)
            if fishing.Running and not fishing.IsCasting then
                fishing.Cast()
            end
        end)
    end)

    -- Animation Disabler
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(fishing.Settings.AnimDisableInterval)
        end
    end)

    -- Start first cast
    task.wait(0.1)
    fishing.Cast()
end

-- Stop Function
function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.WaitingHook = false
    fishing.IsCasting = false

    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            task.cancel(conn)
        end
    end
    fishing.Connections = {}

    log("🛑 STOPPED | Total: " .. fishing.TotalFish .. " fish")
end

-- Update settings dari GUI
function fishing.UpdateSettings(newSettings)
    for key, value in pairs(newSettings) do
        if fishing.Settings[key] ~= nil then
            fishing.Settings[key] = value
            log("⚙️ " .. key .. " = " .. tostring(value))
        end
    end
end

-- Get settings
function fishing.GetSettings()
    return fishing.Settings
end

return fishing
