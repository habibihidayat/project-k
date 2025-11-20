-- LynxGUI_v4.0.lua - Premium iOS Design with Glassmorphism
-- Ultra Modern, Clean, Aesthetic

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

repeat task.wait() until localPlayer:FindFirstChild("PlayerGui")

local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

-- Load Modules (same as before)
local instant = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant.lua"))()
local instant2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant2.lua"))()
local BlatantAutoFishing = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/BlatantAutoFishing.lua"))()
local NoFishingAnimation = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/NoFishingAnimation.lua"))()
local TeleportModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportModule.lua"))()
local TeleportToPlayer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportSystem/TeleportToPlayer.lua"))()
local AutoSell = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSell.lua"))()
local AutoSellTimer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSellTimer.lua"))()
local AntiAFK = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/AntiAFK.lua"))()
local UnlockFPS = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/UnlockFPS.lua"))()
local AutoBuyWeather = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoBuyWeather.lua"))()

-- Premium iOS Color Palette
local colors = {
    -- Primary Colors
    primary = Color3.fromRGB(0, 122, 255),
    primaryLight = Color3.fromRGB(10, 132, 255),
    primaryDark = Color3.fromRGB(0, 112, 245),
    
    -- Status Colors
    success = Color3.fromRGB(52, 199, 89),
    danger = Color3.fromRGB(255, 69, 58),
    warning = Color3.fromRGB(255, 214, 10),
    info = Color3.fromRGB(90, 200, 250),
    
    -- Glassmorphism Backgrounds (more transparent)
    glassBg = Color3.fromRGB(12, 12, 14),
    glassCard = Color3.fromRGB(25, 25, 28),
    glassSidebar = Color3.fromRGB(18, 18, 21),
    glassHeader = Color3.fromRGB(20, 20, 23),
    glassOverlay = Color3.fromRGB(30, 30, 33),
    
    -- Text Colors
    text = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(142, 142, 147),
    textTertiary = Color3.fromRGB(99, 99, 102),
    textQuaternary = Color3.fromRGB(72, 72, 74),
    
    -- UI Elements
    separator = Color3.fromRGB(48, 48, 51),
    border = Color3.fromRGB(58, 58, 60),
    shadow = Color3.fromRGB(0, 0, 0),
    
    -- Accent Colors
    purple = Color3.fromRGB(175, 82, 222),
    pink = Color3.fromRGB(255, 55, 95),
    orange = Color3.fromRGB(255, 159, 10),
    teal = Color3.fromRGB(100, 210, 255),
}

local gui = new("ScreenGui",{
    Name="LynxGUI_Premium_v4",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Enhanced Blur Background with Gradient
local blur = new("Frame",{
    Parent=gui,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(0,0,0),
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    Visible=false,
    ZIndex=1,
    Active=true
})

local blurGradient = new("UIGradient",{
    Parent=blur,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }),
    Rotation=45,
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 0.15)
    })
})

-- Main Window - Ultra Glassmorphism
local win = new("Frame",{
    Parent=gui,
    Size=UDim2.new(0,480,0,420),
    Position=UDim2.new(0.5,-240,0.5,-210),
    BackgroundColor3=colors.glassBg,
    BackgroundTransparency=0.25,  -- More transparent
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,24)})  -- Larger radius

-- Frosted Glass Effect with Stroke
local winStroke = new("UIStroke",{
    Parent=win,
    Color=Color3.fromRGB(255,255,255),
    Thickness=1,
    Transparency=0.85,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Outer Glow Shadow
local outerShadow = new("ImageLabel",{
    Parent=win,
    Size=UDim2.new(1,60,1,60),
    Position=UDim2.new(0,-30,0,-30),
    BackgroundTransparency=1,
    Image="rbxasset://textures/ui/GuiImagePlaceholder.png",
    ImageColor3=Color3.fromRGB(0,0,0),
    ImageTransparency=0.7,
    ZIndex=2
})
new("UICorner",{Parent=outerShadow,CornerRadius=UDim.new(0,36)})

-- Inner Highlight Effect
local innerHighlight = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-2,0,1),
    Position=UDim2.new(0,1,0,1),
    BackgroundColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=0.9,
    BorderSizePixel=0,
    ZIndex=4
})

-- Gradient Overlay for Depth
local depthGradient = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ZIndex=3
})
new("UIGradient",{
    Parent=depthGradient,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
    }),
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.97),
        NumberSequenceKeypoint.new(1, 0.85)
    }),
    Rotation=180
})

-- Top Bar - Frosted Glass
local topBar = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,0,70),
    BackgroundColor3=colors.glassHeader,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,24)})

-- Top Bar Bottom Mask
local topBarMask = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(1,0,0,24),
    Position=UDim2.new(0,0,1,-24),
    BackgroundColor3=colors.glassHeader,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=5
})

-- Subtle Separator with Gradient
local separator = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(1,0,0,1),
    Position=UDim2.new(0,0,1,-1),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ZIndex=6
})
local sepGradient = new("UIGradient",{
    Parent=separator,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors.separator),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100,100,102)),
        ColorSequenceKeypoint.new(1, colors.separator)
    }),
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
})
new("Frame",{
    Parent=separator,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=colors.separator,
    BackgroundTransparency=0.6,
    BorderSizePixel=0
})

-- Title Section with Icon
local titleContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,250,1,0),
    Position=UDim2.new(0,20,0,0),
    BackgroundTransparency=1,
    ZIndex=6
})

-- Logo Icon Background
local logoContainer = new("Frame",{
    Parent=titleContainer,
    Size=UDim2.new(0,42,0,42),
    Position=UDim2.new(0,0,0.5,-21),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.1,
    BorderSizePixel=0,
    ZIndex=7
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,12)})
new("UIStroke",{
    Parent=logoContainer,
    Color=colors.primary,
    Thickness=1.5,
    Transparency=0.5,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Animated gradient for logo
local logoGradient = new("UIGradient",{
    Parent=logoContainer,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(0.5, colors.teal),
        ColorSequenceKeypoint.new(1, colors.purple)
    }),
    Rotation=45
})

-- Logo Text
local logoText = new("TextLabel",{
    Parent=logoContainer,
    Text="L",
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,
    TextSize=24,
    TextColor3=Color3.fromRGB(255,255,255),
    ZIndex=8
})

-- Animate logo gradient
task.spawn(function()
    while logoContainer and logoContainer.Parent do
        for i = 0, 360, 5 do
            if logoGradient and logoGradient.Parent then
                logoGradient.Rotation = i
                task.wait(0.05)
            else
                break
            end
        end
    end
end)

