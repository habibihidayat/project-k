-- BlatantAutoFishing.lua
-- Mode Blatant: Ultra fast fishing (No rod detection needed)

local BlatantAutoFishing = {}
BlatantAutoFishing.Enabled = false
BlatantAutoFishing.Settings = {
    CastDelay = 0.001,
    ReelDelay = 0.001,
    RetryDelay = 0.001,
    ChargeTime = 1.0,
    AutoShake = true,
    AutoReel = true,
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Variables
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local FishingConnection = nil
local ShakeConnection = nil
local isFishing = false
local isMinigameActive = false
local lastCastTime = 0

-- Network events
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

print("✅ Network events loaded successfully!")

-- Fungsi untuk charge dan cast
local function chargeCast()
    if isFishing then return end
    
    local currentTime = tick()
    if currentTime - lastCastTime < BlatantAutoFishing.Settings.CastDelay then
        return
    end
    
    pcall(function()
        print("🎣 Charging and casting...")
        isFishing = true
        lastCastTime = currentTime
        
        local success, result = pcall(function()
            return RF_ChargeFishingRod:InvokeServer(BlatantAutoFishing.Settings.ChargeTime)
        end)
        
        if success then
            print("✅ Cast successful! Power:", BlatantAutoFishing.Settings.ChargeTime)
        else
            warn("❌ Cast failed:", result)
            isFishing = false
        end
    end)
end

-- Fungsi untuk request minigame (reel)
local function requestMinigame()
    if not isFishing or isMinigameActive then return end
    
    pcall(function()
        print("🎮 Requesting minigame (reel)...")
        
        local success, result = pcall(function()
            return RF_RequestMinigame:InvokeServer()
        end)
        
        if success then
            print("✅ Minigame requested!")
        else
            warn("❌ Minigame request failed:", result)
        end
    end)
end

-- Listen untuk FishingCompleted
RE_FishingCompleted.OnClientEvent:Connect(function(...)
    local args = {...}
    print("🐟 Fishing completed!", unpack(args))
    
    -- Reset state
    isFishing = false
    isMinigameActive = false
    
    -- Auto retry
    if BlatantAutoFishing.Enabled then
        task.spawn(function()
            task.wait(BlatantAutoFishing.Settings.RetryDelay)
            if BlatantAutoFishing.Enabled then
                print("🔄 Auto retry...")
                chargeCast()
            end
        end)
    end
end)

-- Listen untuk MinigameChanged
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    print("🎮 Minigame state:", state)
    
    if state == true or state == "started" or state == "active" then
        isMinigameActive = true
        print("✅ Minigame active!")
    elseif state == false or state == "ended" or state == "inactive" then
        isMinigameActive = false
        print("🎮 Minigame ended")
    end
end)

-- Auto shake minigame UI
local function autoShake()
    if ShakeConnection then
        ShakeConnection:Disconnect()
    end
    
    ShakeConnection = RunService.RenderStepped:Connect(function()
        if not BlatantAutoFishing.Enabled or not BlatantAutoFishing.Settings.AutoShake then return end
        if not isMinigameActive then return end
        
        pcall(function()
            for _, gui in pairs(PlayerGUI:GetDescendants()) do
                if gui:IsA("ScreenGui") and gui.Enabled then
                    local name = gui.Name:lower()
                    
                    if name:find("fishing") or name:find("mini") or name:find("game") then
                        -- Spam click semua button
                        for _, button in pairs(gui:GetDescendants()) do
                            if button:IsA("TextButton") or button:IsA("ImageButton") then
                                pcall(function()
                                    for _, connection in pairs(getconnections(button.MouseButton1Click)) do
                                        connection:Fire()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end)
    end)
end

-- Main fishing loop
local function startFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
    end
    
    print("🔄 Starting fishing loop...")
    
    FishingConnection = RunService.Heartbeat:Connect(function()
        if not BlatantAutoFishing.Enabled then return end
        
        pcall(function()
            if not isFishing and not isMinigameActive then
                -- Idle: cast rod
                chargeCast()
                
            elseif isFishing and not isMinigameActive then
                -- Waiting: request minigame after delay
                if BlatantAutoFishing.Settings.AutoReel then
                    local timeSinceCast = tick() - lastCastTime
                    if timeSinceCast >= BlatantAutoFishing.Settings.ReelDelay then
                        requestMinigame()
                    end
                end
            end
        end)
    end)
end

-- Fungsi Start
function BlatantAutoFishing.Start()
    if BlatantAutoFishing.Enabled then
        warn("⚠️ Blatant Auto Fishing sudah aktif!")
        return
    end
    
    print("="..string.rep("=", 50))
    print("🔥 BLATANT MODE AKTIF!")
    print("="..string.rep("=", 50))
    print("⚡ Cast Delay:", BlatantAutoFishing.Settings.CastDelay, "s")
    print("⚡ Reel Delay:", BlatantAutoFishing.Settings.ReelDelay, "s")
    print("⚡ Retry Delay:", BlatantAutoFishing.Settings.RetryDelay, "s")
    print("⚡ Charge Power:", BlatantAutoFishing.Settings.ChargeTime)
    print("🎮 Auto Shake:", BlatantAutoFishing.Settings.AutoShake)
    print("🎣 Auto Reel:", BlatantAutoFishing.Settings.AutoReel)
    print("⚠️ WARNING: Mode ini sangat obvious!")
    print("="..string.rep("=", 50))
    
    BlatantAutoFishing.Enabled = true
    isFishing = false
    isMinigameActive = false
    lastCastTime = 0
    
    -- Start loops
    startFishing()
    
    if BlatantAutoFishing.Settings.AutoShake then
        autoShake()
    end
    
    print("✅ Fishing loop started!")
end

-- Fungsi Stop
function BlatantAutoFishing.Stop()
    if not BlatantAutoFishing.Enabled then
        warn("⚠️ Blatant Auto Fishing sudah tidak aktif!")
        return
    end
    
    BlatantAutoFishing.Enabled = false
    
    -- Cancel fishing
    pcall(function()
        if isFishing then
            RF_CancelFishingInputs:InvokeServer()
            print("❌ Fishing canceled")
        end
    end)
    
    if FishingConnection then
        FishingConnection:Disconnect()
        FishingConnection = nil
    end
    
    if ShakeConnection then
        ShakeConnection:Disconnect()
        ShakeConnection = nil
    end
    
    isFishing = false
    isMinigameActive = false
    
    print("🔴 Blatant Mode dinonaktifkan")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function()
    if BlatantAutoFishing.Enabled then
        task.wait(2)
        
        print("🔄 Character respawned, restarting...")
        
        isFishing = false
        isMinigameActive = false
        lastCastTime = 0
        
        if FishingConnection then
            FishingConnection:Disconnect()
        end
        if ShakeConnection then
            ShakeConnection:Disconnect()
        end
        
        startFishing()
        if BlatantAutoFishing.Settings.AutoShake then
            autoShake()
        end
    end
end)

-- Cleanup
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == localPlayer then
        if BlatantAutoFishing.Enabled then
            BlatantAutoFishing.Stop()
        end
    end
end)

return BlatantAutoFishing
