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
local touchInput = nil
local touchStartPos = nil

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
    
    return move
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
    end
    
    -- Mobile touch input handling - PERBAIKAN
    if isMobile then
        -- Handle touch began
        inputBeganConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
            if not freecam then return end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                touchInput = input
                touchStartPos = input.Position
            end
        end)
        
        -- Handle touch changed dengan deteksi yang lebih baik
        inputChangedConnection = UIS.InputChanged:Connect(function(input, gameProcessed)
            if not freecam or not touchInput then return end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - touchStartPos
                
                if delta.Magnitude > 0 then
                    camRot = camRot + Vector3.new(
                        -delta.Y * sensitivity * 0.003,
                        -delta.X * sensitivity * 0.003,
                        0
                    )
                    
                    touchStartPos = input.Position
                end
            end
        end)
        
        -- Handle touch ended
        inputEndedConnection = UIS.InputEnded:Connect(function(input, gameProcessed)
            if not freecam then return end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                touchInput = nil
                touchStartPos = nil
            end
        end)
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
    
    -- Restore everything
    LockCharacter(false)
    ShowAllGuis()
    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = Humanoid
    
    UIS.MouseBehavior = Enum.MouseBehavior.Default
    UIS.MouseIconEnabled = true
    
    touchInput = nil
    touchStartPos = nil
    
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

-- F3 keybind hanya untuk PC, otomatis aktif ketika freecam dihidupkan
if not isMobile then
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- F3 toggle hanya jika keybind aktif dan freecam sedang aktif
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
print("► Ready to be controlled by GUI")
print("═════════════════════════════════════════")

return FreecamModule
