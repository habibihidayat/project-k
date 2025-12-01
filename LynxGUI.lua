-- LynxGUI_v2.3.lua - Galaxy Edition (REFINED)
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
local LockPosition = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/LockPosition.lua"))()
local AutoEquipRod = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/AutoEquipRod.lua"))()
-- Teleport
local TeleportModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportModule.lua"))()
local TeleportToPlayer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportSystem/TeleportToPlayer.lua"))()
local SavedLocation = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportSystem/SavedLocation.lua"))()
-- Quest page
local AutoQuestModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Quest/AutoQuestModule.lua"))()
-- Shop
local AutoSell = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSell.lua"))()
local AutoSellTimer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSellTimer.lua"))()
local MerchantSystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/OpenShop.lua"))()
-- local RodBuyer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/RodBuyer.lua"))()
-- Camera View
local FreecamModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Camera%20View/FreecamModule.lua"))()
local UnlimitedZoomModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Camera%20View/UnlimitedZoom.lua"))()
-- Misc
local AntiAFK = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/AntiAFK.lua"))()
local UnlockFPS = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/UnlockFPS.lua"))()
local AutoBuyWeather = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoBuyWeather.lua"))()
local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportSystem/NotificationModule.lua"))()

-- Galaxy Color Palette
local colors = {
    primary = Color3.fromRGB(255, 140, 0),       -- Purple
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
local windowSize = UDim2.new(0, 420, 0, 280)
local minWindowSize = Vector2.new(380, 250)
local maxWindowSize = Vector2.new(550, 400)

-- Sidebar state (Always expanded, no toggle)
local sidebarWidth = 140

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
    Transparency=0.9,  -- Lebih transparan dari 0.85
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
    Transparency=0.8  -- Lebih transparan dari 0.7
})

-- Sidebar (Below header, always visible, ULTRA transparent)
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0, sidebarWidth, 1, -45),
    Position=UDim2.new(0, 0, 0, 45),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.75,  -- Lebih transparan dari 0.6
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=sidebar, CornerRadius=UDim.new(0, 12)})

-- Sidebar subtle border
new("UIStroke",{
    Parent=sidebar,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.95  -- Lebih transparan dari 0.9
})

-- Script Header (INSIDE window, at the top, ULTRA transparent)
local scriptHeader = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, 0, 0, 45),
    Position=UDim2.new(0, 0, 0, 0),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.75,  -- Lebih transparan dari 0.6
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
        NumberSequenceKeypoint.new(1, 0.99)   -- Lebih transparan
    }
})

-- Drag Handle for Header (More subtle)
local headerDragHandle = new("Frame",{
    Parent=scriptHeader,
    Size=UDim2.new(0, 40, 0, 3),
    Position=UDim2.new(0.5, -20, 0, 8),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.8,  -- Lebih transparan dari 0.7
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=headerDragHandle, CornerRadius=UDim.new(1, 0)})

-- Drag handle glow effect
new("UIStroke",{
    Parent=headerDragHandle,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.85  -- Lebih transparan dari 0.8
})

-- Title with glow effect
local titleLabel = new("TextLabel",{
    Parent=scriptHeader,
    Text="LynX",
    Size=UDim2.new(0, 80, 1, 0),
    Position=UDim2.new(0, 15, 0, 0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,
    TextSize=17,
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
    TextSize=17,
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
    Size=UDim2.new(0, 2, 0, 25),
    Position=UDim2.new(0, 95, 0.5, -12.5),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=separator, CornerRadius=UDim.new(1, 0)})
new("UIStroke",{
    Parent=separator,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.7
})

local subtitleLabel = new("TextLabel",{
    Parent=scriptHeader,
    Text="Free Not For Sale",
    Size=UDim2.new(0, 150, 1, 0),
    Position=UDim2.new(0, 105, 0, 0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamMedium,
    TextSize=9,
    TextColor3=colors.textDim,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextTransparency=0.3,
    ZIndex=6
})

-- Minimize button in header - more polished
local btnMinHeader = new("TextButton",{
    Parent=scriptHeader,
    Size=UDim2.new(0, 30, 0, 30),
    Position=UDim2.new(1, -38, 0.5, -15),
    BackgroundColor3=colors.bg4,
    BackgroundTransparency=0.5,
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
    Transparency=0.8
})

btnMinHeader.MouseEnter:Connect(function()
    TweenService:Create(btnMinHeader, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundColor3=colors.galaxy1,
        BackgroundTransparency=0.2,
        TextColor3=colors.text,
        TextTransparency=0,
        Size=UDim2.new(0, 32, 0, 32)
    }):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.25), {
        Thickness=1.5,
        Transparency=0.4
    }):Play()
end)

btnMinHeader.MouseLeave:Connect(function()
    TweenService:Create(btnMinHeader, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.5,
        TextColor3=colors.textDim,
        TextTransparency=0.3,
        Size=UDim2.new(0, 30, 0, 30)
    }):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.25), {
        Thickness=0,
        Transparency=0.8
    }):Play()
end)

-- Navigation Container (Below header) - PADDING DIPERBAIKI
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1, -8, 1, -12),  -- Padding kiri kanan 4px, atas bawah 6px
    Position=UDim2.new(0, 4, 0, 6),  -- Posisi dari (2,48) ke (4,6)
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
    Padding=UDim.new(0, 4),
    SortOrder=Enum.SortOrder.LayoutOrder
})

-- Content Area (Below header, ULTRA transparent) - POSISI DIPERBAIKI
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, -(sidebarWidth + 10), 1, -52),  -- Padding kanan 10px, bawah 52px
    Position=UDim2.new(0, sidebarWidth + 5, 0, 47),  -- Padding kiri 5px, atas 47px
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.8,  -- Lebih transparan dari 0.7
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg, CornerRadius=UDim.new(0, 12)})

-- Content area subtle border
new("UIStroke",{
    Parent=contentBg,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.95  -- Lebih transparan dari 0.92
})

-- Top Bar (Page Title, ULTRA transparent) - PADDING DIPERBAIKI
local topBar = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1, -8, 0, 32),  -- Padding kiri kanan 4px
    Position=UDim2.new(0, 4, 0, 4),  -- Padding atas 4px
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.8,  -- Lebih transparan dari 0.7
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar, CornerRadius=UDim.new(0, 10)})

-- Topbar glow
new("UIStroke",{
    Parent=topBar,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.95  -- Lebih transparan dari 0.93
})

