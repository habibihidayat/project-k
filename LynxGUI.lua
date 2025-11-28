-- LynxGUI_v2.3.lua - Galaxy Edition
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
local windowSize = UDim2.new(0, 420, 0, 280)
local minWindowSize = Vector2.new(380, 250)
local maxWindowSize = Vector2.new(550, 400)

-- Sidebar state (Start collapsed to show only icons)
local sidebarExpanded = false
local sidebarCollapsedWidth = 50
local sidebarExpandedWidth = 140

local gui = new("ScreenGui",{
    Name="LynxGUI_Galaxy",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Main Window Container
local win = new("Frame",{
    Parent=gui,
    Size=windowSize,
    Position=UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
    BackgroundColor3=colors.bg1,
    BackgroundTransparency=0.25,
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win, CornerRadius=UDim.new(0, 8)})
new("UIStroke",{
    Parent=win,
    Color=colors.border,
    Thickness=1,
    Transparency=0.5,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Sidebar (Below header, start collapsed)
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0, sidebarCollapsedWidth, 1, -45),
    Position=UDim2.new(0, 0, 0, 45),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=sidebar, CornerRadius=UDim.new(0, 8)})

-- Sidebar Toggle Button (Outside sidebar, fixed position)
local sidebarToggle = new("TextButton",{
    Parent=win,
    Size=UDim2.new(0, 24, 0, 40),
    Position=UDim2.new(0, sidebarCollapsedWidth - 2, 1, -50),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    Text="▶",
    Font=Enum.Font.GothamBold,
    TextSize=12,
    TextColor3=colors.primary,
    ZIndex=101,
    ClipsDescendants=false
})
new("UICorner",{Parent=sidebarToggle, CornerRadius=UDim.new(0, 6)})
new("UIStroke",{
    Parent=sidebarToggle,
    Color=colors.border,
    Thickness=1,
    Transparency=0.6
})

-- Script Header (INSIDE window, at the top)
local scriptHeader = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, 0, 0, 45),
    Position=UDim2.new(0, 0, 0, 0),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=scriptHeader, CornerRadius=UDim.new(0, 8)})

-- Drag Handle for Header (Subtle indicator)
local headerDragHandle = new("Frame",{
    Parent=scriptHeader,
    Size=UDim2.new(0, 35, 0, 3),
    Position=UDim2.new(0.5, -17.5, 0, 6),
    BackgroundColor3=colors.textDimmer,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=headerDragHandle, CornerRadius=UDim.new(1, 0)})

-- Title with gradient effect
local titleLabel = new("TextLabel",{
    Parent=scriptHeader,
    Text="LynX",
    Size=UDim2.new(0, 80, 1, 0),
    Position=UDim2.new(0, 15, 0, 0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,
    TextSize=16,
    TextColor3=colors.primary,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Separator
local separator = new("Frame",{
    Parent=scriptHeader,
    Size=UDim2.new(0, 2, 0, 25),
    Position=UDim2.new(0, 95, 0.5, -12.5),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=separator, CornerRadius=UDim.new(1, 0)})

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
    ZIndex=6
})

-- Minimize button in header
local btnMinHeader = new("TextButton",{
    Parent=scriptHeader,
    Size=UDim2.new(0, 28, 0, 28),
    Position=UDim2.new(1, -36, 0.5, -14),
    BackgroundColor3=colors.bg4,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    Text="─",
    Font=Enum.Font.GothamBold,
    TextSize=16,
    TextColor3=colors.textDim,
    AutoButtonColor=false,
    ZIndex=7
})
new("UICorner",{Parent=btnMinHeader, CornerRadius=UDim.new(0, 6)})

btnMinHeader.MouseEnter:Connect(function()
    TweenService:Create(btnMinHeader, TweenInfo.new(0.2), {
        BackgroundColor3=colors.galaxy1,
        BackgroundTransparency=0.2,
        TextColor3=colors.text
    }):Play()
end)

btnMinHeader.MouseLeave:Connect(function()
    TweenService:Create(btnMinHeader, TweenInfo.new(0.2), {
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.4,
        TextColor3=colors.textDim
    }):Play()
end)

-- Navigation Container (Below header)
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1, -4, 1, -50),
    Position=UDim2.new(0, 2, 0, 48),
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

