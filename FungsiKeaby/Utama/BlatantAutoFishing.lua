-- BlatantAutoFishing.lua
-- Mode Blatant: Simple auto cast and wait for completion

local BlatantAutoFishing = {}
BlatantAutoFishing.Enabled = false
BlatantAutoFishing.Settings = {
    CastDelay = 0.5,
    RetryDelay = 0.5,
    ChargeTime = 1.0,
    AutoShake = true,
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Variables
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local ShakeConnection = nil
local isFishing = false

-- Network events
local netFolder = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")

print("✅ Network events loaded!")

-- Fungsi untuk charge dan cast
local function chargeCast()
    if isFishing or not BlatantAutoFishing.Enabled then return end
    
    pcall(function()
        print("🎣 Casting rod...")
        isFishing = true
        
        task.spawn(function()
            local success, result = pcall(function()
                return RF_ChargeFishingRod:InvokeServer(BlatantAutoFishing.Settings.ChargeTime)
            end)
            
            if success then
                print("✅ Cast successful! Waiting for bite & minigame...")
            else
                warn("❌ Cast failed:", result)
                isFishing = false
                
                -- Retry jika gagal
                task.wait(BlatantAutoFishing.Settings.RetryDelay)
                if BlatantAutoFishing.Enabled then
                    chargeCast()
                end
            end
        end)
    end)
end

-- Listen untuk FishingCompleted
RE_FishingCompleted.OnClientEvent:Connect(function(...)
    local args = {...}
    print("🐟 Fishing completed!", unpack(args))
    
    -- Reset state
    isFishing = false
    
    -- Auto retry
    if BlatantAutoFishing.Enabled then
        task.spawn(function()
            print("⏳ Waiting retry delay...")
            task.wait(BlatantAutoFishing.Settings.RetryDelay)
            
            if BlatantAutoFishing.Enabled then
                print("🔄 Auto retry casting...")
                task.wait(BlatantAutoFishing.Settings.CastDelay)
                chargeCast()
            end
        end)
    end
end)

-- Listen untuk MinigameChanged (info only)
RE_MinigameChanged.OnClientEvent:Connect(function(state)
    if state == true or state == "started" or state == "active" then
        print("🎮 Minigame started automatically!")
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
            -- Cari fishing minigame UI
            for _, gui in pairs(PlayerGUI:GetDescendants()) do
                if gui:IsA("ScreenGui") and gui.Enabled then
                    local name = gui.Name:lower()
                    
                    -- Deteksi minigame UI
                    if name:find("fishing") or name:find("mini") or name:find("game") or name:find("reel") then
                        -- Spam click semua button
                        for _, button in pairs(gui:GetDescendants()) do
                            if button:IsA("TextButton") or button:IsA("ImageButton") then
                                pcall(function()
                                    -- Fire semua connections
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
    print("⚡ Retry Delay:", BlatantAutoFishing.Settings.RetryDelay, "s")
    print("⚡ Charge Power:", BlatantAutoFishing.Settings.ChargeTime)
    print("🎮 Auto Shake:", BlatantAutoFishing.Settings.AutoShake)
    print("💡 Sistem: Auto cast → Wait bite → Auto minigame → Repeat")
    print("="..string.rep("=", 50))
    
    BlatantAutoFishing.Enabled = true
    isFishing = false
    
    -- Start auto shake
    if BlatantAutoFishing.Settings.AutoShake then
        autoShake()
    end
    
    -- Start fishing dengan first cast
    task.spawn(function()
        task.wait(0.5)
        if BlatantAutoFishing.Enabled then
            chargeCast()
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
    
    print("🔴 Blatant Mode dinonaktifkan")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function()
    if BlatantAutoFishing.Enabled then
        task.wait(2)
        
        print("🔄 Character respawned, restarting...")
        
        isFishing = false
        
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
