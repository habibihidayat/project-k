-- LynxGUI_v2.3.lua - Galaxy Edition FIXED
-- BAGIAN 1: Setup, Core Functions, Window Structure
-- FREE NOT FOR SALE

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

repeat task.wait() until localPlayer:FindFirstChild("PlayerGui")

-- Detect if mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

-- Load modules
local instant = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant.lua"))()
local instant2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant2.lua"))()
local blatantv1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/BlatantV1.lua"))()
local blatantv2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/BlatantV2.lua"))()
local NoFishingAnimation = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/NoFishingAnimation.lua"))()
local TeleportModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportModule.lua"))()
local TeleportToPlayer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportSystem/TeleportToPlayer.lua"))()
local AutoSell = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSell.lua"))()
local AutoSellTimer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSellTimer.lua"))()
local AntiAFK = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/AntiAFK.lua"))()
local UnlockFPS = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/UnlockFPS.lua"))()
local AutoBuyWeather = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoBuyWeather.lua"))()

-- Galaxy Color Palette
local colors = {
    primary = Color3.fromRGB(138, 43, 226),       -- Purple
    secondary = Color3.fromRGB(147, 112, 219),    -- Medium purple
    accent = Color3.fromRGB(186, 85, 211),        -- Orchid
    galaxy1 = Color3.fromRGB(123, 104, 238),      -- Medium slate blue
    galaxy2 = Color3.fromRGB(72, 61, 139),        -- Dark slate blue
    success = Color3.fromRGB(34, 197, 94),        -- Green
    warning = Color3.fromRGB(251, 191, 36),       -- Amber
    danger = Color3.fromRGB(239, 68, 68),         -- Red
    
    bg1 = Color3.fromRGB(10, 10, 10),             -- Deep black
    bg2 = Color3.fromRGB(18, 18, 18),             -- Dark gray
    bg3 = Color3.fromRGB(25, 25, 25),             -- Medium gray
    bg4 = Color3.fromRGB(35, 35, 35),             -- Light gray
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(180, 180, 180),
    textDimmer = Color3.fromRGB(120, 120, 120),
    
    border = Color3.fromRGB(50, 50, 50),
    glow = Color3.fromRGB(138, 43, 226),
}

-- Compact Window Size
local windowSize = UDim2.new(0, 450, 0, 300)
local minWindowSize = Vector2.new(400, 260)
local maxWindowSize = Vector2.new(600, 450)

-- Sidebar state (Always expanded)
local sidebarWidth = 145

local gui = new("ScreenGui",{
    Name="LynxGUI_Galaxy",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Main Window Container - ULTRA TRANSPARENT
local win = new("Frame",{
    Parent=gui,
    Size=windowSize,
    Position=UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
    BackgroundColor3=colors.bg1,
    BackgroundTransparency=0.25,  -- Lebih transparan dari 0.15
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win, CornerRadius=UDim.new(0, 12)})

-- Subtle outer glow
new("UIStroke",{
    Parent=win,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.9,  -- Lebih subtle
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Inner shadow effect
local innerShadow = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, -2, 1, -2),
    Position=UDim2.new(0, 1, 0, 1),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ZIndex=2
})
new("UICorner",{Parent=innerShadow, CornerRadius=UDim.new(0, 11)})
new("UIStroke",{
    Parent=innerShadow,
    Color=Color3.fromRGB(0, 0, 0),
    Thickness=1,
    Transparency=0.8  -- Lebih subtle
})

-- Script Header (INSIDE window, at the top) - ULTRA TRANSPARENT
local scriptHeader = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, 0, 0, 48),
    Position=UDim2.new(0, 0, 0, 0),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.7,  -- Lebih transparan
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=scriptHeader, CornerRadius=UDim.new(0, 12)})

-- Subtle gradient overlay
local gradient = new("UIGradient",{
    Parent=scriptHeader,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 61, 139))
    },
    Rotation=45,
    Transparency=NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.97),  -- Lebih transparan
        NumberSequenceKeypoint.new(1, 0.99)
    }
})

