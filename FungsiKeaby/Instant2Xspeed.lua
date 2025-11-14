-- ⚡ ULTRA SPEED AUTO FISHING v34.0 (Adaptive Anti-Throttle)
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

-- Adaptive throttle detection
local fishing = {
    Running = false,
    State = "idle",
    CurrentCycle = 0,
    TotalFish = 0,
    Connections = {},
    MainLoop = nil,
    
    -- Throttle detection
    ConsecutiveFast = 0,  -- Counter ikan cepat berturut-turut
    LastCastTime = 0,
    LastHookTime = 0,
    IsThrottled = false,  -- Apakah server sedang throttle
    
    Settings = {
        FishingDelay = 0.002,
        CancelDelay = 0.08,
        HookDetectionDelay = 0.01,
        MaxWaitTime = 1.2,
        ChargeDelay = 0.02,
        PostCastDelay = 0.03,
        AnimDisableInterval = 0.08,
        
        -- Adaptive settings
        ThrottleThreshold = 3,      -- Setelah X ikan cepat, expect throttle
        ThrottleDelay = 0.15,       // Extra delay saat throttled
        ThrottleCooldown = 2.0,     -- Waktu tunggu sebelum reset throttle
        FastCastWindow = 1.5,       -- Window untuk "fast" fish (detik)
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
            task.wait(0.01)
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

-- Detect if server is throttling
local function updateThrottleStatus()
    local currentTime = tick()
    local timeSinceCast = currentTime - fishing.LastCastTime
    
    -- Jika sudah lama sejak cast terakhir, reset counter
    if timeSinceCast > fishing.Settings.ThrottleCooldown then
        fishing.ConsecutiveFast = 0
        fishing.IsThrottled = false
        log("🔄 Throttle reset")
        return
    end
    
    -- Check apakah hook cepat atau lambat
    if fishing.LastHookTime > 0 then
        local hookDelay = fishing.LastHookTime - fishing.LastCastTime
        
        if hookDelay < fishing.Settings.FastCastWindow then
            -- Hook cepat
            fishing.ConsecutiveFast += 1
            
            -- Jika sudah X kali cepat, predict throttle
            if fishing.ConsecutiveFast >= fishing.Settings.ThrottleThreshold then
                fishing.IsThrottled = true
                log("⚠️ Server throttle detected - adaptive mode")
            end
        else
            -- Hook lambat, server mungkin throttling
            if fishing.ConsecutiveFast > 0 then
                fishing.IsThrottled = true
            end
        end
    end
end

-- Main casting function dengan adaptive delay
local function performCast()
    if fishing.State ~= "idle" then return false end
    
    if not ensureRodEquipped() then
        log("⚠️ Rod not ready")
        return false
    end
    
    -- ADAPTIVE DELAY - Jika server throttle, tunggu lebih lama
    if fishing.IsThrottled then
        log("⏳ Throttle delay...")
        task.wait(fishing.Settings.ThrottleDelay)
    end
    
    fishing.State = "casting"
    fishing.CurrentCycle += 1
    fishing.LastCastTime = tick()
    
    local cycleNum = fishing.CurrentCycle
    local throttleIndicator = fishing.IsThrottled and " [THROTTLED]" or ""
    log("⚡ Cast #" .. cycleNum .. throttleIndicator)
    
    disableFishingAnim()
    
    local success = pcall(function()
        local timestamp = tick()
        
        local chargeOK = pcall(function()
            RF_ChargeFishingRod:InvokeServer({[1] = timestamp})
        end)
        
        if not chargeOK then
            fishing.State = "idle"
            return
        end
        
        task.wait(fishing.Settings.ChargeDelay)
        
        if not isRodReady() then
            fishing.State = "idle"
            return
        end
        
        local minigameOK = pcall(function()
            RF_RequestMinigame:InvokeServer(1, 0, timestamp)
        end)
        
        if not minigameOK then
            fishing.State = "idle"
            return
        end
        
        task.wait(fishing.Settings.PostCastDelay)
        
        fishing.State = "waiting"
        log("🎯 Hook #" .. cycleNum)
        
        -- Adaptive timeout - lebih lama jika throttled
        local timeoutDuration = fishing.Settings.MaxWaitTime
        if fishing.IsThrottled then
            timeoutDuration = timeoutDuration * 1.5  -- 50% lebih lama
        end
        
        task.delay(timeoutDuration, function()
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
                
                -- Update throttle status
                updateThrottleStatus()
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
    log("🔄 Adaptive loop started")
    
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
    fishing.ConsecutiveFast = 0
    fishing.IsThrottled = false
    fishing.LastCastTime = 0
    fishing.LastHookTime = 0

    log("🚀 ADAPTIVE FISHING START!")
    
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
                
                fishing.State = "pulling"
                fishing.LastHookTime = tick()
                log("🎣 HOOK!")
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                task.wait(fishing.Settings.HookDetectionDelay)
                task.wait(fishing.Settings.CancelDelay)
                
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                
                task.wait(fishing.Settings.FishingDelay)
                
                -- Update throttle status
                updateThrottleStatus()
                
                fishing.State = "idle"
            end
        end
    end)

    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        
        if fishing.State == "waiting" or fishing.State == "pulling" then
            fishing.TotalFish += 1
            local weight = data and data.Weight or 0
            local throttleInfo = fishing.IsThrottled and " [T]" or ""
            log("🐟 #" .. fishing.TotalFish .. ": " .. tostring(name) .. " (" .. string.format("%.1f", weight) .. "kg)" .. throttleInfo)

            task.wait(fishing.Settings.CancelDelay)
            pcall(function()
                RF_CancelFishingInputs:InvokeServer()
            end)
            
            task.wait(fishing.Settings.FishingDelay)
            
            -- Update throttle status
            updateThrottleStatus()
            
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

    log("🛑 STOPPED | Total: " .. fishing.TotalFish .. " fish | Fast: " .. fishing.ConsecutiveFast)
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

return fishing
