-- Seraphin | Premium GUI - Modern Edition
-- Optimized for Mobile & Desktop

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

-- Modern Color Palette
local colors = {
    primary = Color3.fromRGB(88, 101, 242),      -- Discord Blue
    secondary = Color3.fromRGB(114, 137, 218),   -- Light Blue
    accent = Color3.fromRGB(67, 181, 129),       -- Green
    danger = Color3.fromRGB(237, 66, 69),        -- Red
    
    bg1 = Color3.fromRGB(32, 34, 37),            -- Dark
    bg2 = Color3.fromRGB(47, 49, 54),            -- Medium
    bg3 = Color3.fromRGB(54, 57, 63),            -- Light
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(185, 187, 190),
}

local windowSize = isMobile and UDim2.new(0,480,0,300) or UDim2.new(0,700,0,420)

local gui = new("ScreenGui",{
    Name="SeraphinGUI",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Main Window
local win = new("Frame",{
    Parent=gui,
    Size=windowSize,
    Position=UDim2.new(0.5,-windowSize.X.Offset/2,0.5,-windowSize.Y.Offset/2),
    BackgroundColor3=colors.bg1,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,12)})

-- Top Bar
local topBar = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,0,40),
    BackgroundColor3=colors.bg2,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,12)})

local titleLabel = new("TextLabel",{
    Parent=topBar,
    Text="Seraphin | Premium",
    Size=UDim2.new(0,200,1,0),
    Position=UDim2.new(0,15,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=14,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=5
})

-- Control buttons
local controlsFrame = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,70,0,30),
    Position=UDim2.new(1,-80,0.5,-15),
    BackgroundTransparency=1,
    ZIndex=5
})
new("UIListLayout",{
    Parent=controlsFrame,
    FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,8)
})

local function createControlBtn(text, color)
    local btn = new("TextButton",{
        Parent=controlsFrame,
        Size=UDim2.new(0,28,0,28),
        BackgroundColor3=color,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        Text=text,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=colors.text,
        AutoButtonColor=false,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,8)})
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundTransparency=0.3}):Play()
    end)
    return btn
end

local btnMin = createControlBtn("─", colors.secondary)
local btnClose = createControlBtn("×", colors.danger)

-- Sidebar
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,160,1,-40),
    Position=UDim2.new(0,0,0,40),
    BackgroundColor3=colors.bg2,
    BorderSizePixel=0,
    ZIndex=4
})

local sidebarList = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    ScrollBarThickness=0,
    BorderSizePixel=0,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ZIndex=5
})
new("UIListLayout",{Parent=sidebarList,Padding=UDim.new(0,4)})
new("UIPadding",{Parent=sidebarList,PaddingTop=UDim.new(0,10),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)})

-- Content Area
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-170,1,-50),
    Position=UDim2.new(0,165,0,45),
    BackgroundColor3=colors.bg1,
    BorderSizePixel=0,
    ZIndex=4
})

-- Pages
local pages = {}
local currentPage = "Main"

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        ScrollBarThickness=4,
        ScrollBarImageColor3=colors.primary,
        BorderSizePixel=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false,
        ZIndex=5
    })
    new("UIListLayout",{Parent=page,Padding=UDim.new(0,12)})
    new("UIPadding",{Parent=page,PaddingTop=UDim.new(0,10),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)})
    pages[name] = page
    return page
end

local mainPage = createPage("Main")
local menuPage = createPage("Menu")
local tradingPage = createPage("Trading")
local questPage = createPage("Quest")
mainPage.Visible = true

-- Menu Button
local navButtons = {}

