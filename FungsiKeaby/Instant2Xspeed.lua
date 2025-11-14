-- ⚡ ULTRA SPEED AUTO FISHING v36.0 (Perfect Cast + Anti Jeda)
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
    
    -- Perfect cast tracking
    PerfectCasts = 0,
    GoodCasts = 0,
    OkCasts = 0,
    
    -- Timing system
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
        
        -- PERFECT CAST TIMING - Key settings
        PerfectChargeTime = 0.95,      -- Waktu charge optimal untuk PERFECT (0.9-1.0s biasanya)
        ChargeVariance = 0.05,         -- Variance untuk natural feeling
        PerfectCastMode = true,        -- Enable perfect cast timing
        
        PostChargeDelay = 0.02,        -- Delay setelah charge sebelum request
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

-- Calculate perfect charge time with slight variance
local function getPerfectChargeTime()
    if not fishing.Settings.PerfectCastMode then
        return 0.025
    end
    
    -- Add small random variance untuk natural feeling (-0.05 to +0.05)
    local variance = (math.random() - 0.5) * 2 * fishing.Settings.ChargeVariance
    local chargeTime = fishing.Settings.PerfectChargeTime + variance
    
    -- Clamp antara 0.85 - 1.05 detik (sweet spot untuk perfect)
    return math.clamp(chargeTime, 0.85, 1.05)
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
    if not fishing.Settings.AdaptiveBoost then
        return 0
    end
    if fishing.AverageHookTime > fishing.Settings.SlowHookThreshold then
        return fishing.Settings.MicroSyncDelay * 1.5
    elseif fishing.AverageHookTime > fishing.Settings.FastHookThreshold then
        return fishing.Settings.MicroSyncDelay
    end
    return 0
end

-- PERFECT CAST SYSTEM
local function performPerfectCast()
    if fishing.State ~= "idle" then return false end
    
    if not ensureRodEquipped() then
        log("⚠️ Rod not ready")
        return false
    end
    
    -- Anti-jeda sync pause
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
    log("⚡ Cast #" .. cycleNum .. " [PERFECT MODE]")
    
    disableFishingAnim()
    
    local success = pcall(function()
        -- PERFECT CAST SEQUENCE
        local chargeStartTime = tick()
        
        -- Calculate perfect charge time
        local perfectCharge = getPerfectChargeTime()
        log("⏱️ Charging for " .. string.format("%.3f", perfectCharge) .. "s")
        
        -- Start charging
        local chargeOK = pcall(function()
            RF_ChargeFishingRod:InvokeServer({[1] = chargeStartTime})
        end)
        
        if not chargeOK then
            log("❌ Charge failed")
            fishing.State = "idle"
            return
        end
        
        -- WAIT PERFECT DURATION - Ini yang menentukan PERFECT cast!
        task.wait(perfectCharge)
        
        -- Small delay untuk stabilitas
        task.wait(fishing.Settings.PostChargeDelay)
        
        -- Double check rod masih ready
        if not isRodReady() then
            log("⚠️ Rod lost during charge")
            fishing.State = "idle"
            return
        end
        
        -- Request minigame dengan timestamp yang SAMA dari charge
        -- Ini penting agar server tahu berapa lama kita charge
        local minigameOK = pcall(function()
            RF_RequestMinigame:InvokeServer(1, 0, chargeStartTime)
        end)
        
        if not minigameOK then
            log("❌ Minigame request failed")
            fishing.State = "idle"
            return
        end
        
        log("✓ Perfect cast executed!")
        
        task.wait(fishing.Settings.PostCastDelay)
        
        fishing.State = "waiting"
        fishing.LastCastTime = castStartTime
        log("🎯 Waiting hook #" .. cycleNum)
        
        -- Adaptive timeout
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
        log("❌ Cast execution failed")
        fishing.State = "idle"
        return false
    end
    
    return true
end

local function mainFishingLoop()
    log("🔄 Perfect cast loop started")
    
    while fishing.Running do
        if fishing.State == "idle" then
            performPerfectCast()
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
    fishing.PerfectCasts = 0
    fishing.GoodCasts = 0
    fishing.OkCasts = 0
    fishing.LastFishTime = 0
    fishing.AverageHookTime = 1.0
    fishing.RecentHookTimes = {}

    log("🚀 PERFECT CAST FISHING START!")
    log("🎯 Target charge: " .. fishing.Settings.PerfectChargeTime .. "s ±" .. fishing.Settings.ChargeVariance .. "s")
    
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
            
            -- Track cast quality (jika ada info dari data)
            local quality = data and data.CastQuality or "unknown"
            if quality == "perfect" or quality == "Perfect" then
                fishing.PerfectCasts += 1
            elseif quality == "good" or quality == "Good" then
                fishing.GoodCasts += 1
            elseif quality == "ok" or quality == "Ok" then
                fishing.OkCasts += 1
            end
            
            log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)")
            log("📊 Perfect: " .. fishing.PerfectCasts .. " | Good: " .. fishing.GoodCasts .. " | Ok: " .. fishing.OkCasts)

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

    local total = fishing.PerfectCasts + fishing.GoodCasts + fishing.OkCasts
    local perfectRate = total > 0 and (fishing.PerfectCasts / total * 100) or 0
    
    log("🛑 STOPPED")
    log("📊 Cast Stats:")
    log("   Perfect: " .. fishing.PerfectCasts .. " (" .. string.format("%.1f", perfectRate) .. "%)")
    log("   Good: " .. fishing.GoodCasts)
    log("   Ok: " .. fishing.OkCasts)
    log("   Total Fish: " .. fishing.TotalFish)
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
        ConsecutiveCasts = fishing.ConsecutiveCasts,
        State = fishing.State,
        PerfectCasts = fishing.PerfectCasts,
        GoodCasts = fishing.GoodCasts,
        OkCasts = fishing.OkCasts,
    }
end

return fishing
