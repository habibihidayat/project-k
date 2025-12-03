-- ⚠️ ULTRA BLATANT AUTO FISHING - GUI COMPATIBLE MODULE
-- DESIGNED TO WORK WITH EXTERNAL GUI SYSTEM

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Network initialization
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

-- Module table
local UltraBlatant = {}
UltraBlatant.Active = false
UltraBlatant.Stats = {
    castCount = 0,
    startTime = 0
}

-- Settings (sesuai dengan pattern GUI kamu)
UltraBlatant.Settings = {
    CompleteDelay = 0.001,    -- Delay sebelum complete
    CancelDelay = 0.001       -- Delay setelah complete sebelum cancel
}


----------------------------------------------------------------
-- CORE FUNCTIONS
----------------------------------------------------------------

local function safeFire(func)
    task.spawn(function()
        pcall(func)
    end)
end

-- MAIN SPAM LOOP
local function ultraSpamLoop()
    while UltraBlatant.Active do
        local currentTime = tick()
        
        -- 1x CHARGE & REQUEST (CASTING)
        safeFire(function()
            RF_ChargeFishingRod:InvokeServer({[1] = currentTime})
        end)
        safeFire(function()
            RF_RequestMinigame:InvokeServer(1, 0, currentTime)
        end)
        
        UltraBlatant.Stats.castCount = UltraBlatant.Stats.castCount + 1
        
        -- Wait CompleteDelay then fire complete once
        task.wait(UltraBlatant.Settings.CompleteDelay)
        
        safeFire(function()
            RE_FishingCompleted:FireServer()
        end)
        
        -- Cancel with CancelDelay
        task.wait(UltraBlatant.Settings.CancelDelay)
        safeFire(function()
            RF_CancelFishingInputs:InvokeServer()
        end)
    end
end

-- BACKUP LISTENER
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if not UltraBlatant.Active then return end
    
    task.spawn(function()
        task.wait(UltraBlatant.Settings.CompleteDelay)
        
        safeFire(function()
            RE_FishingCompleted:FireServer()
        end)
        
        task.wait(UltraBlatant.Settings.CancelDelay)
        safeFire(function()
            RF_CancelFishingInputs:InvokeServer()
        end)
    end)
end)

----------------------------------------------------------------
-- PUBLIC API (Compatible dengan pattern GUI kamu)
----------------------------------------------------------------

-- Start function
function UltraBlatant.Start()
    if UltraBlatant.Active then 
        print("⚠️ Ultra Blatant already running!")
        return
    end
    
    UltraBlatant.Active = true
    UltraBlatant.Stats.castCount = 0
    UltraBlatant.Stats.startTime = tick()
    
    task.spawn(ultraSpamLoop)
end

-- Stop function
function UltraBlatant.Stop()
    if not UltraBlatant.Active then 
        return
    end
    
    UltraBlatant.Active = false
end

-- Return module
return UltraBlatant
