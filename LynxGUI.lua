-- LynxGUI_v2.2.lua - Compact Minimalist Black Edition (IMPROVED)
-- MOBILE OPTIMIZED (Same for PC)
-- BAGIAN 1: Setup, Core Functions, Window Structure

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

-- Enhanced Minimalist Color Palette - Premium Black Theme
local colors = {
    primary = Color3.fromRGB(255, 140, 0),       -- Orange accent
    secondary = Color3.fromRGB(255, 165, 50),    -- Light orange
    accent = Color3.fromRGB(255, 100, 20),       -- Bright orange
    success = Color3.fromRGB(34, 197, 94),       -- Green
    warning = Color3.fromRGB(251, 191, 36),      -- Amber
    danger = Color3.fromRGB(239, 68, 68),        -- Red
    
    bg1 = Color3.fromRGB(12, 12, 12),            -- Deep black
    bg2 = Color3.fromRGB(20, 20, 20),            -- Dark gray
    bg3 = Color3.fromRGB(28, 28, 28),            -- Medium gray
    bg4 = Color3.fromRGB(38, 38, 38),            -- Light gray
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(180, 180, 180),
    textDimmer = Color3.fromRGB(120, 120, 120),
    
    border = Color3.fromRGB(60, 60, 60),
    borderLight = Color3.fromRGB(80, 80, 80),
    glow = Color3.fromRGB(255, 140, 0),
}

-- Improved Window Size
local windowSize = UDim2.new(0, 480, 0, 300)
local minWindowSize = Vector2.new(420, 260)
local maxWindowSize = Vector2.new(600, 420)

local gui = new("ScreenGui",{
    Name="LynxGUI_Compact",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Main Window Container - Premium Black Glass
local win = new("Frame",{
    Parent=gui,
    Size=windowSize,
    Position=UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
    BackgroundColor3=colors.bg1,
    BackgroundTransparency=0.15,
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win, CornerRadius=UDim.new(0, 12)})

-- Enhanced border with gradient
local winStroke = new("UIStroke",{
    Parent=win,
    Color=colors.border,
    Thickness=1.5,
    Transparency=0.3,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Subtle glow effect
local glowFrame = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, 4, 1, 4),
    Position=UDim2.new(0, -2, 0, -2),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.95,
    BorderSizePixel=0,
    ZIndex=2
})
new("UICorner",{Parent=glowFrame, CornerRadius=UDim.new(0, 14)})

-- Sidebar state - START EXPANDED untuk debugging
local sidebarExpanded = true
local sidebarCollapsedWidth = 50
local sidebarExpandedWidth = 180

-- Enhanced Sidebar
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0, sidebarExpandedWidth, 1, 0),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=4
})
new("UICorner",{Parent=sidebar, CornerRadius=UDim.new(0, 12)})

-- Sidebar border
new("UIStroke",{
    Parent=sidebar,
    Color=colors.borderLight,
    Thickness=1,
    Transparency=0.5
})

-- Sidebar gradient overlay
local sidebarGradient = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1, 0, 1, 0),
    BackgroundTransparency=1,
    ZIndex=4
})
new("UIGradient",{
    Parent=sidebarGradient,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    },
    Rotation=180,
    Transparency=NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 1)
    }
})

-- Sidebar Toggle Button - Better positioning
local sidebarToggle = new("TextButton",{
    Parent=win,
    Size=UDim2.new(0, 28, 0, 44),
    Position=UDim2.new(0, sidebarExpandedWidth - 2, 1, -54),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    Text="◀",
    Font=Enum.Font.GothamBold,
    TextSize=13,
    TextColor3=colors.primary,
    ZIndex=101,
    ClipsDescendants=false
})
new("UICorner",{Parent=sidebarToggle, CornerRadius=UDim.new(0, 8)})
new("UIStroke",{
    Parent=sidebarToggle,
    Color=colors.borderLight,
    Thickness=1,
    Transparency=0.5
})

-- Enhanced Sidebar Header
local sidebarHeader = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1, 0, 0, 60),
    BackgroundTransparency=1,
    ClipsDescendants=false,
    ZIndex=5
})

-- Brand container with glow
local brandContainer = new("Frame",{
    Parent=sidebarHeader,
    Size=UDim2.new(1, -16, 0, 40),
    Position=UDim2.new(0, 8, 0, 10),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=brandContainer, CornerRadius=UDim.new(0, 8)})
new("UIStroke",{
    Parent=brandContainer,
    Color=colors.primary,
    Thickness=1.5,
    Transparency=0.6
})

local brandName = new("TextLabel",{
    Parent=brandContainer,
    Text="LYNX",
    Size=UDim2.new(1, 0, 1, 0),
    Font=Enum.Font.GothamBold,
    TextSize=20,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    ZIndex=6
})