-- Title Text
local titleLabel = new("TextLabel",{
    Parent=titleContainer,
    Text="Lynx",
    Size=UDim2.new(0,150,0,26),
    Position=UDim2.new(0,52,0,12),
    Font=Enum.Font.GothamBold,
    TextSize=22,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=7
})

-- Subtitle with Badge
local subtitleContainer = new("Frame",{
    Parent=titleContainer,
    Size=UDim2.new(0,150,0,18),
    Position=UDim2.new(0,52,1,-28),
    BackgroundTransparency=1,
    ZIndex=7
})
new("UIListLayout",{
    Parent=subtitleContainer,
    FillDirection=Enum.FillDirection.Horizontal,
    HorizontalAlignment=Enum.HorizontalAlignment.Left,
    VerticalAlignment=Enum.VerticalAlignment.Center,
    Padding=UDim.new(0,6)
})

local versionBadge = new("Frame",{
    Parent=subtitleContainer,
    Size=UDim2.new(0,42,0,18),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.85,
    BorderSizePixel=0,
    ZIndex=8
})
new("UICorner",{Parent=versionBadge,CornerRadius=UDim.new(0,6)})
new("TextLabel",{
    Parent=versionBadge,
    Text="v4.0",
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,
    TextSize=9,
    TextColor3=colors.primary,
    ZIndex=9
})

local mobileBadge = new("Frame",{
    Parent=subtitleContainer,
    Size=UDim2.new(0,48,0,18),
    BackgroundColor3=colors.success,
    BackgroundTransparency=0.85,
    BorderSizePixel=0,
    ZIndex=8
})
new("UICorner",{Parent=mobileBadge,CornerRadius=UDim.new(0,6)})
new("TextLabel",{
    Parent=mobileBadge,
    Text="Mobile",
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,
    TextSize=8,
    TextColor3=colors.success,
    ZIndex=9
})

-- Control Buttons with Glass Effect
local controlsContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,90,0,36),
    Position=UDim2.new(1,-110,0.5,-18),
    BackgroundTransparency=1,
    ZIndex=6
})
new("UIListLayout",{
    Parent=controlsContainer,
    FillDirection=Enum.FillDirection.Horizontal,
    HorizontalAlignment=Enum.HorizontalAlignment.Right,
    VerticalAlignment=Enum.VerticalAlignment.Center,
    Padding=UDim.new(0,10)
})

local function createControlButton(icon, color, isClose)
    local btnContainer = new("Frame",{
        Parent=controlsContainer,
        Size=UDim2.new(0,36,0,36),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local btn = new("TextButton",{
        Parent=btnContainer,
        Text="",
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=isClose and color or colors.glassCard,
        BackgroundTransparency=isClose and 0.15 or 0.3,
        BorderSizePixel=0,
        AutoButtonColor=false,
        ZIndex=8
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(1,0)})
    
    local btnStroke = new("UIStroke",{
        Parent=btn,
        Color=color,
        Thickness=1.5,
        Transparency=isClose and 0.4 or 0.6,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    -- Icon with better styling
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isClose and 18 or 20,
        TextColor3=isClose and colors.text or color,
        ZIndex=9
    })
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
            BackgroundColor3=color,
            BackgroundTransparency=0.1
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.2),{
            Transparency=0.2
        }):Play()
        TweenService:Create(iconLabel,TweenInfo.new(0.2),{
            TextColor3=Color3.fromRGB(255,255,255)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
            BackgroundColor3=isClose and color or colors.glassCard,
            BackgroundTransparency=isClose and 0.15 or 0.3
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.2),{
            Transparency=isClose and 0.4 or 0.6
        }):Play()
        TweenService:Create(iconLabel,TweenInfo.new(0.2),{
            TextColor3=isClose and colors.text or color
        }):Play()
    end)
    
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.08,Enum.EasingStyle.Quad),{
            Size=UDim2.new(0,32,0,32)
        }):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.12,Enum.EasingStyle.Back),{
            Size=UDim2.new(1,0,1,0)
        }):Play()
    end)
    
    return btn
end

local btnMin = createControlButton("−", colors.info, false)
local btnClose = createControlButton("✕", colors.danger, true)

-- Sidebar - Premium Glass Effect
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,150,1,-70),
    Position=UDim2.new(0,0,0,70),
    BackgroundColor3=colors.glassSidebar,
    BackgroundTransparency=0.35,
    BorderSizePixel=0,
    ZIndex=5
})

-- Sidebar Right Border with Gradient
local sidebarBorder = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(0,1,1,0),
    Position=UDim2.new(1,-1,0,0),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ZIndex=6
})
new("UIGradient",{
    Parent=sidebarBorder,
    Color=ColorSequence.new(colors.separator),
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.1, 0.5),
        NumberSequenceKeypoint.new(0.9, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    }),
    Rotation=90
})
new("Frame",{
    Parent=sidebarBorder,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=colors.separator,
    BackgroundTransparency=0.6,
    BorderSizePixel=0
})

-- Navigation Container
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=4,
    ScrollBarImageColor3=colors.primary,
    ScrollBarImageTransparency=0.6,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0,8),
    HorizontalAlignment=Enum.HorizontalAlignment.Center
})
new("UIPadding",{
    Parent=navContainer,
    PaddingTop=UDim.new(0,16),
    PaddingBottom=UDim.new(0,16),
    PaddingLeft=UDim.new(0,10),
    PaddingRight=UDim.new(0,10)
})

local currentPage = "Main"
local navButtons = {}