-- Content Area (Below header, adjusted for collapsed sidebar)
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1, -(sidebarCollapsedWidth + 7), 1, -55),
    Position=UDim2.new(0, sidebarCollapsedWidth + 3, 0, 48),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg, CornerRadius=UDim.new(0, 8)})

-- Function to toggle sidebar
local function toggleSidebar()
    sidebarExpanded = not sidebarExpanded
    local targetWidth = sidebarExpanded and sidebarExpandedWidth or sidebarCollapsedWidth
    
    TweenService:Create(sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size=UDim2.new(0, targetWidth, 1, -45)
    }):Play()
    
    TweenService:Create(contentBg, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size=UDim2.new(1, -(targetWidth + 7), 1, -55),
        Position=UDim2.new(0, targetWidth + 3, 0, 48)
    }):Play()
    
    if sidebarToggle then
        TweenService:Create(sidebarToggle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position=UDim2.new(0, targetWidth - 2, 1, -50)
        }):Play()
        sidebarToggle.Text = sidebarExpanded and "◀" or "▶"
    end
    
    -- Update nav buttons visibility
    for _, data in pairs(navButtons) do
        data.text.Visible = sidebarExpanded
        if sidebarExpanded then
            -- Show text, icon on left
            TweenService:Create(data.icon, TweenInfo.new(0.3), {
                Size=UDim2.new(0, 28, 1, 0),
                Position=UDim2.new(0, 8, 0, 0)
            }):Play()
        else
            -- Hide text, icon centered
            TweenService:Create(data.icon, TweenInfo.new(0.3), {
                Size=UDim2.new(1, 0, 1, 0),
                Position=UDim2.new(0, 0, 0, 0)
            }):Play()
        end
    end
end

sidebarToggle.MouseButton1Click:Connect(toggleSidebar)

-- Top Bar (Page Title)
local topBar = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1, 0, 0, 32),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar, CornerRadius=UDim.new(0, 8)})