-- Gradient effect
new("UIGradient",{
    Parent=brandName,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(1, colors.accent)
    }
})

-- Navigation Container
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1, -8, 1, -70),
    Position=UDim2.new(0, 4, 0, 65),
    BackgroundTransparency=1,
    ScrollBarThickness=3,
    ScrollBarImageColor3=colors.primary,
    BorderSizePixel=0,
    CanvasSize=UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ClipsDescendants=true,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0, 6),
    SortOrder=Enum.SortOrder.LayoutOrder
})
new("UIPadding",{
    Parent=navContainer,
    PaddingLeft=UDim.new(0, 4),
    PaddingRight=UDim.new(0, 4)
})

-- Content Area - Adjusted
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, -(sidebarExpandedWidth + 10), 1, -12),
    Position=UDim2.new(0, sidebarExpandedWidth + 6, 0, 6),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg, CornerRadius=UDim.new(0, 10)})
new("UIStroke",{
    Parent=contentBg,
    Color=colors.borderLight,
    Thickness=1,
    Transparency=0.5
})

-- Function to toggle sidebar
local navButtons = {}

local function toggleSidebar()
    sidebarExpanded = not sidebarExpanded
    local targetWidth = sidebarExpanded and sidebarExpandedWidth or sidebarCollapsedWidth
    
    TweenService:Create(sidebar, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size=UDim2.new(0, targetWidth, 1, 0)
    }):Play()
    
    TweenService:Create(contentBg, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size=UDim2.new(1, -(targetWidth + 10), 1, -12),
        Position=UDim2.new(0, targetWidth + 6, 0, 6)
    }):Play()
    
    TweenService:Create(sidebarToggle, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position=UDim2.new(0, targetWidth - 2, 1, -54)
    }):Play()
    
    sidebarToggle.Text = sidebarExpanded and "◀" or "▶"
    
    -- Update brand visibility
    TweenService:Create(brandContainer, TweenInfo.new(0.25), {
        BackgroundTransparency=sidebarExpanded and 0.4 or 1
    }):Play()
    TweenService:Create(brandName, TweenInfo.new(0.25), {
        TextTransparency=sidebarExpanded and 0 or 1
    }):Play()
    
    -- Update all nav buttons
    for _, btnData in pairs(navButtons) do
        if btnData.text then
            btnData.text.Visible = sidebarExpanded
            TweenService:Create(btnData.icon, TweenInfo.new(0.25), {
                Size=sidebarExpanded and UDim2.new(0, 32, 0, 32) or UDim2.new(0, 28, 0, 28),
                Position=sidebarExpanded and UDim2.new(0, 8, 0.5, -16) or UDim2.new(0.5, -14, 0.5, -14)
            }):Play()
        end
    end
end

sidebarToggle.MouseButton1Click:Connect(toggleSidebar)

-- Enhanced Top Bar
local topBar = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1, 0, 0, 38),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar, CornerRadius=UDim.new(0, 10)})
new("UIStroke",{
    Parent=topBar,
    Color=colors.borderLight,
    Thickness=1,
    Transparency=0.6
})

-- Drag Handle
local dragHandle = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0, 35, 0, 3.5),
    Position=UDim2.new(0.5, -17.5, 0, 6),
    BackgroundColor3=colors.textDimmer,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=dragHandle, CornerRadius=UDim.new(1, 0)})

local pageTitle = new("TextLabel",{
    Parent=topBar,
    Text="Main Dashboard",
    Size=UDim2.new(1, -60, 1, 0),
    Position=UDim2.new(0, 14, 0, 0),
    Font=Enum.Font.GothamBold,
    TextSize=13,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Control buttons (ONLY MINIMIZE)
local controlsFrame = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0, 28, 0, 28),
    Position=UDim2.new(1, -32, 0.5, -14),
    BackgroundTransparency=1,
    ZIndex=6
})

local function createControlBtn(icon, color)
    local btn = new("TextButton",{
        Parent=controlsFrame,
        Size=UDim2.new(0, 28, 0, 28),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn, CornerRadius=UDim.new(0, 7)})
    
    local stroke = new("UIStroke",{
        Parent=btn,
        Color=color,
        Thickness=0,
        Transparency=0.6
    })
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3=color,
            BackgroundTransparency=0.15,
            TextColor3=colors.text,
            Size=UDim2.new(0, 30, 0, 30)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Thickness=1.5}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3=colors.bg4,
            BackgroundTransparency=0.3,
            TextColor3=colors.textDim,
            Size=UDim2.new(0, 28, 0, 28)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Thickness=0}):Play()
    end)
    return btn
end

local btnMin = createControlBtn("─", colors.warning)