-- Enhanced Navigation Button
local function createNavButton(text, icon, page, accentColor)
    local isActive = page == currentPage
    
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1,0,0,52),
        BackgroundColor3=isActive and colors.glassCard or Color3.fromRGB(0,0,0),
        BackgroundTransparency=isActive and 0.25 or 1,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        ZIndex=8
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,14)})
    
    local btnStroke
    if isActive then
        btnStroke = new("UIStroke",{
            Parent=btn,
            Color=accentColor,
            Thickness=1,
            Transparency=0.6,
            ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        })
    end
    
    -- Active Indicator
    local indicator = new("Frame",{
        Parent=btn,
        Size=UDim2.new(0,3,0.6,0),
        Position=UDim2.new(0,2,0.2,0),
        BackgroundColor3=accentColor,
        BorderSizePixel=0,
        Visible=isActive,
        ZIndex=9
    })
    new("UICorner",{Parent=indicator,CornerRadius=UDim.new(1,0)})
    
    -- Add glow to indicator
    if isActive then
        local indicatorGlow = new("Frame",{
            Parent=indicator,
            Size=UDim2.new(1,8,1,0),
            Position=UDim2.new(0,-4,0,0),
            BackgroundColor3=accentColor,
            BackgroundTransparency=0.7,
            BorderSizePixel=0,
            ZIndex=8
        })
        new("UICorner",{Parent=indicatorGlow,CornerRadius=UDim.new(1,0)})
    end
    
    -- Content Container
    local content = new("Frame",{
        Parent=btn,
        Size=UDim2.new(1,-16,1,0),
        Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,
        ZIndex=9
    })
    
    -- Icon Background with Gradient
    local iconBg = new("Frame",{
        Parent=content,
        Size=UDim2.new(0,38,0,38),
        Position=UDim2.new(0,0,0.5,-19),
        BackgroundColor3=isActive and accentColor or colors.glassOverlay,
        BackgroundTransparency=isActive and 0.85 or 0.4,
        BorderSizePixel=0,
        ZIndex=10
    })
    new("UICorner",{Parent=iconBg,CornerRadius=UDim.new(0,10)})
    
    if isActive then
        new("UIStroke",{
            Parent=iconBg,
            Color=accentColor,
            Thickness=1,
            Transparency=0.7,
            ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        })
    end
    
    -- Icon
    local iconLabel = new("TextLabel",{
        Parent=iconBg,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextColor3=isActive and accentColor or colors.textSecondary,
        ZIndex=11
    })
    
    -- Text Label
    local textLabel = new("TextLabel",{
        Parent=content,
        Size=UDim2.new(1,-46,1,0),
        Position=UDim2.new(0,44,0,0),
        BackgroundTransparency=1,
        Text=text,
        Font=Enum.Font.GothamBold,
        TextSize=13,
        TextColor3=isActive and colors.text or colors.textSecondary,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=10
    })
    
    -- Hover Effects
    btn.MouseEnter:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
                BackgroundColor3=colors.glassCard,
                BackgroundTransparency=0.4
            }):Play()
            TweenService:Create(iconBg,TweenInfo.new(0.2),{
                BackgroundTransparency=0.3,
                Size=UDim2.new(0,40,0,40)
            }):Play()
            TweenService:Create(textLabel,TweenInfo.new(0.2),{
                TextColor3=colors.text
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
                BackgroundTransparency=1
            }):Play()
            TweenService:Create(iconBg,TweenInfo.new(0.2),{
                BackgroundTransparency=0.4,
                Size=UDim2.new(0,38,0,38)
            }):Play()
            TweenService:Create(textLabel,TweenInfo.new(0.2),{
                TextColor3=colors.textSecondary
            }):Play()
        end
    end)
    
    navButtons[page] = {
        btn=btn,
        iconBg=iconBg,
        icon=iconLabel,
        text=textLabel,
        indicator=indicator,
        stroke=btnStroke,
        color=accentColor
    }
    
    return btn
end

-- Content Area with Glass Effect
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-150,1,-70),
    Position=UDim2.new(0,150,0,70),
    BackgroundColor3=colors.glassBg,
    BackgroundTransparency=0.45,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=5
})

-- Content Background Gradient
local contentGradient = new("UIGradient",{
    Parent=contentBg,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,23)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12,12,14))
    }),
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 0.3)
    }),
    Rotation=135
})

-- Pages
local pages = {}
local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        ScrollBarThickness=5,
        ScrollBarImageColor3=colors.primary,
        ScrollBarImageTransparency=0.5,
        BorderSizePixel=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false,
        ClipsDescendants=true,
        ZIndex=6
    })
    new("UIListLayout",{
        Parent=page,
        Padding=UDim.new(0,14),
        HorizontalAlignment=Enum.HorizontalAlignment.Center
    })
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0,20),
        PaddingBottom=UDim.new(0,20),
        PaddingLeft=UDim.new(0,18),
        PaddingRight=UDim.new(0,18)
    })
    pages[name] = page
    return page
end

local mainPage = createPage("Main")
local teleportPage = createPage("Teleport")
local shopPage = createPage("Shop")
local settingsPage = createPage("Settings")
local infoPage = createPage("Info")
mainPage.Visible = true

-- Page Switching with Smooth Animation
local function switchPage(pageName)
    if currentPage == pageName then return end
    
    local currentPageFrame = pages[currentPage]
    local newPageFrame = pages[pageName]
    
    -- Fade out current
    TweenService:Create(currentPageFrame,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
        Position=UDim2.new(0,-30,0,0)
    }):Play()
    
    task.wait(0.15)
    currentPageFrame.Visible = false
    currentPageFrame.Position = UDim2.new(0,0,0,0)
    
    -- Update nav buttons
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        
        TweenService:Create(btnData.btn,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            BackgroundColor3 = isActive and colors.glassCard or Color3.fromRGB(0,0,0),
            BackgroundTransparency = isActive and 0.25 or 1
        }):Play()
        
        TweenService:Create(btnData.iconBg,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            BackgroundColor3 = isActive and btnData.color or colors.glassOverlay,
            BackgroundTransparency = isActive and 0.85 or 0.4,
            Size = isActive and UDim2.new(0,40,0,40) or UDim2.new(0,38,0,38)
        }):Play()
        
        TweenService:Create(btnData.icon,TweenInfo.new(0.3),{
            TextColor3 = isActive and btnData.color or colors.textSecondary
        }):Play()
        
        TweenService:Create(btnData.text,TweenInfo.new(0.3),{
            TextColor3 = isActive and colors.text or colors.textSecondary
        }):Play()
        
        btnData.indicator.Visible = isActive
        
        if isActive then
            if not btnData.stroke then
                btnData.stroke = new("UIStroke",{
                    Parent=btnData.btn,
                    Color=btnData.color,
                    Thickness=1,
                    Transparency=1,
                    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
                })
            end
            TweenService:Create(btnData.stroke,TweenInfo.new(0.3),{Transparency=0.6}):Play()
        elseif btnData.stroke then
            TweenService:Create(btnData.stroke,TweenInfo.new(0.3),{Transparency=1}):Play()
        end
    end
    
    -- Fade in new page
    newPageFrame.Position = UDim2.new(0,30,0,0)
    newPageFrame.Visible = true
    TweenService:Create(newPageFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
        Position=UDim2.new(0,0,0,0)
    }):Play()
    
    currentPage = pageName
end

-- Create Navigation with Accent Colors
local btnMain = createNavButton("Main", "🏠", "Main", colors.primary)
local btnTeleport = createNavButton("Teleport", "⚡", "Teleport", colors.teal)
local btnShop = createNavButton("Shop", "🛒", "Shop", colors.orange)
local btnSettings = createNavButton("Settings", "⚙️", "Settings", colors.purple)
local btnInfo = createNavButton("Info", "ℹ️", "Info", colors.pink)