local pageTitle = new("TextLabel",{
    Parent=topBar,
    Text="Main Dashboard",
    Size=UDim2.new(1, -20, 1, 0),
    Position=UDim2.new(0, 12, 0, 0),
    Font=Enum.Font.GothamBold,
    TextSize=11,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextTransparency=0.2,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Resize Handle - more polished
local resizeHandle = new("TextButton",{
    Parent=win,
    Size=UDim2.new(0, 18, 0, 18),
    Position=UDim2.new(1, -18, 1, -18),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.6,
    BorderSizePixel=0,
    Text="⋰",
    Font=Enum.Font.GothamBold,
    TextSize=11,
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
    Transparency=0.8
})

resizeHandle.MouseEnter:Connect(function()
    TweenService:Create(resizeHandle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundTransparency=0.3,
        TextTransparency=0,
        Size=UDim2.new(0, 20, 0, 20)
    }):Play()
    TweenService:Create(resizeStroke, TweenInfo.new(0.25), {
        Thickness=1.5,
        Transparency=0.5
    }):Play()
end)

resizeHandle.MouseLeave:Connect(function()
    if not resizing then
        TweenService:Create(resizeHandle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundTransparency=0.6,
            TextTransparency=0.4,
            Size=UDim2.new(0, 18, 0, 18)
        }):Play()
        TweenService:Create(resizeStroke, TweenInfo.new(0.25), {
            Thickness=0,
            Transparency=0.8
        }):Play()
    end
end)

-- Pages - PADDING DIPERBAIKI
local pages = {}
local currentPage = "Main"
local navButtons = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1, -16, 1, -44),  -- Padding kiri kanan 8px, bawah 44px
        Position=UDim2.new(0, 8, 0, 40),  -- Padding kiri 8px, atas 40px (32+8)
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
        Padding=UDim.new(0, 8),
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0, 4),
        PaddingBottom=UDim.new(0, 4),
        PaddingLeft=UDim.new(0, 0),
        PaddingRight=UDim.new(0, 0)
    })
    pages[name] = page
    return page
end

local mainPage = createPage("Main")
local teleportPage = createPage("Teleport")
local questPage = createPage("Quest")
local shopPage = createPage("Shop")
local cameraViewPage = createPage("CameraView")
local settingsPage = createPage("Settings")
local infoPage = createPage("Info")
mainPage.Visible = true

-- LynxGUI_v2.3.lua - Galaxy Edition (REFINED)
-- BAGIAN 2: Navigation, UI Components (Toggle, Input Horizontal, Dropdown, Button, Category)

-- Nav Button - PADDING DIPERBAIKI, lebih transparan
local function createNavButton(text, icon, page, order)
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1, 0, 0, 38),
        BackgroundColor3=page == currentPage and colors.bg3 or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency=page == currentPage and 0.7 or 1,  -- Lebih transparan
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        LayoutOrder=order,
        ZIndex=6
    })
    new("UICorner",{Parent=btn, CornerRadius=UDim.new(0, 9)})
    
    local indicator = new("Frame",{
        Parent=btn,
        Size=UDim2.new(0, 3, 0, 20),
        Position=UDim2.new(0, 0, 0.5, -10),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        Visible=page == currentPage,
        ZIndex=7
    })
    new("UICorner",{Parent=indicator, CornerRadius=UDim.new(1, 0)})
    
    -- Indicator glow
    new("UIStroke",{
        Parent=indicator,
        Color=colors.primary,
        Thickness=2,
        Transparency=0.7
    })
    
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=UDim2.new(0, 30, 1, 0),
        Position=UDim2.new(0, 10, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=15,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        TextTransparency=page == currentPage and 0 or 0.3,
        ZIndex=7
    })
    
    local textLabel = new("TextLabel",{
        Parent=btn,
        Text=text,
        Size=UDim2.new(1, -45, 1, 0),
        Position=UDim2.new(0, 40, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,
        TextSize=10,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextTransparency=page == currentPage and 0.1 or 0.4,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=7
    })
    
    -- Smooth hover effect
    btn.MouseEnter:Connect(function()
        if page ~= currentPage then
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                BackgroundTransparency=0.8  -- Lebih transparan
            }):Play()
            TweenService:Create(iconLabel, TweenInfo.new(0.3), {
                TextTransparency=0,
                TextColor3=colors.primary
            }):Play()
            TweenService:Create(textLabel, TweenInfo.new(0.3), {
                TextTransparency=0.2
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if page ~= currentPage then
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                BackgroundTransparency=1
            }):Play()
            TweenService:Create(iconLabel, TweenInfo.new(0.3), {
                TextTransparency=0.3,
                TextColor3=colors.textDim
            }):Play()
            TweenService:Create(textLabel, TweenInfo.new(0.3), {
                TextTransparency=0.4
            }):Play()
        end
    end)
    
    navButtons[page] = {btn=btn, icon=iconLabel, text=textLabel, indicator=indicator}
    
    return btn
end

local function switchPage(pageName, pageTitle_text)
    if currentPage == pageName then return end
    for _, page in pairs(pages) do page.Visible = false end
    
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        TweenService:Create(btnData.btn, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundColor3=isActive and colors.bg3 or Color3.fromRGB(0, 0, 0),
            BackgroundTransparency=isActive and 0.7 or 1  -- Lebih transparan
        }):Play()
        btnData.indicator.Visible = isActive
        TweenService:Create(btnData.icon, TweenInfo.new(0.3), {
            TextColor3=isActive and colors.primary or colors.textDim,
            TextTransparency=isActive and 0 or 0.3
        }):Play()
        TweenService:Create(btnData.text, TweenInfo.new(0.3), {
            TextColor3=isActive and colors.text or colors.textDim,
            TextTransparency=isActive and 0.1 or 0.4
        }):Play()
    end
    
    pages[pageName].Visible = true
    pageTitle.Text = pageTitle_text
    currentPage = pageName
end

local btnMain = createNavButton("Dashboard", "🏠", "Main", 1)
local btnTeleport = createNavButton("Teleport", "🌍", "Teleport", 2)
local btnQuest = createNavButton("Quest", "🛒", "Quest", 3)
local btnShop = createNavButton("Shop", "🛒", "Shop", 3)
local btnCameraView = createNavButton("Camera View", "🛒", "CameraView", 3)
local btnSettings = createNavButton("Settings", "⚙️", "Settings", 4)
local btnInfo = createNavButton("About", "ℹ️", "Info", 5)