-- Enhanced Resize Handle
local resizeHandle = new("TextButton",{
    Parent=win,
    Size=UDim2.new(0, 18, 0, 18),
    Position=UDim2.new(1, -18, 1, -18),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    Text="⋰",
    Font=Enum.Font.GothamBold,
    TextSize=11,
    TextColor3=colors.textDim,
    AutoButtonColor=false,
    ZIndex=100
})
new("UICorner",{Parent=resizeHandle, CornerRadius=UDim.new(0, 5)})
new("UIStroke",{
    Parent=resizeHandle,
    Color=colors.borderLight,
    Thickness=1,
    Transparency=0.5
})

-- Pages
local pages = {}
local currentPage = "Main"

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1, -10, 1, -44),
        Position=UDim2.new(0, 5, 0, 40),
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
        Padding=UDim.new(0, 10),
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0, 8),
        PaddingBottom=UDim.new(0, 8),
        PaddingLeft=UDim.new(0, 4),
        PaddingRight=UDim.new(0, 4)
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

-- LynxGUI_v2.2.lua - Compact Minimalist Black Edition (IMPROVED)
-- BAGIAN 2: Navigation, UI Components (Toggle, Input, Dropdown, Button, Category)

-- Enhanced Nav Button with proper text visibility
local function createNavButton(text, icon, page, order)
    local btn = new("Frame",{
        Parent=navContainer,
        Size=UDim2.new(1, 0, 0, 42),
        BackgroundColor3=page == currentPage and colors.bg3 or colors.bg2,
        BackgroundTransparency=page == currentPage and 0.3 or 0.6,
        BorderSizePixel=0,
        LayoutOrder=order,
        ZIndex=6
    })
    new("UICorner",{Parent=btn, CornerRadius=UDim.new(0, 8)})
    
    local btnStroke = new("UIStroke",{
        Parent=btn,
        Color=page == currentPage and colors.primary or colors.border,
        Thickness=page == currentPage and 1.5 or 0,
        Transparency=0.5
    })
    
    local clickBtn = new("TextButton",{
        Parent=btn,
        Size=UDim2.new(1, 0, 1, 0),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    
    local indicator = new("Frame",{
        Parent=btn,
        Size=UDim2.new(0, 3, 0, 20),
        Position=UDim2.new(0, 0, 0.5, -10),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        Visible=page == currentPage,
        ZIndex=8
    })
    new("UICorner",{Parent=indicator, CornerRadius=UDim.new(1, 0)})
    new("UIGradient",{
        Parent=indicator,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        },
        Rotation=90
    })
    
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=UDim2.new(0, 32, 0, 32),
        Position=UDim2.new(0, 8, 0.5, -16),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        ZIndex=8
    })
    
    local textLabel = new("TextLabel",{
        Parent=btn,
        Text=text,
        Size=UDim2.new(1, -48, 1, 0),
        Position=UDim2.new(0, 44, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,
        TextSize=11,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        Visible=true,  -- ALWAYS VISIBLE when sidebar expanded
        ZIndex=8
    })
    
    navButtons[page] = {
        btn=btn, 
        clickBtn=clickBtn,
        icon=iconLabel, 
        text=textLabel, 
        indicator=indicator,
        stroke=btnStroke
    }
    
    -- Hover effects
    clickBtn.MouseEnter:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency=0.4
            }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {
                Thickness=1,
                Color=colors.primary,
                Transparency=0.7
            }):Play()
        end
    end)
    
    clickBtn.MouseLeave:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency=0.6
            }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {
                Thickness=0
            }):Play()
        end
    end)
    
    return clickBtn
end

local function switchPage(pageName, pageTitle_text)
    if currentPage == pageName then return end
    for _, page in pairs(pages) do page.Visible = false end
    
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        
        TweenService:Create(btnData.btn, TweenInfo.new(0.25), {
            BackgroundColor3=isActive and colors.bg3 or colors.bg2,
            BackgroundTransparency=isActive and 0.3 or 0.6
        }):Play()
        
        TweenService:Create(btnData.stroke, TweenInfo.new(0.25), {
            Color=isActive and colors.primary or colors.border,
            Thickness=isActive and 1.5 or 0,
            Transparency=0.5
        }):Play()
        
        btnData.indicator.Visible = isActive
        
        TweenService:Create(btnData.icon, TweenInfo.new(0.25), {
            TextColor3=isActive and colors.primary or colors.textDim
        }):Play()
        
        TweenService:Create(btnData.text, TweenInfo.new(0.25), {
            TextColor3=isActive and colors.text or colors.textDim
        }):Play()
    end
    
    pages[pageName].Visible = true
    pageTitle.Text = pageTitle_text
    currentPage = pageName
end