-- Drag Handle for Header
local headerDragHandle = new("Frame",{
    Parent=scriptHeader,
    Size=UDim2.new(0, 40, 0, 3),
    Position=UDim2.new(0.5, -20, 0, 10),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.75,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=headerDragHandle, CornerRadius=UDim.new(1, 0)})

new("UIStroke",{
    Parent=headerDragHandle,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.85
})

-- Title with glow effect
local titleLabel = new("TextLabel",{
    Parent=scriptHeader,
    Text="LynX",
    Size=UDim2.new(0, 80, 1, 0),
    Position=UDim2.new(0, 18, 0, 0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,
    TextSize=18,
    TextColor3=colors.primary,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextStrokeTransparency=0.9,
    TextStrokeColor3=colors.primary,
    ZIndex=6
})

-- Title glow effect
local titleGlow = new("TextLabel",{
    Parent=scriptHeader,
    Text="LynX",
    Size=titleLabel.Size,
    Position=titleLabel.Position,
    BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,
    TextSize=18,
    TextColor3=colors.primary,
    TextTransparency=0.7,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=5
})

-- Animated glow pulse
task.spawn(function()
    while true do
        TweenService:Create(titleGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency=0.4
        }):Play()
        task.wait(2)
        TweenService:Create(titleGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency=0.7
        }):Play()
        task.wait(2)
    end
end)

-- Separator with glow
local separator = new("Frame",{
    Parent=scriptHeader,
    Size=UDim2.new(0, 2, 0, 26),
    Position=UDim2.new(0, 100, 0.5, -13),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=separator, CornerRadius=UDim.new(1, 0)})
new("UIStroke",{
    Parent=separator,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.75
})

local subtitleLabel = new("TextLabel",{
    Parent=scriptHeader,
    Text="Free Not For Sale",
    Size=UDim2.new(0, 160, 1, 0),
    Position=UDim2.new(0, 110, 0, 0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamMedium,
    TextSize=9,
    TextColor3=colors.textDim,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextTransparency=0.35,
    ZIndex=6
})

-- Minimize button in header
local btnMinHeader = new("TextButton",{
    Parent=scriptHeader,
    Size=UDim2.new(0, 32, 0, 32),
    Position=UDim2.new(1, -40, 0.5, -16),
    BackgroundColor3=colors.bg4,
    BackgroundTransparency=0.6,
    BorderSizePixel=0,
    Text="─",
    Font=Enum.Font.GothamBold,
    TextSize=18,
    TextColor3=colors.textDim,
    TextTransparency=0.3,
    AutoButtonColor=false,
    ZIndex=7
})
new("UICorner",{Parent=btnMinHeader, CornerRadius=UDim.new(0, 8)})

local btnStroke = new("UIStroke",{
    Parent=btnMinHeader,
    Color=colors.primary,
    Thickness=0,
    Transparency=0.85
})

btnMinHeader.MouseEnter:Connect(function()
    TweenService:Create(btnMinHeader, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundColor3=colors.galaxy1,
        BackgroundTransparency=0.2,
        TextColor3=colors.text,
        TextTransparency=0,
        Size=UDim2.new(0, 34, 0, 34)
    }):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.25), {
        Thickness=1.5,
        Transparency=0.4
    }):Play()
end)

btnMinHeader.MouseLeave:Connect(function()
    TweenService:Create(btnMinHeader, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.6,
        TextColor3=colors.textDim,
        TextTransparency=0.3,
        Size=UDim2.new(0, 32, 0, 32)
    }):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.25), {
        Thickness=0,
        Transparency=0.85
    }):Play()
end)

-- Sidebar (Below header, ULTRA TRANSPARENT)
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0, sidebarWidth, 1, -48),
    Position=UDim2.new(0, 0, 0, 48),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.75,  -- Lebih transparan
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=sidebar, CornerRadius=UDim.new(0, 12)})

