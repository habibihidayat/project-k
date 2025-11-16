-- NoFishingAnimation.lua
-- Disable SEMUA animasi, karakter stuck di pose memancing tapi tetap bisa gerak

local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.OriginalAnimator = nil
NoFishingAnimation.Connection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Fungsi untuk disable semua animasi
local function disableAllAnimations()
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            -- Simpan original animator
            NoFishingAnimation.OriginalAnimator = animator
            
            -- Stop dan destroy semua animation tracks
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:Stop(0)
                track:Destroy()
            end
            
            -- Destroy animator (ini yang bikin semua animasi mati)
            animator:Destroy()
            
            print("🔴 Animator destroyed - Semua animasi disabled")
        end
    end)
end

-- Fungsi untuk set pose memancing manual (C0 manipulation)
local function setFishingPose()
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        -- Cari rod/tool yang sedang equipped
        local tool = character:FindFirstChildOfClass("Tool")
        
        -- Set pose lengan untuk pegang rod (pose memancing idle)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("Motor6D") then
                local name = part.Name
                
                -- RIGHT ARM (pegang rod)
                if name == "Right Shoulder" or name == "RightShoulder" then
                    part.C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))
                elseif name == "Right Elbow" or name == "RightElbow" then
                    part.C0 = CFrame.new(0, -0.5, 0) * CFrame.Angles(math.rad(-45), math.rad(0), math.rad(0))
                end
                
                -- LEFT ARM (support rod)
                if name == "Left Shoulder" or name == "LeftShoulder" then
                    part.C0 = CFrame.new(-1, 0.5, 0) * CFrame.Angles(math.rad(80), math.rad(0), math.rad(0))
                elseif name == "Left Elbow" or name == "LeftElbow" then
                    part.C0 = CFrame.new(0, -0.5, 0) * CFrame.Angles(math.rad(-50), math.rad(0), math.rad(0))
                end
            end
        end
    end)
end

-- Fungsi untuk maintain pose (prevent animasi apapun)
local function maintainPose()
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
            
            -- Cek jika animator ada lagi (kadang game respawn animator)
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                -- Stop semua tracks
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop(0)
                end
                -- Destroy lagi
                animator:Destroy()
            end
            
            -- Re-apply fishing pose setiap frame
            setFishingPose()
        end)
    end)
end

-- Fungsi untuk restore animator
local function restoreAnimator()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
        NoFishingAnimation.Connection = nil
    end
    
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        -- Buat animator baru jika belum ada
        if not humanoid:FindFirstChildOfClass("Animator") then
            local newAnimator = Instance.new("Animator")
            newAnimator.Parent = humanoid
            
            print("✅ Animator restored")
        end
        
        -- Reset pose ke default
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("Motor6D") then
                local name = part.Name
                
                -- Reset RIGHT ARM
                if name == "Right Shoulder" or name == "RightShoulder" then
                    part.C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(0, math.rad(90), 0)
                elseif name == "Right Elbow" or name == "RightElbow" then
                    part.C0 = CFrame.new(0, -0.5, 0)
                end
                
                -- Reset LEFT ARM
                if name == "Left Shoulder" or name == "LeftShoulder" then
                    part.C0 = CFrame.new(-1, 0.5, 0) * CFrame.Angles(0, math.rad(-90), 0)
                elseif name == "Left Elbow" or name == "LeftElbow" then
                    part.C0 = CFrame.new(0, -0.5, 0)
                end
            end
        end
    end)
end

-- Fungsi Start
function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    
    -- 1. Destroy animator (matikan semua animasi)
    disableAllAnimations()
    
    -- 2. Set pose memancing
    task.wait(0.1)
    setFishingPose()
    
    -- 3. Loop maintain pose
    maintainPose()
    
    print("✅ NoFishingAnimation AKTIF")
    print("🎣 Karakter stuck di pose memancing")
    print("🚫 Semua animasi (walk, run, fishing) DISABLED")
    print("✅ Tetap bisa gerak (tapi tanpa animasi)")
end

-- Fungsi Stop
function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah tidak aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = false
    restoreAnimator()
    
    print("🔴 NoFishingAnimation NONAKTIF - Animasi kembali normal")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function(character)
    -- Wait for character to load
    task.wait(1)
    
    if NoFishingAnimation.Enabled then
        print("🔄 Character respawned, re-applying NoFishingAnimation...")
        
        -- Reset state
        if NoFishingAnimation.Connection then
            NoFishingAnimation.Connection:Disconnect()
            NoFishingAnimation.Connection = nil
        end
        
        -- Re-apply
        task.wait(0.5)
        disableAllAnimations()
        task.wait(0.1)
        setFishingPose()
        maintainPose()
        
        print("✅ NoFishingAnimation re-applied setelah respawn")
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
