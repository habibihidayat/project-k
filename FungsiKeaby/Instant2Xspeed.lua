-- ⚡ ULTRA SPEED AUTO FISHING v35.0 (Perfect Sync - Anti Jeda)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

if _G.FishingScript then
    _G.FishingScript.Stop()
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

local fishing = {
    Running = false,
    State = "idle",
    CurrentCycle = 0,
    TotalFish = 0,
    Connections = {},
    MainLoop = nil,
    
    -- Advanced timing
    ConsecutiveCasts = 0,      -- Jumlah cast berturut-turut
    LastFishTime = 0,           -- Waktu ikan terakhir ditangkap
    AverageHookTime = 1.0,      // Rolling average hook time
    RecentHookTimes = {},       // Track 5 hook times terakhir
    NeedSync = false,           // Apakah perlu sync pause
    
    Settings = {
        FishingDelay = 0.002,
        CancelDelay = 0.08,
        HookDetectionDelay = 0.01,
        MaxWaitTime = 1.3,
        ChargeDelay = 0.025,
        PostCastDelay = 0.04,
        AnimDisableInterval = 0.08,
        
        -- Anti-jeda settings
        SyncCastThreshold = 3,      // Setiap 3 cast, cek sync
        MicroSyncDelay = 0.12,      // Micro delay untuk sync
        SlowHookThreshold = 1.8,    // Jika hook > 1.8s, mode slow
        FastHookThreshold = 1.0,    // Jika hook < 1.0s, mode fast
        AdaptiveBoost = true,       // Enable adaptive timing
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

local function isRodReady()
    local rod = Character:FindFirstChild("Rod") or Character:FindFirstChildWhichIsA("Tool")
    if not rod then return false end
    local handle = rod:FindFirstChild("Handle")
    if not handle or not handle.Parent then return false end
    return true
end

local function ensureRodEquipped()
    if isRodReady() then return true end
    local backpack = localPlayer:FindFirstChild("Backpack")
    if backpack then
        local rod = backpack:FindFirstChild("Rod")
        if rod then
            pcall(function()
                Humanoid:EquipTool(rod)
            end)
            task.wait(0.015)
            return isRodReady()
        end
    end
    return false
end

local function disableFishingAnim()
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
end

-- Calculate rolling average hook time
local function updateAverageHookTime(hookTime)
    table.insert(fishing.RecentHookTimes, hookTime)
    
    -- Keep only last 5
    if #fishing.RecentHookTimes > 5 then
        table.remove(fishing.RecentHookTimes, 1)
    end
    
    -- Calculate average
    local sum = 0
    for _, time in ipairs(fishing.RecentHookTimes) do
        sum = sum + time
    end
    fishing.AverageHookTime = sum / #fishing.RecentHookTimes
end

-- Adaptive sync check - KEY FEATURE
local function needsSyncPause()
    -- Setiap X cast, beri micro pause untuk server sync
    if fishing.ConsecutiveCasts > 0 and fishing.ConsecutiveCasts % fishing.Settings.SyncCastThreshold == 0 then
        return true
    end
    
    -- Jika average hook time naik drastis, server mulai slow
    if fishing.AverageHookTime > fishing.Settings.SlowHookThreshold then
        return true
    end
    
    return false
end

-- Get adaptive delay based on recent performance
local function getAdaptiveDelay()
    if not fishing.Settings.AdaptiveBoost then
        return 0
    end
    
    -- Jika hook time rata-rata lambat, tambah delay
    if fishing.AverageHookTime > fishing.Settings.SlowHookThreshold then
        return fishing.Settings.MicroSyncDelay * 1.5
    elseif fishing.AverageHookTime > fishing.Settings.FastHookThreshold then
        return fishing.Settings.MicroSyncDelay
    end
    
    return 0
end

local function performCast()
    if fishing.State ~= "idle" then return false end
    
    if not ensureRodEquipped() then
        log("⚠️ Rod not ready")
        return false
    end
    
    -- ANTI-JEDA: Micro sync pause setiap beberapa cast
    if needsSyncPause() then
        local syncDelay = getAdaptiveDelay()
        log("⏸️ Sync pause (" .. string.format("%.2f", syncDelay) .. "s)")
        task.wait(syncDelay)
        fishing.ConsecutiveCasts = 0  -- Reset counter
    end
    
    fishing.State = "casting"
    fishing.CurrentCycle += 1
    fishing.ConsecutiveCasts += 1
    local castStartTime = tick()
    
    local cycleNum = fishing.CurrentCycle
    local avgInfo = string.format(" [Avg: %.2fs]", fishing.AverageHookTime)
    log("⚡ Cast #" .. cycleNum .. avgInfo)
    
    disableFishingAnim()
    
    local success = pcall(function()
        local timestamp = tick()
        
        -- Charge with retry
        local chargeAttempts = 0
        local chargeOK = false
        repeat
            chargeAttempts += 1
            chargeOK = pcall(function()
                RF_ChargeFishingRod:InvokeServer({[1] = timestamp})
            end)
            if not chargeOK then task.wait(0.01) end
        until chargeOK or chargeAttempts >= 2
        
        if not chargeOK then
            fishing.State = "idle"
            return
        end
        
        task.wait(fishing.Settings.ChargeDelay)
        
        -- Double check rod
        if not isRodReady() then
            log("⚠️ Rod lost")
            fishing.State = "idle"
            return
        end
        
        -- Request minigame with retry
        local minigameAttempts = 0
        local minigameOK = false
        repeat
            minigameAttempts += 1
            minigameOK = pcall(function()
                RF_RequestMinigame:InvokeServer(1, 0, timestamp)
            end)
            if not minigameOK then task.wait(0.01) end
        until minigameOK or minigameAttempts >= 2
        
        if not minigameOK then
            fishing.State = "idle"
            return
        end
        
        task.wait(fishing.Settings.PostCastDelay)
        
        fishing.State = "waiting"
        fishing.LastCastTime = castStartTime
        log("🎯 Hook #" .. cycleNum)
        
        -- Adaptive timeout based on average
        local adaptiveTimeout = fishing.Settings.MaxWaitTime
        if fishing.AverageHookTime > fishing.Settings.SlowHookThreshold then
            adaptiveTimeout = adaptiveTimeout * 1.4
        end
        
        task.delay(adaptiveTimeout, function()
            if fishing.State == "waiting" and fishing.Running then
                log("⏰ Timeout #" .. cycleNum)
                fishing.State = "pulling"
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                
                task.wait(fishing.Settings.FishingDelay)
                fishing.State = "idle"
            end
        end)
    end)
    
    if not success then
        log("❌ Cast failed")
        fishing.State = "idle"
        return false
    end
    
    return true
end

local function mainFishingLoop()
    log("🔄 Perfect sync loop started")
    
    while fishing.Running do
        if fishing.State == "idle" then
            performCast()
            task.wait(0.01)
        else
            task.wait(0.05)
        end
    end
    
    log("🔄 Loop ended")
end

function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.State = "idle"
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.ConsecutiveCasts = 0
    fishing.LastFishTime = 0
    fishing.AverageHookTime = 1.0
    fishing.RecentHookTimes = {}

    log("🚀 PERFECT SYNC FISHING!")
    
    if not ensureRodEquipped() then
        log("❌ No rod!")
        fishing.Running = false
        return
    end
    
    disableFishingAnim()

    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.State ~= "waiting" or not fishing.Running then return end
        
        if typeof(state) == "string" then
            local stateLower = string.lower(state)
            if string.find(stateLower, "hook") or 
               string.find(stateLower, "bite") or 
               string.find(stateLower, "catch") or
               string.find(stateLower, "pull") or
               string.find(stateLower, "reel") or
               string.find(stateLower, "!") then
                
                local hookTime = tick() - fishing.LastCastTime
                updateAverageHookTime(hookTime)
                
                fishing.State = "pulling"
                log("🎣 HOOK! (" .. string.format("%.2fs", hookTime) .. ")")
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                task.wait(fishing.Settings.HookDetectionDelay)
                task.wait(fishing.Settings.CancelDelay)
                
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                
                task.wait(fishing.Settings.FishingDelay)
                fishing.State = "idle"
            end
        end
    end)

    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        
        if fishing.State == "waiting" or fishing.State == "pulling" then
            fishing.TotalFish += 1
            fishing.LastFishTime = tick()
            
            local weight = data and data.Weight or 0
            log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)")

            task.wait(fishing.Settings.CancelDelay)
            pcall(function()
                RF_CancelFishingInputs:InvokeServer()
            end)
            
            task.wait(fishing.Settings.FishingDelay)
            fishing.State = "idle"
        end
    end)

    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(fishing.Settings.AnimDisableInterval)
        end
    end)

    task.wait(0.1)
    fishing.MainLoop = task.spawn(mainFishingLoop)
end

function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.State = "idle"

    if fishing.MainLoop then
        task.cancel(fishing.MainLoop)
        fishing.MainLoop = nil
    end

    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            task.cancel(conn)
        end
    end
    fishing.Connections = {}

    log("🛑 STOPPED | Fish: " .. fishing.TotalFish .. " | Avg Hook: " .. string.format("%.2fs", fishing.AverageHookTime))
end

function fishing.UpdateSettings(newSettings)
    for key, value in pairs(newSettings) do
        if fishing.Settings[key] ~= nil then
            fishing.Settings[key] = value
            log("⚙️ " .. key .. " = " .. tostring(value))
        end
    end
end

function fishing.GetSettings()
    return fishing.Settings
end

-- Get stats untuk GUI
function fishing.GetStats()
    return {
        TotalFish = fishing.TotalFish,
        CurrentCycle = fishing.CurrentCycle,
        AverageHookTime = fishing.AverageHookTime,
        ConsecutiveCasts = fishing.ConsecutiveCasts,
        State = fishing.State
    }
end

return fishing
