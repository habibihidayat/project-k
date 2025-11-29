-- ============================================
-- FREECAM MODULE - UNIVERSAL PC & MOBILE
-- ============================================
-- File: FreecamModule.lua

local FreecamModule = {}

-- Services
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Variables
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

local freecam = false
local camPos = Vector3.new()
local camRot = Vector3.new()
local speed = 50
local sensitivity = 0.3
local hiddenGuis = {}

-- Mobile detection
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- Mobile joystick variables
local mobileJoystickInput = Vector3.new(0, 0, 0)
local joystickConnections = {}
local dynamicThumbstick = nil

-- Touch input for camera rotation
local cameraTouch = nil
local cameraTouchStartPos = nil

-- Connections
local renderConnection = nil
local inputChangedConnection = nil
local inputEndedConnection = nil
local inputBeganConnection = nil

-- Character references
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
end)

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

local function LockCharacter(state)
    if not Humanoid then return end
    
    if state then
        Humanoid.WalkSpeed = 0
        Humanoid.JumpPower = 0
        Humanoid.AutoRotate = false
        if Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.Anchored = true
        end
    else
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
        Humanoid.AutoRotate = true
        if Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.Anchored = false
        end
    end
end

local function HideAllGuis()
    hiddenGuis = {}
    
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            -- JANGAN sembunyikan GUI utama yang sudah diset
            if mainGuiName and gui.Name == mainGuiName then
                continue
            end
            
            -- JANGAN sembunyikan GUI dengan nama umum (fallback)
            local guiName = gui.Name:lower()
            if guiName:find("main") or guiName:find("hub") or guiName:find("menu") or guiName:find("ui") then
                continue
            end
            
            table.insert(hiddenGuis, gui)
            gui.Enabled = false
        end
    end
end

local function ShowAllGuis()
    for _, gui in pairs(hiddenGuis) do
        if gui and gui:IsA("ScreenGui") then
            gui.Enabled = true
        end
    end
    
    hiddenGuis = {}
end

local function GetMovement()
    local move = Vector3.zero
    
    if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, 1) end
    if UIS:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, -1) end
    if UIS:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) then 
        move = move + Vector3.new(0, 1, 0) 
    end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) then 
        move = move + Vector3.new(0, -1, 0) 
    end
    
    -- Add mobile joystick input
    if isMobile then
        move = move + mobileJoystickInput
    end
    
    return move
end

-- ============================================
-- MOBILE JOYSTICK DETECTION
-- ============================================

local thumbstickModule = nil
local lastJoystickInput = Vector3.new(0, 0, 0)

local function DetectDynamicThumbstick()
    -- Cari DynamicThumbstick atau joystick yang sudah ada di game
    local Players_Service = game:GetService("Players")
    local PlayerGui_Check = Players_Service.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Search untuk DynamicThumbstick atau joystick GUI
    local function searchForThumbstick(parent)
        for _, child in pairs(parent:GetDescendants()) do
            local name = child.Name:lower()
            if name:find("thumbstick") or name:find("joystick") or name:find("analog") then
                if child:IsA("Frame") or child:IsA("ImageButton") or child:IsA("TextButton") then
                    return child
                end
            end
        end
        return nil
    end
    
    dynamicThumbstick = searchForThumbstick(PlayerGui_Check)
    
    if dynamicThumbstick then
        print("✅ DynamicThumbstick terdeteksi: " .. dynamicThumbstick.Name)
        
        -- Coba cari module atau script yang associate dengan thumbstick
        local parent = dynamicThumbstick.Parent
        while parent do
            if parent:FindFirstChild("LocalScript") then
                for _, script in pairs(parent:FindFirstChild("LocalScript"):GetChildren()) do
                    if script:IsA("LocalScript") then
                        print("📝 Found LocalScript di " .. parent.Name)
                    end
                end
            end
            parent = parent.Parent
        end
    else
        print("⚠️ DynamicThumbstick tidak ditemukan")
    end
end

-- ============================================
-- MAIN FREECAM FUNCTIONS
-- ============================================

