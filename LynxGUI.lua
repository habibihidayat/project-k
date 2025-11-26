-- LynxGUI_v2.3.lua - Modern Dark Premium Edition
-- REDESIGNED DARK TRANSPARENT STYLE

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

repeat task.wait() until localPlayer:FindFirstChild("PlayerGui")

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

-- Load modules
local instant = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant.lua"))()
local instant2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant2.lua"))()
local instant2x = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant2Xspeed.lua"))()
local blatantv2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/BlatantV2.lua"))()
local NoFishingAnimation = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/NoFishingAnimation.lua"))()
local TeleportModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportModule.lua"))()
local TeleportToPlayer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportSystem/TeleportToPlayer.lua"))()
local AutoSell = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSell.lua"))()
local AutoSellTimer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSellTimer.lua"))()
local AntiAFK = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/AntiAFK.lua"))()
local UnlockFPS = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/UnlockFPS.lua"))()
local AutoBuyWeather = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoBuyWeather.lua"))()

-- Dark Color Palette
local colors = {
    primary = Color3.fromRGB(100, 150, 255),      -- Blue accent
    secondary = Color3.fromRGB(80, 120, 220),     -- Darker blue
    accent = Color3.fromRGB(150, 180, 255),       -- Light blue
    success = Color3.fromRGB(100, 200, 150),
    warning = Color3.fromRGB(255, 180, 80),
    danger = Color3.fromRGB(255, 100, 100),
    
    bg1 = Color3.fromRGB(20, 25, 35),             -- Very dark bg
    bg2 = Color3.fromRGB(30, 35, 50),             -- Dark bg
    bg3 = Color3.fromRGB(40, 45, 65),             -- Medium dark bg
    
    text = Color3.fromRGB(220, 225, 235),
    textDim = Color3.fromRGB(150, 160, 180),
    textDimmer = Color3.fromRGB(100, 110, 130),
}

local windowSize = UDim2.new(0, 650, 0, 700)
local minWindowSize = Vector2.new(500, 500)
local maxWindowSize = Vector2.new(900, 800)

local gui = new("ScreenGui", {
    Name = "LynxGUI_Modern",
    Parent = localPlayer.PlayerGui,
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999
})

-- Main Window
local win = new("Frame", {
    Parent = gui,
    Size = windowSize,
    Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2),
    BackgroundColor3 = colors.bg2,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 3
})
new("UICorner", {Parent = win, CornerRadius = UDim.new(0, 12)})

-- Border stroke
local stroke = new("UIStroke", {
    Parent = win,
    Color = colors.primary,
    Thickness = 1.5,
    Transparency = 0.5
})

-- Top bar
local topBar = new("Frame", {
    Parent = win,
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = colors.bg3,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 5
})

-- Page title
local pageTitle = new("TextLabel", {
    Parent = topBar,
    Text = "Main",
    Size = UDim2.new(0.5, 0, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BackgroundTransparency = 1,
    TextColor3 = colors.text,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6
})

-- Control buttons
local controlsFrame = new("Frame", {
    Parent = topBar,
    Size = UDim2.new(0, 70, 1, 0),
    Position = UDim2.new(1, -70, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 6
})
new("UIListLayout", {
    Parent = controlsFrame,
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 5),
    HorizontalAlignment = Enum.HorizontalAlignment.Right
})

local function createControlBtn(icon, color)
    local btn = new("TextButton", {
        Parent = controlsFrame,
        Size = UDim2.new(0, 32, 0, 32),
        BackgroundColor3 = colors.bg2,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = icon,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = color,
        AutoButtonColor = false,
        ZIndex = 7
    })
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 8)})
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.2
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = colors.bg2,
            BackgroundTransparency = 0.3
        }):Play()
    end)
    return btn
end

local btnMin = createControlBtn("─", colors.warning)
local btnClose = createControlBtn("×", colors.danger)

-- Content area
local contentArea = new("ScrollingFrame", {
    Parent = win,
    Size = UDim2.new(1, -10, 1, -55),
    Position = UDim2.new(0, 5, 0, 50),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = colors.primary,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ClipsDescendants = true,
    ZIndex = 5
})
new("UIListLayout", {
    Parent = contentArea,
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder
})
new("UIPadding", {
    Parent = contentArea,
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5)
})

