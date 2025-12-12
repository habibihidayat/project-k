-- FISH IT - WALK ON WATER MODULE (STABLE & SMOOTH)
-- Walk perfectly on water surface - no sinking!

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
WalkOnWater.WaterLevel = 51.5 -- Fish It water surface level

-- Optimized settings
local PLATFORM_SIZE = 16
local PLATFORM_HEIGHT = 1
local HEIGHT_ABOVE_WATER = 2.8 -- Player height above water (FIXED - no sinking!)

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

local function GetWaterLevel()
    -- Fish It water is at Y = 51.5
    -- You can adjust this if needed
    return WalkOnWater.WaterLevel
end

local function IsOverWater()
    if not HumanoidRootPart then return false end
    
    local pos = HumanoidRootPart.Position
    local waterLevel = GetWaterLevel()
    
    -- Check if player is near water level (within 20 studs above/below)
    if pos.Y > (waterLevel - 5) and pos.Y < (waterLevel + 20) then
        -- Raycast down to check for solid ground
        local rayOrigin = pos
        local rayDirection = Vector3.new(0, -100, 0)
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {Character, WalkOnWater.Platform}
        
        local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        -- No solid ground = over water
        if not rayResult then
            return true
        end
        
        -- Check if ground is below water level
        if rayResult.Position.Y < waterLevel then
            return true
        end
        
        -- Check distance to ground
        if rayResult.Distance > 10 then
            return true
        end
    end
    
    -- Always check swimming state
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
    platform.Size = Vector3.new(PLATFORM_SIZE, PLATFORM_HEIGHT, PLATFORM_SIZE)
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
        local waterLevel = GetWaterLevel()
        
        -- Lock platform at exact water level
        local platformY = waterLevel + (PLATFORM_HEIGHT / 2)
        
        pcall(function()
            -- Update platform position (locked to water surface)
            WalkOnWater.Platform.CFrame = CFrame.new(
                hrpPos.X,
                platformY,
                hrpPos.Z
            )
            WalkOnWater.Platform.CanCollide = true
        end)
        
        -- Lock player height above water surface
        local targetPlayerY = waterLevel + HEIGHT_ABOVE_WATER
        
        -- Smoothly adjust player position if sinking
        if hrpPos.Y < targetPlayerY then
            pcall(function()
                HumanoidRootPart.CFrame = CFrame.new(
                    hrpPos.X,
                    targetPlayerY,
                    hrpPos.Z
                )
                HumanoidRootPart.Velocity = Vector3.new(
                    HumanoidRootPart.Velocity.X,
                    0, -- No vertical movement
                    HumanoidRootPart.Velocity.Z
                )
            end)
        end
        
        -- Force running state (prevent swimming animation)
        if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
            pcall(function()
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        
        -- Prevent freefall state
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
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
        
        -- Disable gravity effect when on water
        pcall(function()
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(
                HumanoidRootPart.AssemblyLinearVelocity.X,
                0,
                HumanoidRootPart.AssemblyLinearVelocity.Z
            )
        end)
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
    
    -- Start ultra-fast update loop for smooth, stable walking
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
    while task.wait(2) do
        if WalkOnWater.Enabled then
            if not WalkOnWater.Platform or not WalkOnWater.Platform.Parent then
                pcall(CreatePlatform)
            end
        end
    end
end)

-- Anti-swim & anti-sink failsafe (HIGH PRIORITY)
task.spawn(function()
    while task.wait() do -- Runs every frame for maximum stability
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
            
            -- Lock height above water (prevent sinking)
            if HumanoidRootPart then
                local waterLevel = GetWaterLevel()
                local targetY = waterLevel + HEIGHT_ABOVE_WATER
                
                if HumanoidRootPart.Position.Y < targetY then
                    pcall(function()
                        local currentPos = HumanoidRootPart.Position
                        HumanoidRootPart.CFrame = CFrame.new(
                            currentPos.X,
                            targetY,
                            currentPos.Z
                        )
                    end)
                end
            end
        end
    end
end)

return WalkOnWater
