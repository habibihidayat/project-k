-- AutoTeleportEvent.lua (revisi)
local module = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local active = false
local selectedEvent = nil

-- Ambil semua event yang punya koordinat
function module.GetAvailableEvents()
    local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
    if not eventsFolder then return {} end

    local available = {}
    for _, eventModule in pairs(eventsFolder:GetChildren()) do
        if eventModule:IsA("ModuleScript") then
            local success, eventData = pcall(require, eventModule)
            if success and eventData.Coordinates and #eventData.Coordinates > 0 then
                table.insert(available, {Name = eventData.Name, Coordinates = eventData.Coordinates, Module = eventModule})
            end
        end
    end
    return available
end

-- Dapatkan koordinat aktif dari event (cek spawn object di server)
local function getCurrentEventCoordinates(eventData)
    -- Cek child di ReplicatedStorage/Events/EventName (misal spawn point atau marker)
    local eventFolder = ReplicatedStorage.Events:FindFirstChild(eventData.Module.Name)
    if eventFolder then
        for _, obj in pairs(eventFolder:GetChildren()) do
            if obj:IsA("BasePart") then
                return obj.Position
            end
        end
    end
    -- fallback ke koordinat pertama
    return eventData.Coordinates[1]
end

-- Teleport ke koordinat aktif
local function teleportToEvent()
    if not selectedEvent then return end
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPos = getCurrentEventCoordinates(selectedEvent)
    if targetPos then
        hrp.CFrame = CFrame.new(targetPos)
    end
end

-- Start auto teleport
function module.Start(eventName)
    if active then return end
    active = true

    local events = module.GetAvailableEvents()
    selectedEvent = nil
    for _, e in pairs(events) do
        if e.Name == eventName then
            selectedEvent = e
            break
        end
    end

    if not selectedEvent then
        warn("Event "..eventName.." tidak ditemukan atau belum aktif!")
        active = false
        return
    end

    RunService.Heartbeat:Connect(function()
        if active then
            teleportToEvent()
        end
    end)
end

-- Stop auto teleport
function module.Stop()
    active = false
end

return module
