-- NoFishingAnimation.lua
-- Auto capture pose saat menarik ikan dan freeze di pose itu

local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.Connection = nil
NoFishingAnimation.SavedPose = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Fungsi untuk capture SEMUA pose motor6D saat ini
local function capturePose()
    NoFishingAnimation.SavedPose = {}
    
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        -- Simpan SEMUA Motor6D C0 dan C1
        for _, descendant in pairs(character:GetDescendants()) do
            if descendant:IsA("Motor6D") then
                NoFishingAnimation.SavedPose[descendant] = {
                    C0 = descendant.C0,
                    C1 = descendant.C1
                }
            end
        end
        
        print("📸 Pose captured! Total joints:", #NoFishingAnimation.SavedPose)
    end)
end

-- Fungsi untuk freeze pose (apply saved pose setiap frame)
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
            
            -- STOP SEMUA ANIMASI
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
            
            -- APPLY SAVED POSE ke semua Motor6D
            for motor6D, poseData in pairs(NoFishingAnimation.SavedPose) do
                if motor6D and motor6D.Parent then
                    motor6D.C0 = poseData.C0
                    motor6D.C1 = poseData.C1
                end
            end
        end)
    end)
end

-- Fungsi untuk stop freeze
local function stopFreeze()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
        NoFishingAnimation.Connection = nil
    end
    
    NoFishingAnimation.SavedPose = {}
end

-- Fungsi Start dengan auto-detect pose reel
function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    print("🎣 Mencari pose 'menarik ikan'...")
    print("⏳ Tunggu sebentar...")
    
    local character = localPlayer.Character
    if not character then 
        warn("❌ Character tidak ditemukan!")
        return 
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then 
        warn("❌ Humanoid tidak ditemukan!")
        return 
    end
    
    -- Cari animasi "reel" atau "pull" yang sedang playing
    local reelTrack = nil
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        local name = track.Name:lower()
        if name:find("reel") or name:find("pull") or name:find("fish") then
            reelTrack = track
            print("✅ Ditemukan animasi:", track.Name)
            break
        end
    end
    
    if reelTrack then
        -- Animasi sedang playing, capture pose langsung
        print("📸 Capturing pose saat menarik ikan...")
        task.wait(0.1)
        capturePose()
        
        NoFishingAnimation.Enabled = true
        freezePose()
        
        print("✅ POSE FROZEN! Karakter stuck di pose menarik ikan")
    else
        -- Animasi tidak playing, tunggu user melakukan reel
        print("⚠️ Tidak sedang menarik ikan!")
        print("💡 CARA PAKAI:")
        print("   1. TARIK IKAN dulu (reel)")
        print("   2. Baru aktifkan toggle ini")
        print("   3. Atau gunakan method delay")
    end
end

-- Fungsi Start dengan delay (tunggu user reel)
function NoFishingAnimation.StartWithDelay()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    print("⏳ Tunggu 3 detik...")
    print("🎣 TARIK IKAN SEKARANG!")
    
    task.wait(3)
    
    print("📸 Capturing pose...")
    capturePose()
    
    NoFishingAnimation.Enabled = true
    freezePose()
    
    print("✅ POSE FROZEN!")
end

-- Fungsi Stop
function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah tidak aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = false
    stopFreeze()
    
    print("🔴 Pose unfrozen - Animasi normal kembali")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function(character)
    if NoFishingAnimation.Enabled then
        print("🔄 Character respawned - NoFishingAnimation direset")
        
        NoFishingAnimation.Enabled = false
        stopFreeze()
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
