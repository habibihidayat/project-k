-- ⚡ ULTRA SPEED AUTO FISHING v37.0 (Auto-Calibrating Perfect Cast)
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
    
    -- Cast quality tracking
    CastQualities = {},  -- Store recent cast qualities
    LastCastQuality = "unknown",
    
    -- Auto-calibration
    CalibrationMode = true,
    TestTimings = {1.2, 1.1, 1.0, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7},  -- Test these timings
    CurrentTestIndex = 1,
    BestTiming = 1.0,
    
    -- Timing
    ConsecutiveCasts = 0,
    LastFishTime = 0,
    AverageHookTime = 1.0,
    RecentHookTimes = {},
    
    Settings = {
        FishingDelay = 0.002,
        CancelDelay = 0.08,
        HookDetectionDelay = 0.01,
        MaxWaitTime = 1.3,
        AnimDisableInterval = 0.08,
        
        -- Perfect cast settings - Will be auto-calibrated
        ChargeTime = 1.0,              -- Start at 1.0s
        UseAutoCalibration = true,     // Enable auto-find perfect timing
        PostChargeDelay = 0.02,
        PostCastDelay = 0.04,
        
        -- Anti-jeda
        SyncCastThreshold = 3,
        MicroSyncDelay = 0.12,
        SlowHookThreshold = 1.8,
        FastHookThreshold = 1.0,
        AdaptiveBoost = true,
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

-- Auto-calibration system
local function updateCalibration(quality)
    if not fishing.Settings.UseAutoCalibration then return end
    if not fishing.CalibrationMode then return end
    
    table.insert(fishing.CastQualities, {
        timing = fishing.Settings.ChargeTime,
        quality = quality
    })
    
    log("📊 Calibration: " .. fishing.Settings.ChargeTime .. "s = " .. quality)
    
    -- If we got PERFECT, lock this timing!
    if quality == "Perfect" or quality == "perfect" or quality == "PERFECT" then
        fishing.BestTiming = fishing.Settings.ChargeTime
        fishing.CalibrationMode = false
        log("✅ PERFECT timing found: " .. fishing.BestTiming .. "s")
        log("🔒 Calibration locked!")
        return
    end
    
    -- Try next timing
    if #fishing.CastQualities >= 2 then  -- Test each timing 2 times
        fishing.CurrentTestIndex += 1
        
        if fishing.CurrentTestIndex > #fishing.TestTimings then
            -- Finished testing all timings, find best
            fishing.CalibrationMode = false
            
            -- Find timing with best quality
            local bestScore = -1
            for _, data in ipairs(fishing.CastQualities) do
                local score = 0
                if data.quality == "Perfect" or data.quality == "perfect" then
                    score = 3
                elseif data.quality == "Good" or data.quality == "good" then
                    score = 2
                elseif data.quality == "Ok" or data.quality == "ok" then
                    score = 1
                end
                
                if score > bestScore then
                    bestScore = score
                    fishing.BestTiming = data.timing
                end
            end
            
            fishing.Settings.ChargeTime = fishing.BestTiming
            log("✅ Best timing found: " .. fishing.BestTiming .. "s")
            log("🔒 Using optimized timing")
        else
            -- Set next test timing
            fishing.Settings.ChargeTime = fishing.TestTimings[fishing.CurrentTestIndex]
            fishing.CastQualities = {}  -- Reset for new timing test
            log("🔄 Testing next timing: " .. fishing.Settings.ChargeTime .. "s")
        end
    end
end

local function updateAverageHookTime(hookTime)
    table.insert(fishing.RecentHookTimes, hookTime)
    if #fishing.RecentHookTimes > 5 then
        table.remove(fishing.RecentHookTimes, 1)
    end
    local sum = 0
    for _, time in ipairs(fishing.RecentHookTimes) do
        sum = sum + time
    end
    fishing.AverageHookTime = sum / #fishing.RecentHookTimes
end

local function needsSyncPause()
    if fishing.ConsecutiveCasts > 0 and fishing.ConsecutiveCasts % fishing.Settings.SyncCastThreshold == 0 then
        return true
    end
    if fishing.AverageHookTime > fishing.Settings.SlowHookThreshold then
        return true
    end
    return false
end

local function getAdaptiveDelay()
    if not fishing.Settings.AdaptiveBoost then return 0 end
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
    
    if needsSyncPause() then
        local syncDelay = getAdaptiveDelay()
        log("⏸️ Sync (" .. string.format("%.2f", syncDelay) .. "s)")
        task.wait(syncDelay)
        fishing.ConsecutiveCasts = 0
    end
    
    fishing.State = "casting"
    fishing.CurrentCycle += 1
    fishing.ConsecutiveCasts += 1
    local castStartTime = tick()
    
    local cycleNum = fishing.CurrentCycle
    local modeText = fishing.CalibrationMode and "[CALIBRATING]" or "[OPTIMIZED]"
    log("⚡ Cast #" .. cycleNum .. " " .. modeText .. " @ " .. string.format("%.2f", fishing.Settings.ChargeTime) .. "s")
    
    disableFishingAnim()
    
    local success = pcall(function()
        local chargeStartTime = tick()
        
        -- Start charge
        local chargeOK = pcall(function()
            RF_ChargeFishingRod:InvokeServer({[1] = chargeStartTime})
        end)
        
        if not chargeOK then
            fishing.State = "idle"
            return
        end
        
        -- WAIT EXACT CHARGE TIME
        task.wait(fishing.Settings.ChargeTime)
        task.wait(fishing.Settings.PostChargeDelay)
        
        if not isRodReady() then
            fishing.State = "idle"
            return
        end
        
        -- Request minigame
        local minigameOK = pcall(function()
            RF_RequestMinigame:InvokeServer(1, 0, chargeStartTime)
        end)
        
        if not minigameOK then
            fishing.State = "idle"
            return
        end
        
        task.wait(fishing.Settings.PostCastDelay)
        
        fishing.State = "waiting"
        fishing.LastCastTime = castStartTime
        log("🎯 Waiting hook #" .. cycleNum)
        
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
        fishing.State = "idle"
        return false
    end
    
    return true
end

local function mainFishingLoop()
    log("🔄 Auto-calibrating loop started")
    
    while fishing.Running do
        if fishing.State == "idle" then
            performCast()
            task.wait(0.01)
        else
            task.wait(0.05)
        end
    end
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
    fishing.CastQualities = {}
    fishing.CurrentTestIndex = 1
    fishing.CalibrationMode = fishing.Settings.UseAutoCalibration
    fishing.Settings.ChargeTime = fishing.TestTimings[1]

    log("🚀 AUTO-CALIBRATING FISHING START!")
    if fishing.CalibrationMode then
        log("🔍 Testing timings: " .. table.concat(fishing.TestTimings, "s, ") .. "s")
    end
    
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
                log("🎣 HOOK! (" .. string.format("%.2f", hookTime) .. "s)")
                
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
            
            -- Detect cast quality from data
            local quality = "Unknown"
            if data then
                -- Try different possible field names
                quality = data.CastQuality or data.castQuality or data.Quality or data.quality or 
                         data.CastRating or data.castRating or data.Rating or data.rating or "Unknown"
            end
            
            fishing.LastCastQuality = quality
            
            log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)")
            log("⭐ Cast quality: " .. tostring(quality))
            
            -- Update calibration with this result
            updateCalibration(quality)

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

    log("🛑 STOPPED")
    log("📊 Calibration Results:")
    for _, data in ipairs(fishing.CastQualities) do
        log("   " .. data.timing .. "s = " .. data.quality)
    end
    log("✅ Best timing: " .. fishing.BestTiming .. "s")
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

function fishing.GetStats()
    return {
        TotalFish = fishing.TotalFish,
        CurrentCycle = fishing.CurrentCycle,
        AverageHookTime = fishing.AverageHookTime,
        State = fishing.State,
        LastCastQuality = fishing.LastCastQuality,
        BestTiming = fishing.BestTiming,
        CalibrationMode = fishing.CalibrationMode,
    }
end

return fishing
