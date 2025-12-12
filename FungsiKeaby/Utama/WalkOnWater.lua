-- FISH IT - WALK ON WATER MODULE (FIXED)
-- Module for walking on water surface

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- =====================================================
-- MODULE
-- =====================================================
local WalkOnWater = {}
WalkOnWater.Enabled = false
WalkOnWater.Connection = nil
WalkOnWater.Platform = nil

-- Configuration
local Config = {
    PlatformSize = Vector3.new(12, 1, 12),
    HeightAboveWater = 2, -- How high above water surface
    CheckDistance = 50, -- Ray distance to check for water
    UpdateRate = RunService.Heartbeat, -- Update every frame
}

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

local function IsInWater()
    if not Humanoid then return false end
    
    -- Method 1: Check Humanoid state
    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        return true
    end
    
    -- Method 2: Check if character Y position is low (near water)
    if HumanoidRootPart then
        local pos = HumanoidRootPart.Position
        -- Fish It water is typically at Y = 0 to -10
        if pos.Y < 20 then
            -- Raycast down to check for water
            local rayOrigin = pos
            local rayDirection = Vector3.new(0, -Config.CheckDistance, 0)
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {Character}
            
            local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            -- If no ground detected or ground is far, assume water
            if not rayResult or (rayResult.Distance > 10) then
                return true
            end
            
            -- Check if hit material is water
            if rayResult and rayResult.Material == Enum.Material.Water then
                return true
            end
        end
    end
    
    return false
end

local function CreatePlatform()
    if WalkOnWater.Platform then
        WalkOnWater.Platform:Destroy()
    end
    
    local platform = Instance.new("Part")
    platform.Name = "WaterWalkPlatform_" .. LocalPlayer.Name
    platform.Size = Config.PlatformSize
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1
    platform.Material = Enum.Material.ForceField
    platform.CastShadow = false
    
    -- Additional properties for stability
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Locked = true
    
    -- Prevent platform from being affected by physics
    platform.Massless = true
    
    platform.Parent = Workspace
    
    WalkOnWater.Platform = platform
    
    return platform
end

local function UpdatePlatform()
    if not WalkOnWater.Enabled then return end
    if not HumanoidRootPart or not HumanoidRootPart.Parent then return end
    if not Character or not Character.Parent then return end
    if not WalkOnWater.Platform or not WalkOnWater.Platform.Parent then 
        CreatePlatform()
        return 
    end
    
    local hrpPos = HumanoidRootPart.Position
    local isInOrNearWater = IsInWater()
    
    if isInOrNearWater then
        -- Calculate platform position
        local targetY = hrpPos.Y - 3 -- Platform below feet
        
        -- Adjust based on humanoid state
        if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
            targetY = hrpPos.Y - 2.5
        end
        
        -- Update platform position
        WalkOnWater.Platform.CFrame = CFrame.new(
            hrpPos.X,
            targetY,
            hrpPos.Z
        )
        
        WalkOnWater.Platform.CanCollide = true
        
        -- Force humanoid to not swim
        if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    else
        -- Disable collision when not in water
        WalkOnWater.Platform.CanCollide = false
        WalkOnWater.Platform.CFrame = CFrame.new(0, -1000, 0)
    end
end

-- =====================================================
-- MODULE FUNCTIONS
-- =====================================================

function WalkOnWater.Start()
    if WalkOnWater.Enabled then return end
    
    WalkOnWater.Enabled = true
    
    -- Create platform
    CreatePlatform()
    
    -- Disable swimming state immediately if in water
    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    
    -- Start update loop with highest priority
    WalkOnWater.Connection = Config.UpdateRate:Connect(UpdatePlatform)
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
    Config.PlatformSize = Vector3.new(size, 1, size)
    if WalkOnWater.Platform then
        WalkOnWater.Platform.Size = Config.PlatformSize
    end
end

function WalkOnWater.SetHeightAboveWater(height)
    Config.HeightAboveWater = height
end

function WalkOnWater.SetTransparency(transparency)
    if WalkOnWater.Platform then
        WalkOnWater.Platform.Transparency = transparency
    end
end

-- =====================================================
-- CHARACTER RESPAWN HANDLING
-- =====================================================
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    if WalkOnWater.Enabled then
        -- Stop and restart
        WalkOnWater.Stop()
        task.wait(1)
        WalkOnWater.Start()
    end
end)

-- Failsafe: Recreate platform if destroyed
task.spawn(function()
    while true do
        task.wait(1)
        if WalkOnWater.Enabled and (not WalkOnWater.Platform or not WalkOnWater.Platform.Parent) then
            CreatePlatform()
        end
    end
end)

return WalkOnWater
