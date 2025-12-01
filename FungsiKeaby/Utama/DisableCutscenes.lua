--=====================================================
-- DisableCutscenes.lua (FIXED VERSION)
-- Menonaktifkan semua cutscene termasuk legendary, mythic, dan secret
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

local function connect(event, fn)
    if event then
        local c = event.OnClientEvent:Connect(fn)
        table.insert(_connections, c)
    end
end

local function stopAllCutscenes()
    -- Fire StopCutscene multiple times untuk memastikan
    if StopCutscene then
        for i = 1, 5 do
            task.spawn(function()
                StopCutscene:FireServer()
            end)
        end
    end
    
    -- Cari dan destroy UI cutscene yang mungkin muncul
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and (
            gui.Name:lower():find("cutscene") or 
            gui.Name:lower():find("blackout") or
            gui.Name:lower():find("fade")
        ) then
            gui.Enabled = false
            task.spawn(function()
                gui:Destroy()
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
    
    -- Block ReplicateCutscene dengan immediate stop
    connect(ReplicateCutscene, function(...)
        if running then
            -- Stop immediately tanpa delay
            task.spawn(stopAllCutscenes)
        end
    end)
    
    -- Block BlackoutScreen
    connect(BlackoutScreen, function(...)
        if running then
            task.spawn(stopAllCutscenes)
        end
    end)
    
    -- Monitor PlayerGui untuk UI cutscene yang muncul
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    connect(PlayerGui.ChildAdded, function(child)
        if running and child:IsA("ScreenGui") then
            -- Check jika ini cutscene UI
            if child.Name:lower():find("cutscene") or 
               child.Name:lower():find("blackout") or
               child.Name:lower():find("fade") then
                child.Enabled = false
                task.spawn(function()
                    child:Destroy()
                end)
                stopAllCutscenes()
            end
        end
    end)
    
    -- Loop paksa StopCutscene dengan interval lebih cepat
    _loopThread = task.spawn(function()
        while running do
            stopAllCutscenes()
            task.wait(0.5) -- Lebih cepat dari 1 detik
        end
    end)
    
    print("[DisableCutscenes] ENABLED - All cutscenes blocked")
end

-----------------------------------------------------
-- STOP
-----------------------------------------------------
function DisableCutscenes.Stop()
    if not running then return end
    running = false
    
    -- Hapus semua koneksi listener
    for _, c in ipairs(_connections) do
        pcall(function()
            c:Disconnect()
        end)
    end
    _connections = {}
    
    -- Stop loop
    if _loopThread then
        task.cancel(_loopThread)
        _loopThread = nil
    end
    
    print("[DisableCutscenes] DISABLED")
end

-----------------------------------------------------
return DisableCutscenes
