-- DisableSmallNotification.lua
local module = {}

local player = game.Players.LocalPlayer
local connection

function module.Start()
    if connection then return false end -- Sudah aktif
    connection = player.PlayerGui.ChildAdded:Connect(function(child)
        if child.Name == "Small Notification" then
            child:Destroy()
        end
    end)
    return true
end

function module.Stop()
    if connection then
        connection:Disconnect()
        connection = nil
        return true
    end
    return false -- Tidak aktif
end

return module