function FreecamModule.Start()
    if freecam then return end
    
    freecam = true
    
    -- Save camera position and rotation
    local currentCF = Camera.CFrame
    camPos = currentCF.Position
    local x, y, z = currentCF:ToEulerAnglesYXZ()
    camRot = Vector3.new(x, y, z)
    
    -- Lock character and hide GUI
    LockCharacter(true)
    HideAllGuis()
    Camera.CameraType = Enum.CameraType.Scriptable
    
    task.wait()
    
    -- Setup input based on platform
    if not isMobile then
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        UIS.MouseIconEnabled = false
    else
        -- Deteksi thumbstick untuk mobile
        DetectDynamicThumbstick()
    end
    
    -- Mobile touch input handling untuk CAMERA ROTATION saja
    if isMobile then
        -- Handle touch began untuk camera
        inputBeganConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
            if not freecam then return end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                -- Jika di area thumbstick, abaikan
                if dynamicThumbstick then
                    local thumbstickSize = dynamicThumbstick.AbsoluteSize
                    local thumbstickPos = dynamicThumbstick.AbsolutePosition
                    local thumbstickArea = UDim2.new(thumbstickPos.X, thumbstickSize.X, thumbstickPos.Y, thumbstickSize.Y)
                    
                    if input.Position.X >= thumbstickPos.X and input.Position.X <= thumbstickPos.X + thumbstickSize.X and
                       input.Position.Y >= thumbstickPos.Y and input.Position.Y <= thumbstickPos.Y + thumbstickSize.Y then
                        return -- Joystick area, skip camera touch
                    end
                end
                
                -- Hanya gunakan untuk camera rotation di area lain
                cameraTouch = input
                cameraTouchStartPos = input.Position
            end
        end)
        
        -- Handle touch changed untuk camera rotation
        inputChangedConnection = UIS.InputChanged:Connect(function(input, gameProcessed)
            if not freecam or not cameraTouch then return end
            
            if input.UserInputType == Enum.UserInputType.Touch and input == cameraTouch then
                local delta = input.Position - cameraTouchStartPos
                
                if delta.Magnitude > 0 then
                    camRot = camRot + Vector3.new(
                        -delta.Y * sensitivity * 0.003,
                        -delta.X * sensitivity * 0.003,
                        0
                    )
                    
                    cameraTouchStartPos = input.Position
                end
            end
        end)
        
        -- Handle touch ended
        inputEndedConnection = UIS.InputEnded:Connect(function(input, gameProcessed)
            if not freecam then return end
            
            if input.UserInputType == Enum.UserInputType.Touch and input == cameraTouch then
                cameraTouch = nil
                cameraTouchStartPos = nil
            end
        end)
        
        -- Monitor joystick/thumbstick input
        local joystickCheckConnection = RunService.Heartbeat:Connect(function()
            if not freecam then 
                mobileJoystickInput = Vector3.new(0, 0, 0)
                return 
            end
            
            -- Coba berbagai cara deteksi joystick input
            local joystickInput = Vector3.new(0, 0, 0)
            
            if dynamicThumbstick then
                -- Method 1: Check untuk BindableEvent atau object dengan joystick data
                if dynamicThumbstick:FindFirstChild("Direction") then
                    local dir = dynamicThumbstick.Direction.Value
                    joystickInput = Vector3.new(dir.X, 0, dir.Y)
                end
                
                -- Method 2: Check untuk property bernama similar
                if dynamicThumbstick:FindFirstChild("JoystickData") then
                    local data = dynamicThumbstick.JoystickData.Value
                    if typeof(data) == "Vector2" then
                        joystickInput = Vector3.new(data.X, 0, data.Y)
                    end
                end
                
                -- Method 3: Check untuk ObjectValue atau ValueBase
                for _, obj in pairs(dynamicThumbstick:GetChildren()) do
                    if obj:IsA("Vector2Value") then
                        joystickInput = Vector3.new(obj.Value.X, 0, obj.Value.Y)
                        break
                    end
                end
            end
            
            mobileJoystickInput = joystickInput
        end)
        
        table.insert(joystickConnections, joystickCheckConnection)
    end
    
    -- Main render loop
    renderConnection = RunService.RenderStepped:Connect(function(dt)
        if not freecam then return end
        
        -- PC mouse input
        if not isMobile then
            local mouseDelta = UIS:GetMouseDelta()
            
            if mouseDelta.Magnitude > 0 then
                camRot = camRot + Vector3.new(
                    -mouseDelta.Y * sensitivity * 0.01,
                    -mouseDelta.X * sensitivity * 0.01,
                    0
                )
            end
        end
        
        -- Build rotation CFrame
        local rotationCF = CFrame.fromEulerAnglesYXZ(camRot.X, camRot.Y, camRot.Z)
        
        -- Handle movement
        local moveInput = GetMovement()
        if moveInput.Magnitude > 0 then
            moveInput = moveInput.Unit
            
            local moveCF = CFrame.new(camPos) * rotationCF
            local velocity = (moveCF.LookVector * moveInput.Z) +
                             (moveCF.RightVector * moveInput.X) +
                             (moveCF.UpVector * moveInput.Y)
            
            camPos = camPos + velocity * speed * dt
        end
        
        -- Apply to camera
        Camera.CFrame = CFrame.new(camPos) * rotationCF
    end)
    
    return true
