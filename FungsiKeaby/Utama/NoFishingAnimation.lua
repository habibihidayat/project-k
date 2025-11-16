-- NoFishingAnimation.lua
-- Membuat karakter tetap dalam posisi memancing (Fixed)

local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.Connection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Fungsi untuk disable animasi fishing
local function disableFishingAnim()
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            local name = track.Name:lower()
            if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") then
                track:Stop(0)
            end
        end
    end)
end

-- Fungsi untuk freeze pose secara real-time
local function startFreezing()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
    end
    
    -- Loop setiap frame untuk stop animasi fishing
    NoFishingAnimation.Connection = RunService.RenderStepped:Connect(function()
        if not NoFishingAnimation.Enabled then return end
        
        pcall(function()
            local character = localPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            -- Stop semua animasi fishing setiap frame
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") then
                    track:Stop(0)
                end
            end
        end)
    end)
end

-- Fungsi untuk stop freezing
local function stopFreezing()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
        NoFishingAnimation.Connection = nil
    end
end

-- Fungsi Start
function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = true
    
    -- Langsung disable animasi yang ada
    disableFishingAnim()
    
    -- Mulai loop untuk prevent animasi baru
    startFreezing()
    
    print("✅ NoFishingAnimation diaktifkan - Karakter freeze dalam posisi memancing")
end

-- Fungsi Stop
function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then
        warn("⚠️ NoFishingAnimation sudah tidak aktif!")
        return
    end
    
    NoFishingAnimation.Enabled = false
    stopFreezing()
    
    print("🔴 NoFishingAnimation dinonaktifkan - Animasi memancing kembali normal")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function(character)
    -- Tunggu character dan humanoid loaded
    task.wait(1)
    
    if NoFishingAnimation.Enabled then
        -- Reset connection jika ada
        stopFreezing()
        
        -- Re-apply freeze setelah respawn
        task.wait(0.5)
        disableFishingAnim()
        startFreezing()
        
        print("🔄 NoFishingAnimation re-applied setelah respawn")
    end
end)

-- Cleanup saat player leaving
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == localPlayer then
        if NoFishingAnimation.Enabled then
            NoFishingAnimation.Stop()
        end
    end
end)

return NoFishingAnimation
