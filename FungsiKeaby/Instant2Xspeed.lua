-- ⚡ ULTRA SPEED AUTO FISHING v33.0 (Rod Check + True Single Thread)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Stop old script
if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.1)
end

-- Network connections
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

-- Main module with TRUE SINGLE THREAD
local fishing = {
    Running = false,
    State = "idle",  -- idle, casting, waiting, pulling
    CurrentCycle = 0,
    TotalFish = 0,
    Connections = {},
    MainLoop = nil,  -- SINGLE main loop thread
    
    Settings = {
        FishingDelay = 0.002,
        CancelDelay = 0.08,
        HookDetectionDelay = 0.01,
        MaxWaitTime = 1.0,
        ChargeDelay = 0.025,
        PostCastDelay = 0.035,
        AnimDisableInterval = 0.08,
        RodCheckDelay = 0.01,
    }
}

_G.FishingScript = fishing

local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

-- Check if rod is equipped and ready
local function isRodReady()
    local rod = Character:FindFirstChild("Rod") or Character:FindFirstChildWhichIsA("Tool")
    if not rod then return false end
    
    -- Check if rod is actually equipped (has Handle in Character)
    local handle = rod:FindFirstChild("Handle")
    if not handle or not handle.Parent then return false end
    
    return true
end

-- Ensure rod is equipped
local function ensureRodEquipped()
    if isRodReady() then return true end
    
    -- Try to find rod in backpack and equip it
    local backpack = localPlayer:FindFirstChild("Backpack")
    if backpack then
        local rod = backpack:FindFirstChild("Rod")
        if rod then
            pcall(function()
                Humanoid:EquipTool(rod)
            end)
            task.wait(fishing.Settings.RodCheckDelay)
            return isRodReady()
        end
    end
    
    return false
end

-- Disable animations
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

-- MAIN CASTING FUNCTION - Called ONLY by main loop
local function performCast()
    if fishing.State ~= "idle" then
        return false
    end
    
    -- Check rod first
    if not ensureRodEquipped() then
        log("⚠️ Rod not ready")
        return false
    end
    
    fishing.State = "casting"
    fishing.CurrentCycle += 1
    
    local cycleNum = fishing.CurrentCycle
    log("⚡ Cast #" .. cycleNum)
    
    disableFishingAnim()
    
    local success = pcall(function()
        local timestamp = tick()
        
        -- Charge rod
        local chargeOK = pcall(function()
            RF_ChargeFishingRod:InvokeServer({[1] = timestamp})
        end)
        
        if not chargeOK then
            fishing.State = "idle"
            return
        end
        
        task.wait(fishing.Settings.ChargeDelay)
        
        -- Request minigame - rod MUST be equipped
        if not isRodReady() then
            log("⚠️ Rod lost during cast")
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
        
        -- Transition to waiting
        fishing.State = "waiting"
        log("🎯 Hook #" .. cycleNum)
        
        -- Single timeout
        task.delay(fishing.Settings.MaxWaitTime, function()
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

-- MAIN LOOP - SINGLE THREAD controlling everything
local function mainFishingLoop()
    log("🔄 Main loop started")
    
    while fishing.Running do
        if fishing.State == "idle" then
            -- Try to cast
            performCast()
            task.wait(0.01)  -- Small yield to prevent tight loop
        else
            -- Wait for state to become idle
            task.wait(0.05)
        end
    end
    
    log("🔄 Main loop ended")
end

-- Start Function
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.State = "idle"
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0

    log("🚀 CONSISTENT FISHING START!")
    
    -- Ensure rod is equipped first
    if not ensureRodEquipped() then
        log("❌ No rod found!")
        fishing.Running = false
        return
    end
    
    disableFishingAnim()

    -- Hook Detection
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
                log("🎣 HOOK!")
                
                -- Instant pull
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

    -- Fish Caught Handler
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if not fishing.Running then return end
        
        if fishing.State == "waiting" or fishing.State == "pulling" then
            fishing.TotalFish += 1
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

    -- Animation Disabler
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(fishing.Settings.AnimDisableInterval)
        end
    end)

    -- START MAIN LOOP - SINGLE THREAD
    task.wait(0.1)
    fishing.MainLoop = task.spawn(mainFishingLoop)
end

-- Stop Function
function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.State = "idle"

    -- Cancel main loop
    if fishing.MainLoop then
        task.cancel(fishing.MainLoop)
        fishing.MainLoop = nil
    end

    -- Disconnect all connections
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

-- Update settings
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