new("UIStroke",{
    Parent=sidebar,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.93  -- Lebih subtle
})

-- Navigation Container (Below header)
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1, -8, 1, -12),  -- Padding rapi
    Position=UDim2.new(0, 4, 0, 8),
    BackgroundTransparency=1,
    ScrollBarThickness=2,
    ScrollBarImageColor3=colors.primary,
    BorderSizePixel=0,
    CanvasSize=UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ClipsDescendants=true,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0, 6),  -- Spacing rapi
    SortOrder=Enum.SortOrder.LayoutOrder
})

-- Content Area (Below header, ULTRA TRANSPARENT, ALIGNED)
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, -(sidebarWidth + 8), 1, -58),  -- Adjusted untuk alignment
    Position=UDim2.new(0, sidebarWidth + 4, 0, 52),  -- Sejajar dengan sidebar
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.8,  -- Lebih transparan
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg, CornerRadius=UDim.new(0, 12)})

new("UIStroke",{
    Parent=contentBg,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.94  -- Lebih subtle
})

-- Top Bar (Page Title) - ULTRA TRANSPARENT
local topBar = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1, -8, 0, 34),  -- Padding rapi
    Position=UDim2.new(0, 4, 0, 4),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.8,  -- Lebih transparan
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar, CornerRadius=UDim.new(0, 10)})

new("UIStroke",{
    Parent=topBar,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.95  -- Lebih subtle
})

local pageTitle = new("TextLabel",{
    Parent=topBar,
    Text="Main Dashboard",
    Size=UDim2.new(1, -24, 1, 0),
    Position=UDim2.new(0, 12, 0, 0),
    Font=Enum.Font.GothamBold,
    TextSize=12,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextTransparency=0.2,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Resize Handle
local resizeHandle = new("TextButton",{
    Parent=win,
    Size=UDim2.new(0, 20, 0, 20),
    Position=UDim2.new(1, -20, 1, -20),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.65,
    BorderSizePixel=0,
    Text="⋰",
    Font=Enum.Font.GothamBold,
    TextSize=12,
    TextColor3=colors.textDim,
    TextTransparency=0.4,
    AutoButtonColor=false,
    ZIndex=100
})
new("UICorner",{Parent=resizeHandle, CornerRadius=UDim.new(0, 6)})

local resizeStroke = new("UIStroke",{
    Parent=resizeHandle,
    Color=colors.primary,
    Thickness=0,
    Transparency=0.85
})

resizeHandle.MouseEnter:Connect(function()
    TweenService:Create(resizeHandle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundTransparency=0.3,
        TextTransparency=0,
        Size=UDim2.new(0, 22, 0, 22)
    }):Play()
    TweenService:Create(resizeStroke, TweenInfo.new(0.25), {
        Thickness=1.5,
        Transparency=0.5
    }):Play()
end)

resizeHandle.MouseLeave:Connect(function()
    if not resizing then
        TweenService:Create(resizeHandle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundTransparency=0.65,
            TextTransparency=0.4,
            Size=UDim2.new(0, 20, 0, 20)
        }):Play()
        TweenService:Create(resizeStroke, TweenInfo.new(0.25), {
            Thickness=0,
            Transparency=0.85
        }):Play()
    end
end)

-- Pages
local pages = {}
local currentPage = "Main"
local navButtons = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1, -16, 1, -46),  -- Padding rapi, sejajar
        Position=UDim2.new(0, 8, 0, 42),  -- Aligned dengan topBar
        BackgroundTransparency=1,
        ScrollBarThickness=3,
        ScrollBarImageColor3=colors.primary,
        BorderSizePixel=0,
        CanvasSize=UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false,
        ClipsDescendants=true,
        ZIndex=5
    })
    new("UIListLayout",{
        Parent=page,
        Padding=UDim.new(0, 10),  -- Spacing rapi antar items
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0, 8),
        PaddingBottom=UDim.new(0, 8),
        PaddingLeft=UDim.new(0, 0),
        PaddingRight=UDim.new(0, 0)
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