btnMain.MouseButton1Click:Connect(function() switchPage("Main", "Main Dashboard") end)
btnTeleport.MouseButton1Click:Connect(function() switchPage("Teleport", "Teleport System") end)
btnQuest.MouseButton1Click:Connect(function() switchPage("Quest", "Auto Quest") end)
btnShop.MouseButton1Click:Connect(function() switchPage("Shop", "Shop Features") end)
btnCameraView.MouseButton1Click:Connect(function() switchPage("CameraView", "Camera View Settings") end)
btnSettings.MouseButton1Click:Connect(function() switchPage("Settings", "Settings") end)
btnInfo.MouseButton1Click:Connect(function() switchPage("Info", "About Lynx") end)

-- ==== UI COMPONENTS - SEMUA DIPERBAIKI ALIGNMENT ====

-- Category - LEBIH TRANSPARAN
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 36),
        BackgroundColor3=colors.bg3,
        BackgroundTransparency=0.6,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=false,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame, CornerRadius=UDim.new(0, 6)})
    
    local categoryStroke = new("UIStroke",{
        Parent=categoryFrame,
        Color=colors.border,
        Thickness=0,
        Transparency=0.8
    })
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1, 0, 0, 36),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ClipsDescendants=true,
        ZIndex=7
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1, -50, 1, 0),
        Position=UDim2.new(0, 8, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0, 20, 1, 0),
        Position=UDim2.new(1, -24, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=10,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    local contentContainer = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1, -16, 0, 0),
        Position=UDim2.new(0, 8, 0, 38),
        BackgroundTransparency=1,
        Visible=false,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=true,
        ZIndex=7
    })
    new("UIListLayout",{Parent=contentContainer, Padding=UDim.new(0, 6)})
    new("UIPadding",{Parent=contentContainer, PaddingBottom=UDim.new(0, 8)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation=isOpen and 180 or 0}):Play()
        TweenService:Create(categoryFrame, TweenInfo.new(0.25), {
            BackgroundTransparency=isOpen and 0.4 or 0.6
        }):Play()
        TweenService:Create(categoryStroke, TweenInfo.new(0.25), {Thickness=isOpen and 1 or 0}):Play()
    end)
    
    return contentContainer
end

-- Toggle - ALIGNMENT DIPERBAIKI
local function makeToggle(parent, label, callback)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 32),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local labelText = new("TextLabel",{
        Parent=frame,
        Text=label,
        Size=UDim2.new(0.68, 0, 1, 0),  -- 68% untuk label
        Position=UDim2.new(0, 0, 0, 0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=9,
        TextWrapped=true,
        ZIndex=8
    })
    
    local toggleBg = new("Frame",{
        Parent=frame,
        Size=UDim2.new(0, 38, 0, 20),
        Position=UDim2.new(1, -38, 0.5, -10),  -- Align ke kanan
        BackgroundColor3=colors.bg4,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=toggleBg, CornerRadius=UDim.new(1, 0)})
    
    local toggleCircle = new("Frame",{
        Parent=toggleBg,
        Size=UDim2.new(0, 16, 0, 16),
        Position=UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3=colors.textDim,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=toggleCircle, CornerRadius=UDim.new(1, 0)})
    
    local btn = new("TextButton",{
        Parent=toggleBg,
        Size=UDim2.new(1, 0, 1, 0),
        BackgroundTransparency=1,
        Text="",
        ZIndex=10
    })
    
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(toggleBg, TweenInfo.new(0.25), {BackgroundColor3=on and colors.primary or colors.bg4}):Play()
        TweenService:Create(toggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position=on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3=on and colors.text or colors.textDim
        }):Play()
        callback(on)
    end)
end

-- Input HORIZONTAL - ALIGNMENT DIPERBAIKI & LEBIH TRANSPARAN
local function makeInput(parent, label, defaultValue, callback)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 32),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local lbl = new("TextLabel",{
        Parent=frame,
        Text=label,
        Size=UDim2.new(0.55, 0, 1, 0),  -- 55% untuk label
        Position=UDim2.new(0, 0, 0, 0),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium,
        TextSize=9,
        ZIndex=8
    })
    
    local inputBg = new("Frame",{
        Parent=frame,
        Size=UDim2.new(0.42, 0, 0, 28),  -- 42% untuk input
        Position=UDim2.new(0.58, 0, 0.5, -14),  -- Align ke kanan
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.4,  -- Lebih transparan dari 0.3
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=inputBg, CornerRadius=UDim.new(0, 6)})
    
    local inputStroke = new("UIStroke",{
        Parent=inputBg,
        Color=colors.border,
        Thickness=1,
        Transparency=0.7  -- Lebih transparan dari 0.6
    })
    
    local inputBox = new("TextBox",{
        Parent=inputBg,
        Size=UDim2.new(1, -12, 1, 0),
        Position=UDim2.new(0, 6, 0, 0),
        BackgroundTransparency=1,
        Text=tostring(defaultValue),
        PlaceholderText="0.00",
        Font=Enum.Font.Gotham,
        TextSize=9,
        TextColor3=colors.text,
        PlaceholderColor3=colors.textDimmer,
        TextXAlignment=Enum.TextXAlignment.Center,
        ClearTextOnFocus=false,
        ZIndex=9
    })
    
    inputBox.Focused:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {
            Color=colors.primary,
            Thickness=1.5,
            Transparency=0.3
        }):Play()
    end)
    
    inputBox.FocusLost:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {
            Color=colors.border,
            Thickness=1,
            Transparency=0.7  -- Lebih transparan dari 0.6
        }):Play()
        
        local value = tonumber(inputBox.Text)
        if value then
            callback(value)
        else
            inputBox.Text = tostring(defaultValue)
        end
    end)
end