local btnMain = createNavButton("Dashboard", "🏠", "Main", 1)
local btnTeleport = createNavButton("Teleport", "🌍", "Teleport", 2)
local btnShop = createNavButton("Shop", "🛒", "Shop", 3)
local btnSettings = createNavButton("Settings", "⚙️", "Settings", 4)
local btnInfo = createNavButton("About", "ℹ️", "Info", 5)

btnMain.MouseButton1Click:Connect(function() switchPage("Main", "Main Dashboard") end)
btnTeleport.MouseButton1Click:Connect(function() switchPage("Teleport", "Teleport System") end)
btnShop.MouseButton1Click:Connect(function() switchPage("Shop", "Shop Features") end)
btnSettings.MouseButton1Click:Connect(function() switchPage("Settings", "Settings") end)
btnInfo.MouseButton1Click:Connect(function() switchPage("Info", "About Lynx") end)

-- ==== UI COMPONENTS ====

-- Enhanced Category
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 40),
        BackgroundColor3=colors.bg3,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=false,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame, CornerRadius=UDim.new(0, 8)})
    
    local categoryStroke = new("UIStroke",{
        Parent=categoryFrame,
        Color=colors.border,
        Thickness=1,
        Transparency=0.5
    })
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1, 0, 0, 40),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ClipsDescendants=true,
        ZIndex=7
    })
    
    local iconBg = new("Frame",{
        Parent=header,
        Size=UDim2.new(0, 30, 0, 30),
        Position=UDim2.new(0, 8, 0.5, -15),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.85,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=iconBg, CornerRadius=UDim.new(0, 7)})
    
    local iconLabel = new("TextLabel",{
        Parent=iconBg,
        Text=icon,
        Size=UDim2.new(1, 0, 1, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=15,
        TextColor3=colors.primary,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1, -80, 1, 0),
        Position=UDim2.new(0, 42, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=12,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0, 24, 1, 0),
        Position=UDim2.new(1, -28, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    local contentContainer = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1, -16, 0, 0),
        Position=UDim2.new(0, 8, 0, 44),
        BackgroundTransparency=1,
        Visible=false,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=true,
        ZIndex=7
    })
    new("UIListLayout",{Parent=contentContainer, Padding=UDim.new(0, 8)})
    new("UIPadding",{Parent=contentContainer, PaddingBottom=UDim.new(0, 10)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
            Rotation=isOpen and 180 or 0
        }):Play()
        
        TweenService:Create(categoryFrame, TweenInfo.new(0.25), {
            BackgroundTransparency=isOpen and 0.25 or 0.4
        }):Play()
        
        TweenService:Create(categoryStroke, TweenInfo.new(0.25), {
            Color=isOpen and colors.primary or colors.border,
            Thickness=isOpen and 1.5 or 1,
            Transparency=isOpen and 0.4 or 0.5
        }):Play()
        
        TweenService:Create(iconBg, TweenInfo.new(0.25), {
            BackgroundTransparency=isOpen and 0.7 or 0.85
        }):Play()
    end)
    
    return contentContainer
end

-- Enhanced Toggle
local function makeToggle(parent, label, callback)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 36),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.5,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=frame, CornerRadius=UDim.new(0, 7)})
    new("UIStroke",{
        Parent=frame,
        Color=colors.border,
        Thickness=1,
        Transparency=0.6
    })
    
    local labelText = new("TextLabel",{
        Parent=frame,
        Text=label,
        Size=UDim2.new(0.6, 0, 1, 0),
        Position=UDim2.new(0, 10, 0, 0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=10,
        TextWrapped=true,
        ZIndex=8
    })
    
    local toggleBg = new("Frame",{
        Parent=frame,
        Size=UDim2.new(0, 42, 0, 22),
        Position=UDim2.new(1, -46, 0.5, -11),
        BackgroundColor3=colors.bg4,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=toggleBg, CornerRadius=UDim.new(1, 0)})
    new("UIStroke",{
        Parent=toggleBg,
        Color=colors.border,
        Thickness=1,
        Transparency=0.5
    })
    
    local toggleCircle = new("Frame",{
        Parent=toggleBg,
        Size=UDim2.new(0, 18, 0, 18),
        Position=UDim2.new(0, 2, 0.5, -9),
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
        
        TweenService:Create(toggleBg, TweenInfo.new(0.25), {
            BackgroundColor3=on and colors.primary or colors.bg4
        }):Play()
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position=on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
            BackgroundColor3=on and colors.text or colors.textDim
        }):Play()
        
        callback(on)
    end)
end