end

function FreecamModule.Stop()
    if not freecam then return end
    
    freecam = false
    
    -- Disconnect all connections
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    
    if inputChangedConnection then
        inputChangedConnection:Disconnect()
        inputChangedConnection = nil
    end
    
    if inputEndedConnection then
        inputEndedConnection:Disconnect()
        inputEndedConnection = nil
    end
    
    if inputBeganConnection then
        inputBeganConnection:Disconnect()
        inputBeganConnection = nil
    end
    
    -- Disconnect joystick connections
    for _, conn in pairs(joystickConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    joystickConnections = {}
    
    -- Restore everything
    LockCharacter(false)
    ShowAllGuis()
    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = Humanoid
    
    UIS.MouseBehavior = Enum.MouseBehavior.Default
    UIS.MouseIconEnabled = true
    
    cameraTouch = nil
    cameraTouchStartPos = nil
    mobileJoystickInput = Vector3.new(0, 0, 0)
    
    return true
end

function FreecamModule.Toggle()
    if freecam then
        return FreecamModule.Stop()
    else
        return FreecamModule.Start()
    end
end

function FreecamModule.IsActive()
    return freecam
end

function FreecamModule.SetSpeed(newSpeed)
    speed = math.max(1, newSpeed)
end

function FreecamModule.SetSensitivity(newSensitivity)
    sensitivity = math.max(0.01, math.min(5, newSensitivity))
end

function FreecamModule.GetSpeed()
    return speed
end

function FreecamModule.GetSensitivity()
    return sensitivity
end

-- ============================================
-- MOBILE JOYSTICK INPUT OVERRIDE
-- ============================================
-- Gunakan fungsi ini jika Anda punya akses langsung ke joystick input
function FreecamModule.SetMobileJoystickInput(direction)
    if isMobile then
        mobileJoystickInput = Vector3.new(direction.X, direction.Y, direction.Z)
    end
end

-- Debug function untuk melihat struktur thumbstick
function FreecamModule.DebugThumbstickStructure()
    if not dynamicThumbstick then
        print("❌ Thumbstick tidak ditemukan")
        return
    end
    
    print("🔍 === THUMBSTICK STRUCTURE DEBUG ===")
    print("Name: " .. dynamicThumbstick.Name)
    print("Type: " .. dynamicThumbstick.ClassName)
    print("\n📋 Children:")
    
    for _, child in pairs(dynamicThumbstick:GetChildren()) do
        print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
        if child:IsA("ValueBase") then
            print("    Value: " .. tostring(child.Value))
        end
    end
    
    print("\n📋 Parent: " .. tostring(dynamicThumbstick.Parent.Name))
end

-- ============================================
-- SET MAIN GUI NAME (AGAR TIDAK IKUT HILANG)
-- ============================================
local mainGuiName = nil

function FreecamModule.SetMainGuiName(guiName)
    mainGuiName = guiName
    print("✅ Main GUI set to: " .. guiName)
end

function FreecamModule.GetMainGuiName()
    return mainGuiName
end

-- ============================================
-- F3 KEYBIND - AKTIF HANYA UNTUK PC
-- ============================================
local f3KeybindActive = false

function FreecamModule.EnableF3Keybind(enable)
    f3KeybindActive = enable
    if not isMobile then
        local status = f3KeybindActive and "ENABLED" or "DISABLED"
        print("⚙️ F3 Keybind: " .. status)
    end
end

function FreecamModule.IsF3KeybindActive()
    return f3KeybindActive
end

-- F3 keybind hanya untuk PC
if not isMobile then
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if f3KeybindActive and freecam and input.KeyCode == Enum.KeyCode.F3 then
            FreecamModule.Toggle()
            print("🎥 Freecam toggled via F3")
        end
    end)
end

-- ============================================
-- INFO
-- ============================================
print("╔════════════════════════════════════════╗")
print("║   FREECAM MODULE - PC & MOBILE READY   ║")
print("╚════════════════════════════════════════╝")
print("► Platform: " .. (isMobile and "📱 MOBILE" or "💻 PC"))
print("► F3 Keybind: " .. (isMobile and "N/A (Mobile)" or "READY (Toggle with GUI)"))
print("► Mobile Joystick: " .. (isMobile and "AUTO-DETECTED" or "N/A"))
print("► Ready to be controlled by GUI")
print("═════════════════════════════════════════")

return FreecamModule
