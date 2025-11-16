-- NoFishingAnimation.lua
-- Freeze karakter di pose "rod sejajar paha" (after reel pose)

local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.Connection = nil
NoFishingAnimation.SavedPose = {}
NoFishingAnimation.OriginalC0 = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Fungsi untuk capture pose saat menarik ikan
local function captureFishingPose()
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        -- Simpan semua motor6D positions (pose tulang)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("Motor6D") then
                -- Simpan original C0 untuk restore nanti
                if not NoFishingAnimation.OriginalC0[part.Name] then
                    NoFishingAnimation.OriginalC0[part.Name] = part.C0
                end
                
                -- Simpan pose saat ini
                NoFishingAnimation.SavedPose[part.Name] = part.C0
            end
        end
        
        print("📸 Pose captured:", #NoFishingAnimation.SavedPose, "joints")
    end)
end

-- Fungsi untuk freeze pose
local function freezePose()
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
            
            -- Stop semua animasi fishing
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") or name:find("pull") then
                    track:Stop(0)
                end
            end
            
            -- Apply saved pose ke semua joints
            if next(NoFishingAnimation.SavedPose) then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("Motor6D") and NoFishingAnimation.SavedPose[part.Name] then
                        -- Force pose dari saved data
                        part.C0 = NoFishingAnimation.SavedPose[part.Name]
                    end
                end
            end
        end)
    end)
end

-- Fungsi untuk restore pose original
local function restorePose()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
        NoFishingAnimation.Connection = nil
    end
    
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        -- Restore original C0
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("Motor6D") and NoFishingAnimation.OriginalC0[part.Name] then
                part.C0 = NoFishingAnimation.OriginalC0[part.Name]
            end
        end
    end)
    
    -- Clear saved data
    NoFishingAnimation.SavedPose = {}
end

-- Fungsi Start (dengan delay untuk capture pose reel)
function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    
    print("⏳ Menunggu 3 detik...")
    print("🎣 Silakan TARIK IKAN (reel) dalam 3 detik!")
    print("📸 Pose akan di-capture saat rod sejajar paha")
    
    -- Tunggu 3 detik untuk user melakukan reel
    task.wait(3)
    
    -- Capture pose saat ini (harusnya sedang reel)
    captureFishingPose()
    
    -- Mulai freeze pose
    freezePose()
    
    print("✅ NoFishingAnimation diaktifkan - Pose frozen!")
    print("💡 Karakter tetap bisa jalan tapi pose stuck di 'rod sejajar paha'")
end

-- Fungsi Start Instant (capture pose langsung)
function NoFishingAnimation.StartInstant()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    
    -- Capture pose langsung tanpa delay
    captureFishingPose()
    freezePose()
    
    print("✅ NoFishingAnimation diaktifkan (instant) - Pose frozen!")
end

-- Fungsi Stop
function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah tidak aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = false
    restorePose()
    
    print("🔴 NoFishingAnimation dinonaktifkan - Pose kembali normal")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function(character)
    if NoFishingAnimation.Enabled then
        NoFishingAnimation.Enabled = false
        
        -- Clear saved data
        NoFishingAnimation.SavedPose = {}
        NoFishingAnimation.OriginalC0 = {}
        
        if NoFishingAnimation.Connection then
            NoFishingAnimation.Connection:Disconnect()
            NoFishingAnimation.Connection = nil
        end
        
        print("🔄 Character respawned - NoFishingAnimation direset")
        print("💡 Aktifkan kembali jika ingin freeze pose lagi")
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
