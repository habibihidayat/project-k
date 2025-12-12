-- FISH IT - WALK ON WATER MODULE
-- Module for walking on water surface

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- =====================================================
-- MODULE
-- =====================================================
local WalkOnWater = {}
WalkOnWater.Enabled = false
WalkOnWater.Connection = nil
WalkOnWater.Platform = nil
WalkOnWater.WaterLevel = nil

-- Configuration
local Config = {
    PlatformSize = Vector3.new(15, 0.5, 15),
    PlatformOffset = -3.5, -- Platform offset from character Y position
    Transparency = 1, -- Fully invisible
    UpdateRate = 0.03, -- Update every frame for smooth movement
}

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

local function FindWaterLevel()
    -- Try to find Terrain water or specific water parts
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    
    if terrain then
        -- Check common water levels in Roblox games
        -- Fish It typically has water at around Y = 0 to -10
        local possibleLevels = {-1, 0, -5, -10, -2, -3}
        
        for _, level in ipairs(possibleLevels) do
            local region = Region3.new(
                Vector3.new(-100, level - 5, -100),
                Vector3.new(100, level + 5, 100)
            )
            region = region:ExpandToGrid(4)
            
            local materials, sizes = terrain:ReadVoxels(region, 4)
            local size = materials.Size
            
            for x = 1, size.X do
                for y = 1, size.Y do
                    for z = 1, size.Z do
                        if materials[x][y][z] == Enum.Material.Water then
                            return level
                        end
                    end
                end
            end
        end
    end
    
    -- Fallback: Check for water parts
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name:lower():find("water") then
            return obj.Position.Y + (obj.Size.Y / 2)
        end
    end
    
    -- Default water level for Fish It
    return 0
end

local function IsOverWater()
    if not HumanoidRootPart then return false end
    
    local pos = HumanoidRootPart.Position
    
    -- Check if player is above water level
    if WalkOnWater.WaterLevel then
        return pos.Y <= (WalkOnWater.WaterLevel + 10) and pos.Y >= (WalkOnWater.WaterLevel - 5)
    end
    
    return false
end

local function CreatePlatform()
    if WalkOnWater.Platform then
        WalkOnWater.Platform:Destroy()
    end
    
    local platform = Instance.new("Part")
    platform.Name = "WaterPlatform"
    platform.Size = Config.PlatformSize
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = Config.Transparency
    platform.Material = Enum.Material.SmoothPlastic
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.CastShadow = false
    
    -- Make it invisible and non-interactive for others
    platform.Parent = Workspace
    
    WalkOnWater.Platform = platform
    
    return platform
end

local function UpdatePlatform()
    if not WalkOnWater.Enabled then return end
    if not HumanoidRootPart or not HumanoidRootPart.Parent then return end
    if not WalkOnWater.Platform then return end
    
    local pos = HumanoidRootPart.Position
    
    if IsOverWater() then
        -- Position platform below character
        WalkOnWater.Platform.Position = Vector3.new(
            pos.X,
            pos.Y + Config.PlatformOffset,
            pos.Z
        )
        WalkOnWater.Platform.CanCollide = true
    else
        -- Move platform far away when not over water
        WalkOnWater.Platform.CanCollide = false
        WalkOnWater.Platform.Position = Vector3.new(0, -1000, 0)
    end
end

-- =====================================================
-- MODULE FUNCTIONS
-- =====================================================

function WalkOnWater.Start()
    if WalkOnWater.Enabled then return end
    
    WalkOnWater.Enabled = true
    
    -- Find water level
    WalkOnWater.WaterLevel = FindWaterLevel()
    
    -- Create platform
    CreatePlatform()
    
    -- Start update loop
    WalkOnWater.Connection = RunService.Heartbeat:Connect(UpdatePlatform)
end

function WalkOnWater.Stop()
    WalkOnWater.Enabled = false
    
    -- Disconnect update loop
    if WalkOnWater.Connection then
        WalkOnWater.Connection:Disconnect()
        WalkOnWater.Connection = nil
    end
    
    -- Remove platform
    if WalkOnWater.Platform then
        WalkOnWater.Platform:Destroy()
        WalkOnWater.Platform = nil
    end
end

function WalkOnWater.SetPlatformSize(size)
    Config.PlatformSize = Vector3.new(size, 0.5, size)
    if WalkOnWater.Platform then
        WalkOnWater.Platform.Size = Config.PlatformSize
    end
end

function WalkOnWater.SetPlatformOffset(offset)
    Config.PlatformOffset = offset
end

function WalkOnWater.SetTransparency(transparency)
    Config.Transparency = transparency
    if WalkOnWater.Platform then
        WalkOnWater.Platform.Transparency = transparency
    end
end

-- =====================================================
-- CHARACTER RESPAWN HANDLING
-- =====================================================
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    if WalkOnWater.Enabled then
        task.wait(1)
        -- Recreate platform
        if WalkOnWater.Platform then
            WalkOnWater.Platform:Destroy()
        end
        CreatePlatform()
    end
end)

return WalkOnWater