btnMain.MouseButton1Click:Connect(function() switchPage("Main") end)
btnTeleport.MouseButton1Click:Connect(function() switchPage("Teleport") end)
btnShop.MouseButton1Click:Connect(function() switchPage("Shop") end)
btnSettings.MouseButton1Click:Connect(function() switchPage("Settings") end)
btnInfo.MouseButton1Click:Connect(function() switchPage("Info") end)

-- Premium Category Creation
local function createCategory(parent, title, accentColor)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,0),
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.35,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=7
    })
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,16)})
    
    -- Glass stroke
    new("UIStroke",{
        Parent=categoryFrame,
        Color=Color3.fromRGB(255,255,255),
        Thickness=1,
        Transparency=0.9,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    -- Accent border on left
    local accentBorder = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(0,3,1,0),
        Position=UDim2.new(0,0,0,0),
        BackgroundColor3=accentColor or colors.primary,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=accentBorder,CornerRadius=UDim.new(0,16)})
    
    -- Header Button
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,0,56),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=8
    })
    
    -- Title with Icon
    local titleContainer = new("Frame",{
        Parent=header,
        Size=UDim2.new(1,-70,1,0),
        Position=UDim2.new(0,20,0,0),
        BackgroundTransparency=1,
        ZIndex=9
    })
    
    new("TextLabel",{
        Parent=titleContainer,
        Text=title,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=15,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=10
    })
    
    -- Arrow Indicator
    local arrowBg = new("Frame",{
        Parent=header,
        Size=UDim2.new(0,32,0,32),
        Position=UDim2.new(1,-48,0.5,-16),
        BackgroundColor3=colors.glassOverlay,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=arrowBg,CornerRadius=UDim.new(0,8)})
    
    local arrow = new("TextLabel",{
        Parent=arrowBg,
        Text="›",
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=20,
        TextColor3=colors.textTertiary,
        Rotation=0,
        ZIndex=10
    })
    
    -- Separator
    local separator = new("Frame",{
        Parent=header,
        Size=UDim2.new(1,-40,0,1),
        Position=UDim2.new(0,20,1,-1),
        BackgroundColor3=colors.separator,
        BackgroundTransparency=0.6,
        BorderSizePixel=0,
        ZIndex=9
    })
    
    -- Content Container
    local container = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1,-36,0,0),
        Position=UDim2.new(0,18,0,56),
        BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y,
        Visible=false,
        ZIndex=8
    })
    new("UIListLayout",{Parent=container,Padding=UDim.new(0,12)})
    new("UIPadding",{Parent=container,PaddingBottom=UDim.new(0,18)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        container.Visible = isOpen
        separator.Visible = not isOpen
        
        TweenService:Create(arrow,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            Rotation = isOpen and 90 or 0,
            TextColor3 = isOpen and (accentColor or colors.primary) or colors.textTertiary
        }):Play()
        
        TweenService:Create(arrowBg,TweenInfo.new(0.3),{
            BackgroundColor3 = isOpen and (accentColor or colors.primary) or colors.glassOverlay,
            BackgroundTransparency = isOpen and 0.85 or 0.4
        }):Play()
        
        TweenService:Create(accentBorder,TweenInfo.new(0.3),{
            BackgroundTransparency = isOpen and 0.1 or 0.3
        }):Play()
    end)
    
    return container
end