-- Dropdown - LEBIH TRANSPARAN & ALIGNMENT DIPERBAIKI
local function makeDropdown(parent, title, icon, items, onSelect, uniqueId)
    local dropdownFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 40),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.5,  -- Lebih transparan dari 0.4
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=7,
        Name=uniqueId or "Dropdown"
    })
    new("UICorner",{Parent=dropdownFrame, CornerRadius=UDim.new(0, 6)})
    
    local dropStroke = new("UIStroke",{
        Parent=dropdownFrame,
        Color=colors.border,
        Thickness=0,
        Transparency=0.8  -- Lebih transparan dari 0.7
    })
    
    local header = new("TextButton",{
        Parent=dropdownFrame,
        Size=UDim2.new(1, -12, 0, 36),
        Position=UDim2.new(0, 6, 0, 2),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=8
    })
    
    local iconLabel = new("TextLabel",{
        Parent=header,
        Text=icon,
        Size=UDim2.new(0, 24, 1, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=12,
        TextColor3=colors.primary,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1, -70, 0, 14),
        Position=UDim2.new(0, 26, 0, 4),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=9,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local statusLabel = new("TextLabel",{
        Parent=header,
        Text="None Selected",
        Size=UDim2.new(1, -70, 0, 12),
        Position=UDim2.new(0, 26, 0, 20),
        BackgroundTransparency=1,
        Font=Enum.Font.Gotham,
        TextSize=8,
        TextColor3=colors.textDimmer,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0, 24, 1, 0),
        Position=UDim2.new(1, -24, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=10,
        TextColor3=colors.primary,
        ZIndex=9
    })
    
    local listContainer = new("ScrollingFrame",{
        Parent=dropdownFrame,
        Size=UDim2.new(1, -12, 0, 0),
        Position=UDim2.new(0, 6, 0, 42),
        BackgroundTransparency=1,
        Visible=false,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=UDim2.new(0, 0, 0, 0),
        ScrollBarThickness=2,
        ScrollBarImageColor3=colors.primary,
        BorderSizePixel=0,
        ClipsDescendants=true,
        ZIndex=10
    })
    new("UIListLayout",{Parent=listContainer, Padding=UDim.new(0, 4)})
    new("UIPadding",{Parent=listContainer, PaddingBottom=UDim.new(0, 8)})
    
    local isOpen = false
    local selectedItem = nil
    
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation=isOpen and 180 or 0}):Play()
        TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {
            BackgroundTransparency=isOpen and 0.35 or 0.5  -- Lebih transparan
        }):Play()
        TweenService:Create(dropStroke, TweenInfo.new(0.25), {Thickness=isOpen and 1 or 0}):Play()
        
        if isOpen then
            listContainer.Size = UDim2.new(1, -12, 0, math.min(#items * 28, 140))
        end
    end)
    
    for _, itemName in ipairs(items) do
        local itemBtn = new("TextButton",{
            Parent=listContainer,
            Size=UDim2.new(1, 0, 0, 26),
            BackgroundColor3=colors.bg4,
            BackgroundTransparency=0.6,  -- Lebih transparan dari 0.5
            BorderSizePixel=0,
            Text="",
            AutoButtonColor=false,
            ZIndex=11
        })
        new("UICorner",{Parent=itemBtn, CornerRadius=UDim.new(0, 5)})
        
        local itemStroke = new("UIStroke",{
            Parent=itemBtn,
            Color=colors.border,
            Thickness=0,
            Transparency=0.8  -- Lebih transparan dari 0.7
        })
        
        local btnLabel = new("TextLabel",{
            Parent=itemBtn,
            Text=itemName,
            Size=UDim2.new(1, -12, 1, 0),
            Position=UDim2.new(0, 6, 0, 0),
            BackgroundTransparency=1,
            Font=Enum.Font.GothamMedium,
            TextSize=8,
            TextColor3=colors.textDim,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
            ZIndex=12
        })
        
        itemBtn.MouseEnter:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                    BackgroundColor3=colors.primary,
                    BackgroundTransparency=0.3
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.2), {TextColor3=colors.text}):Play()
                TweenService:Create(itemStroke, TweenInfo.new(0.2), {Thickness=1}):Play()
            end
        end)
        
        itemBtn.MouseLeave:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                    BackgroundColor3=colors.bg4,
                    BackgroundTransparency=0.6
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.2), {TextColor3=colors.textDim}):Play()
                TweenService:Create(itemStroke, TweenInfo.new(0.2), {Thickness=0}):Play()
            end
        end)
        
        itemBtn.MouseButton1Click:Connect(function()
            selectedItem = itemName
            statusLabel.Text = "✓ " .. itemName
            statusLabel.TextColor3 = colors.success
            onSelect(itemName)
            
            task.wait(0.1)
            isOpen = false
            listContainer.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation=0}):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {
                BackgroundTransparency=0.5
            }):Play()
            TweenService:Create(dropStroke, TweenInfo.new(0.25), {Thickness=0}):Play()
        end)
    end
    
    return dropdownFrame
end

-- Button - LEBIH TRANSPARAN
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 32),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.3,  -- Lebih transparan dari 0.2
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=btnFrame, CornerRadius=UDim.new(0, 6)})
    
    local btnStroke = new("UIStroke",{
        Parent=btnFrame,
        Color=colors.primary,
        Thickness=0,
        Transparency=0.7  -- Lebih transparan dari 0.6
    })
    
    local button = new("TextButton",{
        Parent=btnFrame,
        Size=UDim2.new(1, 0, 1, 0),
        BackgroundTransparency=1,
        Text=label,
        Font=Enum.Font.GothamBold,
        TextSize=10,
        TextColor3=colors.text,
        AutoButtonColor=false,
        ZIndex=9
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {
            BackgroundTransparency=0.1,  -- Lebih transparan dari 0
            Size=UDim2.new(1, 0, 0, 35)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Thickness=1.5}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {
            BackgroundTransparency=0.3,
            Size=UDim2.new(1, 0, 0, 32)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Thickness=0}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.1), {Size=UDim2.new(0.98, 0, 0, 30)}):Play()
        task.wait(0.1)
        TweenService:Create(btnFrame, TweenInfo.new(0.1), {Size=UDim2.new(1, 0, 0, 32)}):Play()
        pcall(callback)
    end)
    
    return btnFrame
end

-- LynxGUI_v2.3.lua - Galaxy Edition (REFINED)
-- BAGIAN 3 (FINAL): Features, Pages Content, Minimize System, Animations

-- ==== MAIN PAGE ====
local catAutoFishing = makeCategory(mainPage, "Auto Fishing", "🎣")

local currentInstantMode = "None"
local fishingDelayValue = 1.30
local cancelDelayValue = 0.19

makeDropdown(catAutoFishing, "Instant Fishing Mode", "⚡", {"Fast", "Perfect"}, function(mode)
    currentInstantMode = mode
    instant.Stop()
    instant2.Stop()
    
    if mode == "Fast" then
        instant.Settings.MaxWaitTime = fishingDelayValue
        instant.Settings.CancelDelay = cancelDelayValue
        instant.Start()
    elseif mode == "Perfect" then
        instant2.Settings.MaxWaitTime = fishingDelayValue
        instant2.Settings.CancelDelay = cancelDelayValue
        instant2.Start()
    end
end, "InstantFishingMode")

