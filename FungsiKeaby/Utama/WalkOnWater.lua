-- ULTRA STABLE WALK ON WATER (ALIGNPOSITION V2 – NO ERROR)
-- Module Version - No Chat Commands
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local WalkOnWater = {}
WalkOnWater.Enabled = false
WalkOnWater.Platform = nil
WalkOnWater.AlignPos = nil
WalkOnWater.Connection = nil

local PLATFORM_SIZE = 14
local OFFSET = 3 -- tinggi aman & anti jitter

----------------------------------------------------------
-- WATER HEIGHT DETECTION
----------------------------------------------------------

local function GetWaterHeight()
    local origin = HRP.Position
    local direction = Vector3.new(0, -200, 0)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {Character}

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
    if WalkOnWater.AlignPos then
        WalkOnWater.AlignPos:Destroy()
    end

    -- Buat attachment kalau belum ada
    local att = HRP:FindFirstChild("RootAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "RootAttachment"
        att.Parent = HRP
    end

    local ap = Instance.new("AlignPosition")
    ap.Attachment0 = att
    ap.MaxForce = 500000 -- cukup kuat menahan HRP
    ap.MaxVelocity = 500
    ap.Responsiveness = 200  -- smooth + cepat
    ap.RigidityEnabled = true
    ap.Parent = HRP

    WalkOnWater.AlignPos = ap
end

----------------------------------------------------------
-- START WALK ON WATER
----------------------------------------------------------

function WalkOnWater.Start()
    if WalkOnWater.Enabled then return end
    WalkOnWater.Enabled = true

    if not WalkOnWater.Platform then CreatePlatform() end
    SetupAlign()

    WalkOnWater.Connection = RunService.Heartbeat:Connect(function()
        if not WalkOnWater.Enabled then return end

        local waterY = GetWaterHeight()
        if not waterY then
            WalkOnWater.Platform.CanCollide = false
            return
        end

        WalkOnWater.Platform.CanCollide = true

        -- Platform mengikuti player
        WalkOnWater.Platform.CFrame = CFrame.new(
            HRP.Position.X,
            waterY,
            HRP.Position.Z
        )

        -- Target posisi HRP (super smooth)
        WalkOnWater.AlignPos.Position = Vector3.new(
            HRP.Position.X,
            waterY + OFFSET,
            HRP.Position.Z
        )
    end)
end

----------------------------------------------------------
-- STOP WALK ON WATER
----------------------------------------------------------

function WalkOnWater.Stop()
    WalkOnWater.Enabled = false

    if WalkOnWater.Connection then WalkOnWater.Connection:Disconnect() end
    if WalkOnWater.AlignPos then WalkOnWater.AlignPos:Destroy() end

    if WalkOnWater.Platform then
        WalkOnWater.Platform:Destroy()
        WalkOnWater.Platform = nil
    end
end

----------------------------------------------------------
return WalkOnWater
