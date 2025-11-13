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
    LastCastTime = 0,
    ActiveCoroutine = nil,
    Settings = {
        -- ULTRA FAST MODE
        InstantRequest = true,      -- Request minigame bersamaan dengan cast
        CastDelay = 0.05,           -- Minimal delay (nyaris instant)
        HookTimeout = 3.5,          -- Timeout lebih cepat
        PullDelay = 0.5,            -- Pull lebih cepat
        CleanupDelay = 0.05,        -- Cleanup minimal
        PostCatchDelay = 0.05,      -- Delay setelah ikan tertangkap (SUPER CEPAT)
        MinCastInterval = 0.1,      -- Anti-spam protection minimal
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
    if duration <= 0 then return true end
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

local function instantPull()
    -- Tarik ikan secepat mungkin
    pcall(function()
        RE_FishingCompleted:FireServer()
    end)
    task.wait(0.05)
    pcall(function()
        RF_CancelFishingInputs:InvokeServer()
    end)
end

-- Core fishing cycle (OPTIMIZED FOR SPEED)
local function executeFishingCycle()
    -- Anti-spam check
    local currentTime = tick()
    if currentTime - fishing.LastCastTime < fishing.Settings.MinCastInterval then
        task.wait(fishing.Settings.MinCastInterval)
    end
    
    if not canTransition(STATE.IDLE) then return end
    
    setState(STATE.CASTING)
    fishing.CurrentCycle += 1
    fishing.LastCastTime = tick()
    log("⚡ Lempar pancing.")
    
    -- PARALLEL EXECUTION - Cast dan Request bersamaan!
    task.spawn(function()
        pcall(function()
            RF_ChargeFishingRod:InvokeServer({[1] = tick()})
        end)
    end)
    
    -- Request minigame INSTANT (tanda seru muncul bersamaan)
    if fishing.Settings.InstantRequest then
        task.spawn(function()
            task.wait(0.01) -- Tiny delay untuk sinkronisasi
            pcall(function()
                RF_RequestMinigame:InvokeServer(1, 0, tick())
            end)
        end)
    end
    
    if not waitSafe(fishing.Settings.CastDelay) then
        setState(STATE.IDLE)
        return
    end
    
    -- Langsung ke WAITING_HOOK
    if not canTransition(STATE.CASTING) then return end
    
    setState(STATE.WAITING_HOOK)
    log("🎯 Menunggu hook...")
    
    -- Timeout dengan auto-pull
    fishing.ActiveCoroutine = task.delay(fishing.Settings.HookTimeout, function()
        if canTransition(STATE.WAITING_HOOK) then
            log("⚠️ Timeout — auto pull.")
            setState(STATE.PULLING)
            
            instantPull()
            
            setState(STATE.IDLE)
            
            if fishing.Running then
                waitSafe(fishing.Settings.PostCatchDelay)
                executeFishingCycle()
            end
        end
    end)
end

-- Hook detection handler (INSTANT RESPONSE)
local hookConnection
hookConnection = RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if not canTransition(STATE.WAITING_HOOK) then return end
    
    if typeof(state) == "string" and string.find(string.lower(state), "hook") then
        cancelActive()
        
        log("✅ Hook terdeteksi!")
        setState(STATE.PULLING)
        
        -- INSTANT PULL - No delay!
        task.spawn(function()
            waitSafe(fishing.Settings.PullDelay)
            
            if fishing.State == STATE.PULLING then
                instantPull()
            end
        end)
    end
end)

-- Fish caught handler (INSTANT RECAST)
local fishConnection
fishConnection = RE_FishCaught.OnClientEvent:Connect(function(name)
    if not fishing.Running then return end
    if fishing.State ~= STATE.PULLING and fishing.State ~= STATE.WAITING_HOOK then return end
    
    cancelActive()
    
    fishing.TotalFish += 1
    setState(STATE.CAUGHT)
    log("🐟 Ikan #" .. fishing.TotalFish .. ": " .. tostring(name))
    
    -- INSTANT CLEANUP + RECAST
    task.spawn(function()
        waitSafe(fishing.Settings.CleanupDelay)
        pcall(function() RF_CancelFishingInputs:InvokeServer() end)
        
        setState(STATE.IDLE)
        
        if fishing.Running then
            -- SUPER FAST RECAST - Minimal delay
            waitSafe(fishing.Settings.PostCatchDelay)
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
    fishing.LastCastTime = 0
    setState(STATE.IDLE)
    cancelActive()
    
    log("🚀 TURBO FISHING MODE ACTIVATED!")
    log("⚡ Instant cast + pull enabled")
    
    task.wait(0.3)
    executeFishingCycle()
end

-- Stop fishing
function fishing.Stop()
    if not fishing.Running then return end
    
    fishing.Running = false
    cancelActive()
    setState(STATE.IDLE)
    
    pcall(function() RF_CancelFishingInputs:InvokeServer() end)
    
    log("🛑 STOPPED - Total: " .. fishing.TotalFish .. " ikan dalam " .. fishing.CurrentCycle .. " cycles")
end

-- Adjust speed on the fly
function fishing.SetSpeed(mode)
    if mode == "ULTRA" then
        fishing.Settings.CastDelay = 0.05
        fishing.Settings.HookTimeout = 3.0
        fishing.Settings.PullDelay = 0.3
        fishing.Settings.PostCatchDelay = 0.05
        log("⚡ ULTRA SPEED MODE")
    elseif mode == "FAST" then
        fishing.Settings.CastDelay = 0.1
        fishing.Settings.HookTimeout = 3.5
        fishing.Settings.PullDelay = 0.5
        fishing.Settings.PostCatchDelay = 0.1
        log("🏃 FAST SPEED MODE")
    elseif mode == "SAFE" then
        fishing.Settings.CastDelay = 0.2
        fishing.Settings.HookTimeout = 4.5
        fishing.Settings.PullDelay = 0.8
        fishing.Settings.PostCatchDelay = 0.3
        log("🐢 SAFE SPEED MODE")
    end
end

-- Status
function fishing.GetStatus()
    return {
        Running = fishing.Running,
        State = fishing.State,
        TotalFish = fishing.TotalFish,
        Cycle = fishing.CurrentCycle,
        FishPerMinute = fishing.TotalFish / ((tick() - fishing.LastCastTime) / 60)
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
