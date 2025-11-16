-- NoFishingAnimation.lua
-- Menonaktifkan animasi memancing untuk performa lebih baik

local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.OriginalAnimations = {}

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Fungsi untuk mematikan animasi
local function disableAnimations()
    local character = localPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    
    -- Simpan animasi original sebelum dihapus
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.AnimationId then
            -- Cek jika ini animasi fishing (biasanya memiliki keyword tertentu)
            local animId = track.Animation.AnimationId:lower()
            if animId:match("fish") or animId:match("rod") or animId:match("cast") then
                table.insert(NoFishingAnimation.OriginalAnimations, {
                    track = track,
                    id = track.Animation.AnimationId,
                    priority = track.Priority
                })
                track:Stop()
            end
        end
    end
    
    -- Monitor animasi baru yang dimainkan
    animator.AnimationPlayed:Connect(function(animationTrack)
        if NoFishingAnimation.Enabled then
            local animId = animationTrack.Animation.AnimationId:lower()
            if animId:match("fish") or animId:match("rod") or animId:match("cast") then
                animationTrack:Stop()
            end
        end
    end)
end

-- Fungsi untuk mengaktifkan kembali animasi
local function enableAnimations()
    local character = localPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    
    -- Mainkan kembali animasi yang disimpan
    for _, data in pairs(NoFishingAnimation.OriginalAnimations) do
        if data.track and data.track.Animation then
            local newTrack = animator:LoadAnimation(data.track.Animation)
            if newTrack then
                newTrack.Priority = data.priority
                newTrack:Play()
            end
        end
    end
    
    -- Bersihkan data
    NoFishingAnimation.OriginalAnimations = {}
end

-- Fungsi Start
function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    disableAnimations()
    print("✅ NoFishingAnimation diaktifkan - Animasi memancing dinonaktifkan")
end

-- Fungsi Stop
function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah tidak aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = false
    enableAnimations()
    print("🔴 NoFishingAnimation dinonaktifkan - Animasi memancing kembali normal")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function()
    task.wait(1) -- Tunggu character sepenuhnya loaded
    if NoFishingAnimation.Enabled then
        disableAnimations()
    end
end)

return NoFishingAnimation
