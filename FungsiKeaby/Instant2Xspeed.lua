local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")
local RE_FishCaught = netFolder:WaitForChild("RE/FishCaught")

-- State Machine
local STATE = {
    IDLE = "Idle",
    CASTING = "Casting",
    WAITING_HOOK = "WaitingHook",
    PULLING = "Pulling",
    CAUGHT = "Caught"
}

local fishing = {
    Running = false,
    State = STATE.IDLE,
    TotalFish = 0,
    CurrentCycle = 0,
    LastActionTime = 0,
    ActiveCoroutine = nil,
    Settings = {
        CastDelay = 0.15,        -- Delay sebelum request minigame
        HookTimeout = 4.5,       -- Timeout menunggu hook
        PullDelay = 0.8,         -- Delay sebelum pull
        CleanupDelay = 0.15,     -- Delay cleanup
        CycleDelay = 0.3,        -- Delay antar cycle
        MinActionGap = 0.1,      -- Min gap antar action
    }
}
_G.FishingScript = fishing

local function log(msg)
    print("[Fishing] " .. msg)
end

local function setState(newState)
    if fishing.State ~= newState then
        fishing.State = newState
    end
end

local function canTransition(fromState)
    return fishing.Running and fishing.State == fromState
end

local function waitSafe(duration)
    local start = tick()
    while tick() - start < duration do
        if not fishing.Running then return false end
        task.wait()
    end
    return true
end

local function cancelActive()
    if fishing.ActiveCoroutine then
        task.cancel(fishing.ActiveCoroutine)
        fishing.ActiveCoroutine = nil
    end
end

-- Core fishing cycle
local function executeFishingCycle()
    -- 1. CASTING PHASE
    if not canTransition(STATE.IDLE) then return end
    
    setState(STATE.CASTING)
    fishing.CurrentCycle += 1
    fishing.LastActionTime = tick()
    log("⚡ Lempar pancing.")
    
    -- Charge rod
    local chargeSuccess = pcall(function()
        RF_ChargeFishingRod:InvokeServer({[1] = tick()})
    end)
    
    if not chargeSuccess or not waitSafe(fishing.Settings.CastDelay) then
        setState(STATE.IDLE)
        return
    end
    
    -- 2. REQUEST MINIGAME
    if not canTransition(STATE.CASTING) then return end
    
    local requestSuccess = pcall(function()
        RF_RequestMinigame:InvokeServer(1, 0, tick())
    end)
    
    if not requestSuccess then
        setState(STATE.IDLE)
        if fishing.Running then
            task.wait(fishing.Settings.CycleDelay)
            executeFishingCycle()
        end
        return
    end
    
    setState(STATE.WAITING_HOOK)
    log("🎯 Menunggu hook...")
    
    -- 3. WAIT FOR HOOK WITH TIMEOUT
    local hookStartTime = tick()
    local hookDetected = false
    
    fishing.ActiveCoroutine = task.delay(fishing.Settings.HookTimeout, function()
        if canTransition(STATE.WAITING_HOOK) then
            log("⚠️ Timeout pendek — fallback tarik cepat.")
            setState(STATE.PULLING)
            
            pcall(function()
                RE_FishingCompleted:FireServer()
            end)
            
            waitSafe(fishing.Settings.CleanupDelay)
            pcall(function() RF_CancelFishingInputs:InvokeServer() end)
            
            setState(STATE.IDLE)
            
            if fishing.Running then
                waitSafe(fishing.Settings.CycleDelay)
                executeFishingCycle()
            end
        end
    end)
end

-- Hook detection handler
local hookConnection
hookConnection = RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if not canTransition(STATE.WAITING_HOOK) then return end
    
    if typeof(state) == "string" and string.find(string.lower(state), "hook") then
        cancelActive()
        
        log("✅ Hook terdeteksi — ikan ditarik.")
        setState(STATE.PULLING)
        
        task.spawn(function()
            waitSafe(fishing.Settings.PullDelay)
            
            if fishing.State == STATE.PULLING then
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                waitSafe(fishing.Settings.CleanupDelay)
                pcall(function() RF_CancelFishingInputs:InvokeServer() end)
            end
        end)
    end
end)

-- Fish caught handler
local fishConnection
fishConnection = RE_FishCaught.OnClientEvent:Connect(function(name)
    if not fishing.Running then return end
    if fishing.State ~= STATE.PULLING and fishing.State ~= STATE.WAITING_HOOK then return end
    
    cancelActive()
    
    fishing.TotalFish += 1
    setState(STATE.CAUGHT)
    log("🐟 Ikan tertangkap: " .. tostring(name) .. " (Total: " .. fishing.TotalFish .. ")")
    
    task.spawn(function()
        waitSafe(fishing.Settings.CleanupDelay)
        pcall(function() RF_CancelFishingInputs:InvokeServer() end)
        
        setState(STATE.IDLE)
        
        if fishing.Running then
            waitSafe(fishing.Settings.CycleDelay)
            executeFishingCycle()
        end
    end)
end)

-- Start fishing
function fishing.Start()
    if fishing.Running then 
        log("⚠️ Fishing sudah berjalan!")
        return 
    end
    
    fishing.Running = true
    fishing.TotalFish = 0
    fishing.CurrentCycle = 0
    setState(STATE.IDLE)
    cancelActive()
    
    log("🚀 FISHING STARTED!")
    
    task.wait(0.5)
    executeFishingCycle()
end

-- Stop fishing
function fishing.Stop()
    if not fishing.Running then return end
    
    fishing.Running = false
    cancelActive()
    setState(STATE.IDLE)
    
    pcall(function() RF_CancelFishingInputs:InvokeServer() end)
    
    log("🛑 FISHING STOPPED - Total ikan: " .. fishing.TotalFish)
end

-- Status check
function fishing.GetStatus()
    return {
        Running = fishing.Running,
        State = fishing.State,
        TotalFish = fishing.TotalFish,
        Cycle = fishing.CurrentCycle
    }
end

-- Auto-reconnect on teleport
local teleportConnection
teleportConnection = localPlayer.OnTeleport:Connect(function()
    if fishing.Running then
        task.wait(2)
        fishing.Start()
    end
end)

return fishing
