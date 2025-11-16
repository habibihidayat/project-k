-- NoFishingAnimation.lua
-- Membuat karakter tetap dalam posisi memancing

local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.Connection = nil
NoFishingAnimation.AnimationConnection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Fungsi untuk freeze karakter dalam posisi memancing
local function freezeFishingPose()
    local character = localPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    
    -- Stop semua animasi fishing yang sedang berjalan
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        if track.Animation then
            local animId = track.Animation.AnimationId:lower()
            -- Hentikan animasi cast, reel, dll tapi biarkan idle fishing pose
            if animId:match("cast") or animId:match("reel") or animId:match("pull") then
                track:Stop()
            end
        end
    end
    
    -- Monitor dan stop animasi baru secara real-time
    if not NoFishingAnimation.AnimationConnection then
        NoFishingAnimation.AnimationConnection = animator.AnimationPlayed:Connect(function(track)
            if NoFishingAnimation.Enabled and track.Animation then
                local animId = track.Animation.AnimationId:lower()
                -- Stop animasi yang mengganggu posisi idle
                if animId:match("cast") or animId:match("reel") or animId:match("pull") then
                    track:Stop()
                end
            end
        end)
    end
    
    -- Freeze pose menggunakan RunService
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
    end
    
    NoFishingAnimation.Connection = RunService.RenderStepped:Connect(function()
        if not NoFishingAnimation.Enabled then return end
        
        local char = localPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        local anim = hum:FindFirstChildOfClass("Animator")
        if not anim then return end
        
        -- Cek dan stop animasi yang tidak diinginkan setiap frame
        for _, track in pairs(anim:GetPlayingAnimationTracks()) do
            if track.Animation then
                local animId = track.Animation.AnimationId:lower()
                if animId:match("cast") or animId:match("reel") or animId:match("pull") then
                    track:Stop()
                    track:AdjustSpeed(0) -- Set speed ke 0 untuk freeze
                end
            end
        end
        
        -- Set Humanoid state untuk mencegah animasi default
        if hum:GetState() ~= Enum.HumanoidStateType.Physics then
            -- Biarkan karakter dalam state idle/standing
        end
    end)
end

-- Fungsi untuk restore animasi normal
local function restoreAnimations()
    -- Disconnect semua connection
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
        NoFishingAnimation.Connection = nil
    end
    
    if NoFishingAnimation.AnimationConnection then
        NoFishingAnimation.AnimationConnection:Disconnect()
        NoFishingAnimation.AnimationConnection = nil
    end
    
    -- Reset animator
    local character = localPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                -- Resume semua animasi yang di-pause
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    if track.Animation then
                        track:AdjustSpeed(1) -- Kembalikan speed normal
                    end
                end
            end
        end
    end
end

-- Fungsi Start
function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    freezeFishingPose()
    print("✅ NoFishingAnimation diaktifkan - Karakter freeze dalam posisi memancing")
end

-- Fungsi Stop
function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah tidak aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = false
    restoreAnimations()
    print("🔴 NoFishingAnimation dinonaktifkan - Animasi memancing kembali normal")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function(character)
    task.wait(1) -- Tunggu character sepenuhnya loaded
    if NoFishingAnimation.Enabled then
        -- Reset connections
        if NoFishingAnimation.Connection then
            NoFishingAnimation.Connection:Disconnect()
            NoFishingAnimation.Connection = nil
        end
        if NoFishingAnimation.AnimationConnection then
            NoFishingAnimation.AnimationConnection:Disconnect()
            NoFishingAnimation.AnimationConnection = nil
        end
        -- Re-apply freeze
        task.wait(0.5)
        freezeFishingPose()
    end
end)

-- Cleanup saat script dihapus
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == localPlayer then
        NoFishingAnimation.Stop()
    end
end)

return NoFishingAnimation
