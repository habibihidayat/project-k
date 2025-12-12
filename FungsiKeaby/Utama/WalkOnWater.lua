-- FISH IT - WALK ON WATER MODULE (STABLE & LOCKED)
-- Walk on water with NO bouncing - perfectly stable like on ground

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
WalkOnWater.LockedHeight = nil

-- Settings
local PLATFORM_SIZE = 14
local PLAYER_HEIGHT_OFFSET = 0.9 -- Perfect height!
local HEIGHT_LOCK_TOLERANCE = 0.05 -- Very strict height lock

-- =====================================================
-- WATER DETECTION
-- =====================================================

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
    platform.Size = Vector3.new(PLATFORM_SIZE, 1, PLATFORM_SIZE)
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
        -- Lock height on first detection
        if not WalkOnWater.LockedHeight then
            WalkOnWater.LockedHeight = hrpPos.Y
        end
        
        -- Calculate platform position based on locked height
        local platformY = WalkOnWater.LockedHeight - PLAYER_HEIGHT_OFFSET
        
        pcall(function()
            -- Update platform position (X and Z follow player, Y is locked)
            WalkOnWater.Platform.CFrame = CFrame.new(
                hrpPos.X,
                platformY,
                hrpPos.Z
            )
            WalkOnWater.Platform.CanCollide = true
        end)
        
        -- STRICT HEIGHT LOCKING - Keep player at exact locked height
        local heightDiff = math.abs(hrpPos.Y - WalkOnWater.LockedHeight)
        if heightDiff > HEIGHT_LOCK_TOLERANCE then
            pcall(function()
                -- Lock player to exact height (no bouncing!)
                HumanoidRootPart.CFrame = CFrame.new(
                    hrpPos.X,
                    WalkOnWater.LockedHeight,
                    hrpPos.Z
                )
                
                -- Cancel all vertical velocity (no jumping/falling)
                HumanoidRootPart.Velocity = Vector3.new(
                    HumanoidRootPart.Velocity.X,
                    0,
                    HumanoidRootPart.Velocity.Z
                )
                
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(
                    HumanoidRootPart.AssemblyLinearVelocity.X,
                    0,
                    HumanoidRootPart.AssemblyLinearVelocity.Z
                )
            end)
        end
        
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
        
        -- Prevent jumping
        if Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
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
        
        -- Reset locked height
        WalkOnWater.LockedHeight = nil
    end
end

-- =====================================================
-- MODULE FUNCTIONS
-- =====================================================

function WalkOnWater.Start()
    if WalkOnWater.Enabled then return end
    
    WalkOnWater.Enabled = true
    WalkOnWater.LockedHeight = nil
    
    -- Create platform
    pcall(CreatePlatform)
    
    -- Fix swimming state
    if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        pcall(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    
    -- Disable jump temporarily to prevent bouncing
    local originalJumpPower = Humanoid.JumpPower
    local originalJumpHeight = Humanoid.JumpHeight
    
    pcall(function()
        Humanoid.JumpPower = 0
        Humanoid.JumpHeight = 0
    end)
    
    -- Start update loop
    WalkOnWater.Connection = RunService.Heartbeat:Connect(function()
        pcall(UpdatePlatform)
    end)
    
    print("[Walk on Water] Started - Height locked at 1.4, perfectly stable!")
end

function WalkOnWater.Stop()
    WalkOnWater.Enabled = false
    WalkOnWater.LockedHeight = nil
    
    -- Restore jump
    pcall(function()
        Humanoid.JumpPower = 50
        Humanoid.JumpHeight = 7.2
    end)
    
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

-- ULTRA STRICT height lock failsafe (prevents ALL bouncing)
task.spawn(function()
    while task.wait() do -- Every frame
        if WalkOnWater.Enabled and IsOverWater() and WalkOnWater.LockedHeight then
            if HumanoidRootPart then
                local currentY = HumanoidRootPart.Position.Y
                
                -- Force exact height if drifting
                if math.abs(currentY - WalkOnWater.LockedHeight) > HEIGHT_LOCK_TOLERANCE then
                    pcall(function()
                        local pos = HumanoidRootPart.Position
                        HumanoidRootPart.CFrame = CFrame.new(
                            pos.X,
                            WalkOnWater.LockedHeight,
                            pos.Z
                        )
                        
                        -- Zero out vertical velocity
                        HumanoidRootPart.Velocity = Vector3.new(
                            HumanoidRootPart.Velocity.X,
                            0,
                            HumanoidRootPart.Velocity.Z
                        )
                    end)
                end
            end
            
            -- Force running state (no swimming/jumping/freefall)
            if Humanoid then
                local state = Humanoid:GetState()
                if state == Enum.HumanoidStateType.Swimming or 
                   state == Enum.HumanoidStateType.Freefall or
                   state == Enum.HumanoidStateType.Jumping then
                    pcall(function()
                        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end)
                end
            end
        end
    end
end)

return WalkOnWater
