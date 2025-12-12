-- FISH IT - WALK ON WATER MODULE (SIMPLE & EFFECTIVE)
-- Just toggle ON and walk on water like normal ground

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

-- Optimized settings for Fish It
local PLATFORM_SIZE = 14
local PLATFORM_OFFSET = 3.0
local WATER_LEVEL_MIN = 45
local WATER_LEVEL_MAX = 65

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

local function IsOverWater()
    if not HumanoidRootPart then return false end
    
    local pos = HumanoidRootPart.Position
    
    -- Check if near water level (Fish It water is around Y = 51-52)
    if pos.Y < WATER_LEVEL_MAX and pos.Y > WATER_LEVEL_MIN then
        -- Raycast down to check for solid ground
        local rayOrigin = pos
        local rayDirection = Vector3.new(0, -50, 0)
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {Character, WalkOnWater.Platform}
        
        local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        -- No ground = over water
        if not rayResult then
            return true
        end
        
        -- Ground too far = over water
        if rayResult.Distance > 5 then
            return true
        end
        
        -- Hit water material
        if rayResult.Instance and rayResult.Material == Enum.Material.Water then
            return true
        end
    end
    
    -- Check swimming state
    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        return true
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
        -- Position platform under player's feet
        pcall(function()
            WalkOnWater.Platform.CFrame = CFrame.new(
                hrpPos.X,
                hrpPos.Y - PLATFORM_OFFSET,
                hrpPos.Z
            )
            WalkOnWater.Platform.CanCollide = true
        end)
        
        -- Force running state (no swimming)
        if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
            pcall(function()
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        
        -- Maintain normal walkspeed
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
    
    -- Fix swimming state immediately
    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        pcall(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    
    -- Start update loop (runs every frame)
    WalkOnWater.Connection = RunService.Heartbeat:Connect(function()
        pcall(UpdatePlatform)
    end)
end

function WalkOnWater.Stop()
    WalkOnWater.Enabled = false
    
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
    while task.wait(3) do
        if WalkOnWater.Enabled then
            if not WalkOnWater.Platform or not WalkOnWater.Platform.Parent then
                pcall(CreatePlatform)
            end
        end
    end
end)

-- Anti-swim failsafe (extra protection)
task.spawn(function()
    while task.wait(0.05) do
        if WalkOnWater.Enabled and IsOverWater() then
            if Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                pcall(function()
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end
    end
end)

return WalkOnWater
