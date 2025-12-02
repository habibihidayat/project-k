-- AutoTeleportEvent.lua
local module = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local active = false
local selectedEvent = nil

-- Ambil semua event yang punya koordinat
function module.GetAvailableEvents()
    local eventsFolder = ReplicatedStorage:WaitForChild("Events")
    local available = {}

    for _, eventModule in pairs(eventsFolder:GetChildren()) do
        if eventModule:IsA("ModuleScript") then
            local success, eventData = pcall(require, eventModule)
            if success and eventData.Coordinates and #eventData.Coordinates > 0 then
                table.insert(available, {Name = eventData.Name, Coordinates = eventData.Coordinates})
            end
        end
    end

    return available
end

-- Fungsi teleport ke koordinat pertama dari event
local function teleportToEvent()
    if not selectedEvent or #selectedEvent.Coordinates == 0 then return end
    local targetPos = selectedEvent.Coordinates[1]

    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(targetPos)
    end
end

-- Mulai auto teleport ke event tertentu
function module.Start(eventName)
    if active then return end
    active = true

    local events = module.GetAvailableEvents()
    for _, e in pairs(events) do
        if e.Name == eventName then
            selectedEvent = e
            break
        end
    end

    if not selectedEvent then
        warn("Event "..eventName.." tidak ditemukan atau belum aktif!")
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