-- Enhanced Input for Delay
local function makeInput(parent, label, defaultValue, callback)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 56),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local lbl = new("TextLabel",{
        Parent=frame,
        Text=label,
        Size=UDim2.new(1, 0, 0, 18),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium,
        TextSize=10,
        ZIndex=8
    })
    
    local inputBg = new("Frame",{
        Parent=frame,
        Size=UDim2.new(1, 0, 0, 32),
        Position=UDim2.new(0, 0, 0, 22),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=inputBg, CornerRadius=UDim.new(0, 7)})
    
    local inputStroke = new("UIStroke",{
        Parent=inputBg,
        Color=colors.border,
        Thickness=1,
        Transparency=0.5
    })
    
    local inputBox = new("TextBox",{
        Parent=inputBg,
        Size=UDim2.new(1, -20, 1, 0),
        Position=UDim2.new(0, 10, 0, 0),
        BackgroundTransparency=1,
        Text=tostring(defaultValue),
        PlaceholderText="Enter value...",
        Font=Enum.Font.Gotham,
        TextSize=10,
        TextColor3=colors.text,
        PlaceholderColor3=colors.textDimmer,
        TextXAlignment=Enum.TextXAlignment.Left,
        ClearTextOnFocus=false,
        ZIndex=9
    })
    
    inputBox.Focused:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {
            Color=colors.primary,
            Thickness=1.5,
            Transparency=0.3
        }):Play()
        TweenService:Create(inputBg, TweenInfo.new(0.2), {
            BackgroundTransparency=0.25
        }):Play()
    end)
    
    inputBox.FocusLost:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {
            Color=colors.border,
            Thickness=1,
            Transparency=0.5
        }):Play()
        TweenService:Create(inputBg, TweenInfo.new(0.2), {
            BackgroundTransparency=0.4
        }):Play()
        
        local value = tonumber(inputBox.Text)
        if value then
            callback(value)
        else
            inputBox.Text = tostring(defaultValue)
        end
    end)
end

-- Enhanced Dropdown
local function makeDropdown(parent, title, icon, items, onSelect, uniqueId)
    local dropdownFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 44),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=7,
        Name=uniqueId or "Dropdown"
    })
    new("UICorner",{Parent=dropdownFrame, CornerRadius=UDim.new(0, 8)})
    
    local dropStroke = new("UIStroke",{
        Parent=dropdownFrame,
        Color=colors.border,
        Thickness=1,
        Transparency=0.5
    })
    
    local header = new("TextButton",{
        Parent=dropdownFrame,
        Size=UDim2.new(1, -16, 0, 40),
        Position=UDim2.new(0, 8, 0, 2),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=8
    })
    
    local iconLabel = new("TextLabel",{
        Parent=header,
        Text=icon,
        Size=UDim2.new(0, 28, 1, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=14,
        TextColor3=colors.primary,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1, -75, 0, 16),
        Position=UDim2.new(0, 32, 0, 4),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=10,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local statusLabel = new("TextLabel",{
        Parent=header,
        Text="None Selected",
        Size=UDim2.new(1, -75, 0, 14),
        Position=UDim2.new(0, 32, 0, 22),
        BackgroundTransparency=1,
        Font=Enum.Font.Gotham,
        TextSize=9,
        TextColor3=colors.textDimmer,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0, 28, 1, 0),
        Position=UDim2.new(1, -28, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=colors.primary,
        ZIndex=9
    })
    
    local listContainer = new("ScrollingFrame",{
        Parent=dropdownFrame,
        Size=UDim2.new(1, -16, 0, 0),
        Position=UDim2.new(0, 8, 0, 46),
        BackgroundTransparency=1,
        Visible=false,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=UDim2.new(0, 0, 0, 0),
        ScrollBarThickness=3,
        ScrollBarImageColor3=colors.primary,
        BorderSizePixel=0,
        ClipsDescendants=true,
        ZIndex=10
    })
    new("UIListLayout",{Parent=listContainer, Padding=UDim.new(0, 5)})
    new("UIPadding",{Parent=listContainer, PaddingBottom=UDim.new(0, 10)})
    
    local isOpen = false
    local selectedItem = nil
    
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
            Rotation=isOpen and 180 or 0
        }):Play()
        
        TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {
            BackgroundTransparency=isOpen and 0.25 or 0.4
        }):Play()
        
        TweenService:Create(dropStroke, TweenInfo.new(0.25), {
            Color=isOpen and colors.primary or colors.border,
            Thickness=isOpen and 1.5 or 1,
            Transparency=isOpen and 0.4 or 0.5
        }):Play()
        
        if isOpen then
            listContainer.Size = UDim2.new(1, -16, 0, math.min(#items * 32, 160))
        end
    end)
    
    for _, itemName in ipairs(items) do
        local itemBtn = new("TextButton",{
            Parent=listContainer,
            Size=UDim2.new(1, 0, 0, 30),
            BackgroundColor3=colors.bg4,
            BackgroundTransparency=0.5,
            BorderSizePixel=0,
            Text="",
            AutoButtonColor=false,
            ZIndex=11
        })
        new("UICorner",{Parent=itemBtn, CornerRadius=UDim.new(0, 6)})
        
        local itemStroke = new("UIStroke",{
            Parent=itemBtn,
            Color=colors.border,
            Thickness=0,
            Transparency=0.6
        })
        
        local btnLabel = new("TextLabel",{
            Parent=itemBtn,
            Text=itemName,
            Size=UDim2.new(1, -16, 1, 0),
            Position=UDim2.new(0, 8, 0, 0),
            BackgroundTransparency=1,
            Font=Enum.Font.GothamMedium,
            TextSize=9,
            TextColor3=colors.textDim,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
            ZIndex=12
        })
        
        itemBtn.MouseEnter:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                    BackgroundColor3=colors.primary,
                    BackgroundTransparency=0.25
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.2), {
                    TextColor3=colors.text
                }):Play()
                TweenService:Create(itemStroke, TweenInfo.new(0.2), {
                    Thickness=1.5,
                    Color=colors.primary
                }):Play()
            end
        end)
        
        itemBtn.MouseLeave:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                    BackgroundColor3=colors.bg4,
                    BackgroundTransparency=0.5
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.2), {
                    TextColor3=colors.textDim
                }):Play()
                TweenService:Create(itemStroke, TweenInfo.new(0.2), {
                    Thickness=0
                }):Play()
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
            TweenService:Create(arrow, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
                Rotation=0
            }):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {
                BackgroundTransparency=0.4
            }):Play()
            TweenService:Create(dropStroke, TweenInfo.new(0.25), {
                Color=colors.border,
                Thickness=1,
                Transparency=0.5
            }):Play()
        end)
    end
    
    return dropdownFrame
