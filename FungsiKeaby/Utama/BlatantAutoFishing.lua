-- BlatantAutoFishing.lua
-- Mode Blatant: Ultra fast, no delays, aggressive fishing

local BlatantAutoFishing = {}
BlatantAutoFishing.Enabled = false
BlatantAutoFishing.Settings = {
    CastDelay = 0.001,        -- Delay setelah cast (hampir instant)
    ReelDelay = 0.001,        -- Delay setelah reel (hampir instant)
    RetryDelay = 0.001,       -- Delay retry jika gagal
    AutoShake = true,         -- Auto shake saat minigame
    AutoReel = true,          -- Auto reel instant
    MaxSpeed = true,          -- Kecepatan maksimal
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local localPlayer = Players.LocalPlayer

-- Variables
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local FishingConnection = nil
local ShakeConnection = nil

-- Fungsi untuk get rod
local function getRod()
    local character = localPlayer.Character
    if not character then return nil end
    
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("rod") or tool.Name:lower():find("fishing")) then
            return tool
        end
    end
    
    return nil
end

-- Fungsi untuk cast
local function castRod()
    pcall(function()
        local rod = getRod()
        if not rod then return end
        
        -- Cari event cast di rod
        local events = rod:FindFirstChild("events")
        if events then
            local cast = events:FindFirstChild("cast")
            if cast then
                cast:FireServer(100) -- Cast dengan power 100
                return
            end
        end
        
        -- Backup method: activate tool
        if rod.Parent == localPlayer.Character then
            rod:Activate()
        end
    end)
end

-- Fungsi untuk reel
local function reelRod()
    pcall(function()
        local rod = getRod()
        if not rod then return end
        
        -- Cari event reel
        local events = rod:FindFirstChild("events")
        if events then
            local reel = events:FindFirstChild("reel")
            if reel then
                reel:FireServer(100, true) -- Reel dengan power maksimal
                return
            end
        end
    end)
end

-- Fungsi untuk auto shake (minigame)
local function autoShake()
    if ShakeConnection then
        ShakeConnection:Disconnect()
    end
    
    ShakeConnection = RunService.RenderStepped:Connect(function()
        if not BlatantAutoFishing.Enabled or not BlatantAutoFishing.Settings.AutoShake then return end
        
        pcall(function()
            -- Cari UI shake minigame
            local shakeUI = PlayerGUI:FindFirstChild("shakeui", true)
            if shakeUI and shakeUI.Enabled then
                -- Spam click untuk shake
                local button = shakeUI:FindFirstChild("safezone", true) or shakeUI:FindFirstChild("button", true)
                if button then
                    -- Fire clicked event
                    for i = 1, 10 do -- Spam 10x per frame
                        pcall(function()
                            firesignal(button.MouseButton1Click)
                        end)
                    end
                end
                
                -- Backup: use VirtualInputManager
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.001)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
        end)
    end)
end

-- Main fishing loop
local function startFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
    end
    
    FishingConnection = RunService.Heartbeat:Connect(function()
        if not BlatantAutoFishing.Enabled then return end
        
        pcall(function()
            local rod = getRod()
            if not rod then return end
            
            local rodValue = rod:FindFirstChild("values")
            if not rodValue then return end
            
            -- Cek status fishing
            local cast = rodValue:FindFirstChild("cast")
            local bite = rodValue:FindFirstChild("bite")
            
            if cast and not cast.Value then
                -- Belum cast, cast sekarang
                task.wait(BlatantAutoFishing.Settings.CastDelay)
                castRod()
                
            elseif bite and bite.Value then
                -- Ada bite, reel sekarang!
                if BlatantAutoFishing.Settings.AutoReel then
                    task.wait(BlatantAutoFishing.Settings.ReelDelay)
                    reelRod()
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
    
    BlatantAutoFishing.Enabled = true
    
    -- Start fishing loop
    startFishing()
    
    -- Start auto shake
    if BlatantAutoFishing.Settings.AutoShake then
        autoShake()
    end
    
    print("🔥 BLATANT MODE AKTIF - Ultra fast fishing!")
    print("⚡ Cast Delay:", BlatantAutoFishing.Settings.CastDelay, "s")
    print("⚡ Reel Delay:", BlatantAutoFishing.Settings.ReelDelay, "s")
    print("⚠️ WARNING: Mode ini sangat obvious!")
end

-- Fungsi Stop
function BlatantAutoFishing.Stop()
    if not BlatantAutoFishing.Enabled then
        warn("⚠️ Blatant Auto Fishing sudah tidak aktif!")
        return
    end
    
    BlatantAutoFishing.Enabled = false
    
    if FishingConnection then
        FishingConnection:Disconnect()
        FishingConnection = nil
    end
    
    if ShakeConnection then
        ShakeConnection:Disconnect()
        ShakeConnection = nil
    end
    
    print("🔴 Blatant Mode dinonaktifkan")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function()
    if BlatantAutoFishing.Enabled then
        task.wait(1)
        
        -- Restart fishing
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
        
        print("🔄 Blatant Mode restarted setelah respawn")
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