local function createNavButton(icon, text, page, order)
    local btn = new("TextButton",{
        Parent=sidebarList,
        Size=UDim2.new(1,0,0,42),
        BackgroundColor3=page == currentPage and colors.bg3 or Color3.fromRGB(0,0,0),
        BackgroundTransparency=page == currentPage and 0 or 1,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        LayoutOrder=order,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,8)})
    
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=UDim2.new(0,30,1,0),
        Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        ZIndex=7
    })
    
    local textLabel = new("TextLabel",{
        Parent=btn,
        Text=text,
        Size=UDim2.new(1,-50,1,0),
        Position=UDim2.new(0,45,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,
        TextSize=13,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=7
    })
    
    navButtons[page] = {btn=btn, icon=iconLabel, text=textLabel}
    
    btn.MouseButton1Click:Connect(function()
        for name, data in pairs(navButtons) do
            local isActive = name == page
            TweenService:Create(data.btn,TweenInfo.new(0.2),{
                BackgroundColor3=isActive and colors.bg3 or Color3.fromRGB(0,0,0),
                BackgroundTransparency=isActive and 0 or 1
            }):Play()
            TweenService:Create(data.icon,TweenInfo.new(0.2),{
                TextColor3=isActive and colors.primary or colors.textDim
            }):Play()
            TweenService:Create(data.text,TweenInfo.new(0.2),{
                TextColor3=isActive and colors.text or colors.textDim
            }):Play()
        end
        
        for _, p in pairs(pages) do p.Visible = false end
        pages[page].Visible = true
        currentPage = page
    end)
    
    return btn
end

createNavButton("ℹ️", "Info", "Main", 1)
createNavButton("⭐", "Exclusive", "Menu", 2)
createNavButton("🎣", "Main", "Main", 3)
createNavButton("📋", "Menu", "Menu", 4)
createNavButton("💱", "Trading", "Trading", 5)
createNavButton("📜", "Quest", "Quest", 6)

-- Modern Input Box for Delay
local function makeInputDelay(parent, label, defaultValue, onChange)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,60),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local labelText = new("TextLabel",{
        Parent=frame,
        Text=label,
        Size=UDim2.new(1,0,0,20),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local inputBg = new("Frame",{
        Parent=frame,
        Size=UDim2.new(0,120,0,32),
        Position=UDim2.new(0,0,0,26),
        BackgroundColor3=colors.bg3,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=inputBg,CornerRadius=UDim.new(0,8)})
    new("UIStroke",{
        Parent=inputBg,
        Color=colors.primary,
        Thickness=1,
        Transparency=0.7
    })
    
    local inputBox = new("TextBox",{
        Parent=inputBg,
        Size=UDim2.new(1,-20,1,0),
        Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text=tostring(defaultValue),
        Font=Enum.Font.GothamMedium,
        TextSize=14,
        TextColor3=colors.text,
        PlaceholderText="0.00",
        PlaceholderColor3=colors.textDim,
        ClearTextOnFocus=false,
        ZIndex=9
    })
    
    inputBox.FocusLost:Connect(function()
        local value = tonumber(inputBox.Text)
        if value then
            inputBox.Text = string.format("%.2f", value)
            onChange(value)
        else
            inputBox.Text = tostring(defaultValue)
        end
    end)
    
    return frame
end

-- Modern Toggle
local function makeToggle(parent, label, callback)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,40),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local labelText = new("TextLabel",{
        Parent=frame,
        Text=label,
        Size=UDim2.new(0.7,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=13,
        ZIndex=8
    })
    
    local toggleBg = new("Frame",{
        Parent=frame,
        Size=UDim2.new(0,50,0,26),
        Position=UDim2.new(1,-52,0.5,-13),
        BackgroundColor3=colors.bg3,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=toggleBg,CornerRadius=UDim.new(1,0)})
    
    local toggleCircle = new("Frame",{
        Parent=toggleBg,
        Size=UDim2.new(0,20,0,20),
        Position=UDim2.new(0,3,0.5,-10),
        BackgroundColor3=colors.textDim,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=toggleCircle,CornerRadius=UDim.new(1,0)})
    
    local btn = new("TextButton",{
        Parent=toggleBg,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text="",
        ZIndex=10
    })
    
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(toggleBg,TweenInfo.new(0.25),{BackgroundColor3=on and colors.accent or colors.bg3}):Play()
        TweenService:Create(toggleCircle,TweenInfo.new(0.3,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10),
            BackgroundColor3=on and colors.text or colors.textDim
        }):Play()
        callback(on)
    end)