local pageTitle = new("TextLabel",{
    Parent=topBar,
    Text="Main Dashboard",
    Size=UDim2.new(1, -20, 1, 0),
    Position=UDim2.new(0, 10, 0, 0),
    Font=Enum.Font.GothamBold,
    TextSize=11,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Resize Handle
local resizeHandle = new("TextButton",{
    Parent=win,
    Size=UDim2.new(0, 16, 0, 16),
    Position=UDim2.new(1, -16, 1, -16),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    Text="⋰",
    Font=Enum.Font.GothamBold,
    TextSize=10,
    TextColor3=colors.textDim,
    AutoButtonColor=false,
    ZIndex=100
})
new("UICorner",{Parent=resizeHandle, CornerRadius=UDim.new(0, 4)})

-- Pages
local pages = {}
local currentPage = "Main"
local navButtons = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1, -8, 1, -38),
        Position=UDim2.new(0, 4, 0, 34),
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
        PaddingTop=UDim.new(0, 6),
        PaddingBottom=UDim.new(0, 6)
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

-- LynxGUI_v2.3.lua - Galaxy Edition
-- BAGIAN 2: Navigation, UI Components (Toggle, Input Horizontal, Dropdown, Button, Category)

-- Nav Button - Show text only when expanded
local function createNavButton(text, icon, page, order)
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1, 0, 0, 36),
        BackgroundColor3=page == currentPage and colors.bg3 or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency=page == currentPage and 0.4 or 1,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        LayoutOrder=order,
        ZIndex=6
    })
    new("UICorner",{Parent=btn, CornerRadius=UDim.new(0, 6)})
    
    local indicator = new("Frame",{
        Parent=btn,
        Size=UDim2.new(0, 2.5, 0, 18),
        Position=UDim2.new(0, 0, 0.5, -9),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        Visible=page == currentPage,
        ZIndex=7
    })
    new("UICorner",{Parent=indicator, CornerRadius=UDim.new(1, 0)})
    
    -- Icon - centered when collapsed, left when expanded
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=UDim2.new(1, 0, 1, 0),
        Position=UDim2.new(0, 0, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=14,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        ZIndex=7
    })
    
    -- Text - hidden when collapsed
    local textLabel = new("TextLabel",{
        Parent=btn,
        Text=text,
        Size=UDim2.new(1, -40, 1, 0),
        Position=UDim2.new(0, 36, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,
        TextSize=10,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        Visible=false,
        ZIndex=7
    })
    
    navButtons[page] = {btn=btn, icon=iconLabel, text=textLabel, indicator=indicator}
    
    return btn
end

local function switchPage(pageName, pageTitle_text)
    if currentPage == pageName then return end
    for _, page in pairs(pages) do page.Visible = false end
    
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        TweenService:Create(btnData.btn, TweenInfo.new(0.2), {
            BackgroundColor3=isActive and colors.bg3 or Color3.fromRGB(0, 0, 0),
            BackgroundTransparency=isActive and 0.4 or 1
        }):Play()
        btnData.indicator.Visible = isActive
        TweenService:Create(btnData.icon, TweenInfo.new(0.2), {
            TextColor3=isActive and colors.primary or colors.textDim
        }):Play()
        if sidebarExpanded then
            TweenService:Create(btnData.text, TweenInfo.new(0.2), {
                TextColor3=isActive and colors.text or colors.textDim
            }):Play()
        end
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

-- Category
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 36),
        BackgroundColor3=colors.bg3,
        BackgroundTransparency=0.5,
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
        Transparency=0.7
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
    
    local iconLabel = new("TextLabel",{
        Parent=header,
        Text=icon,
        Size=UDim2.new(0, 28, 1, 0),
        Position=UDim2.new(0, 8, 0, 0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=14,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1, -70, 1, 0),
        Position=UDim2.new(0, 36, 0, 0),
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
        Size=UDim2.new(1, -12, 0, 0),
        Position=UDim2.new(0, 6, 0, 38),
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
            BackgroundTransparency=isOpen and 0.3 or 0.5
        }):Play()
        TweenService:Create(categoryStroke, TweenInfo.new(0.25), {Thickness=isOpen and 1 or 0}):Play()
    end)
    
    return contentContainer
end

-- Toggle
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
        Size=UDim2.new(0.65, 0, 1, 0),
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
        Position=UDim2.new(1, -40, 0.5, -10),
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

-- Input HORIZONTAL (Label left, Input right)
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
        Size=UDim2.new(0.55, 0, 1, 0),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium,
        TextSize=9,
        ZIndex=8
    })
    
    local inputBg = new("Frame",{
        Parent=frame,
        Size=UDim2.new(0.4, 0, 0, 28),
        Position=UDim2.new(0.58, 0, 0.5, -14),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=inputBg, CornerRadius=UDim.new(0, 6)})
    
    local inputStroke = new("UIStroke",{
        Parent=inputBg,
        Color=colors.border,
        Thickness=1,
        Transparency=0.6
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
            Transparency=0.6
        }):Play()
        
        local value = tonumber(inputBox.Text)
        if value then
            callback(value)
        else
            inputBox.Text = tostring(defaultValue)
        end
    end)
end

-- Dropdown
local function makeDropdown(parent, title, icon, items, onSelect, uniqueId)
    local dropdownFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 40),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.4,
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
        Transparency=0.7
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
            BackgroundTransparency=isOpen and 0.25 or 0.4
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
            BackgroundTransparency=0.5,
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
            Transparency=0.7
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
                    BackgroundTransparency=0.2
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.2), {TextColor3=colors.text}):Play()
                TweenService:Create(itemStroke, TweenInfo.new(0.2), {Thickness=1}):Play()
            end
        end)
        
        itemBtn.MouseLeave:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                    BackgroundColor3=colors.bg4,
                    BackgroundTransparency=0.5
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
                BackgroundTransparency=0.4
            }):Play()
            TweenService:Create(dropStroke, TweenInfo.new(0.25), {Thickness=0}):Play()
        end)
    end
    
    return dropdownFrame
