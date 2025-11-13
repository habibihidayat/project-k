local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")
local RE_FishCaught = netFolder:WaitForChild("RE/FishCaught")

local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    Requested = false,
    Phase = "Idle",
    CastLock = false, -- Prevent concurrent casts
    TimeoutHandle = nil, -- Track timeout task
    Settings = {
        FishingDelay = 0.5,
        CancelDelay = 0.2,
        FallbackDelay = 5.0,
        RequestDelay = 1.3,
        PostRequestDelay = 1.3,
        Timeout = 0.26,
        SafeCooldown = 0.25,
    }
}
_G.FishingScript = fishing

local function log(msg)
    print("[Fishing] " .. msg)
end

local function resetCycle()
    fishing.WaitingHook = false
    fishing.Requested = false
    fishing.Phase = "Idle"
    fishing.CastLock = false
    
    -- Cancel pending timeout
    if fishing.TimeoutHandle then
        task.cancel(fishing.TimeoutHandle)
        fishing.TimeoutHandle = nil
    end
end

local function cleanup()
    task.wait(fishing.Settings.CancelDelay)
    pcall(function() RF_CancelFishingInputs:InvokeServer() end)
    task.wait(fishing.Settings.FishingDelay)
    resetCycle()
    task.wait(fishing.Settings.SafeCooldown)
end

-- 🪝 Lempar kail
function fishing.Cast()
    -- Prevent concurrent casts
    if not fishing.Running or fishing.Phase ~= "Idle" or fishing.CastLock then 
        return 
    end
    
    fishing.CastLock = true
    fishing.Phase = "Casting"
    fishing.CurrentCycle += 1
    log("⚡ Lempar pancing.")

    task.spawn(function()
        pcall(function()
            RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        end)

        task.wait(fishing.Settings.RequestDelay)
        if not fishing.Running or fishing.Phase ~= "Casting" then 
            resetCycle()
            return 
        end

        -- Request minigame once
        if not fishing.Requested then
            fishing.Requested = true
            pcall(function()
                RF_RequestMinigame:InvokeServer(1, 0, tick())
            end)
            log("🎯 Menunggu hook...")
            fishing.WaitingHook = true
            fishing.Phase = "Waiting"
        end

        -- Timeout fallback with handle
        fishing.TimeoutHandle = task.delay(fishing.Settings.FallbackDelay, function()
            if fishing.Running and fishing.WaitingHook and fishing.Phase == "Waiting" then
                log("⚠️ Timeout pendek — fallback tarik cepat.")
                fishing.WaitingHook = false
                fishing.Phase = "Pulling"
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                cleanup()
                
                if fishing.Running and fishing.Phase == "Idle" then 
                    fishing.Cast() 
                end
            end
        end)
    end)
end

-- 🎯 Hook detection
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if not fishing.Running or not fishing.WaitingHook or fishing.Phase ~= "Waiting" then 
        return 
    end
    
    if typeof(state) == "string" and string.find(string.lower(state), "hook") then
        log("✅ Hook terdeteksi — ikan ditarik.")
        fishing.WaitingHook = false
        fishing.Phase = "Pulling"
        
        -- Cancel timeout
        if fishing.TimeoutHandle then
            task.cancel(fishing.TimeoutHandle)
            fishing.TimeoutHandle = nil
        end
        
        task.wait(1.0)
        
        pcall(function()
            RE_FishingCompleted:FireServer()
        end)
        
        cleanup()
        
        if fishing.Running and fishing.Phase == "Idle" then 
            fishing.Cast() 
        end
    end
end)

-- 🐟 Ikan tertangkap
RE_FishCaught.OnClientEvent:Connect(function(name)
    if not fishing.Running then return end
    
    -- Only process if we're in a valid fishing state
    if fishing.Phase == "Pulling" or fishing.Phase == "Waiting" then
        fishing.TotalFish += 1
        log("🐟 Ikan tertangkap: " .. tostring(name))
        
        fishing.WaitingHook = false
        fishing.Phase = "Cooldown"
        
        -- Cancel timeout
        if fishing.TimeoutHandle then
            task.cancel(fishing.TimeoutHandle)
            fishing.TimeoutHandle = nil
        end
        
        cleanup()
        
        if fishing.Running and fishing.Phase == "Idle" then 
            fishing.Cast() 
        end
    end
end)

-- 🚀 Start / Stop
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    resetCycle()
    log("🚀 FISHING STARTED!")
    fishing.Cast()
end

function fishing.Stop()
    fishing.Running = false
    fishing.WaitingHook = false
    fishing.Requested = false
    fishing.Phase = "Idle"
    fishing.CastLock = false
    
    if fishing.TimeoutHandle then
        task.cancel(fishing.TimeoutHandle)
        fishing.TimeoutHandle = nil
    end
    
    log("🛑 FISHING STOPPED")
end

return fishing