end

-- Enhanced Button
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 36),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.15,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=btnFrame, CornerRadius=UDim.new(0, 8)})
    new("UIGradient",{
        Parent=btnFrame,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        },
        Rotation=45
    })
    
    local btnStroke = new("UIStroke",{
        Parent=btnFrame,
        Color=colors.primary,
        Thickness=1,
        Transparency=0.5
    })
    
    local button = new("TextButton",{
        Parent=btnFrame,
        Size=UDim2.new(1, 0, 1, 0),
        BackgroundTransparency=1,
        Text=label,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=colors.text,
        AutoButtonColor=false,
        ZIndex=9
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {
            BackgroundTransparency=0,
            Size=UDim2.new(1, 0, 0, 38)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {
            Thickness=2,
            Transparency=0.3
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {
            BackgroundTransparency=0.15,
            Size=UDim2.new(1, 0, 0, 36)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {
            Thickness=1,
            Transparency=0.5
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.1), {
            Size=UDim2.new(0.98, 0, 0, 34)
        }):Play()
        task.wait(0.1)
        TweenService:Create(btnFrame, TweenInfo.new(0.1), {
            Size=UDim2.new(1, 0, 0, 36)
        }):Play()
        pcall(callback)
    end)
    
    return btnFrame
end

-- LynxGUI_v2.2.lua - Compact Minimalist Black Edition (IMPROVED)
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

makeInput(catAutoFishing, "Fishing Delay", "1.30", function(v)
    fishingDelayValue = v
    instant.Settings.MaxWaitTime = v
    instant2.Settings.MaxWaitTime = v
end)

makeInput(catAutoFishing, "Cancel Delay", "0.19", function(v)
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

makeInput(catBlatantV1, "Complete Delay", "0.05", function(v)
    blatantv1.Settings.CompleteDelay = v
    print("✅ Complete Delay set to: " .. v)
end)

makeInput(catBlatantV1, "Cancel Delay", "0.1", function(v)
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

makeInput(catBlatantV2, "Fishing Delay", "0.05", function(v) 
    blatantv2.Settings.FishingDelay = v 
end)

makeInput(catBlatantV2, "Cancel Delay", "0.01", function(v) 
    blatantv2.Settings.CancelDelay = v 
end)

makeInput(catBlatantV2, "Hook Wait Time", "0.15", function(v) 
    blatantv2.Settings.HookWaitTime = v 
end)

makeInput(catBlatantV2, "Cast Delay", "0.03", function(v) 
    blatantv2.Settings.CastDelay = v 
end)

makeInput(catBlatantV2, "Timeout Delay", "0.8", function(v) 
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

makeDropdown(teleportPage, "Teleport to Player", "👤", playerItems, function(selectedPlayer)
    TeleportToPlayer.TeleportTo(selectedPlayer)
end, "PlayerTeleport")

local function refreshPlayerList()
    table.clear(playerItems)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerItems, player.Name)
        end
    end
    table.sort(playerItems)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- ==== SHOP PAGE ====
local catSell = makeCategory(shopPage, "Auto Sell System", "💰")

makeButton(catSell, "Sell All Now", function()
    if AutoSell and AutoSell.SellOnce then
        AutoSell.SellOnce()
    end
end)

local catTimer = makeCategory(shopPage, "Auto Sell Timer", "⏰")

makeInput(catTimer, "Sell Interval (seconds)", "5", function(value)
    AutoSellTimer.SetInterval(value)
end)

makeButton(catTimer, "Start Auto Sell", function()
    if AutoSellTimer then
        AutoSellTimer.Start(AutoSellTimer.Interval)
    end
end)

makeButton(catTimer, "Stop Auto Sell", function()
    if AutoSellTimer then
        AutoSellTimer.Stop()
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
    Size=UDim2.new(1, 0, 0, 460),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=infoContainer, CornerRadius=UDim.new(0, 10)})
new("UIStroke",{
    Parent=infoContainer,
    Color=colors.borderLight,
    Thickness=1.5,
    Transparency=0.5
})

local infoText = new("TextLabel",{
    Parent=infoContainer,
    Size=UDim2.new(1, -28, 1, -28),
    Position=UDim2.new(0, 14, 0, 14),
    BackgroundTransparency=1,
    Text=[[
🧡 LYNX v2.2 PREMIUM COMPACT

Minimalist Black Premium Design
━━━━━━━━━━━━━━━━━━━━━━

🎣 AUTO FISHING
• Instant Fishing (Fast/Perfect)
• Input-based delay controls
• Blatant Mode V1 & V2
• Advanced automation
• Precise delay adjustments

🛠️ SUPPORT FEATURES
• No Fishing Animation
• Performance optimizations
• Smooth interactions

🌍 TELEPORT SYSTEM
• Location teleport
• Player teleport
• Smart dropdown selection
• Real-time player list

💰 SHOP FEATURES
• Auto Sell (instant & timer)
• Auto Buy Weather
• Organized categories
• Customizable intervals

⚙️ SETTINGS
• Anti-AFK Protection
• FPS Unlocker (60-240 FPS)
• General preferences
• Performance modes

━━━━━━━━━━━━━━━━━━━━━━

💡 PREMIUM FEATURES v2.2
✓ Minimalist black design
✓ Enhanced navigation bars
✓ Smooth animations
✓ Input-based delay system
✓ Logo only on minimize
✓ Compact UI (480x300)
✓ Subtle rounded corners
✓ No close button
✓ Same for mobile & PC
✓ Premium gradients
✓ Better performance
✓ Enhanced hover effects
✓ Organized categories

🎮 CONTROLS
• Click categories to expand
• Drag from top bar to move
• Drag corner to resize
• (◀/▶) Toggle sidebar
• (─) Minimize window
• Click minimized icon to restore

━━━━━━━━━━━━━━━━━━━━━━

💎 Created with 🧡 by Lynx Team
Premium Compact Edition 2024
    ]],
    Font=Enum.Font.Gotham,
    TextSize=10,
    TextColor3=colors.text,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=7
})

-- ==== MINIMIZE SYSTEM WITH LOGO ====
local minimized = false
local icon
local savedIconPos = UDim2.new(0, 20, 0, 100)

local function createMinimizedIcon()
    if icon then return end
    
    icon = new("Frame",{
        Parent=gui,
        Size=UDim2.new(0, 56, 0, 56),
        Position=savedIconPos,
        BackgroundColor3=colors.bg2,
        BackgroundTransparency=0.15,
        BorderSizePixel=0,
        ZIndex=100
    })
    new("UICorner",{Parent=icon, CornerRadius=UDim.new(0, 12)})
    
    local iconStroke = new("UIStroke",{
        Parent=icon,
        Color=colors.primary,
        Thickness=2,
        Transparency=0.4
    })
    new("UIGradient",{
        Parent=iconStroke,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        },
        Rotation=45
    })
    
    local logoImage = new("ImageLabel",{
        Parent=icon,
        Size=UDim2.new(0.75, 0, 0.75, 0),
        Position=UDim2.new(0.125, 0, 0.125, 0),
        BackgroundTransparency=1,
        Image="rbxassetid://111416780887356",
        ScaleType=Enum.ScaleType.Fit,
        ZIndex=101
    })
    
    local logoText = new("TextLabel",{
        Parent=icon,
        Text="L",
        Size=UDim2.new(1, 0, 1, 0),
        Font=Enum.Font.GothamBold,
        TextSize=32,
        BackgroundTransparency=1,
        TextColor3=colors.primary,
        Visible=logoImage.Image == "",
        ZIndex=101
    })
    
    local clickDetector = new("TextButton",{
        Parent=icon,
        Size=UDim2.new(1, 0, 1, 0),
        BackgroundTransparency=1,
        Text="",
        ZIndex=102
    })
    
    local dragging, dragStart, startPos, dragMoved = false, nil, nil, false
    
    clickDetector.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragMoved, dragStart, startPos = true, false, input.Position, icon.Position
        end
    end)
    
    clickDetector.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.sqrt(delta.X^2 + delta.Y^2) > 5 then 
                dragMoved = true 
            end
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(icon, TweenInfo.new(0.05), {Position=newPos}):Play()
        end
    end)
    
    clickDetector.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                savedIconPos = icon.Position
                if not dragMoved then
                    -- Restore window
                    win.Visible = true
                    win.Size = UDim2.new(0, 0, 0, 0)
                    win.Position = UDim2.new(0.5, 0, 0.5, 0)
                    
                    TweenService:Create(win, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size=windowSize,
                        Position=UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
                    }):Play()
                    
                    TweenService:Create(icon, TweenInfo.new(0.3), {
                        Size=UDim2.new(0, 0, 0, 0)
                    }):Play()
                    
                    task.wait(0.3)
                    if icon then 
                        icon:Destroy() 
                        icon = nil 
                    end
                    minimized = false
                end
            end
        end
    end)
    
    -- Hover effect
    clickDetector.MouseEnter:Connect(function()
        TweenService:Create(icon, TweenInfo.new(0.2), {
            Size=UDim2.new(0, 60, 0, 60)
        }):Play()
        TweenService:Create(iconStroke, TweenInfo.new(0.2), {
            Thickness=3,
            Transparency=0.2
        }):Play()
    end)
    
    clickDetector.MouseLeave:Connect(function()
        if not dragging then
            TweenService:Create(icon, TweenInfo.new(0.2), {
                Size=UDim2.new(0, 56, 0, 56)
            }):Play()
            TweenService:Create(iconStroke, TweenInfo.new(0.2), {
                Thickness=2,
                Transparency=0.4
            }):Play()
        end
    end)
