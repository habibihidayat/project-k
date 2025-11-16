-- NoFishingAnimation.lua
-- Memaksa karakter SELALU dalam pose memancing

local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.Connection = nil
NoFishingAnimation.FishingIdleTrack = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Fungsi untuk mendapatkan animasi fishing idle
local function getFishingIdleAnimation()
    pcall(function()
        local character = localPlayer.Character
        if not character then return nil end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return nil end
        
        -- Cari animasi fishing idle yang sedang berjalan
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            local name = track.Name:lower()
            -- Cari animasi idle fishing (biasanya ada kata "idle" atau "hold")
            if (name:find("fish") or name:find("rod")) and (name:find("idle") or name:find("hold")) then
                return track
            end
        end
        
        -- Jika tidak ada yang playing, cari dari animator
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                if (name:find("fish") or name:find("rod")) and (name:find("idle") or name:find("hold")) then
                    return track
                end
            end
        end
    end)
    
    return nil
end

-- Fungsi untuk memaksa pose fishing
local function forceFishingPose()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
    end
    
    NoFishingAnimation.Connection = RunService.RenderStepped:Connect(function()
        if not NoFishingAnimation.Enabled then return end
        
        pcall(function()
            local character = localPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            -- Stop semua animasi yang bukan fishing idle
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                
                -- Stop animasi cast, reel, pull
                if name:find("cast") or name:find("reel") or name:find("pull") or name:find("throw") then
                    track:Stop(0)
                end
                
                -- Stop animasi walk, run, jump, dll (agar tetap pose fishing)
                if name:find("walk") or name:find("run") or name:find("jump") or name:find("fall") or name:find("climb") or name:find("swim") then
                    track:Stop(0)
                end
                
                -- Simpan track fishing idle
                if (name:find("fish") or name:find("rod")) and (name:find("idle") or name:find("hold")) then
                    NoFishingAnimation.FishingIdleTrack = track
                    track.Priority = Enum.AnimationPriority.Action4 -- Priority tertinggi
                    if not track.IsPlaying then
                        track:Play(0.1, 1, 1)
                    end
                    track.Looped = true
                end
            end
            
            -- Jika tidak ada fishing idle yang playing, coba play lagi
            if NoFishingAnimation.FishingIdleTrack then
                if not NoFishingAnimation.FishingIdleTrack.IsPlaying then
                    NoFishingAnimation.FishingIdleTrack:Play(0.1, 1, 1)
                end
            else
                -- Coba cari lagi fishing idle animation
                local idleTrack = getFishingIdleAnimation()
                if idleTrack then
                    NoFishingAnimation.FishingIdleTrack = idleTrack
                    idleTrack.Priority = Enum.AnimationPriority.Action4
                    idleTrack:Play(0.1, 1, 1)
                    idleTrack.Looped = true
                end
            end
            
            -- Set humanoid state untuk prevent animasi lain
            if humanoid.MoveDirection.Magnitude > 0 then
                humanoid.WalkSpeed = 0 -- Freeze movement agar tidak trigger walk animation
            end
        end)
    end)
end

-- Fungsi untuk stop forcing pose
local function stopForcingPose()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
        NoFishingAnimation.Connection = nil
    end
    
    -- Restore walkspeed
    pcall(function()
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16 -- Default walkspeed
            end
        end
    end)
    
    NoFishingAnimation.FishingIdleTrack = nil
end

-- Fungsi Start
function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    
    -- Cari dan simpan fishing idle animation
    task.spawn(function()
        task.wait(0.5)
        local idleTrack = getFishingIdleAnimation()
        if idleTrack then
            NoFishingAnimation.FishingIdleTrack = idleTrack
        end
    end)
    
    -- Mulai forcing pose
    forceFishingPose()
    
    print("✅ NoFishingAnimation diaktifkan - Karakter SELALU dalam pose memancing")
end

-- Fungsi Stop
function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah tidak aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = false
    stopForcingPose()
    
    print("🔴 NoFishingAnimation dinonaktifkan - Animasi kembali normal")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    
    if NoFishingAnimation.Enabled then
        -- Reset
        stopForcingPose()
        NoFishingAnimation.FishingIdleTrack = nil
        
        -- Re-apply
        task.wait(1)
        local idleTrack = getFishingIdleAnimation()
        if idleTrack then
            NoFishingAnimation.FishingIdleTrack = idleTrack
        end
        forceFishingPose()
        
        print("🔄 NoFishingAnimation re-applied setelah respawn")
    end
end)

-- Cleanup
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == localPlayer then
        if NoFishingAnimation.Enabled then
            NoFishingAnimation.Stop()
        end
    end
end)

return NoFishingAnimation