-- Create category
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = colors.bg3,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 6
    })
    new("UICorner", {Parent = categoryFrame, CornerRadius = UDim.new(0, 10)})
    
    local header = new("TextButton", {
        Parent = categoryFrame,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 7
    })
    
    local iconLabel = new("TextLabel", {
        Parent = header,
        Text = icon,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0.5, -15),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = colors.primary,
        ZIndex = 8
    })
    
    local titleLabel = new("TextLabel", {
        Parent = header,
        Text = title,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    local arrow = new("TextLabel", {
        Parent = header,
        Text = "▼",
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = colors.primary,
        ZIndex = 8
    })
    
    local contentContainer = new("Frame", {
        Parent = categoryFrame,
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        ZIndex = 7
    })
    new("UIListLayout", {Parent = contentContainer, Padding = UDim.new(0, 8)})
    new("UIPadding", {Parent = contentContainer, PaddingBottom = UDim.new(0, 10)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation = isOpen and 180 or 0}):Play()
    end)
    
    return contentContainer
end

-- Modern Input Box (untuk manual delay input)
local function makeInputBox(parent, label, defaultValue, onChanged)
    local frame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        ZIndex = 7
    })
    
    local labelText = new("TextLabel", {
        Parent = frame,
        Text = label,
        Size = UDim2.new(0.5, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    local inputBox = new("TextBox", {
        Parent = frame,
        Size = UDim2.new(0.6, 0, 0, 28),
        Position = UDim2.new(0.35, 0, 0, 20),
        BackgroundColor3 = colors.bg2,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = tostring(defaultValue),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = colors.text,
        TextScaled = false,
        ClearTextOnFocus = false,
        MultiLine = false,
        ZIndex = 8
    })
    new("UICorner", {Parent = inputBox, CornerRadius = UDim.new(0, 6)})
    new("UIStroke", {
        Parent = inputBox,
        Color = colors.primary,
        Thickness = 1,
        Transparency = 0.7
    })
    
    local function updateValue()
        local val = tonumber(inputBox.Text) or defaultValue
        val = math.max(0, math.min(5, val))
        inputBox.Text = string.format("%.2f", val)
        onChanged(val)
    end
    
    inputBox.FocusLost:Connect(updateValue)
    inputBox.InputChanged:Connect(function()
        local text = inputBox.Text
        if text ~= "" then
            local val = tonumber(text)
            if val then
                val = math.max(0, math.min(5, val))
                onChanged(val)
            end
        end
    end)
    
    return inputBox
end

-- Modern Toggle
local function makeToggle(parent, label, callback)
    local frame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        ZIndex = 7
    })
    
    local labelText = new("TextLabel", {
        Parent = frame,
        Text = label,
        Size = UDim2.new(0.6, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        TextColor3 = colors.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        ZIndex = 8
    })
    
    local toggleBg = new("Frame", {
        Parent = frame,
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(1, -52, 0.5, -13),
        BackgroundColor3 = colors.bg2,
        BorderSizePixel = 0,
        ZIndex = 8
    })
    new("UICorner", {Parent = toggleBg, CornerRadius = UDim.new(1, 0)})
    
    local toggleCircle = new("Frame", {
        Parent = toggleBg,
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 2, 0.5, -11),
        BackgroundColor3 = colors.textDim,
        BorderSizePixel = 0,
        ZIndex = 9
    })
    new("UICorner", {Parent = toggleCircle, CornerRadius = UDim.new(1, 0)})
    
    local btn = new("TextButton", {
        Parent = toggleBg,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 10
    })
    
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(toggleBg, TweenInfo.new(0.25), {BackgroundColor3 = on and colors.primary or colors.bg2}):Play()
        TweenService:Create(toggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11),
            BackgroundColor3 = on and colors.text or colors.textDim
        }):Play()
        callback(on)
    end)
end

