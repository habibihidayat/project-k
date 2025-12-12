-- ULTRA STABLE WALK ON WATER (ALIGNPOSITION V2 – NO ERROR)
-- Module Version - No Chat Commands - Fixed Respawn Issue
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local WalkOnWater = {}
WalkOnWater.Enabled = false
WalkOnWater.Platform = nil
WalkOnWater.AlignPos = nil
WalkOnWater.Connection = nil

local PLATFORM_SIZE = 14
local OFFSET = 3 -- tinggi aman & anti jitter

----------------------------------------------------------
-- GET CURRENT CHARACTER REFERENCES
----------------------------------------------------------

local function GetCharacterReferences()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return nil, nil, nil end
    
    return char, humanoid, hrp
end

----------------------------------------------------------
-- WATER HEIGHT DETECTION
----------------------------------------------------------

local function GetWaterHeight()
    local _, _, hrp = GetCharacterReferences()
    if not hrp then return nil end
    
    local origin = hrp.Position
    local direction = Vector3.new(0, -200, 0)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    
    local char = LocalPlayer.Character
    if char then
        params.FilterDescendantsInstances = {char}
    end

    local result = Workspace:Raycast(origin, direction, params)
    if not result then return nil end

    local mat = result.Material
    if mat == Enum.Material.Water or tostring(mat):lower():find("water") then
        return result.Position.Y
    end

    return nil
end

----------------------------------------------------------
-- PLATFORM CREATION
----------------------------------------------------------

local function CreatePlatform()
    if WalkOnWater.Platform then
        WalkOnWater.Platform:Destroy()
    end
    
    local p = Instance.new("Part")
    p.Size = Vector3.new(PLATFORM_SIZE, 1, PLATFORM_SIZE)
    p.Anchored = true
    p.CanCollide = true
    p.Transparency = 1
    p.CanQuery = false
    p.CanTouch = false
    p.Parent = Workspace
    WalkOnWater.Platform = p
end

----------------------------------------------------------
-- ALIGN POSITION SETUP (NO FORCE LIMIT)
----------------------------------------------------------

local function SetupAlign()
    local _, _, hrp = GetCharacterReferences()
    if not hrp then return false end
    
    if WalkOnWater.AlignPos then
        WalkOnWater.AlignPos:Destroy()
    end

    -- Buat attachment kalau belum ada
    local att = hrp:FindFirstChild("RootAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "RootAttachment"
        att.Parent = hrp
    end

    local ap = Instance.new("AlignPosition")
    ap.Attachment0 = att
    ap.MaxForce = 500000 -- cukup kuat menahan HRP
    ap.MaxVelocity = 500
    ap.Responsiveness = 200  -- smooth + cepat
    ap.RigidityEnabled = true
    ap.Parent = hrp

    WalkOnWater.AlignPos = ap
    return true
end

----------------------------------------------------------
-- CLEANUP
----------------------------------------------------------

local function Cleanup()
    if WalkOnWater.Connection then 
        WalkOnWater.Connection:Disconnect() 
        WalkOnWater.Connection = nil
    end
    
    if WalkOnWater.AlignPos then 
        WalkOnWater.AlignPos:Destroy() 
        WalkOnWater.AlignPos = nil
    end

    if WalkOnWater.Platform then
        WalkOnWater.Platform:Destroy()
        WalkOnWater.Platform = nil
    end
end

----------------------------------------------------------
-- START WALK ON WATER
----------------------------------------------------------

function WalkOnWater.Start()
    if WalkOnWater.Enabled then return end
    
    -- Pastikan character tersedia
    local char, humanoid, hrp = GetCharacterReferences()
    if not char or not humanoid or not hrp then
        warn("[WalkOnWater] Character not ready yet!")
        return
    end
    
    WalkOnWater.Enabled = true

    CreatePlatform()
    local setupSuccess = SetupAlign()
    
    if not setupSuccess then
        warn("[WalkOnWater] Failed to setup AlignPosition!")
        WalkOnWater.Enabled = false
        Cleanup()
        return
    end

    WalkOnWater.Connection = RunService.Heartbeat:Connect(function()
        if not WalkOnWater.Enabled then return end

        -- Dapatkan referensi terbaru setiap frame
        local _, _, currentHRP = GetCharacterReferences()
        if not currentHRP then
            WalkOnWater.Stop()
            return
        end

        local waterY = GetWaterHeight()
        if not waterY then
            if WalkOnWater.Platform then
                WalkOnWater.Platform.CanCollide = false
            end
            return
        end

        if WalkOnWater.Platform then
            WalkOnWater.Platform.CanCollide = true

            -- Platform mengikuti player
            WalkOnWater.Platform.CFrame = CFrame.new(
                currentHRP.Position.X,
                waterY,
                currentHRP.Position.Z
            )
        end

        -- Target posisi HRP (super smooth)
        if WalkOnWater.AlignPos and WalkOnWater.AlignPos.Parent then
            WalkOnWater.AlignPos.Position = Vector3.new(
                currentHRP.Position.X,
                waterY + OFFSET,
                currentHRP.Position.Z
            )
        end
    end)
end

----------------------------------------------------------
-- STOP WALK ON WATER
----------------------------------------------------------

function WalkOnWater.Stop()
    WalkOnWater.Enabled = false
    Cleanup()
end

----------------------------------------------------------
-- CHARACTER RESPAWN HANDLER
----------------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if WalkOnWater.Enabled then
        -- Tunggu karakter siap
        task.wait(0.5)
        
        -- Restart fitur dengan karakter baru
        Cleanup()
        WalkOnWater.Enabled = false
        WalkOnWater.Start()
    end
end)

----------------------------------------------------------
return WalkOnWater
