-- FungsiKeaby/Utama/NoFishingAnimation.lua
local NoFishingAnimation = {}

-- State untuk mengaktifkan / menonaktifkan
NoFishingAnimation.Enabled = false

-- Fungsi utama untuk menonaktifkan animasi
function NoFishingAnimation:HookAnimations()
    if not self.Enabled then return end

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local localPlayer = Players.LocalPlayer

    -- Contoh: mengganti animasi fishing dengan nil
    localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = localCharacter:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Hook animasi
        humanoid.Animator.AnimationPlayed:Connect(function(animTrack)
            if animTrack.Name:lower():find("fishing") then
                animTrack:Stop()
            end
        end)
    end
end

return NoFishingAnimation
