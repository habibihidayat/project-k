local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local TeleportToPlayer = {}

function TeleportToPlayer.TeleportTo(playerName)
    local target = Players:FindFirstChild(playerName)
    local myChar = localPlayer.Character
    if not target or not target.Character then return end

    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")

    if targetHRP and myHRP then
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
    end
end

return TeleportToPlayer
