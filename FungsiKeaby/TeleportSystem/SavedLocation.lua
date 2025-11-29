-- SaveLocation.lua
local SaveLocation = {}
local Notification = require(script.Parent.NotificationModule)

local savedPos = nil

-- Save posisi pemain
function SaveLocation.Save()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    savedPos = hrp.Position
    Notification.Send("Saved Location", "Lokasi berhasil disimpan!", 4)
end

-- Teleport ke posisi tersimpan
function SaveLocation.Teleport()
    if not savedPos then
        Notification.Send("Error", "Tidak ada lokasi tersimpan!", 4)
        return false
    end
    
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    hrp.CFrame = CFrame.new(savedPos)
    Notification.Send("Teleported", "Berhasil teleport ke lokasi tersimpan!", 4)

    return true
end

-- Reset lokasi tersimpan
function SaveLocation.Reset()
    savedPos = nil
    Notification.Send("Location Reset", "Lokasi tersimpan berhasil dihapus!", 4)
end

return SaveLocation
