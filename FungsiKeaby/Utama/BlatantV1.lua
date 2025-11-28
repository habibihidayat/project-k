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
local RE_FishCaught = netFolder:WaitForChild("RE/FishCaught")

-- Module table
local UltraBlatant = {}
UltraBlatant.Active = false
UltraBlatant.Stats = {
    castCount = 0,
    fishCaught = 0,
    startTime = 0
}

-- Settings (sesuai dengan pattern GUI kamu)
UltraBlatant.Settings = {
    CompleteDelay = 0.05,    -- Delay sebelum complete
    CancelDelay = 0.1,       -- Delay setelah complete sebelum cancel
    AfterCancelDelay = 0.027 -- Delay setelah cancel sebelum cast lagi (untuk status OK)
}

print("💀 ULTRA BLATANT MODULE LOADED!")

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
        
        -- 2x CHARGE & REQUEST (CASTING)
        for i = 1, 2 do
            safeFire(function()
                RF_ChargeFishingRod:InvokeServer({[1] = currentTime})
            end)
            safeFire(function()
                RF_RequestMinigame:InvokeServer(1, 0, currentTime)
            end)
        end
        
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
        
        -- Wait after cancel before next cast (untuk status OK)
        task.wait(UltraBlatant.Settings.AfterCancelDelay)
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
        
        task.wait(UltraBlatant.Settings.AfterCancelDelay)
    end)
end)

-- FISH CAUGHT COUNTER
RE_FishCaught.OnClientEvent:Connect(function()
    UltraBlatant.Stats.fishCaught = UltraBlatant.Stats.fishCaught + 1
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
    UltraBlatant.Stats.fishCaught = 0
    UltraBlatant.Stats.startTime = tick()
    
    task.spawn(ultraSpamLoop)
    
    print("💀 ULTRA BLATANT STARTED!")
end

-- Stop function
function UltraBlatant.Stop()
    if not UltraBlatant.Active then 
        print("⚠️ Ultra Blatant not running!")
        return
    end
    
    UltraBlatant.Active = false
    
    print("⏸ ULTRA BLATANT STOPPED")
end

-- Get stats function (optional, untuk display di GUI)
function UltraBlatant.GetStats()
    local elapsed = tick() - UltraBlatant.Stats.startTime
    local cpm = 0
    
    if elapsed > 0 then
        cpm = math.floor((UltraBlatant.Stats.castCount / elapsed) * 60)
    end
    
    return {
        casts = UltraBlatant.Stats.castCount,
        fish = UltraBlatant.Stats.fishCaught,
        cpm = cpm,
        isRunning = UltraBlatant.Active
    }
end

print("✅ ULTRA BLATANT MODULE READY!")
print("📚 Usage: UltraBlatant.Start() / UltraBlatant.Stop()")
print("⚙️ Settings: CompleteDelay / CancelDelay / AfterCancelDelay")
print("💡 Use makeInput() for delay input in GUI")

-- Return module
return UltraBlatant