-- Premium Toggle Switch
local function makeToggle(parent, label, callback, accentColor)
    accentColor = accentColor or colors.primary
    
    local f = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,46),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    new("TextLabel",{
        Parent=f,
        Text=label,
        Size=UDim2.new(0.62,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=13,
        TextWrapped=true,
        ZIndex=8
    })
    
    local toggleBg = new("Frame",{
        Parent=f,
        Size=UDim2.new(0,52,0,30),
        Position=UDim2.new(1,-54,0.5,-15),
        BackgroundColor3=colors.glassOverlay,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=toggleBg,CornerRadius=UDim.new(1,0)})
    
    local toggleStroke = new("UIStroke",{
        Parent=toggleBg,
        Color=colors.border,
        Thickness=1.5,
        Transparency=0.6,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local toggleCircle = new("Frame",{
        Parent=toggleBg,
        Size=UDim2.new(0,24,0,24),
        Position=UDim2.new(0,3,0.5,-12),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=toggleCircle,CornerRadius=UDim.new(1,0)})
    
    -- Circle shadow
    new("UIStroke",{
        Parent=toggleCircle,
        Color=Color3.fromRGB(0,0,0),
        Thickness=0.5,
        Transparency=0.9,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
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
        
        TweenService:Create(toggleBg,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            BackgroundColor3 = on and accentColor or colors.glassOverlay,
            BackgroundTransparency = on and 0.15 or 0.2
        }):Play()
        
        TweenService:Create(toggleStroke,TweenInfo.new(0.3),{
            Color = on and accentColor or colors.border,
            Transparency = on and 0.3 or 0.6
        }):Play()
        
        TweenService:Create(toggleCircle,TweenInfo.new(0.35,Enum.EasingStyle.Quart),{
            Position = on and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12),
            Size = on and UDim2.new(0,26,0,26) or UDim2.new(0,24,0,24)
        }):Play()
        
        task.wait(0.15)
        TweenService:Create(toggleCircle,TweenInfo.new(0.2,Enum.EasingStyle.Back),{
            Size = UDim2.new(0,24,0,24)
        }):Play()
        
        callback(on)
    end)
end

-- Premium Slider
local function makeSlider(parent, label, min, max, def, onChange, accentColor)
    accentColor = accentColor or colors.primary
    
    local f = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,64),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local headerFrame = new("Frame",{
        Parent=f,
        Size=UDim2.new(1,0,0,22),
        BackgroundTransparency=1,
        ZIndex=8
    })
    
    new("TextLabel",{
        Parent=headerFrame,
        Text=label,
        Size=UDim2.new(1,-70,1,0),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamBold,
        TextSize=12,
        ZIndex=9
    })
    
    local valueBg = new("Frame",{
        Parent=headerFrame,
        Size=UDim2.new(0,60,0,26),
        Position=UDim2.new(1,-62,0,-2),
        BackgroundColor3=accentColor,
        BackgroundTransparency=0.9,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=valueBg,CornerRadius=UDim.new(0,8)})
    new("UIStroke",{
        Parent=valueBg,
        Color=accentColor,
        Thickness=1,
        Transparency=0.5,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local valueLabel = new("TextLabel",{
        Parent=valueBg,
        Text=string.format("%.2f",def),
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        TextColor3=accentColor,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        ZIndex=10
    })
    
    local bar = new("Frame",{
        Parent=f,
        Size=UDim2.new(1,0,0,6),
        Position=UDim2.new(0,0,0,36),
        BackgroundColor3=colors.glassOverlay,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(1,0)})
    
    local fill = new("Frame",{
        Parent=bar,
        Size=UDim2.new((def-min)/(max-min),0,1,0),
        BackgroundColor3=accentColor,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(1,0)})
    
    -- Fill glow effect
    local fillGlow = new("Frame",{
        Parent=fill,
        Size=UDim2.new(1,0,1,4),
        Position=UDim2.new(0,0,0,-2),
        BackgroundColor3=accentColor,
        BackgroundTransparency=0.7,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=fillGlow,CornerRadius=UDim.new(1,0)})
    
    local knob = new("Frame",{
        Parent=bar,
        Size=UDim2.new(0,20,0,20),
        Position=UDim2.new((def-min)/(max-min),-10,0.5,-10),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BorderSizePixel=0,
        ZIndex=10
    })
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    new("UIStroke",{
        Parent=knob,
        Color=accentColor,
        Thickness=2,
        Transparency=0.3,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    -- Knob shadow
    local knobShadow = new("Frame",{
        Parent=knob,
        Size=UDim2.new(1,8,1,8),
        Position=UDim2.new(0,-4,0,-4),
        BackgroundColor3=accentColor,
        BackgroundTransparency=0.8,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=knobShadow,CornerRadius=UDim.new(1,0)})
    
    local dragging = false
    local function update(x)
        local rel = math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        local val = min+(max-min)*rel
        fill.Size = UDim2.new(rel,0,1,0)
        knob.Position = UDim2.new(rel,-10,0.5,-10)
        valueLabel.Text = string.format("%.2f",val)
        onChange(val)
    end
    
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            update(i.Position.X)
            TweenService:Create(knob,TweenInfo.new(0.15,Enum.EasingStyle.Back),{
                Size=UDim2.new(0,26,0,26)
            }):Play()
            TweenService:Create(knobShadow,TweenInfo.new(0.15),{
                Size=UDim2.new(1,16,1,16),
                Position=UDim2.new(0,-8,0,-8),
                BackgroundTransparency=0.6
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            update(i.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(knob,TweenInfo.new(0.15,Enum.EasingStyle.Back),{
                Size=UDim2.new(0,20,0,20)
            }):Play()
            TweenService:Create(knobShadow,TweenInfo.new(0.15),{
                Size=UDim2.new(1,8,1,8),
                Position=UDim2.new(0,-4,0,-4),
                BackgroundTransparency=0.8
            }):Play()
        end
    end)
end

-- Premium Dropdown
local function makeDropdown(parent, title, items, onSelect, accentColor)
    accentColor = accentColor or colors.primary
    local selectedItem = nil
    
    local dropdownFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,48),
        BackgroundColor3=colors.glassOverlay,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=7
    })
    new("UICorner",{Parent=dropdownFrame,CornerRadius=UDim.new(0,14)})
    new("UIStroke",{
        Parent=dropdownFrame,
        Color=Color3.fromRGB(255,255,255),
        Thickness=1,
        Transparency=0.9,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local header = new("TextButton",{
        Parent=dropdownFrame,
        Size=UDim2.new(1,0,0,48),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=8
    })
    
    new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-110,1,0),
        Position=UDim2.new(0,16,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=13,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local selectedLabel = new("TextLabel",{
        Parent=header,
        Text="None",
        Size=UDim2.new(0,70,1,0),
        Position=UDim2.new(1,-110,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=colors.textSecondary,
        TextXAlignment=Enum.TextXAlignment.Right,
        TextTruncate=Enum.TextTruncate.AtEnd,
        ZIndex=9
    })
    
    local arrowBg = new("Frame",{
        Parent=header,
        Size=UDim2.new(0,32,0,32),
        Position=UDim2.new(1,-40,0.5,-16),
        BackgroundColor3=colors.glassOverlay,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=arrowBg,CornerRadius=UDim.new(0,8)})
    
    local arrow = new("TextLabel",{
        Parent=arrowBg,
        Text="›",
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextColor3=colors.textTertiary,
        Rotation=0,
        ZIndex=10
    })
    
    local listContainer = new("ScrollingFrame",{
        Parent=dropdownFrame,
        Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,0,48),
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.2,
        Visible=false,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=UDim2.new(0,0,0,0),
        ScrollBarThickness=4,
        ScrollBarImageColor3=accentColor,
        ScrollBarImageTransparency=0.5,
        BorderSizePixel=0,
        ClipsDescendants=true,
        ZIndex=11
    })
    new("UIListLayout",{Parent=listContainer,Padding=UDim.new(0,0)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            Rotation = isOpen and 90 or 0,
            TextColor3 = isOpen and accentColor or colors.textTertiary
        }):Play()
        
        TweenService:Create(arrowBg,TweenInfo.new(0.25),{
            BackgroundColor3 = isOpen and accentColor or colors.glassOverlay,
            BackgroundTransparency = isOpen and 0.85 or 0.3
        }):Play()
        
        if isOpen then
            local maxHeight = math.min(#items * 44, 220)
            TweenService:Create(listContainer,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
                Size=UDim2.new(1,0,0,maxHeight)
            }):Play()
        else
            TweenService:Create(listContainer,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
                Size=UDim2.new(1,0,0,0)
            }):Play()
        end
    end)
    
    for index, itemName in ipairs(items) do
        local isLastItem = index == #items
        local itemBtn = new("TextButton",{
            Parent=listContainer,
            Size=UDim2.new(1,0,0,44),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            Text="",
            AutoButtonColor=false,
            ZIndex=12
        })
        
        new("TextLabel",{
            Parent=itemBtn,
            Text=itemName,
            Size=UDim2.new(1,-56,1,0),
            Position=UDim2.new(0,16,0,0),
            BackgroundTransparency=1,
            Font=Enum.Font.GothamMedium,
            TextSize=12,
            TextColor3=colors.text,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
            ZIndex=13
        })
        
        local checkBg = new("Frame",{
            Parent=itemBtn,
            Size=UDim2.new(0,24,0,24),
            Position=UDim2.new(1,-36,0.5,-12),
            BackgroundColor3=accentColor,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ZIndex=13
        })
        new("UICorner",{Parent=checkBg,CornerRadius=UDim.new(0,6)})
        
        local checkIcon = new("TextLabel",{
            Parent=checkBg,
            Text="✓",
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            Font=Enum.Font.GothamBold,
            TextSize=14,
            TextColor3=Color3.fromRGB(255,255,255),
            Visible=false,
            ZIndex=14
        })
        
        if not isLastItem then
            new("Frame",{
                Parent=itemBtn,
                Size=UDim2.new(1,-32,0,1),
                Position=UDim2.new(0,16,1,-1),
                BackgroundColor3=colors.separator,
                BackgroundTransparency=0.7,
                BorderSizePixel=0,
                ZIndex=13
            })
        end
        
        itemBtn.MouseEnter:Connect(function()
            TweenService:Create(itemBtn,TweenInfo.new(0.15),{
                BackgroundTransparency=0.9,
                BackgroundColor3=accentColor
            }):Play()
        end)
        
        itemBtn.MouseLeave:Connect(function()
            TweenService:Create(itemBtn,TweenInfo.new(0.15),{
                BackgroundTransparency=1
            }):Play()
        end)
        
        itemBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(listContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    for _, c in ipairs(child:GetChildren()) do
                        if c:IsA("Frame") and c.Name ~= "Frame" then
                            c.BackgroundTransparency = 1
                            for _, icon in ipairs(c:GetChildren()) do
                                if icon:IsA("TextLabel") then
                                    icon.Visible = false
                                end
                            end
                        end
                    end
                end
            end
            
            selectedItem = itemName
            checkBg.BackgroundTransparency = 0.15
            checkIcon.Visible = true
            selectedLabel.Text = itemName
            
            TweenService:Create(selectedLabel,TweenInfo.new(0.25),{
                TextColor3 = accentColor
            }):Play()
            
            TweenService:Create(checkBg,TweenInfo.new(0.2,Enum.EasingStyle.Back),{
                Size = UDim2.new(0,28,0,28),
                Position = UDim2.new(1,-38,0.5,-14)
            }):Play()
            
            task.wait(0.1)
            TweenService:Create(checkBg,TweenInfo.new(0.15),{
                Size = UDim2.new(0,24,0,24),
                Position = UDim2.new(1,-36,0.5,-12)
            }):Play()
            
            onSelect(itemName)
            
            task.wait(0.15)
            isOpen = false
            listContainer.Visible = false
            
            TweenService:Create(listContainer,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
                Size=UDim2.new(1,0,0,0)
            }):Play()
            
            TweenService:Create(arrow,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
                Rotation=0,
                TextColor3=colors.textTertiary
            }):Play()
            
            TweenService:Create(arrowBg,TweenInfo.new(0.25),{
                BackgroundColor3=colors.glassOverlay,
                BackgroundTransparency=0.3
            }):Play()
        end)
    end
    
    return dropdownFrame
end

-- Premium Button
local function makeButton(parent, label, callback, accentColor)
    accentColor = accentColor or colors.primary
    
    local btnFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,48),
        BackgroundColor3=accentColor,
        BackgroundTransparency=0.15,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=btnFrame,CornerRadius=UDim.new(0,14)})
    
    local btnStroke = new("UIStroke",{
        Parent=btnFrame,
        Color=accentColor,
        Thickness=1.5,
        Transparency=0.4,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    -- Button glow
    local btnGlow = new("Frame",{
        Parent=btnFrame,
        Size=UDim2.new(1,4,1,4),
        Position=UDim2.new(0,-2,0,-2),
        BackgroundColor3=accentColor,
        BackgroundTransparency=0.8,
        BorderSizePixel=0,
        ZIndex=6
    })
    new("UICorner",{Parent=btnGlow,CornerRadius=UDim.new(0,16)})
    
    local button = new("TextButton",{
        Parent=btnFrame,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=label,
        Font=Enum.Font.GothamBold,
        TextSize=14,
        TextColor3=Color3.fromRGB(255,255,255),
        AutoButtonColor=false,
        ZIndex=8
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
            BackgroundTransparency=0.05,
            Size=UDim2.new(1,0,0,50)
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.2),{
            Transparency=0.2
        }):Play()
        TweenService:Create(btnGlow,TweenInfo.new(0.2),{
            BackgroundTransparency=0.6,
            Size=UDim2.new(1,8,1,8),
            Position=UDim2.new(0,-4,0,-4)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
            BackgroundTransparency=0.15,
            Size=UDim2.new(1,0,0,48)
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.2),{
            Transparency=0.4
        }):Play()
        TweenService:Create(btnGlow,TweenInfo.new(0.2),{
            BackgroundTransparency=0.8,
            Size=UDim2.new(1,4,1,4),
            Position=UDim2.new(0,-2,0,-2)
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.08),{
            Size=UDim2.new(1,0,0,44)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.12,Enum.EasingStyle.Back),{
            Size=UDim2.new(1,0,0,48)
        }):Play()
        pcall(callback)
    end)
    
    return btnFrame
end

-- CONTENT SECTIONS

-- Main Page
local autoFishingCat = createCategory(mainPage, "Auto Fishing", colors.primary)
local instantContainer = new("Frame",{
    Parent=autoFishingCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=instantContainer,Padding=UDim.new(0,12)})

local selectedInstantMode = "Fast"
local instantActive = false

makeDropdown(instantContainer, "Instant Fishing Mode", {"Fast", "Perfect"}, function(mode)
    selectedInstantMode = mode
    if instantActive then
        instant.Stop()
        instant2.Stop()
    end
end, colors.primary)

makeToggle(instantContainer, "Enable Instant Fishing", function(on)
    instantActive = on
    if on then
        if selectedInstantMode == "Fast" then
            instant.Start()
            instant2.Stop()
        else
            instant2.Start()
            instant.Stop()
        end
    else
        instant.Stop()
        instant2.Stop()
    end
end, colors.primary)

makeSlider(instantContainer, "Fishing Delay", 0.01, 5.0, 1.30, function(v)
    instant.Settings.MaxWaitTime = v
    instant2.Settings.MaxWaitTime = v
end, colors.primary)

makeSlider(instantContainer, "Cancel Delay", 0.01, 1.5, 0.19, function(v)
    instant.Settings.CancelDelay = v
    instant2.Settings.CancelDelay = v
end, colors.primary)

local blatantCat = createCategory(mainPage, "Blatant Mode", colors.danger)
local blatantContainer = new("Frame",{
    Parent=blatantCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=blatantContainer,Padding=UDim.new(0,12)})

makeToggle(blatantContainer, "Enable Extreme Blatant", function(on)
    if on then BlatantAutoFishing.Start() else BlatantAutoFishing.Stop() end
end, colors.danger)

makeToggle(blatantContainer, "Instant Catch", function(on)
    BlatantAutoFishing.Settings.InstantCatch = on
end, colors.danger)

makeToggle(blatantContainer, "Auto Complete", function(on)
    BlatantAutoFishing.Settings.AutoComplete = on
end, colors.danger)

makeSlider(blatantContainer, "Spam Rate", 0.001, 0.1, 0.001, function(v)
    BlatantAutoFishing.Settings.SpamRate = v
end, colors.danger)

local supportCat = createCategory(mainPage, "Support Features", colors.success)
local supportContainer = new("Frame",{
    Parent=supportCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=supportContainer,Padding=UDim.new(0,12)})

makeToggle(supportContainer, "Manual Capture (2s Delay)", function(on)
    if on then NoFishingAnimation.StartWithDelay() else NoFishingAnimation.Stop() end
end, colors.success)

-- Teleport Page
local locationItems = {}
for name, _ in pairs(TeleportModule.Locations) do
    table.insert(locationItems, name)
end
table.sort(locationItems)

local teleportLocationCat = createCategory(teleportPage, "Location Teleport", colors.teal)
makeDropdown(teleportLocationCat, "Select Location", locationItems, function(loc)
    TeleportModule.TeleportTo(loc)
end, colors.teal)

local playerItems = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        table.insert(playerItems, player.Name)
    end
end
table.sort(playerItems)

local teleportPlayerCat = createCategory(teleportPage, "Player Teleport", colors.info)
local playerDropdown = makeDropdown(teleportPlayerCat, "Select Player", playerItems, function(p)
    TeleportToPlayer.TeleportTo(p)
end, colors.info)

local function refreshPlayerList()
    if playerDropdown then playerDropdown:Destroy() end
    table.clear(playerItems)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerItems, player.Name)
        end
    end
    table.sort(playerItems)
    playerDropdown = makeDropdown(teleportPlayerCat, "Select Player", playerItems, function(p)
        TeleportToPlayer.TeleportTo(p)
    end, colors.info)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Shop Page
