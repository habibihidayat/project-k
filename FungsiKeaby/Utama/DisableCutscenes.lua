--=====================================================
-- DisableCutscenes.lua (ERROR-FREE VERSION)
-- Memblokir cutscene tanpa GuiControl require
--=====================================================
local DisableCutscenes = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Index = Packages:WaitForChild("_Index")
local NetFolder = Index:WaitForChild("sleitnick_net@0.2.0")
local net = NetFolder:WaitForChild("net")

local ReplicateCutscene = net:FindFirstChild("ReplicateCutscene")
local StopCutscene = net:FindFirstChild("StopCutscene")
local BlackoutScreen = net:FindFirstChild("BlackoutScreen")

local running = false
local _connections = {}
local _threads = {}

local function connect(signal, fn)
    if signal then
        local success, connection = pcall(function()
            return signal:Connect(fn)
        end)
        if success and connection then
            table.insert(_connections, connection)
            return connection
        end
    end
end

local function addThread(thread)
    if thread then
        table.insert(_threads, thread)
    end
end

local function blockInCutsceneAttribute()
    pcall(function()
        if LocalPlayer:GetAttribute("InCutscene") then
            LocalPlayer:SetAttribute("InCutscene", false)
        end
    end)
end

local function unlockPlayerGui()
    -- Unlock GUI tanpa require GuiControl
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if PlayerGui then
        -- Enable semua ScreenGui yang mungkin di-disable
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and not gui.Enabled then
                local name = gui.Name:lower()
                -- Skip cutscene GUI, enable yang lain
                if not (name:find("cutscene") or name:find("blackout") or 
                        name:find("fade") or name:find("transition")) then
                    pcall(function()
                        gui.Enabled = true
                    end)
                end
            end
        end
    end
    
    -- Restore camera jika terkunci
    local Camera = workspace.CurrentCamera
    if Camera then
        pcall(function()
            Camera.CameraType = Enum.CameraType.Custom
        end)
    end
    
    -- Enable character movement
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then
            pcall(function()
                Humanoid.WalkSpeed = 16 -- Reset ke default
            end)
        end
    end
end

local function stopAllCutscenes()
    if not running then return end
    
    -- Fire StopCutscene
    if StopCutscene then
        for i = 1, 3 do
            task.spawn(function()
                pcall(function()
                    StopCutscene:FireServer()
                end)
            end)
        end
    end
    
    -- Force attribute ke false
    blockInCutsceneAttribute()
    
    -- Cleanup UI cutscene
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if PlayerGui then
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                local name = gui.Name:lower()
                if name:find("cutscene") or name:find("blackout") or 
                   name:find("fade") or name:find("transition") then
                    pcall(function()
                        gui.Enabled = false
                        task.wait(0.1)
                        gui:Destroy()
                    end)
                end
            end
        end
    end
    
    -- Unlock GUI dan restore controls (tanpa require)
    unlockPlayerGui()
end

-----------------------------------------------------
-- START
-----------------------------------------------------
function DisableCutscenes.Start()
    if running then 
        warn("[DisableCutscenes] Already running!")
        return false
    end
    
    running = true
    
    -- Thread 1: Monitor InCutscene attribute secara agresif
    addThread(task.spawn(function()
        while running do
            if LocalPlayer:GetAttribute("InCutscene") == true then
                LocalPlayer:SetAttribute("InCutscene", false)
                task.spawn(stopAllCutscenes)
            end
            task.wait(0.05)
        end
    end))
    
    -- Thread 2: Attribute change listener
    connect(LocalPlayer:GetAttributeChangedSignal("InCutscene"), function()
        if running and LocalPlayer:GetAttribute("InCutscene") == true then
            task.spawn(function()
                LocalPlayer:SetAttribute("InCutscene", false)
                stopAllCutscenes()
            end)
        end
    end)
    
    -- Thread 3: Block ReplicateCutscene event
    if ReplicateCutscene then
        connect(ReplicateCutscene.OnClientEvent, function(...)
            if running then
                task.spawn(function()
                    LocalPlayer:SetAttribute("InCutscene", false)
                    stopAllCutscenes()
                end)
            end
        end)
    end
    
    -- Thread 4: Block BlackoutScreen
    if BlackoutScreen then
        connect(BlackoutScreen.OnClientEvent, function(...)
            if running then
                task.spawn(stopAllCutscenes)
            end
        end)
    end
    
    -- Thread 5: Monitor UI cutscene yang muncul
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    connect(PlayerGui.ChildAdded, function(child)
        if running and child:IsA("ScreenGui") then
            local name = child.Name:lower()
            if name:find("cutscene") or name:find("blackout") or 
               name:find("fade") or name:find("transition") then
                task.spawn(function()
                    pcall(function()
                        child.Enabled = false
                        task.wait(0.05)
                        child:Destroy()
                    end)
                    stopAllCutscenes()
                end)
            end
        end
    end)
    
    -- Thread 6: Backup loop
    addThread(task.spawn(function()
        while running do
            stopAllCutscenes()
            task.wait(0.3)
        end
    end))
    
    -- Initial cleanup
    task.spawn(stopAllCutscenes)
    
    print("[DisableCutscenes] ✓ ENABLED - All cutscenes blocked")
    return true
end

-----------------------------------------------------
-- STOP
-----------------------------------------------------
function DisableCutscenes.Stop()
    if not running then 
        warn("[DisableCutscenes] Not running!")
        return false
    end
    
    running = false
    
    -- Disconnect semua connections
    for _, connection in ipairs(_connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(_connections)
    
    -- Cancel semua threads
    for _, thread in ipairs(_threads) do
        pcall(function()
            task.cancel(thread)
        end)
    end
    table.clear(_threads)
    
    print("[DisableCutscenes] ✗ DISABLED - Cutscenes restored")
    return true
end

-----------------------------------------------------
-- STATUS CHECK
-----------------------------------------------------
function DisableCutscenes.IsRunning()
    return running
end

function DisableCutscenes.GetStatus()
    return {
        Running = running,
        Connections = #_connections,
        Threads = #_threads,
        InCutscene = LocalPlayer:GetAttribute("InCutscene")
    }
end

-----------------------------------------------------
return DisableCutscenes
