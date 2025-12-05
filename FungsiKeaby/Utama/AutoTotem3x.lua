-- AUTO TOTEM 3X (ENHANCED VERSION - WITH FLY & NOCLIP)
local AutoTotem3X = {}
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Net = RS.Packages["_Index"]["sleitnick_net@0.2.0"].net
local RE_EquipToolFromHotbar = Net["RE/EquipToolFromHotbar"]

-- Settings
local HOTBAR_SLOT = 2
local CLICK_COUNT = 5
local CLICK_DELAY = 0.2
local TRIANGLE_RADIUS = 58
local CENTER_OFFSET = Vector3.new(0, 0, -7.25)
local FLY_SPEED = 50
local FLY_HEIGHT = 15

-- States
local isRunning = false
local flyConnection
local noClipConnection
local originalWalkSpeed = 16
local isFrozen = false

-- Flying Function
local function enableFly(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not root or not humanoid then return end
    
    -- Save original walkspeed
    originalWalkSpeed = humanoid.WalkSpeed
    
    -- Create BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = root
    
    -- Flying loop
    flyConnection = RunService.Heartbeat:Connect(function()
        if not isRunning or not root or not root.Parent then
            if flyConnection then flyConnection:Disconnect() end
            return
        end
        
        bv.Velocity = Vector3.new(0, 0, 0)
    end)
end

-- Disable Flying
local function disableFly(char)
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local bv = root:FindFirstChild("FlyVelocity")
        if bv then bv:Destroy() end
    end
    
    local humanoid = char and char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = originalWalkSpeed
    end
end

-- NoClip Function
local function enableNoClip(char)
    noClipConnection = RunService.Stepped:Connect(function()
        if not isRunning or not char or not char.Parent then
            if noClipConnection then noClipConnection:Disconnect() end
            return
        end
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

-- Disable NoClip
local function disableNoClip(char)
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end
    
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- Freeze Character
local function freezeCharacter(char, freeze)
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root then
        if freeze then
            isFrozen = true
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            root.Anchored = true
        else
            isFrozen = false
            humanoid.WalkSpeed = originalWalkSpeed
            humanoid.JumpPower = 50
            root.Anchored = false
        end
    end
end

-- Teleport Function with Fly
local function tp(pos)
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        -- Fly up first
        local flyPos = Vector3.new(pos.X, pos.Y + FLY_HEIGHT, pos.Z)
        root.CFrame = CFrame.new(flyPos)
        task.wait(0.3)
        
        -- Move to target position
        root.CFrame = CFrame.new(pos)
        task.wait(0.5)
    end
end

-- Equip Totem
local function equipTotem()
    pcall(function()
        RE_EquipToolFromHotbar:FireServer(HOTBAR_SLOT)
    end)
    task.wait(1.5)
end

-- Auto Click
local function autoClick()
    for i = 1, CLICK_COUNT do
        pcall(function()
            VirtualUser:Button1Down(Vector2.new(0, 0))
            task.wait(0.05)
            VirtualUser:Button1Up(Vector2.new(0, 0))
        end)
        task.wait(CLICK_DELAY)
        
        local char = LP.Character
        if char then
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    pcall(function()
                        tool:Activate()
                    end)
                end
            end
        end
        task.wait(CLICK_DELAY)
    end
end

-- Main Function
function AutoTotem3X.Start()
    if isRunning then
        return false, "Sudah berjalan!"
    end
    
    isRunning = true
    
    task.spawn(function()
        local char = LP.Character or LP.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")
        
        -- Save original walkspeed
        originalWalkSpeed = humanoid.WalkSpeed
        
        -- Enable Fly & NoClip
        enableFly(char)
        enableNoClip(char)
        
        local centerPos = root.Position
        local adjustedCenter = centerPos + CENTER_OFFSET
        
        -- Calculate 3 totem positions (Triangle pattern)
        local angles = {90, 210, 330}
        local totemPositions = {}
        
        for i, angleDeg in ipairs(angles) do
            local angleRad = math.rad(angleDeg)
            local offsetX = TRIANGLE_RADIUS * math.cos(angleRad)
            local offsetZ = TRIANGLE_RADIUS * math.sin(angleRad)
            table.insert(totemPositions, adjustedCenter + Vector3.new(offsetX, 0, offsetZ))
        end
        
        -- Place totems (3x)
        for i, pos in ipairs(totemPositions) do
            if not isRunning then break end
            
            -- Freeze character during placement
            freezeCharacter(char, true)
            
            tp(pos)
            equipTotem()
            autoClick()
            
            -- Unfreeze after placement
            freezeCharacter(char, false)
            
            task.wait(2)
        end
        
        -- Return to start position
        tp(centerPos)
        task.wait(1)
        
        -- Cleanup: Disable Fly & NoClip
        disableFly(char)
        disableNoClip(char)
        freezeCharacter(char, false)
        
        isRunning = false
    end)
    
    return true, "Mulai memasang 3 totem!"
end

function AutoTotem3X.Stop()
    isRunning = false
    
    local char = LP.Character
    if char then
        disableFly(char)
        disableNoClip(char)
        freezeCharacter(char, false)
    end
    
    return true, "Auto totem dihentikan!"
end

function AutoTotem3X.IsRunning()
    return isRunning
end

return AutoTotem3X