local autoSellCat = createCategory(shopPage, "Auto Sell System", colors.orange)
local sellContainer = new("Frame",{
    Parent=autoSellCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=sellContainer,Padding=UDim.new(0,12)})

makeButton(sellContainer, "Sell All Items Now", function()
    if AutoSell and AutoSell.SellOnce then
        AutoSell.SellOnce()
    end
end, colors.orange)

local timerCat = createCategory(shopPage, "Auto Sell Timer", colors.warning)
local timerContainer = new("Frame",{
    Parent=timerCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=timerContainer,Padding=UDim.new(0,12)})

makeSlider(timerContainer, "Sell Interval (Seconds)", 1, 60, 5, function(v)
    AutoSellTimer.SetInterval(v)
end, colors.warning)

makeButton(timerContainer, "Start Auto Sell Timer", function()
    if AutoSellTimer then
        AutoSellTimer.Start(AutoSellTimer.Interval)
    end
end, colors.success)

makeButton(timerContainer, "Stop Auto Sell Timer", function()
    if AutoSellTimer then
        AutoSellTimer.Stop()
    end
end, colors.danger)

local weatherCat = createCategory(shopPage, "Auto Buy Weather", colors.teal)
local weatherContainer = new("Frame",{
    Parent=weatherCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=weatherContainer,Padding=UDim.new(0,12)})

