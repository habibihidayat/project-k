-- NoFishingAnimation.lua
-- Force freeze pose "rod sejajar paha" (arms only, legs bebas)

local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.Connection = nil
NoFishingAnimation.AnimConnection = nil
NoFishingAnimation.SavedArmPose = {}
NoFishingAnimation.OriginalC0 = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Daftar joints yang perlu di-freeze (HANYA LENGAN DAN BAHU)
local FREEZE_JOINTS = {
    "Right Shoulder",
    "Left Shoulder", 
    "Right Elbow",
    "Left Elbow",
    "RightShoulder",
    "LeftShoulder",
    "RightUpperArm",
    "LeftUpperArm",
    "RightLowerArm",
    "LeftLowerArm",
    "RightHand",
    "LeftHand"
}

-- Fungsi untuk cek apakah joint perlu di-freeze
local function shouldFreezeJoint(jointName)
    for _, name in ipairs(FREEZE_JOINTS) do
        if jointName:find(name) then
            return true
        end
    end
    return false
end

-- Fungsi untuk capture pose lengan
local function captureArmPose()
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        local count = 0
        -- Simpan HANYA pose lengan
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("Motor6D") then
                if shouldFreezeJoint(part.Name) then
                    -- Simpan original untuk restore
                    if not NoFishingAnimation.OriginalC0[part.Name] then
                        NoFishingAnimation.OriginalC0[part.Name] = part.C0
                    end
                    
                    -- Simpan pose saat ini
                    NoFishingAnimation.SavedArmPose[part.Name] = part.C0
                    count = count + 1
                end
            end
        end
        
        print("📸 Arm pose captured:", count, "joints (arms only)")
    end)
end

-- Fungsi untuk freeze pose secara agresif
local function freezeArmPose()
    -- Disconnect jika sudah ada
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
    end
    if NoFishingAnimation.AnimConnection then
        NoFishingAnimation.AnimConnection:Disconnect()
    end
    
    -- Loop RenderStepped untuk force pose
    NoFishingAnimation.Connection = RunService.RenderStepped:Connect(function()
        if not NoFishingAnimation.Enabled then return end
        
        pcall(function()
            local character = localPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            -- STOP SEMUA ANIMASI (termasuk walk/run)
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                -- Stop fishing animations
                if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") or name:find("pull") then
                    track:Stop(0)
                end
                -- Stop walk/run animations yang bisa override arm pose
                if name:find("walk") or name:find("run") then
                    track:Stop(0)
                end
            end
            
            -- FORCE APPLY arm pose setiap frame
            if next(NoFishingAnimation.SavedArmPose) then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("Motor6D") then
                        if shouldFreezeJoint(part.Name) and NoFishingAnimation.SavedArmPose[part.Name] then
                            -- FORCE C0 ke saved pose (ini yang bikin frozen)
                            part.C0 = NoFishingAnimation.SavedArmPose[part.Name]
                        end
                    end
                end
            end
        end)
    end)
    
    -- Connection tambahan untuk block animasi baru
    NoFishingAnimation.AnimConnection = RunService.Heartbeat:Connect(function()
        if not NoFishingAnimation.Enabled then return end
        
        pcall(function()
            local character = localPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            -- Double check: stop fishing/walk animations lagi
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") or name:find("walk") or name:find("run") then
                    track:Stop(0)
                end
            end
        end)
    end)
end

-- Fungsi untuk restore pose
local function restoreArmPose()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
        NoFishingAnimation.Connection = nil
    end
    if NoFishingAnimation.AnimConnection then
        NoFishingAnimation.AnimConnection:Disconnect()
        NoFishingAnimation.AnimConnection = nil
    end
    
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        -- Restore original C0 untuk lengan
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("Motor6D") then
                if shouldFreezeJoint(part.Name) and NoFishingAnimation.OriginalC0[part.Name] then
                    part.C0 = NoFishingAnimation.OriginalC0[part.Name]
                end
            end
        end
    end)
    
    NoFishingAnimation.SavedArmPose = {}
end

-- Fungsi Start dengan delay
function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    
    print("⏳ Menunggu 3 detik untuk capture pose...")
    print("🎣 TARIK IKAN SEKARANG! (posisi rod sejajar paha)")
    
    task.wait(3)
    
    captureArmPose()
    freezeArmPose()
    
    print("✅ Arm pose FROZEN di 'rod sejajar paha'!")
    print("🚶 Kaki tetap bisa jalan normal")
end

-- Fungsi Start instant
function NoFishingAnimation.StartInstant()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    
    captureArmPose()
    freezeArmPose()
    
    print("✅ Arm pose FROZEN (instant capture)!")
end

-- Fungsi Stop
function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah tidak aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = false
    restoreArmPose()
    
    print("🔴 Arm pose restored - Animasi normal kembali")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function(character)
    if NoFishingAnimation.Enabled then
        NoFishingAnimation.Enabled = false
        
        NoFishingAnimation.SavedArmPose = {}
        NoFishingAnimation.OriginalC0 = {}
        
        if NoFishingAnimation.Connection then
            NoFishingAnimation.Connection:Disconnect()
            NoFishingAnimation.Connection = nil
        end
        if NoFishingAnimation.AnimConnection then
            NoFishingAnimation.AnimConnection:Disconnect()
            NoFishingAnimation.AnimConnection = nil
        end
        
        print("🔄 Respawned - NoFishingAnimation reset")
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
