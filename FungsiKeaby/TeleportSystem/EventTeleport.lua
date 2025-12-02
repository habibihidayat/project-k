-- EventTeleport.lua
-- Berisi daftar koordinat + fungsi teleport event

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local EventTeleport = {}

-- =======================
--   EVENT COORDINATES
-- =======================
EventTeleport.Events = {
    ["Shark Hunt"] = {
        Vector3.new(1.64999, -1.3500, 2095.72),
        Vector3.new(1369.94, -1.3500, 930.125),
        Vector3.new(-1585.5, -1.3500, 1242.87),
        Vector3.new(-1896.8, -1.3500, 2634.37)
    },

    ["Worm Hunt"] = {
        Vector3.new(2190.85, -1.3999, 97.5749),
        Vector3.new(-2450.6, -1.3999, 139.731),
        Vector3.new(-267.47, -1.3999, 5188.53)
    },

    ["Megalodon Hunt"] = {
        Vector3.new(-1076.3, -1.3999, 1676.19),
        Vector3.new(-1191.8, -1.3999, 3597.30),
        Vector3.new(412.700, -1.3999, 4134.39)
    },

    ["Ghost Shark Hunt"] = {
        Vector3.new(489.558, -1.3500, 25.4060),
        Vector3.new(-1358.2, -1.3500, 4100.55),
        Vector3.new(627.859, -1.3500, 3798.08)
    },

    ["Treasure Hunt"] = nil -- Tidak punya koordinat
}

-- =======================
--   TELEPORT FUNCTION
-- =======================
function EventTeleport.TeleportTo(eventName)
    local coords = EventTeleport.Events[eventName]

    if not coords then
        warn("Event tidak punya koordinat →", eventName)
        return false
    end

    -- Ambil titik pertama (atau bisa dirandom)
    local target = coords[1]

    if target then
        LocalPlayer.Character:PivotTo(CFrame.new(target))
        return true
    end

    return false
end

return EventTeleport