local selectedWeathers = {}
makeDropdown(weatherContainer, "Select Weather Types", AutoBuyWeather.AllWeathers, function(w)
    local idx = table.find(selectedWeathers, w)
    if idx then
        table.remove(selectedWeathers, idx)
    else
        table.insert(selectedWeathers, w)
    end
    AutoBuyWeather.SetSelected(selectedWeathers)
end, colors.teal)

makeToggle(weatherContainer, "Enable Auto Weather Purchase", function(on)
    if on then AutoBuyWeather.Start() else AutoBuyWeather.Stop() end
end, colors.teal)

-- Settings Page
local generalCat = createCategory(settingsPage, "General Settings", colors.purple)
local generalContainer = new("Frame",{
    Parent=generalCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=generalContainer,Padding=UDim.new(0,12)})

makeToggle(generalContainer, "Auto Save Settings", function(on) end, colors.purple)
makeToggle(generalContainer, "Show Notifications", function(on) end, colors.purple)
makeToggle(generalContainer, "Performance Mode", function(on) end, colors.purple)

local afkCat = createCategory(settingsPage, "Anti-AFK System", colors.info)
local afkContainer = new("Frame",{
    Parent=afkCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=afkContainer,Padding=UDim.new(0,12)})

makeToggle(afkContainer, "Enable Anti-AFK Protection", function(on)
    if on then AntiAFK.Start() else AntiAFK.Stop() end
end, colors.info)

