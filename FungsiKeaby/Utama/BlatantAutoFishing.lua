-- BlatantAutoFishing.lua
-- Mode Blatant: Wait for bite before requesting minigame

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
local ShakeConnection = nil
local isFishing = false
local canRequestMinigame = false
local minigameRequested = false

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

print("✅ Network events loaded!")

-- Fungsi untuk charge dan cast
local function chargeCast()
    if isFishing then return end
    
    pcall(function()
        print("🎣 Charging and casting...")
        isFishing = true
        canRequestMinigame = false
        minigameRequested = false
        
        task.spawn(function()
            local success, result = pcall(function()
                return RF_ChargeFishingRod:InvokeServer(BlatantAutoFishing.Settings.ChargeTime)
            end)
            
            if success then
                print("✅ Cast successful! Power:", BlatantAutoFishing.Settings.ChargeTime)
                
                -- Tunggu delay lalu allow request minigame
                task.wait(BlatantAutoFishing.Settings.ReelDelay)
                canRequestMinigame = true
                print("✅ Ready to request minigame")
            else
                warn("❌ Cast failed:", result)
                isFishing = false
            end
        end)
    end)
end

-- Fungsi untuk request minigame (hanya sekali per cast)
local function requestMinigame()
    if not isFishing or not canRequestMinigame or minigameRequested then 
        return 
    end
    
    if not BlatantAutoFishing.Settings.AutoReel then
        return
    end
    
    pcall(function()
        print("🎮 Requesting minigame...")
        minigameRequested = true
        
        task.spawn(function()
            local success, result = pcall(function()
                return RF_RequestMinigame:InvokeServer()
            end)
            
            if success then
                print("✅ Minigame started!")
            else
                warn("❌ Minigame request failed:", result)
                -- Reset untuk retry
                task.wait(0.5)
                minigameRequested = false
            end
        end)
    end)
end

-- Listen untuk FishingCompleted
RE_FishingCompleted.OnClientEvent:Connect(function(...)
    print("🐟 Fishing completed!")
    
    -- Reset state
    isFishing = false
    canRequestMinigame = false
    minigameRequested = false
    
    -- Auto retry
    if BlatantAutoFishing.Enabled then
        task.spawn(function()
            task.wait(BlatantAutoFishing.Settings.RetryDelay)
            if BlatantAutoFishing.Enabled then
                print("🔄 Auto retry...")
                task.wait(BlatantAutoFishing.Settings.CastDelay)
                chargeCast()
            end
        end)
    end
end)

-- Listen untuk MinigameChanged
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    print("🎮 Minigame state:", state)
    
    if state == true or state == "started" or state == "active" then
        print("✅ Minigame active!")
    elseif state == false or state == "ended" or state == "inactive" then
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
    canRequestMinigame = false
    minigameRequested = false
    
    -- Start auto shake
    if BlatantAutoFishing.Settings.AutoShake then
        autoShake()
    end
    
    -- Start fishing dengan first cast
    task.spawn(function()
        task.wait(0.5)
        if BlatantAutoFishing.Enabled then
            chargeCast()
            
            -- Loop untuk auto request minigame
            while BlatantAutoFishing.Enabled do
                if canRequestMinigame and not minigameRequested then
                    requestMinigame()
                end
                task.wait(0.1)
            end
        end
    end)
    
    print("✅ Blatant mode started!")
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
    
    if ShakeConnection then
        ShakeConnection:Disconnect()
        ShakeConnection = nil
    end
    
    isFishing = false
    canRequestMinigame = false
    minigameRequested = false
    
    print("🔴 Blatant Mode dinonaktifkan")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function()
    if BlatantAutoFishing.Enabled then
        task.wait(2)
        
        print("🔄 Character respawned, restarting...")
        
        isFishing = false
        canRequestMinigame = false
        minigameRequested = false
        
        if ShakeConnection then
            ShakeConnection:Disconnect()
        end
        
        if BlatantAutoFishing.Settings.AutoShake then
            autoShake()
        end
        
        task.wait(0.5)
        chargeCast()
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