end

-- Button
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1, 0, 0, 32),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=btnFrame, CornerRadius=UDim.new(0, 6)})
    
    local btnStroke = new("UIStroke",{
        Parent=btnFrame,
        Color=colors.primary,
        Thickness=0,
        Transparency=0.6
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
            BackgroundTransparency=0,
            Size=UDim2.new(1, 0, 0, 35)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Thickness=1.5}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {
            BackgroundTransparency=0.2,
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

-- LynxGUI_v2.3.lua - Galaxy Edition
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

makeInput(catTimer, "Sell Interval (seconds)", 5, function(value)
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
    Size=UDim2.new(1, 0, 0, 420),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=infoContainer, CornerRadius=UDim.new(0, 8)})
new("UIStroke",{
    Parent=infoContainer,
    Color=colors.border,
    Thickness=1,
    Transparency=0.6
})

local infoText = new("TextLabel",{
    Parent=infoContainer,
    Size=UDim2.new(1, -24, 1, -24),
    Position=UDim2.new(0, 12, 0, 12),
    BackgroundTransparency=1,
    Text=[[
💜 LynX v2.3 GALAXY EDITION

Free Not For Sale
━━━━━━━━━━━━━━━━━━━━━━

🎣 AUTO FISHING
• Instant Fishing (Fast/Perfect)
• Horizontal input layout
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

💡 NEW IN v2.3 GALAXY
✓ Galaxy purple theme
✓ Input horizontal layout
✓ Fixed script header
✓ Better sidebar navigation
✓ Tab names always visible
✓ No orange borders
✓ Smooth animations
✓ Better performance

🎮 CONTROLS
• Click categories to expand
• Drag from top bar to move
• Drag corner to resize
• (▶/◀) Toggle sidebar
• (─) Minimize window

━━━━━━━━━━━━━━━━━━━━━━

Created with 💜 by Lynx Team
Galaxy Edition 2024
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
        BackgroundTransparency=0.2,
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
        Transparency=0.4
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

-- ==== DRAGGING SYSTEM (From Header) ====
local dragging, dragStart, startPos = false, nil, nil
local dragTween = nil

scriptHeader.InputBegan:Connect(function(input)
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

resizeHandle.MouseEnter:Connect(function()
    TweenService:Create(resizeHandle, TweenInfo.new(0.2), {
        BackgroundTransparency=0.3,
        Size=UDim2.new(0, 18, 0, 18)
    }):Play()
end)

resizeHandle.MouseLeave:Connect(function()
    if not resizing then
        TweenService:Create(resizeHandle, TweenInfo.new(0.2), {
            BackgroundTransparency=0.5,
            Size=UDim2.new(0, 16, 0, 16)
        }):Play()
    end
end)

-- ==== OPENING ANIMATION ====
task.spawn(function()
    win.Size = UDim2.new(0, 0, 0, 0)
    win.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    
    task.wait(0.1)
    
    TweenService:Create(win, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size=windowSize
    }):Play()
end)

print("━━━━━━━━━━━━━━━━━━━━━━")
print("✨ Lynx GUI v2.3 Galaxy Edition")
print("💜 FREE NOT FOR SALE")
print("━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 ALL PARTS LOADED!")
print("━━━━━━━━━━━━━━━━━━━━━━")
print("📦 Features:")
print("  • Galaxy purple theme")
print("  • Horizontal input layout")
print("  • Fixed script header")
print("  • Tab names always visible")
print("  • Smooth animations")
print("━━━━━━━━━━━━━━━━━━━━━━")
print("💎 Created by Lynx Team")
print("━━━━━━━━━━━━━━━━━━━━━━")
