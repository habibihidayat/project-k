--=====================================================
-- DisableCutscenes.lua (ATTRIBUTE BLOCKING VERSION)
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
local _loopThread = nil
local _attributeThread = nil

local function connect(signal, fn)
    if signal then
        local c = signal:Connect(fn)
        table.insert(_connections, c)
        return c
    end
end

local function blockInCutsceneAttribute()
    -- Set InCutscene ke false dan prevent perubahan
    if LocalPlayer:GetAttribute("InCutscene") then
        LocalPlayer:SetAttribute("InCutscene", false)
    end
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
    
    -- Cleanup UI
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if PlayerGui then
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                local name = gui.Name:lower()
                if name:find("cutscene") or name:find("blackout") or 
                   name:find("fade") or name:find("transition") then
                    gui.Enabled = false
                    task.spawn(function()
                        pcall(function() gui:Destroy() end)
                    end)
                end
            end
        end
    end
    
    -- Unlock GuiControl jika terkunci
    local GuiControl = ReplicatedStorage:FindFirstChild("Modules")
    if GuiControl then
        GuiControl = GuiControl:FindFirstChild("GuiControl")
        if GuiControl then
            pcall(function()
                local GuiControlModule = require(GuiControl)
                if GuiControlModule.Unlock then
                    GuiControlModule:Unlock()
                end
                if GuiControlModule.SetHUDVisibility then
                    GuiControlModule:SetHUDVisibility(true)
                end
            end)
        end
    end
end

-----------------------------------------------------
-- START
-----------------------------------------------------
function DisableCutscenes.Start()
    if running then return end
    running = true
    
    -- CRITICAL: Block InCutscene attribute changes
    _attributeThread = task.spawn(function()
        while running do
            -- Monitor dan force InCutscene ke false
            if LocalPlayer:GetAttribute("InCutscene") == true then
                LocalPlayer:SetAttribute("InCutscene", false)
                stopAllCutscenes()
            end
            task.wait(0.1) -- Check setiap 0.1 detik
        end
    end)
    
    -- Listen untuk attribute changes
    connect(LocalPlayer:GetAttributeChangedSignal("InCutscene"), function()
        if running and LocalPlayer:GetAttribute("InCutscene") == true then
            LocalPlayer:SetAttribute("InCutscene", false)
            stopAllCutscenes()
        end
    end)
    
    -- Block ReplicateCutscene event
    connect(ReplicateCutscene.OnClientEvent, function(...)
        if running then
            -- Immediately set attribute to false
            LocalPlayer:SetAttribute("InCutscene", false)
            stopAllCutscenes()
        end
    end)
    
    -- Block BlackoutScreen
    if BlackoutScreen then
        connect(BlackoutScreen.OnClientEvent, function(...)
            if running then
                stopAllCutscenes()
            end
        end)
    end
    
    -- Monitor PlayerGui untuk UI baru
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    connect(PlayerGui.ChildAdded, function(child)
        if running and child:IsA("ScreenGui") then
            local name = child.Name:lower()
            if name:find("cutscene") or name:find("blackout") or 
               name:find("fade") or name:find("transition") then
                child.Enabled = false
                task.spawn(function()
                    pcall(function() child:Destroy() end)
                end)
                stopAllCutscenes()
            end
        end
    end)
    
    -- Loop backup untuk memastikan
    _loopThread = task.spawn(function()
        while running do
            stopAllCutscenes()
            task.wait(0.5)
        end
    end)
    
    -- Initial cleanup
    stopAllCutscenes()
    
    print("[DisableCutscenes] ENABLED - Blocking InCutscene attribute")
end

-----------------------------------------------------
-- STOP
-----------------------------------------------------
function DisableCutscenes.Stop()
    if not running then return end
    running = false
    
    -- Disconnect semua
    for _, c in ipairs(_connections) do
        pcall(function()
            c:Disconnect()
        end)
    end
    _connections = {}
    
    -- Stop threads
    if _loopThread then
        task.cancel(_loopThread)
        _loopThread = nil
    end
    
    if _attributeThread then
        task.cancel(_attributeThread)
        _attributeThread = nil
    end
    
    print("[DisableCutscenes] DISABLED")
end

-----------------------------------------------------
return DisableCutscenes