-- Modern Button
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = colors.primary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 8
    })
    new("UICorner", {Parent = btnFrame, CornerRadius = UDim.new(0, 8)})
    
    local button = new("TextButton", {
        Parent = btnFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = colors.text,
        AutoButtonColor = false,
        ZIndex = 9
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return btnFrame
end

-- Main Page Content
local catAutoFishing = makeCategory(contentArea, "Auto Fishing", "🎣")

local currentInstantMode = "Fast"
local fishingDelayValue = 1.30
local cancelDelayValue = 0.19

makeToggle(catAutoFishing, "Enable Instant Fishing", function(on)
    if on then
        if currentInstantMode == "Fast" then
            instant.Start()
        else
            instant2.Start()
        end
    else
        instant.Stop()
        instant2.Stop()
    end
end)

makeInputBox(catAutoFishing, "Fishing Delay", 1.30, function(v)
    fishingDelayValue = v
    instant.Settings.MaxWaitTime = v
    instant2.Settings.MaxWaitTime = v
end)

makeInputBox(catAutoFishing, "Cancel Delay", 0.19, function(v)
    cancelDelayValue = v
    instant.Settings.CancelDelay = v
    instant2.Settings.CancelDelay = v
end)

local catBlatant = makeCategory(contentArea, "Blatant Mode", "🔥")
makeToggle(catBlatant, "Enable Blatant", function(on) 
    if on then instant2x.Start() else instant2x.Stop() end 
end)

makeInputBox(catBlatant, "Fishing Delay", 0.3, function(v) 
    instant2x.Settings.FishingDelay = v 
end)

makeInputBox(catBlatant, "Cancel Delay", 0.19, function(v) 
    instant2x.Settings.CancelDelay = v 
end)

local catBlatantV2 = makeCategory(contentArea, "Blatant V2", "⚡")
makeToggle(catBlatantV2, "Enable Blatant V2", function(on) 
    if on then blatantv2.Start() else blatantv2.Stop() end 
end)

makeInputBox(catBlatantV2, "Fishing Delay", 0.05, function(v) 
    blatantv2.Settings.FishingDelay = v 
end)

makeInputBox(catBlatantV2, "Cancel Delay", 0.01, function(v) 
    blatantv2.Settings.CancelDelay = v 
end)

makeInputBox(catBlatantV2, "Hook Wait Time", 0.15, function(v) 
    blatantv2.Settings.HookWaitTime = v 
end)

makeInputBox(catBlatantV2, "Cast Delay", 0.03, function(v) 
    blatantv2.Settings.CastDelay = v 
end)

makeInputBox(catBlatantV2, "Timeout Delay", 0.8, function(v) 
    blatantv2.Settings.TimeoutDelay = v 
end)

local catSupport = makeCategory(contentArea, "Support Features", "🛠️")
makeToggle(catSupport, "No Fishing Animation", function(on)
    if on then
        NoFishingAnimation.StartWithDelay()
    else
        NoFishingAnimation.Stop()
    end
end)

-- Minimized Icon
local minimized = false
local icon

local function createMinimizedIcon()
    if icon then return end
    local iconSize = 50
    icon = new("ImageLabel", {
        Parent = gui,
        Size = UDim2.new(0, iconSize, 0, iconSize),
        Position = UDim2.new(0, 20, 0, 120),
        BackgroundColor3 = colors.primary,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Image = "rbxassetid://111416780887356",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 100
    })
    new("UICorner", {Parent = icon, CornerRadius = UDim.new(0, 10)})
    new("UIStroke", {
        Parent = icon,
        Color = colors.primary,
        Thickness = 1.5,
        Transparency = 0.5
    })
    
    local dragging, dragStart, startPos, dragMoved = false, nil, nil, false
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragMoved, dragStart, startPos = true, false, input.Position, icon.Position
        end
    end)
    
    icon.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.sqrt(delta.X^2 + delta.Y^2) > 5 then dragMoved = true end
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(icon, TweenInfo.new(0.05), {Position = newPos}):Play()
        end
    end)
    
    icon.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if not dragMoved then
                    win.Visible = true
                    TweenService:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = windowSize,
                        Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
                    }):Play()
                    if icon then icon:Destroy() icon = nil end
                    minimized = false
                end
            end
        end
    end)
end

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(win, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        win.Visible = false
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.3)
    gui:Destroy()
end)

-- Dragging System
local dragging, dragStart, startPos = false, nil, nil
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, win.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(win, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = newPos}):Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Opening Animation
task.spawn(function()
    win.Size = UDim2.new(0, 0, 0, 0)
    win.Position = UDim2.new(0.5, 0, 0.5, 0)
    task.wait(0.1)
    TweenService:Create(win, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    }):Play()
end)

print("✨ Lynx GUI v2.3 - Modern Dark Edition loaded!")
print("🎨 Transparent Dark Style")
print("📝 Manual Delay Input")
print("💙 Created by Lynx Team")