makeToggle(catAutoFishing, "Enable Instant Fishing", function(on)
    if on then
        if currentInstantMode == "Fast" then
            instant.Start()
        elseif currentInstantMode == "Perfect" then
            instant2.Start()
        end
    else
        instant.Stop()
        instant2.Stop()
    end
end)

makeInput(catAutoFishing, "Fishing Delay", 1.30, function(v)
    fishingDelayValue = v
    instant.Settings.MaxWaitTime = v
    instant2.Settings.MaxWaitTime = v
end)

makeInput(catAutoFishing, "Cancel Delay", 0.19, function(v)
    cancelDelayValue = v
    instant.Settings.CancelDelay = v
    instant2.Settings.CancelDelay = v
end)

-- Blatant V1
local catBlatantV1 = makeCategory(mainPage, "Blatant V1", "💀")

makeToggle(catBlatantV1, "Blatant Mode", function(on) 
    if on then 
        blatantv1.Start() 
    else 
        blatantv1.Stop() 
    end 
end)

makeInput(catBlatantV1, "Complete Delay", 0.05, function(v)
    blatantv1.Settings.CompleteDelay = v
    print("✅ Complete Delay set to: " .. v)
end)

makeInput(catBlatantV1, "Cancel Delay", 0.1, function(v)
    blatantv1.Settings.CancelDelay = v
    print("✅ Cancel Delay set to: " .. v)
end)

-- Blatant V2
local catBlatantV2 = makeCategory(mainPage, "Blatant V2", "🔥")

makeToggle(catBlatantV2, "Blatant Features", function(on) 
    if on then 
        blatantv2.Start() 
    else 
        blatantv2.Stop() 
    end 
end)

makeInput(catBlatantV2, "Fishing Delay", 0.05, function(v) 
    blatantv2.Settings.FishingDelay = v 
end)

makeInput(catBlatantV2, "Cancel Delay", 0.01, function(v) 
    blatantv2.Settings.CancelDelay = v 
end)

makeInput(catBlatantV2, "Hook Wait Time", 0.15, function(v) 
    blatantv2.Settings.HookWaitTime = v 
end)

makeInput(catBlatantV2, "Cast Delay", 0.03, function(v) 
    blatantv2.Settings.CastDelay = v 
end)

makeInput(catBlatantV2, "Timeout Delay", 0.8, function(v) 
    blatantv2.Settings.TimeoutDelay = v 
end)

-- Support Features
local catSupport = makeCategory(mainPage, "Support Features", "🛠️")

makeToggle(catSupport, "No Fishing Animation", function(on)
    if on then
        NoFishingAnimation.StartWithDelay()
    else
        NoFishingAnimation.Stop()
    end
end)

makeToggle(catSupport, "Lock Position", function(on)
    if on then
        LockPosition.Start()
        Notify.Send("Lock Position", "Posisi kamu dikunci!", 4)
    else
        LockPosition.Stop()
        Notify.Send("Lock Position", "Posisi kamu dilepas!", 4)
    end
end)

-- ✨ NEW: Auto Equip Rod
makeToggle(catSupport, "Auto Equip Rod", function(on)
    if on then
        AutoEquipRod.Start()
        Notify.Send("Auto Equip Rod", "Rod akan otomatis di-equip!", 4)
    else
        AutoEquipRod.Stop()
        Notify.Send("Auto Equip Rod", "Auto equip dimatikan!", 4)
    end
end)

-- ==== TELEPORT PAGE ====
local locationItems = {}
for name, _ in pairs(TeleportModule.Locations) do
    table.insert(locationItems, name)
end
table.sort(locationItems)

makeDropdown(teleportPage, "Teleport to Location", "📍", locationItems, function(selectedLocation)
    TeleportModule.TeleportTo(selectedLocation)
end, "LocationTeleport")

local playerItems = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        table.insert(playerItems, player.Name)
    end
end
table.sort(playerItems)

-- PLAYER TELEPORT WITH AUTO REFRESH
local playerDropdown
local playerItems = {}

local function updatePlayerList()
    table.clear(playerItems)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerItems, player.Name)
        end
    end
    table.sort(playerItems)
    
    -- Hapus dropdown lama jika ada
    if playerDropdown and playerDropdown.Parent then
        playerDropdown:Destroy()
    end
    
    -- Buat dropdown baru dengan list ter-update
    playerDropdown = makeDropdown(teleportPage, "Teleport to Player", "👤", playerItems, function(selectedPlayer)
        TeleportToPlayer.TeleportTo(selectedPlayer)
    end, "PlayerTeleport")
end

-- Initial update
updatePlayerList()

-- Auto refresh ketika player join
Players.PlayerAdded:Connect(function(player)
    task.wait(0.5) -- Delay kecil untuk stabilitas
    updatePlayerList()
    print("🟢 Player joined: " .. player.Name .. " | List updated!")
end)

-- Auto refresh ketika player leave
Players.PlayerRemoving:Connect(function(player)
    task.wait(0.1)
    updatePlayerList()
    print("🔴 Player left: " .. player.Name .. " | List updated!")
end)

local catSaved = makeCategory(teleportPage, "Saved Location", "⭐")

makeButton(catSaved, "Save Current Location", function()
    SavedLocation.Save()
    Notify("Saved ⭐", "Lokasi berhasil disimpan.", 3)
end)

makeButton(catSaved, "Teleport Saved Location", function()
    if SavedLocation.Teleport() then
        Notify("Teleported 🚀", "Berhasil teleport ke lokasi tersimpan.", 3)
    else
        Notify("Error ❌", "Tidak ada lokasi yang disimpan!", 3)
    end
end)

makeButton(catSaved, "Reset Saved Location", function()
    SavedLocation.Reset()
    Notify("Reset 🔄", "Lokasi tersimpan telah dihapus.", 3)
end)


-- ==== QUEST PAGE ====
local catDeepSea = makeCategory(questPage, "Deep Sea Quest (Ghostfinn Rod)")

-- Progress display
local deepSeaProgressFrame = new("Frame",{
    Parent=catDeepSea,
    Size=UDim2.new(1, 0, 0, 160),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.6,
    BorderSizePixel=0,
    ZIndex=7
})
new("UICorner",{Parent=deepSeaProgressFrame, CornerRadius=UDim.new(0, 8)})
new("UIStroke",{Parent=deepSeaProgressFrame, Color=colors.border, Thickness=1, Transparency=0.7})