end

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        local targetPos = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size=UDim2.new(0, 0, 0, 0),
            Position=targetPos
        }):Play()
        task.wait(0.4)
        win.Visible = false
        createMinimizedIcon()
        minimized = true
    end
end)

-- ==== DRAGGING SYSTEM ====
local dragging, dragStart, startPos = false, nil, nil
local dragTween = nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, win.Position
        if dragTween then dragTween:Cancel() end
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
        if dragTween then dragTween:Cancel() end
        dragTween = TweenService:Create(win, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position=newPos})
        dragTween:Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

-- ==== RESIZING SYSTEM ====
local resizing = false
local resizeStart, startSize = nil, nil
local resizeTween = nil

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing, resizeStart, startSize = true, input.Position, win.Size
        if resizeTween then resizeTween:Cancel() end
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
        
        if resizeTween then resizeTween:Cancel() end
        resizeTween = TweenService:Create(win, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
            Size=newSize
        })
        resizeTween:Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        resizing = false 
    end
end)

-- Resize handle hover effect
resizeHandle.MouseEnter:Connect(function()
    TweenService:Create(resizeHandle, TweenInfo.new(0.2), {
        BackgroundTransparency=0.25,
        Size=UDim2.new(0, 20, 0, 20)
    }):Play()
end)

resizeHandle.MouseLeave:Connect(function()
    if not resizing then
        TweenService:Create(resizeHandle, TweenInfo.new(0.2), {
            BackgroundTransparency=0.4,
            Size=UDim2.new(0, 18, 0, 18)
        }):Play()
    end
end)

-- ==== OPENING ANIMATION ====
task.spawn(function()
    win.Size = UDim2.new(0, 0, 0, 0)
    win.Position = UDim2.new(0.5, 0, 0.5, 0)
    win.Rotation = 0
    
    task.wait(0.15)
    
    TweenService:Create(win, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size=windowSize,
        Position=UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    }):Play()
end)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✨ Lynx GUI v2.2 Premium Compact")
print("🎉 ALL PARTS LOADED SUCCESSFULLY!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("📦 Features:")
print("  ✓ Input-based delay controls")
print("  ✓ Premium black design")
print("  ✓ Enhanced navigation")
print("  ✓ Logo on minimize")
print("  ✓ Smooth animations")
print("  ✓ Better UI components")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎮 Controls:")
print("  • Drag top bar to move")
print("  • Drag corner to resize")
print("  • (◀/▶) Toggle sidebar")
print("  • (─) Minimize window")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("💎 Created by Lynx Team")
print("🧡 Premium Edition 2024")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
