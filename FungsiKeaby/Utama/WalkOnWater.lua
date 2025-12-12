-- FISH IT - WALK ON WATER MODULE (FINAL)
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
WalkOnWater.Settings = {
    PlatformSize = 12,
    PlatformOffset = 4.5,
    CheckDistance = 50,
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
            local rayDirection = Vector3.new(0, -WalkOnWater.Settings.CheckDistance, 0)
            
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
        pcall(function()
            WalkOnWater.Platform:Destroy()
        end)
    end
    
    local platform = Instance.new("Part")
    platform.Name = "WaterWalkPlatform_" .. LocalPlayer.Name
    platform.Size = Vector3.new(WalkOnWater.Settings.PlatformSize, 1, WalkOnWater.Settings.PlatformSize)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1
    platform.Material = Enum.Material.ForceField
    platform.CastShadow = false
    
    -- Additional properties for stability
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Locked = true
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
        pcall(CreatePlatform)
        return 
    end
    
    local hrpPos = HumanoidRootPart.Position
    local isInOrNearWater = IsInWater()
    
    if isInOrNearWater then
        -- Calculate platform position using configurable offset
        local targetY = hrpPos.Y - WalkOnWater.Settings.PlatformOffset
        
        -- Adjust based on humanoid state
        if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
            targetY = hrpPos.Y - (WalkOnWater.Settings.PlatformOffset - 0.3)
        end
        
        -- Update platform position
        pcall(function()
            WalkOnWater.Platform.CFrame = CFrame.new(
                hrpPos.X,
                targetY,
                hrpPos.Z
            )
            
            WalkOnWater.Platform.CanCollide = true
        end)
        
        -- Force humanoid to not swim
        if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
            pcall(function()
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    else
        -- Disable collision when not in water
        pcall(function()
            WalkOnWater.Platform.CanCollide = false
            WalkOnWater.Platform.CFrame = CFrame.new(0, -1000, 0)
        end)
    end
end

-- =====================================================
-- MODULE FUNCTIONS
-- =====================================================

function WalkOnWater.Start()
    if WalkOnWater.Enabled then return end
    
    WalkOnWater.Enabled = true
    
    -- Create platform
    pcall(CreatePlatform)
    
    -- Disable swimming state immediately if in water
    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        pcall(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    
    -- Start update loop with highest priority
    WalkOnWater.Connection = RunService.Heartbeat:Connect(UpdatePlatform)
end

function WalkOnWater.Stop()
    WalkOnWater.Enabled = false
    
    -- Disconnect update loop
    if WalkOnWater.Connection then
        pcall(function()
            WalkOnWater.Connection:Disconnect()
        end)
        WalkOnWater.Connection = nil
    end
    
    -- Remove platform
    if WalkOnWater.Platform then
        pcall(function()
            WalkOnWater.Platform:Destroy()
        end)
        WalkOnWater.Platform = nil
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
        pcall(function()
            WalkOnWater.Stop()
        end)
        task.wait(1)
        pcall(function()
            WalkOnWater.Start()
        end)
    end
end)

-- Failsafe: Recreate platform if destroyed
task.spawn(function()
    while true do
        task.wait(1)
        if WalkOnWater.Enabled and (not WalkOnWater.Platform or not WalkOnWater.Platform.Parent) then
            pcall(CreatePlatform)
        end
    end
end)

return WalkOnWater