local deepSeaLabel = new("TextLabel",{
    Parent=deepSeaProgressFrame,
    Size=UDim2.new(1, -24, 1, -24),
    Position=UDim2.new(0, 12, 0, 12),
    BackgroundTransparency=1,
    Text=AutoQuestModule.GetQuestInfo("DeepSeaQuest"),
    Font=Enum.Font.Gotham,
    TextSize=8,
    TextColor3=colors.text,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=8
})

makeButton(catDeepSea, "Refresh Progress", function()
    if AutoQuestModule then
        deepSeaLabel.Text = AutoQuestModule.GetQuestInfo("DeepSeaQuest")
        if Notify and type(Notify.Send) == "function" then
            Notify.Send("Refresh", "Progress updated!", 2)
        end
    end
end)

makeToggle(catDeepSea, "Auto Teleport", function(on)
    if not AutoQuestModule then return end
    
    if on then
        if type(AutoQuestModule.StartAutoTeleport) == "function" then
            AutoQuestModule.StartAutoTeleport("DeepSeaQuest")
            if Notify and type(Notify.Send) == "function" then
                Notify.Send("Auto Teleport", "Deep Sea Quest Auto Teleport AKTIF!", 2)
            end
        end
    else
        if type(AutoQuestModule.StopAutoTeleport) == "function" then
            AutoQuestModule.StopAutoTeleport()
            if Notify and type(Notify.Send) == "function" then
                Notify.Send("Auto Teleport", "Deep Sea Quest Auto Teleport DIMATIKAN!", 2)
            end
        end
    end
    
    deepSeaLabel.Text = AutoQuestModule.GetQuestInfo("DeepSeaQuest")
end)


-- Element Quest
local catElement = makeCategory(questPage, "Element Quest (Element Rod)")

local elementProgressFrame = new("Frame",{
    Parent=catElement,
    Size=UDim2.new(1, 0, 0, 160),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.6,
    BorderSizePixel=0,
    ZIndex=7
})
new("UICorner",{Parent=elementProgressFrame, CornerRadius=UDim.new(0, 8)})
new("UIStroke",{Parent=elementProgressFrame, Color=colors.border, Thickness=1, Transparency=0.7})

local elementLabel = new("TextLabel",{
    Parent=elementProgressFrame,
    Size=UDim2.new(1, -24, 1, -24),
    Position=UDim2.new(0, 12, 0, 12),
    BackgroundTransparency=1,
    Text=AutoQuestModule.GetQuestInfo("ElementQuest"),
    Font=Enum.Font.Gotham,
    TextSize=8,
    TextColor3=colors.text,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=8
})

makeButton(catElement, "Refresh Progress", function()
    if AutoQuestModule then
        elementLabel.Text = AutoQuestModule.GetQuestInfo("ElementQuest")
        if Notify and type(Notify.Send) == "function" then
            Notify.Send("Refresh", "Progress updated!", 2)
        end
    end
end)

makeToggle(catElement, "Auto Teleport", function(on)
    if not AutoQuestModule then return end
    
    if on then
        if type(AutoQuestModule.StartAutoTeleport) == "function" then
            AutoQuestModule.StartAutoTeleport("ElementQuest")
            if Notify and type(Notify.Send) == "function" then
                Notify.Send("Auto Teleport", "Element Quest Auto Teleport AKTIF!", 2)
            end
        end
    else
        if type(AutoQuestModule.StopAutoTeleport) == "function" then
            AutoQuestModule.StopAutoTeleport()
            if Notify and type(Notify.Send) == "function" then
                Notify.Send("Auto Teleport", "Element Quest Auto Teleport DIMATIKAN!", 2)
            end
        end
    end
    
    elementLabel.Text = AutoQuestModule.GetQuestInfo("ElementQuest")
end)


-- ==== REAL-TIME UPDATE ====
task.spawn(function()
    while true do
        task.wait(2)
        
        pcall(function()
            if deepSeaLabel and deepSeaLabel.Parent and AutoQuestModule and type(AutoQuestModule.GetQuestInfo) == "function" then
                deepSeaLabel.Text = AutoQuestModule.GetQuestInfo("DeepSeaQuest")
            end
        end)
        
        pcall(function()
            if elementLabel and elementLabel.Parent and AutoQuestModule and type(AutoQuestModule.GetQuestInfo) == "function" then
                elementLabel.Text = AutoQuestModule.GetQuestInfo("ElementQuest")
            end
        end)
    end
end)

-- ==== SHOP PAGE ====
local catSell = makeCategory(shopPage, "Sell All", "💰")

makeButton(catSell, "Sell All Now", function()
    if AutoSell and AutoSell.SellOnce then
        AutoSell.SellOnce()
    end
end)

local catTimer = makeCategory(shopPage, "Auto Sell Timer", "⏰")

makeInput(catTimer, "Sell Interval (seconds)", 5, function(value)
    AutoSellTimer.SetInterval(value)
end)

makeToggle(catTimer, "Auto Sell Timer", function(on)
    if AutoSellTimer then
        if on then
            AutoSellTimer.Start(AutoSellTimer.Interval)
        else
            AutoSellTimer.Stop()
        end
    end
end)

local catWeather = makeCategory(shopPage, "Auto Buy Weather", "🌦️")

local selectedWeathers = {}
makeDropdown(catWeather, "Select Weather", "☁️", AutoBuyWeather.AllWeathers, function(weather)
    local idx = table.find(selectedWeathers, weather)
    if idx then
        table.remove(selectedWeathers, idx)
    else
        table.insert(selectedWeathers, weather)
    end
    AutoBuyWeather.SetSelected(selectedWeathers)
end, "WeatherDropdown")

makeToggle(catWeather, "Enable Auto Weather", function(on)
    if on then
        AutoBuyWeather.Start()
    else
        AutoBuyWeather.Stop()
    end
end)

-- ============================
--  MERCHANT CATEGORY
-- ============================
local catMerchant = makeCategory(shopPage, "Remote Merchant", "🛒")

makeButton(catMerchant, "Open Merchant", function()
    MerchantSystem.Open()
    Notify("Merchant 🛒", "Merchant dibuka!", 3)
end)

makeButton(catMerchant, "Close Merchant", function()
    MerchantSystem.Close()
    Notify("Merchant 🛒", "Merchant ditutup!", 3)
end)



-- local catRod = makeCategory(shopPage, "Rod Shop", "🎣")

-- 126 = Ares Rod
--makeButton(catRod, "Buy Ares Rod", function()
  --  RodBuyer.Buy(126)
--end)

