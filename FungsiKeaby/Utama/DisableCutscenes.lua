--=====================================================
-- DisableCutscenes.lua (GUI TOGGLE OPTIMIZED VERSION)
-- Memblokir cutscene dengan mencegah InCutscene attribute
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

local function stopAllCutscenes()
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
                        gui:Destroy()
                    end)
                end
            end
        end
    end
    
    -- Unlock GuiControl
    pcall(function()
        local GuiControlModule = require(ReplicatedStorage.Modules.GuiControl)
        if GuiControlModule.Unlock then
            GuiControlModule:Unlock()
        end
        if GuiControlModule.SetHUDVisibility then
            GuiControlModule:SetHUDVisibility(true)
        end
    end)
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
                stopAllCutscenes()
            end
            task.wait(0.05) -- Check setiap 50ms untuk response cepat
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
                        child:Destroy()
                    end)
                    stopAllCutscenes()
                end)
            end
        end
    end)
    
    -- Thread 6: Backup loop untuk safety
    addThread(task.spawn(function()
        while running do
            stopAllCutscenes()
            task.wait(0.3) -- Backup check setiap 300ms
        end
    end))
    
    -- Initial cleanup saat start
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
-- STATUS CHECK (optional, untuk debugging)
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
