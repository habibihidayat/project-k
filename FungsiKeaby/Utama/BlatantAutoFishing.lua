-- BlatantAutoFishing.lua
-- Mode Blatant: Aggressive auto fishing with bypass attempts

local BlatantAutoFishing = {}
BlatantAutoFishing.Enabled = false
BlatantAutoFishing.Settings = {
    InstantCatch = true,      -- Instant catch tanpa delay
    AutoShake = true,         -- Auto complete minigame
    SpamClick = true,         -- Spam click minigame
    BypassCooldown = true,    -- Bypass cooldown
    MaxSpeed = true,          -- Max speed mode
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Variables
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local Connections = {}

-- Network events
local netFolder = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")

print("✅ Blatant Mode - Network events loaded!")

-- Fungsi untuk spam cast (aggressive)
local function aggressiveCast()
    task.spawn(function()
        while BlatantAutoFishing.Enabled do
            pcall(function()
                -- Spam invoke dengan max power
                RF_ChargeFishingRod:InvokeServer(1)
            end)
            
            -- Ultra fast loop
            if BlatantAutoFishing.Settings.MaxSpeed then
                task.wait(0.01)
            else
                task.wait(0.1)
            end
        end
    end)
end

-- Fungsi untuk auto complete minigame (aggressive spam)
local function autoCompleteMinigame()
    Connections.Minigame = RunService.Heartbeat:Connect(function()
        if not BlatantAutoFishing.Enabled then return end
        
        pcall(function()
            -- Method 1: Spam request minigame
            if BlatantAutoFishing.Settings.InstantCatch then
                RF_RequestMinigame:InvokeServer()
            end
            
            -- Method 2: Find dan spam click UI
            if BlatantAutoFishing.Settings.AutoShake then
                for _, gui in pairs(PlayerGUI:GetDescendants()) do
                    if gui:IsA("ScreenGui") and gui.Enabled then
                        -- Cari minigame UI
                        for _, frame in pairs(gui:GetDescendants()) do
                            if frame:IsA("Frame") or frame:IsA("ImageLabel") then
                                local name = frame.Name:lower()
                                
                                -- Deteksi minigame elements
                                if name:find("bar") or name:find("safe") or name:find("zone") or 
                                   name:find("progress") or name:find("mini") then
                                    
                                    -- Spam click di area tersebut
                                    if BlatantAutoFishing.Settings.SpamClick then
                                        for i = 1, 10 do
                                            pcall(function()
                                                -- Fire semua mouse events
                                                for _, btn in pairs(frame:GetDescendants()) do
                                                    if btn:IsA("GuiButton") then
                                                        for _, sig in pairs(getconnections(btn.MouseButton1Click)) do
                                                            sig:Fire()
                                                        end
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)
end

-- Hook FishingCompleted untuk instant retry
local function setupInstantRetry()
    Connections.FishingCompleted = RE_FishingCompleted.OnClientEvent:Connect(function(...)
        if not BlatantAutoFishing.Enabled then return end
        
        print("🐟 Caught! Instant retry...")
        
        -- Instant cast lagi tanpa delay
        task.spawn(function()
            for i = 1, 3 do
                pcall(function()
                    RF_ChargeFishingRod:InvokeServer(1)
                end)
                task.wait(0.01)
            end
        end)
    end)
end

-- Monitor minigame state
local function setupMinigameMonitor()
    Connections.MinigameChanged = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if not BlatantAutoFishing.Enabled then return end
        
        if state then
            print("🎮 Minigame detected! Spamming completion...")
            
            -- Spam complete attempts
            task.spawn(function()
                for i = 1, 20 do
                    pcall(function()
                        RF_RequestMinigame:InvokeServer()
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end)
end

-- Fungsi untuk bypass detection (experimental)
local function bypassAttempts()
    if not BlatantAutoFishing.Settings.BypassCooldown then return end
    
    task.spawn(function()
        while BlatantAutoFishing.Enabled do
            pcall(function()
                -- Attempt 1: Manipulate workspace values
                local character = localPlayer.Character
                if character then
                    for _, obj in pairs(character:GetDescendants()) do
                        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                            local name = obj.Name:lower()
                            if name:find("cooldown") or name:find("timer") or name:find("wait") then
                                obj.Value = 0
                            end
                        end
                    end
                end
                
                -- Attempt 2: Clear GUI cooldown indicators
                for _, gui in pairs(PlayerGUI:GetDescendants()) do
                    if gui:IsA("Frame") or gui:IsA("TextLabel") then
                        local name = gui.Name:lower()
                        if name:find("cooldown") or name:find("timer") then
                            gui.Visible = false
                        end
                    end
                end
            end)
            
            task.wait(0.5)
        end
    end)
end

-- Fungsi Start
function BlatantAutoFishing.Start()
    if BlatantAutoFishing.Enabled then
        warn("⚠️ Blatant Mode sudah aktif!")
        return
    end
    
    print("="..string.rep("=", 50))
    print("🔥 BLATANT MODE AKTIF - AGGRESSIVE FISHING!")
    print("="..string.rep("=", 50))
    print("⚡ Instant Catch:", BlatantAutoFishing.Settings.InstantCatch)
    print("⚡ Auto Shake:", BlatantAutoFishing.Settings.AutoShake)
    print("⚡ Spam Click:", BlatantAutoFishing.Settings.SpamClick)
    print("⚡ Bypass Cooldown:", BlatantAutoFishing.Settings.BypassCooldown)
    print("⚡ Max Speed:", BlatantAutoFishing.Settings.MaxSpeed)
    print("="..string.rep("=", 50))
    print("⚠️ WARNING: SANGAT OBVIOUS! HIGH BAN RISK!")
    print("="..string.rep("=", 50))
    
    BlatantAutoFishing.Enabled = true
    
    -- Start all aggressive loops
    task.wait(0.5)
    
    -- 1. Aggressive casting
    aggressiveCast()
    print("✅ Aggressive cast loop started")
    
    -- 2. Auto complete minigame
    autoCompleteMinigame()
    print("✅ Auto complete minigame started")
    
    -- 3. Instant retry on completion
    setupInstantRetry()
    print("✅ Instant retry hook installed")
    
    -- 4. Minigame monitor
    setupMinigameMonitor()
    print("✅ Minigame monitor started")
    
    -- 5. Bypass attempts
    bypassAttempts()
    print("✅ Bypass attempts started")
    
    print("🔥 BLATANT MODE FULLY ACTIVE!")
end

-- Fungsi Stop
function BlatantAutoFishing.Stop()
    if not BlatantAutoFishing.Enabled then
        warn("⚠️ Blatant Mode sudah tidak aktif!")
        return
    end
    
    BlatantAutoFishing.Enabled = false
    
    -- Disconnect all connections
    for name, connection in pairs(Connections) do
        if connection then
            connection:Disconnect()
            print("🔴 Disconnected:", name)
        end
    end
    Connections = {}
    
    print("🔴 BLATANT MODE DINONAKTIFKAN")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function()
    if BlatantAutoFishing.Enabled then
        task.wait(2)
        
        print("🔄 Character respawned, restarting blatant mode...")
        
        -- Clear old connections
        for _, connection in pairs(Connections) do
            if connection then connection:Disconnect() end
        end
        Connections = {}
        
        -- Restart
        task.wait(1)
        aggressiveCast()
        autoCompleteMinigame()
        setupInstantRetry()
        setupMinigameMonitor()
        bypassAttempts()
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