-- 168 = Angler Rod
--makeButton(catRod, "Buy Angler Rod", function()
 --   RodBuyer.Buy(168)
--end)

-- 258 = Bamboo Rod
--makeButton(catRod, "Buy Bamboo Rod", function()
  --  RodBuyer.Buy(258)
-- end)


-- Camera settings
local catZoom = makeCategory(cameraViewPage, "Unlimited Zoom", "🔭")

makeToggle(catZoom, "Enable Unlimited Zoom", function(on)
    -- Safety check: pastikan module sudah loaded
    if not UnlimitedZoomModule then
        Notify.Send("Error ❌", "UnlimitedZoomModule belum di-load!", 3)
        warn("❌ UnlimitedZoomModule is nil!")
        return
    end
    
    -- Safety check: pastikan function Enable ada
    if type(UnlimitedZoomModule.Enable) ~= "function" then
        Notify.Send("Error ❌", "UnlimitedZoomModule.Enable bukan function!", 3)
        warn("❌ UnlimitedZoomModule.Enable is not a function, type:", type(UnlimitedZoomModule.Enable))
        return
    end
    
    if on then
        local success, result = pcall(function()
            return UnlimitedZoomModule.Enable()
        end)
        
        if success and result then
            Notify.Send("Zoom 🔭", "Unlimited Zoom aktif! Scroll atau pinch untuk zoom.", 4)
        elseif not success then
            Notify.Send("Error ❌", "Gagal mengaktifkan: " .. tostring(result), 3)
            warn("❌ Enable error:", result)
        end
    else
        local success, result = pcall(function()
            return UnlimitedZoomModule.Disable()
        end)
        
        if success and result then
            Notify.Send("Zoom 🔭", "Unlimited Zoom nonaktif.", 3)
        elseif not success then
            Notify.Send("Error ❌", "Gagal menonaktifkan: " .. tostring(result), 3)
            warn("❌ Disable error:", result)
        end
    end
end)

FreecamModule.SetMainGuiName("LynxGUI_Galaxy")

local catFreecam = makeCategory(cameraViewPage, "Freecam Camera", "📷")

-- Note untuk PC saja - Info Container Style
if not isMobile then
    local noteContainer = new("Frame", {
        Parent = catFreecam,
        Size = UDim2.new(1, 0, 0, 85),
        BackgroundColor3 = colors.bg3,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        ZIndex = 7
    })
    
    new("UICorner", {
        Parent = noteContainer,
        CornerRadius = UDim.new(0, 8)
    })
    
    new("UIStroke", {
        Parent = noteContainer,
        Color = colors.border,
        Thickness = 1,
        Transparency = 0.7
    })
    
    local noteText = new("TextLabel", {
        Parent = noteContainer,
        Size = UDim2.new(1, -24, 1, -24),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1,
        Text = [[📌 FREECAM CONTROLS (PC)
    ━━━━━━━━━━━━━━━━━━━━━━
    1. Aktifkan toggle "Enable Freecam"
    2. Tekan F3 untuk ON/OFF freecam
    3. WASD - Gerak | Mouse - Rotasi
    4. Space/E - Naik | Shift/Q - Turun]],
        Font = Enum.Font.Gotham,
        TextSize = 8,
        TextColor3 = colors.text,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 8
    })
end

-- Detect platform
local UIS = game:GetService("UserInputService")
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

makeToggle(catFreecam, "Enable Freecam", function(on)
    if on then
        if not isMobile then
            if FreecamModule and type(FreecamModule.EnableF3Keybind) == "function" then
                FreecamModule.EnableF3Keybind(true)
                if Notify and type(Notify.Send) == "function" then
                    Notify.Send("Freecam", "Freecam siap! Tekan F3 untuk mengaktifkan.", 4)
                end
            end
        else
            if FreecamModule and type(FreecamModule.Start) == "function" then
                FreecamModule.Start()
                if Notify and type(Notify.Send) == "function" then
                    Notify.Send("Freecam", "Freecam aktif! Kontrol dengan touch.", 4)
                end
            end
        end
    else
        if FreecamModule and type(FreecamModule.EnableF3Keybind) == "function" then
            FreecamModule.EnableF3Keybind(false)
            if Notify and type(Notify.Send) == "function" then
                Notify.Send("Freecam", "Freecam nonaktif.", 3)
            end
        end
    end
end)

makeInput(catFreecam, "Movement Speed", 50, function(value)
    local speed = tonumber(value) or 50
    if FreecamModule and type(FreecamModule.SetSpeed) == "function" then
        FreecamModule.SetSpeed(speed)
    end
end)

makeInput(catFreecam, "Mouse Sensitivity", 0.3, function(value)
    local sens = tonumber(value) or 0.3
    if FreecamModule and type(FreecamModule.SetSensitivity) == "function" then
        FreecamModule.SetSensitivity(sens)
    end
end)

makeButton(catFreecam, "Reset Settings", function()
    if FreecamModule then
        if type(FreecamModule.SetSpeed) == "function" then
            FreecamModule.SetSpeed(50)
        end
        if type(FreecamModule.SetSensitivity) == "function" then
            FreecamModule.SetSensitivity(0.3)
        end
        if Notify and type(Notify.Send) == "function" then
            Notify.Send("Reset", "Freecam settings direset!", 3)
        end
    end
end)

-- ==== SETTINGS PAGE ====
local catAFK = makeCategory(settingsPage, "Anti-AFK Protection", "🧍‍♂️")

makeToggle(catAFK, "Enable Anti-AFK", function(on)
    if on then
        AntiAFK.Start()
    else
        AntiAFK.Stop()
    end
end)

local catFPS = makeCategory(settingsPage, "FPS Unlocker", "🎞️")

makeDropdown(catFPS, "Select FPS Limit", "⚙️", {"60 FPS", "90 FPS", "120 FPS", "240 FPS"}, function(selected)
    local fpsValue = tonumber(selected:match("%d+"))
    if fpsValue and UnlockFPS and UnlockFPS.SetCap then
        UnlockFPS.SetCap(fpsValue)
    end
end, "FPSDropdown")

local catGeneral = makeCategory(settingsPage, "General Settings", "⚙️")

makeToggle(catGeneral, "Auto Save Settings", function(on) 
    print("Auto Save:", on) 
end)

makeToggle(catGeneral, "Show Notifications", function(on) 
    print("Notifications:", on) 
end)

makeToggle(catGeneral, "Performance Mode", function(on) 
    print("Performance:", on) 
end)