end

-- Section Header
local function makeSection(parent, title)
    local section = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,35),
        BackgroundColor3=colors.bg2,
        BorderSizePixel=0,
        ZIndex=6
    })
    new("UICorner",{Parent=section,CornerRadius=UDim.new(0,10)})
    
    local titleLabel = new("TextLabel",{
        Parent=section,
        Text=title,
        Size=UDim2.new(1,-20,1,0),
        Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=14,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=7
    })
    
    return section
end

-- ==== MAIN PAGE ====
makeSection(mainPage, "Delay Configuration")

local delayReelValue = 1.8
local delayCompleteValue = 0.7

makeInputDelay(mainPage, "Delay Reel", 1.8, function(v)
    delayReelValue = v
    instant.Settings.MaxWaitTime = v
    instant2.Settings.MaxWaitTime = v
end)

makeInputDelay(mainPage, "Delay Complete", 0.7, function(v)
    delayCompleteValue = v
    instant.Settings.CancelDelay = v
    instant2.Settings.CancelDelay = v
end)

makeSection(mainPage, "Blatant Fishing")

makeToggle(mainPage, "Blatant Fishing", function(on)
    if on then
        blatantv2.Start()
    else
        blatantv2.Stop()
    end
end)

makeSection(mainPage, "Recovery Fishing")

makeToggle(mainPage, "Recovery Fishing", function(on)
    if on then
        instant.Start()
    else
        instant.Stop()
    end
end)

-- Minimized Icon (HANYA MUNCUL SAAT MINIMIZE)
local minimized = false
local icon

local function createMinimizedIcon()
    if icon then return end
    local iconSize = isMobile and 50 or 70
    icon = new("ImageLabel",{
        Parent=gui,
        Size=UDim2.new(0,iconSize,0,iconSize),
        Position=UDim2.new(0,20,0,120),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.1,
        BorderSizePixel=0,
        Image="rbxassetid://111416780887356",
        ScaleType=Enum.ScaleType.Fit,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,14)})
    new("UIStroke",{
        Parent=icon,
        Color=colors.primary,
        Thickness=2.5,
        Transparency=0.5
    })
    
    -- Fallback text if image fails
    local logoText = new("TextLabel",{
        Parent=icon,
        Text="S",
        Size=UDim2.new(1,0,1,0),
        Font=Enum.Font.GothamBold,
        TextSize=36,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Visible=icon.Image == "",
        ZIndex=101
    })
    
    -- Drag and click to restore
    local dragging,dragStart,startPos,dragMoved = false,nil,nil,false
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging,dragMoved,dragStart,startPos = true,false,input.Position,icon.Position
        end
    end)
    
    icon.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.sqrt(delta.X^2 + delta.Y^2) > 5 then dragMoved = true end
            icon.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y)
        end
    end)
    
    icon.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if not dragMoved then
                    win.Visible = true
                    TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                        Size=windowSize
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
        TweenService:Create(win,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
            Size=UDim2.new(0,0,0,0)
        }):Play()
        task.wait(0.3)
        win.Visible = false
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    -- Smooth fade out animation
    TweenService:Create(win,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        BackgroundTransparency=1
    }):Play()
    task.wait(0.3)
    gui:Destroy()
end)

-- Dragging
local dragging,dragStart,startPos = false,nil,nil
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging,dragStart,startPos = true,input.Position,win.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        win.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

-- Opening Animation
win.Size = UDim2.new(0,0,0,0)
task.wait(0.1)
TweenService:Create(win,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=windowSize}):Play()

print("✨ Seraphin GUI Modern Edition loaded!")
print("📱 Input delay manual tersedia")
print("🖼️ Logo hanya muncul saat minimize")