local fpsCat = createCategory(settingsPage, "FPS Unlocker", colors.success)
local fpsContainer = new("Frame",{
    Parent=fpsCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UIListLayout",{Parent=fpsContainer,Padding=UDim.new(0,12)})

makeDropdown(fpsContainer, "FPS Limit", {"60 FPS", "90 FPS", "120 FPS", "240 FPS"}, function(s)
    local fps = tonumber(s:match("%d+"))
    if fps and UnlockFPS and UnlockFPS.SetCap then
        UnlockFPS.SetCap(fps)
    end
end, colors.success)

-- Info Page
local infoCard = new("Frame",{
    Parent=infoPage,
    Size=UDim2.new(1,0,0,0),
    BackgroundColor3=colors.glassCard,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UICorner",{Parent=infoCard,CornerRadius=UDim.new(0,18)})
new("UIStroke",{
    Parent=infoCard,
    Color=Color3.fromRGB(255,255,255),
    Thickness=1,
    Transparency=0.9,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Info gradient background
local infoGradient = new("UIGradient",{
    Parent=infoCard,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(0.5, colors.purple),
        ColorSequenceKeypoint.new(1, colors.pink)
    }),
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.95),
        NumberSequenceKeypoint.new(1, 0.85)
    }),
    Rotation=45
})

local infoText = new("TextLabel",{
    Parent=infoCard,
    Size=UDim2.new(1,-40,0,0),
    Position=UDim2.new(0,20,0,20),
    BackgroundTransparency=1,
    Text=[[✨ LYNX v4.0 PREMIUM EDITION

🎨 ULTRA MODERN DESIGN
• iOS-inspired glassmorphism
• Smooth animations & transitions
• Accent colors per category
• Premium glass effects

⚡ CORE FEATURES
• Auto Fishing (Fast/Perfect modes)
• Blatant fishing with instant catch
• Location & Player teleportation
• Auto Sell with smart timer
• Weather totem auto-purchase
• Anti-AFK protection
• FPS unlocker (up to 240 FPS)

🎯 OPTIMIZED SETTINGS
• Fishing Delay: 1.30s (recommended)
• Cancel Delay: 0.19s (recommended)
• Auto Sell Interval: 5-10s

💎 DESIGN HIGHLIGHTS
• Ultra-transparent windows
• Animated gradients & glows
• Color-coded categories
• Frosted glass sidebar
• Premium iOS aesthetics

🦊 Made with ❤️ by Lynx Team
© 2024 - All Rights Reserved]],
    Font=Enum.Font.Gotham,
    TextSize=12,
    TextColor3=colors.text,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    AutomaticSize=Enum.AutomaticSize.Y,
    LineHeight=1.35,
    ZIndex=8
})

new("UIPadding",{
    Parent=infoCard,
    PaddingTop=UDim.new(0,20),
    PaddingBottom=UDim.new(0,20),
    PaddingLeft=UDim.new(0,20),
    PaddingRight=UDim.new(0,20)
})

-- Minimized Icon - Premium Design
local minimized = false
local icon
local savedIconPos = UDim2.new(0,20,0,100)

local function createMinimizedIcon()
    if icon then return end
    
    icon = new("Frame",{
        Parent=gui,
        Size=UDim2.new(0,56,0,56),
        Position=savedIconPos,
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,16)})
    
    new("UIStroke",{
        Parent=icon,
        Color=colors.primary,
        Thickness=2,
        Transparency=0.4,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    -- Icon glow
    local iconGlow = new("Frame",{
        Parent=icon,
        Size=UDim2.new(1,20,1,20),
        Position=UDim2.new(0,-10,0,-10),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.85,
        BorderSizePixel=0,
        ZIndex=99
    })
    new("UICorner",{Parent=iconGlow,CornerRadius=UDim.new(0,22)})
    
    -- Pulsing animation
    task.spawn(function()
        while icon and icon.Parent do
            TweenService:Create(iconGlow,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{
                BackgroundTransparency=0.95,
                Size=UDim2.new(1,26,1,26),
                Position=UDim2.new(0,-13,0,-13)
            }):Play()
            task.wait(1.5)
        end
    end)
    
    local iconLabel = new("TextLabel",{
        Parent=icon,
        Text="L",
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=28,
        TextColor3=colors.primary,
        ZIndex=101
    })
    
    -- Icon gradient
    local iconGradient = new("UIGradient",{
        Parent=iconLabel,
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.teal)
        }),
        Rotation=45
    })
    
    local dragging, dragStart, startPos, dragMoved = false, nil, nil, false
    
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragMoved, dragStart, startPos = true, false, input.Position, icon.Position
            TweenService:Create(icon,TweenInfo.new(0.15,Enum.EasingStyle.Back),{
                Size=UDim2.new(0,52,0,52)
            }):Play()
        end
    end)
    
    icon.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.sqrt(delta.X^2 + delta.Y^2) > 5 then
                dragMoved = true
            end
            icon.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    icon.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                TweenService:Create(icon,TweenInfo.new(0.15,Enum.EasingStyle.Back),{
                    Size=UDim2.new(0,56,0,56)
                }):Play()
                
                dragging = false
                savedIconPos = icon.Position
                
                if not dragMoved then
                    win.Visible = true
                    blur.Visible = true
                    
                    TweenService:Create(blur,TweenInfo.new(0.35,Enum.EasingStyle.Quad),{
                        BackgroundTransparency=0.2
                    }):Play()
                    
                    win.Size = UDim2.new(0,440,0,380)
                    win.BackgroundTransparency = 1
                    
                    TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back),{
                        BackgroundTransparency=0.25,
                        Size=UDim2.new(0,480,0,420)
                    }):Play()
                    
                    task.wait(0.4)
                    if icon then
                        icon:Destroy()
                        icon = nil
                    end
                    minimized = false
                end
            end
        end
    end)
end

-- Control Button Actions
btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(win,TweenInfo.new(0.35,Enum.EasingStyle.Quad),{
            BackgroundTransparency=1,
            Size=UDim2.new(0,440,0,380)
        }):Play()
        
        TweenService:Create(blur,TweenInfo.new(0.35,Enum.EasingStyle.Quad),{
            BackgroundTransparency=1
        }):Play()
        
        task.wait(0.35)
        win.Visible = false
        blur.Visible = false
        win.BackgroundTransparency = 0.25
        win.Size = UDim2.new(0,480,0,420)
        
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win,TweenInfo.new(0.35,Enum.EasingStyle.Quad),{
        BackgroundTransparency=1,
        Size=UDim2.new(0,440,0,380)
    }):Play()
    
    TweenService:Create(blur,TweenInfo.new(0.35,Enum.EasingStyle.Quad),{
        BackgroundTransparency=1
    }):Play()
    
    task.wait(0.35)
    gui:Destroy()
end)

-- Window Dragging
local dragging, dragStart, startPos = false, nil, nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, win.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        win.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Startup Animation
task.spawn(function()
    win.BackgroundTransparency = 1
    win.Size = UDim2.new(0,420,0,360)
    blur.BackgroundTransparency = 1
    blur.Visible = true
    
    task.wait(0.15)
    
    TweenService:Create(blur,TweenInfo.new(0.5,Enum.EasingStyle.Quad),{
        BackgroundTransparency=0.2
    }):Play()
    
    TweenService:Create(win,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        BackgroundTransparency=0.25,
        Size=UDim2.new(0,480,0,420)
    }):Play()
    
    -- Animate sidebar buttons
    task.wait(0.4)
    for i, btnData in pairs(navButtons) do
        btnData.btn.Size = UDim2.new(0,0,0,52)
        btnData.btn.BackgroundTransparency = 1
        task.spawn(function()
            local delays = {Main=0, Teleport=0.06, Shop=0.12, Settings=0.18, Info=0.24}
            task.wait(delays[i] or 0)
            TweenService:Create(btnData.btn,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Size=UDim2.new(1,0,0,52),
                BackgroundTransparency=(currentPage == i) and 0.25 or 1
            }):Play()
        end)
    end
end)

-- Window breathing animation
task.spawn(function()
    while win and win.Parent do
        local stroke = win:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke,TweenInfo.new(2.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{
                Transparency=0.9
            }):Play()
        end
        task.wait(2.5)
    end
end)

print("✓ LYNX GUI v4.0 - PREMIUM iOS EDITION LOADED")
print("✓ Ultra Modern Design | Glassmorphism | Smooth Animations")
print("✓ Window: 480x420 | Icon: 56x56 | Transparent: 25%")
print("✓ Optimized for Mobile & Desktop | iOS Aesthetic")
