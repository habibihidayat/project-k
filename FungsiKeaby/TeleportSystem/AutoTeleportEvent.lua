-- AutoTeleportEvent.lua
local module = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local active = false
local selectedEventId = nil

-- Replion & EventUtility
local ReplionClient = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Events")
local EventUtility = require(ReplicatedStorage.Shared.EventUtility)

-- Ambil list event aktif
function module.GetAvailableEvents()
    local events = {}
    local adminEvents = ReplionClient:Get("AdminEvents") or {}
    for _, e in ipairs(adminEvents) do
        local eventData = EventUtility:GetEvent(e.eventId)
        if eventData and eventData.Coordinates then
            table.insert(events, {Name = eventData.Name, eventId = e.eventId})
        end
    end
    return events
end

-- Teleport ke koordinat aktif event
local function teleportToEvent()
    if not selectedEventId then return end
    local eventData = EventUtility:GetEvent(selectedEventId)
    if not eventData or not eventData.Coordinates then return end

    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Teleport ke koordinat pertama (bisa diubah logika nanti untuk koordinat terdekat)
    local targetPos = eventData.Coordinates[1]
    if targetPos then
        hrp.CFrame = CFrame.new(targetPos)
    end
end

-- Start auto teleport
function module.Start(eventId)
    if active then return end
    active = true
    selectedEventId = eventId

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