-- ==== INFO PAGE ====
local infoContainer = new("Frame",{
    Parent=infoPage,
    Size=UDim2.new(1, 0, 0, 420),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.6,  -- Lebih transparan dari 0.5
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=infoContainer, CornerRadius=UDim.new(0, 8)})
new("UIStroke",{
    Parent=infoContainer,
    Color=colors.border,
    Thickness=1,
    Transparency=0.7  -- Lebih transparan dari 0.6
})

local infoText = new("TextLabel",{
    Parent=infoContainer,
    Size=UDim2.new(1, -24, 1, -24),
    Position=UDim2.new(0, 12, 0, 12),
    BackgroundTransparency=1,
    Text=[[
💜 LynX v2.3 GALAXY EDITION (REFINED)

Free Not For Sale
━━━━━━━━━━━━━━━━━━━━━━

🎣 AUTO FISHING
• Instant Fishing (Fast/Perfect)
• Perfect horizontal alignment
• Blatant Mode V1 & V2
• Advanced automation

🛠️ SUPPORT FEATURES
• No Fishing Animation
• Performance optimizations

🌍 TELEPORT SYSTEM
• Location teleport
• Player teleport
• Smart dropdown selection

💰 SHOP FEATURES
• Auto Sell (instant & timer)
• Auto Buy Weather
• Organized categories

⚙️ SETTINGS
• Anti-AFK Protection
• FPS Unlocker (60-240 FPS)
• General preferences

━━━━━━━━━━━━━━━━━━━━━━

💡 NEW IN v2.3 REFINED
✓ Ultra transparent design
✓ Perfect alignment system
✓ Galaxy purple theme
✓ Sidebar always visible
✓ Fixed padding & spacing
✓ Label-input horizontal layout
✓ Smooth Quint animations
✓ Better performance
✓ Glass morphism effect

🎮 CONTROLS
• Click categories to expand
• Drag from top bar to move
• Drag corner to resize
• (─) Minimize window

━━━━━━━━━━━━━━━━━━━━━━

Created with 💜 by Lynx Team
Refined Edition 2024
    ]],
    Font=Enum.Font.Gotham,
    TextSize=9,
    TextColor3=colors.text,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=7
})

-- ==== MINIMIZE SYSTEM ====
local minimized = false
local icon
local savedIconPos = UDim2.new(0, 20, 0, 100)

local function createMinimizedIcon()
    if icon then return end
    
    icon = new("ImageLabel",{
        Parent=gui,
        Size=UDim2.new(0, 50, 0, 50),
        Position=savedIconPos,
        BackgroundColor3=colors.bg2,
        BackgroundTransparency=0.3,  -- Lebih transparan dari 0.2
        BorderSizePixel=0,
        Image="rbxassetid://111416780887356",
        ScaleType=Enum.ScaleType.Fit,
        ZIndex=100
    })
    new("UICorner",{Parent=icon, CornerRadius=UDim.new(0, 10)})
    new("UIStroke",{
        Parent=icon,
        Color=colors.primary,
        Thickness=2,
        Transparency=0.5  -- Lebih transparan dari 0.4
    })
    
    local logoText = new("TextLabel",{
        Parent=icon,
        Text="L",
        Size=UDim2.new(1, 0, 1, 0),
        Font=Enum.Font.GothamBold,
        TextSize=28,
        BackgroundTransparency=1,
        TextColor3=colors.primary,
        Visible=icon.Image == "",
        ZIndex=101
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
            if math.sqrt(delta.X^2 + delta.Y^2) > 5 then 
                dragMoved = true 
            end
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(icon, TweenInfo.new(0.05), {Position=newPos}):Play()
        end
    end)
    
    icon.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                savedIconPos = icon.Position
                if not dragMoved then
                    win.Visible = true
                    TweenService:Create(win, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size=windowSize,
                        Position=UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
                    }):Play()
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

btnMinHeader.MouseButton1Click:Connect(function()
    if not minimized then
        local targetPos = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(win, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size=UDim2.new(0, 0, 0, 0),
            Position=targetPos
        }):Play()
        task.wait(0.35)
        win.Visible = false
        createMinimizedIcon()
        minimized = true
    end
end)

-- ==== DRAGGING SYSTEM (From Header) - Smoother ====
local dragging, dragStart, startPos = false, nil, nil

scriptHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, win.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        TweenService:Create(win, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {Position=newPos}):Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

-- ==== RESIZING SYSTEM - Smoother ====
local resizing = false
local resizeStart, startSize = nil, nil

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing, resizeStart, startSize = true, input.Position, win.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        
        local newWidth = math.clamp(
            startSize.X.Offset + delta.X,
            minWindowSize.X,
            maxWindowSize.X
        )
        local newHeight = math.clamp(
            startSize.Y.Offset + delta.Y,
            minWindowSize.Y,
            maxWindowSize.Y
        )
        
        local newSize = UDim2.new(0, newWidth, 0, newHeight)
        TweenService:Create(win, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {Size=newSize}):Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        resizing = false 
    end
end)

-- ==== OPENING ANIMATION - More dramatic ====
task.spawn(function()
    win.Size = UDim2.new(0, 0, 0, 0)
    win.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    win.BackgroundTransparency = 1
    
    task.wait(0.1)
    
    -- Expand with bounce
    TweenService:Create(win, TweenInfo.new(0.7, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size=windowSize
    }):Play()
    
    -- Fade in
    TweenService:Create(win, TweenInfo.new(0.5), {
        BackgroundTransparency=0.25  -- Lebih transparan dari 0.15
    }):Play()
end)

print("━━━━━━━━━━━━━━━━━━━━━━")
print("✨ Lynx GUI v2.3 Galaxy Edition (REFINED)")
print("💜 FREE NOT FOR SALE")
print("━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 PERFECTED & ALIGNED!")
print("━━━━━━━━━━━━━━━━━━━━━━")
print("📦 Features:")
print("  • Ultra transparent design")
print("  • Perfect alignment system")
print("  • Galaxy purple theme")
print("  • Smooth Quint animations")
print("  • Always-visible sidebar")
print("  • Horizontal input layout")
print("  • Glass morphism effect")
print("  • Polished UI components")
print("━━━━━━━━━━━━━━━━━━━━━━")
print("💎 All elements perfectly aligned!")
print("━━━━━━━━━━━━━━━━━━━━━━")
print("💎 Created by Lynx Team")
print("━━━━━━━━━━━━━━━━━━━━━━")
