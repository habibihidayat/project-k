-- FISH IT - WALK ON WATER MODULE (AUTO WATER LEVEL DETECTION)
-- Automatically finds correct water level and walks on it

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
WalkOnWater.DetectedWaterLevel = nil

-- Settings
local PLATFORM_SIZE = 14
local PLAYER_HEIGHT_OFFSET = 3.5 -- Offset from platform to player feet

-- =====================================================
-- WATER DETECTION
-- =====================================================

local function DetectWaterLevel()
    if not HumanoidRootPart then return nil end
    
    local pos = HumanoidRootPart.Position
    
    -- Raycast straight down to find water or ground
    local rayOrigin = pos + Vector3.new(0, 10, 0) -- Start above player
    local rayDirection = Vector3.new(0, -200, 0) -- Go far down
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Character, WalkOnWater.Platform}
    raycastParams.IgnoreWater = false
    
    local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if rayResult then
        -- If we hit something, use that Y position
        return rayResult.Position.Y
    end
    
    -- Fallback: use player's current Y position minus offset
    return pos.Y - 5
end

local function IsOverWater()
    if not HumanoidRootPart then return false end
    
    local pos = HumanoidRootPart.Position
    
    -- Check if swimming
    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        return true
    end
    
    -- Raycast down to check for ground
    local rayOrigin = pos
    local rayDirection = Vector3.new(0, -50, 0)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Character, WalkOnWater.Platform}
    
    local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    -- No ground nearby = over water
    if not rayResult then
        return true
    end
    
    -- Ground is far = over water
    if rayResult.Distance > 10 then
        return true
    end
    
    return false
end

-- =====================================================
-- PLATFORM MANAGEMENT
-- =====================================================

local function CreatePlatform()
    if WalkOnWater.Platform then
        pcall(function()
            WalkOnWater.Platform:Destroy()
        end)
    end
    
    local platform = Instance.new("Part")
    platform.Name = "WaterWalkPlatform"
    platform.Size = Vector3.new(PLATFORM_SIZE, 0.5, PLATFORM_SIZE)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1
    platform.Material = Enum.Material.SmoothPlastic
    platform.CastShadow = false
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Locked = true
    platform.Massless = true
    platform.CanTouch = false
    platform.CanQuery = false
    
    platform.Parent = Workspace
    WalkOnWater.Platform = platform
    
    return platform
end

local function UpdatePlatform()
    if not WalkOnWater.Enabled then return end
    if not HumanoidRootPart or not HumanoidRootPart.Parent then return end
    if not Character or not Character.Parent then return end
    if not Humanoid or not Humanoid.Parent then return end
    
    -- Recreate platform if missing
    if not WalkOnWater.Platform or not WalkOnWater.Platform.Parent then 
        pcall(CreatePlatform)
        return 
    end
    
    local hrpPos = HumanoidRootPart.Position
    local isOverWater = IsOverWater()
    
    if isOverWater then
        -- Detect water level if not already detected
        if not WalkOnWater.DetectedWaterLevel then
            WalkOnWater.DetectedWaterLevel = DetectWaterLevel()
        end
        
        -- Place platform directly under player's feet
        local platformY = hrpPos.Y - PLAYER_HEIGHT_OFFSET
        
        pcall(function()
            -- Update platform position to follow player
            WalkOnWater.Platform.CFrame = CFrame.new(
                hrpPos.X,
                platformY,
                hrpPos.Z
            )
            WalkOnWater.Platform.CanCollide = true
        end)
        
        -- Prevent swimming animation
        if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
            pcall(function()
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        
        -- Prevent freefall
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            pcall(function()
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        
        -- Maintain walkspeed
        if Humanoid.WalkSpeed < 16 then
            pcall(function()
                Humanoid.WalkSpeed = 16
            end)
        end
    else
        -- Hide platform when not over water
        pcall(function()
            WalkOnWater.Platform.CanCollide = false
            WalkOnWater.Platform.CFrame = CFrame.new(0, -10000, 0)
        end)
        
        -- Reset water level detection
        WalkOnWater.DetectedWaterLevel = nil
    end
end

-- =====================================================
-- MODULE FUNCTIONS
-- =====================================================

function WalkOnWater.Start()
    if WalkOnWater.Enabled then return end
    
    WalkOnWater.Enabled = true
    WalkOnWater.DetectedWaterLevel = nil
    
    -- Create platform
    pcall(CreatePlatform)
    
    -- Fix swimming state
    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        pcall(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    
    -- Start update loop
    WalkOnWater.Connection = RunService.Heartbeat:Connect(function()
        pcall(UpdatePlatform)
    end)
    
    print("[Walk on Water] Started - Platform follows your feet!")
end

function WalkOnWater.Stop()
    WalkOnWater.Enabled = false
    WalkOnWater.DetectedWaterLevel = nil
    
    -- Stop update loop
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
    
    print("[Walk on Water] Stopped")
end

-- =====================================================
-- AUTO HANDLERS
-- =====================================================

-- Handle character respawn
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    
    task.wait(0.5)
    
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    -- Restart if was enabled
    if WalkOnWater.Enabled then
        local wasEnabled = WalkOnWater.Enabled
        pcall(function() WalkOnWater.Stop() end)
        task.wait(1)
        if wasEnabled then
            pcall(function() WalkOnWater.Start() end)
        end
    end
end)

-- Platform health monitor
task.spawn(function()
    while task.wait(2) do
        if WalkOnWater.Enabled then
            if not WalkOnWater.Platform or not WalkOnWater.Platform.Parent then
                pcall(CreatePlatform)
            end
        end
    end
end)

-- Anti-swim failsafe
task.spawn(function()
    while task.wait() do
        if WalkOnWater.Enabled and IsOverWater() then
            -- Prevent swimming
            if Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                pcall(function()
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
            
            -- Prevent freefall
            if Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                pcall(function()
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end
    end
end)

return WalkOnWater
