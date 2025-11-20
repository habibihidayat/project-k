-- LynxGUI_v2.1.lua - Ultra Premium Enhanced Edition ✨
-- Glass Morphism with Enhanced Colors & Perfect Resize

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
local BlatantAutoFishing = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/BlatantAutoFishing.lua"))()
local NoFishingAnimation = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/NoFishingAnimation.lua"))()
local TeleportModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportModule.lua"))()
local TeleportToPlayer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportSystem/TeleportToPlayer.lua"))()
local AutoSell = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSell.lua"))()
local AutoSellTimer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSellTimer.lua"))()
local AntiAFK = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/AntiAFK.lua"))()
local UnlockFPS = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/UnlockFPS.lua"))()
local AutoBuyWeather = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoBuyWeather.lua"))()

-- Enhanced Premium Color Palette with Vibrant Colors
local colors = {
    primary = Color3.fromRGB(99, 115, 255),      -- Brighter primary
    secondary = Color3.fromRGB(138, 161, 255),   -- Brighter secondary
    accent = Color3.fromRGB(255, 130, 255),      -- Brighter accent
    success = Color3.fromRGB(77, 201, 149),      -- Brighter success
    warning = Color3.fromRGB(255, 186, 46),      -- Brighter warning
    danger = Color3.fromRGB(255, 86, 89),        -- Brighter danger
    
    bg1 = Color3.fromRGB(20, 22, 30),            -- Slightly lighter
    bg2 = Color3.fromRGB(28, 31, 40),            -- Slightly lighter
    bg3 = Color3.fromRGB(36, 40, 52),            -- Slightly lighter
    bg4 = Color3.fromRGB(44, 48, 62),            -- Slightly lighter
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(180, 187, 205),     -- Brighter
    textDimmer = Color3.fromRGB(130, 135, 145),  -- Brighter
    
    border = Color3.fromRGB(57, 59, 64),
    glow = Color3.fromRGB(99, 115, 255),
}

-- Window size based on device
local windowSize = isMobile and UDim2.new(0,380,0,520) or UDim2.new(0,650,0,450)
local minWindowSize = isMobile and Vector2.new(320, 400) or Vector2.new(550, 380)
local maxWindowSize = isMobile and Vector2.new(450, 650) or Vector2.new(900, 600)

local gui = new("ScreenGui",{
    Name="LynxGUI_Modern",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Background overlay - REMOVED DARK BACKGROUND
local overlay = new("Frame",{
    Parent=gui,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,  -- Fully transparent
    BorderSizePixel=0,
    Visible=false,
    ZIndex=1
})

-- Main Window Container with Enhanced Glass effect
local win = new("Frame",{
    Parent=gui,
    Size=windowSize,
    Position=UDim2.new(0.5,-windowSize.X.Offset/2,0.5,-windowSize.Y.Offset/2),
    BackgroundColor3=colors.bg1,
    BackgroundTransparency=0.25,  -- More transparent
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,18)})

-- Enhanced Glassmorphism effect with subtle glow
local glassBlur = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=0.97,
    BorderSizePixel=0,
    ZIndex=2
})
new("UICorner",{Parent=glassBlur,CornerRadius=UDim.new(0,18)})

-- Subtle glow border
local glowBorder = new("UIStroke",{
    Parent=win,
    Color=colors.primary,
    Thickness=1.5,
    Transparency=0.7,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Sidebar with enhanced transparency
local sidebar = new("Frame",{
    Parent=win,
    Size=isMobile and UDim2.new(0,75,1,0) or UDim2.new(0,180,1,0),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.3,  -- More transparent
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=sidebar,CornerRadius=UDim.new(0,18)})

-- Sidebar Header with Custom Logo Support
local sidebarHeader = new("Frame",{
    Parent=sidebar,
    Size=isMobile and UDim2.new(1,0,0,85) or UDim2.new(1,0,0,90),
    BackgroundTransparency=1,
    ClipsDescendants=true,
    ZIndex=5
})

-- Logo Container with enhanced gradient
local logoContainer = new("ImageLabel",{
    Parent=sidebarHeader,
    Size=isMobile and UDim2.new(0,42,0,42) or UDim2.new(0,50,0,50),
    Position=isMobile and UDim2.new(0.5,-21,0,15) or UDim2.new(0.5,-25,0,18),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    Image="https://raw.githubusercontent.com/habibihidayat/project-k/main/src/logo.jpg",
    ScaleType=Enum.ScaleType.Fit,
    ZIndex=6
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,14)})
new("UIGradient",{
    Parent=logoContainer,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(0.5, colors.accent),
        ColorSequenceKeypoint.new(1, colors.secondary)
    },
    Rotation=45
})

-- Enhanced glow for logo
new("UIStroke",{
    Parent=logoContainer,
    Color=colors.primary,
    Thickness=2,
    Transparency=0.5
})

-- Fallback text if no image
local logoText = new("TextLabel",{
    Parent=logoContainer,
    Text="L",
    Size=UDim2.new(1,0,1,0),
    Font=Enum.Font.GothamBold,
    TextSize=isMobile and 26 or 32,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    Visible=logoContainer.Image == "https://raw.githubusercontent.com/habibihidayat/project-k/main/src/logo.jpg",
    ZIndex=7
})

logoContainer:GetPropertyChangedSignal("Image"):Connect(function()
    logoText.Visible = (logoContainer.Image == "")
end)

local brandName = new("TextLabel",{
    Parent=sidebarHeader,
    Text=isMobile and "LYNX" or "LYNX",
    Size=UDim2.new(1,0,0,18),
    Position=isMobile and UDim2.new(0,0,0,62) or UDim2.new(0,0,0,72),
    Font=Enum.Font.GothamBold,
    TextSize=isMobile and 14 or 17,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    Visible=not isMobile,
    ZIndex=6
})

local brandVersion = new("TextLabel",{
    Parent=sidebarHeader,
    Text="v2.1 Enhanced",
    Size=UDim2.new(1,0,0,12),
    Position=UDim2.new(0,0,0,88),
    Font=Enum.Font.Gotham,
    TextSize=9,
    BackgroundTransparency=1,
    TextColor3=colors.accent,
    Visible=not isMobile,
    ZIndex=6
})

-- Navigation Container
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=isMobile and UDim2.new(1,-8,1,-95) or UDim2.new(1,-16,1,-110),
    Position=isMobile and UDim2.new(0,4,0,90) or UDim2.new(0,8,0,105),
    BackgroundTransparency=1,
    ScrollBarThickness=2,
    ScrollBarImageColor3=colors.primary,
    BorderSizePixel=0,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ClipsDescendants=true,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

-- Content Area with enhanced transparency
local contentBg = new("Frame",{
    Parent=win,
    Size=isMobile and UDim2.new(1,-85,1,-15) or UDim2.new(1,-190,1,-15),
    Position=isMobile and UDim2.new(0,80,0,10) or UDim2.new(0,185,0,10),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.4,  -- More transparent
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg,CornerRadius=UDim.new(0,16)})

-- Top bar with controls - DRAGGABLE AREA
local topBar = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1,0,0,45),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,16)})

-- Enhanced Drag Handle Indicator
local dragHandle = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,40,0,4),
    Position=UDim2.new(0.5,-20,0,8),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=dragHandle,CornerRadius=UDim.new(1,0)})

local pageTitle = new("TextLabel",{
    Parent=topBar,
    Text="Main Dashboard",
    Size=UDim2.new(1,-90,1,0),
    Position=UDim2.new(0,15,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=isMobile and 13 or 16,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Control buttons
local controlsFrame = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,70,0,28),
    Position=UDim2.new(1,-75,0.5,-14),
    BackgroundTransparency=1,
    ZIndex=6
})
new("UIListLayout",{
    Parent=controlsFrame,
    FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,6)
})

local function createControlBtn(icon, color)
    local btn = new("TextButton",{
        Parent=controlsFrame,
        Size=UDim2.new(0,28,0,28),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=icon == "×" and 20 or 16,
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,8)})
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.15),{
            BackgroundColor3=color,
            BackgroundTransparency=0.1,
            TextColor3=colors.text,
            Size=UDim2.new(0,30,0,30)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.15),{
            BackgroundColor3=colors.bg4,
            BackgroundTransparency=0.4,
            TextColor3=colors.textDim,
            Size=UDim2.new(0,28,0,28)
        }):Play()
    end)
    return btn
end

local btnMin = createControlBtn("─", colors.warning)
local btnClose = createControlBtn("×", colors.danger)

-- FIXED Resize Handle (Bottom Right Corner) - Only expands right and down
local resizeHandle = new("TextButton",{
    Parent=win,
    Size=UDim2.new(0,20,0,20),
    Position=UDim2.new(1,-20,1,-20),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    Text="⋰",
    Font=Enum.Font.GothamBold,
    TextSize=12,
    TextColor3=colors.text,
    AutoButtonColor=false,
    ZIndex=100
})
new("UICorner",{Parent=resizeHandle,CornerRadius=UDim.new(0,6)})
new("UIStroke",{
    Parent=resizeHandle,
    Color=colors.primary,
    Thickness=1,
    Transparency=0.6
})

-- Pages
local pages = {}
local currentPage = "Main"
local navButtons = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,-16,1,-60),
        Position=UDim2.new(0,8,0,52),
        BackgroundTransparency=1,
        ScrollBarThickness=3,
        ScrollBarImageColor3=colors.primary,
        BorderSizePixel=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false,
        ClipsDescendants=true,
        ZIndex=5
    })
    new("UIListLayout",{
        Parent=page,
        Padding=UDim.new(0,10),
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0,8),
        PaddingBottom=UDim.new(0,8)
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

-- Nav Button Function (Enhanced)
local function createNavButton(text, icon, page, order)
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=isMobile and UDim2.new(1,0,0,50) or UDim2.new(1,0,0,42),
        BackgroundColor3=page == currentPage and colors.bg3 or Color3.fromRGB(0,0,0),
        BackgroundTransparency=page == currentPage and 0.4 or 1,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        LayoutOrder=order,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,11)})
    
    local indicator = new("Frame",{
        Parent=btn,
        Size=UDim2.new(0,3,0,20),
        Position=UDim2.new(0,0,0.5,-10),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        Visible=page == currentPage,
        ZIndex=7
    })
    new("UICorner",{Parent=indicator,CornerRadius=UDim.new(1,0)})
    
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=isMobile and UDim2.new(1,0,1,0) or UDim2.new(0,28,1,0),
        Position=isMobile and UDim2.new(0,0,0,0) or UDim2.new(0,12,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 20 or 17,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        ZIndex=7
    })
    
    local textLabel = new("TextLabel",{
        Parent=btn,
        Text=text,
        Size=UDim2.new(1,-45,1,0),
        Position=UDim2.new(0,42,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,
        TextSize=12,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        Visible=not isMobile,
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
        TweenService:Create(btnData.btn,TweenInfo.new(0.15),{
            BackgroundColor3=isActive and colors.bg3 or Color3.fromRGB(0,0,0),
            BackgroundTransparency=isActive and 0.4 or 1
        }):Play()
        btnData.indicator.Visible = isActive
        TweenService:Create(btnData.icon,TweenInfo.new(0.15),{
            TextColor3=isActive and colors.primary or colors.textDim
        }):Play()
        if not isMobile then
            TweenService:Create(btnData.text,TweenInfo.new(0.15),{
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

-- Modern Category with enhanced colors
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,48),
        BackgroundColor3=colors.bg3,
        BackgroundTransparency=0.5,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=false,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,14)})
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,0,48),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ClipsDescendants=true,
        ZIndex=7
    })
    new("UICorner",{Parent=header,CornerRadius=UDim.new(0,14)})
    
    local iconContainer = new("Frame",{
        Parent=header,
        Size=UDim2.new(0,34,0,34),
        Position=UDim2.new(0,10,0.5,-17),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.85,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=iconContainer,CornerRadius=UDim.new(0,9)})
    
    local iconLabel = new("TextLabel",{
        Parent=iconContainer,
        Text=icon,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 15 or 17,
        TextColor3=colors.primary,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-120,1,0),
        Position=UDim2.new(0,50,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 12 or 14,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0,18,1,0),
        Position=UDim2.new(1,-30,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=13,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    local contentContainer = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1,-20,0,0),
        Position=UDim2.new(0,10,0,54),
        BackgroundTransparency=1,
        Visible=false,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=true,
        ZIndex=7
    })
    new("UIListLayout",{Parent=contentContainer,Padding=UDim.new(0,8)})
    new("UIPadding",{Parent=contentContainer,PaddingBottom=UDim.new(0,10)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        TweenService:Create(arrow,TweenInfo.new(0.25,Enum.EasingStyle.Back),{Rotation=isOpen and 180 or 0}):Play()
        TweenService:Create(categoryFrame,TweenInfo.new(0.2),{
            BackgroundColor3=isOpen and colors.bg4 or colors.bg3,
            BackgroundTransparency=isOpen and 0.3 or 0.5
        }):Play()
    end)
    
    return contentContainer
end

-- Modern Toggle
local function makeToggle(parent, label, callback)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,36),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local labelText = new("TextLabel",{
        Parent=frame,
        Text=label,
        Size=UDim2.new(0.65,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=12,
        TextWrapped=true,
        ZIndex=8
    })
    
    local toggleBg = new("Frame",{
        Parent=frame,
        Size=UDim2.new(0,48,0,26),
        Position=UDim2.new(1,-50,0.5,-13),
        BackgroundColor3=colors.bg4,
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
        TweenService:Create(toggleBg,TweenInfo.new(0.25),{BackgroundColor3=on and colors.primary or colors.bg4}):Play()
        TweenService:Create(toggleCircle,TweenInfo.new(0.3,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10),
            BackgroundColor3=on and colors.text or colors.textDim
        }):Play()
        callback(on)
    end)
end

-- Modern Slider
local function makeSlider(parent, label, min, max, def, onChange)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,50),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local lbl = new("TextLabel",{
        Parent=frame,
        Text=("%s: %.2f"):format(label,def),
        Size=UDim2.new(1,0,0,18),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium,
        TextSize=12,
        ZIndex=8
    })
    
    local bar = new("Frame",{
        Parent=frame,
        Size=UDim2.new(1,0,0,10),
        Position=UDim2.new(0,0,0,30),
        BackgroundColor3=colors.bg4,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(1,0)})
    
    local fill = new("Frame",{
        Parent=bar,
        Size=UDim2.new((def-min)/(max-min),0,1,0),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(1,0)})
    new("UIGradient",{
        Parent=fill,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.secondary)
        }
    })
    
    local knob = new("Frame",{
        Parent=bar,
        Size=UDim2.new(0,20,0,20),
        Position=UDim2.new((def-min)/(max-min),-10,0.5,-10),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        ZIndex=10
    })
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    
    local knobShadow = new("Frame",{
        Parent=knob,
        Size=UDim2.new(1,4,1,4),
        Position=UDim2.new(0,-2,0,-2),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.7,
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
        lbl.Text = ("%s: %.2f"):format(label,val)
        onChange(val)
    end
    
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
            dragging=true 
            update(i.Position.X)
        end 
    end)
    
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then 
            update(i.Position.X)
        end 
    end)
    
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end 
    end)
end

-- Modern Dropdown
local function makeDropdown(parent, title, icon, items, onSelect, uniqueId)
    local dropdownFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,48),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=7,
        Name=uniqueId or "Dropdown"
    })
    new("UICorner",{Parent=dropdownFrame,CornerRadius=UDim.new(0,14)})
    
    local header = new("TextButton",{
        Parent=dropdownFrame,
        Size=UDim2.new(1,-16,0,44),
        Position=UDim2.new(0,8,0,2),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=8
    })
    
    local iconLabel = new("TextLabel",{
        Parent=header,
        Text=icon,
        Size=UDim2.new(0,28,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=colors.primary,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-90,0,16),
        Position=UDim2.new(0,32,0,4),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=12,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local statusLabel = new("TextLabel",{
        Parent=header,
        Text="None Selected",
        Size=UDim2.new(1,-90,0,12),
        Position=UDim2.new(0,32,0,24),
        BackgroundTransparency=1,
        Font=Enum.Font.Gotham,
        TextSize=10,
        TextColor3=colors.textDimmer,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0,24,1,0),
        Position=UDim2.new(1,-24,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=12,
        TextColor3=colors.primary,
        ZIndex=9
    })
    
    local listContainer = new("ScrollingFrame",{
        Parent=dropdownFrame,
        Size=UDim2.new(1,-16,0,0),
        Position=UDim2.new(0,8,0,52),
        BackgroundTransparency=1,
        Visible=false,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=UDim2.new(0,0,0,0),
        ScrollBarThickness=3,
        ScrollBarImageColor3=colors.primary,
        BorderSizePixel=0,
        ClipsDescendants=true,
        ZIndex=10
    })
    new("UIListLayout",{Parent=listContainer,Padding=UDim.new(0,6)})
    new("UIPadding",{Parent=listContainer,PaddingBottom=UDim.new(0,10)})
    
    local isOpen = false
    local selectedItem = nil
    
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Rotation=isOpen and 180 or 0}):Play()
        TweenService:Create(dropdownFrame,TweenInfo.new(0.2),{
            BackgroundColor3=isOpen and colors.bg3 or colors.bg4,
            BackgroundTransparency=isOpen and 0.3 or 0.4
        }):Play()
        
        if isOpen and #items > 6 then
            listContainer.Size = UDim2.new(1,-16,0,200)
        else
            listContainer.Size = UDim2.new(1,-16,0,math.min(#items * 36, 220))
        end
    end)
    
    for _, itemName in ipairs(items) do
        local itemBtn = new("TextButton",{
            Parent=listContainer,
            Size=UDim2.new(1,0,0,34),
            BackgroundColor3=colors.bg4,
            BackgroundTransparency=0.5,
            BorderSizePixel=0,
            Text="",
            AutoButtonColor=false,
            ZIndex=11
        })
        new("UICorner",{Parent=itemBtn,CornerRadius=UDim.new(0,10)})
        
        local btnLabel = new("TextLabel",{
            Parent=itemBtn,
            Text=itemName,
            Size=UDim2.new(1,-16,1,0),
            Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,
            Font=Enum.Font.GothamMedium,
            TextSize=11,
            TextColor3=colors.textDim,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
            ZIndex=12
        })
        
        itemBtn.MouseEnter:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn,TweenInfo.new(0.15),{
                    BackgroundColor3=colors.primary,
                    BackgroundTransparency=0.2
                }):Play()
                TweenService:Create(btnLabel,TweenInfo.new(0.15),{TextColor3=colors.text}):Play()
            end
        end)
        
        itemBtn.MouseLeave:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn,TweenInfo.new(0.15),{
                    BackgroundColor3=colors.bg4,
                    BackgroundTransparency=0.5
                }):Play()
                TweenService:Create(btnLabel,TweenInfo.new(0.15),{TextColor3=colors.textDim}):Play()
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
            TweenService:Create(arrow,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Rotation=0}):Play()
            TweenService:Create(dropdownFrame,TweenInfo.new(0.2),{
                BackgroundColor3=colors.bg4,
                BackgroundTransparency=0.4
            }):Play()
        end)
    end
    
    return dropdownFrame
end

-- Modern Button
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,40),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.1,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=btnFrame,CornerRadius=UDim.new(0,12)})
    new("UIGradient",{
        Parent=btnFrame,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.secondary)
        },
        Rotation=45
    })
    
    local button = new("TextButton",{
        Parent=btnFrame,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=label,
        Font=Enum.Font.GothamBold,
        TextSize=13,
        TextColor3=colors.text,
        AutoButtonColor=false,
        ZIndex=9
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.2),{
            Size=UDim2.new(1,0,0,44),
            BackgroundTransparency=0
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.2),{
            Size=UDim2.new(1,0,0,40),
            BackgroundTransparency=0.1
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.1),{Size=UDim2.new(0.98,0,0,38)}):Play()
        task.wait(0.1)
        TweenService:Create(btnFrame,TweenInfo.new(0.1),{Size=UDim2.new(1,0,0,40)}):Play()
        pcall(callback)
    end)
    
    return btnFrame
end

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

makeSlider(catAutoFishing, "Fishing Delay", 0.01, 5.0, 1.30, function(v)
    fishingDelayValue = v
    instant.Settings.MaxWaitTime = v
    instant2.Settings.MaxWaitTime = v
end)

makeSlider(catAutoFishing, "Cancel Delay", 0.01, 1.5, 0.19, function(v)
    cancelDelayValue = v
    instant.Settings.CancelDelay = v
    instant2.Settings.CancelDelay = v
end)

local catBlatant = makeCategory(mainPage, "Blatant Mode", "🔥")

makeToggle(catBlatant, "Enable Extreme Blatant", function(on)
    if on then
        BlatantAutoFishing.Start()
    else
        BlatantAutoFishing.Stop()
    end
end)

makeToggle(catBlatant, "Instant Catch", function(on)
    BlatantAutoFishing.Settings.InstantCatch = on
end)

makeToggle(catBlatant, "Auto Complete Everything", function(on)
    BlatantAutoFishing.Settings.AutoComplete = on
end)

makeSlider(catBlatant, "Spam Rate (ms)", 0.001, 0.1, 0.001, function(v)
    BlatantAutoFishing.Settings.SpamRate = v
end)

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

makeSlider(catTimer, "Sell Interval (seconds)", 1, 60, 5, function(value)
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
    Size=UDim2.new(1,0,0,450),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=infoContainer,CornerRadius=UDim.new(0,16)})

local infoText = new("TextLabel",{
    Parent=infoContainer,
    Size=UDim2.new(1,-40,1,-40),
    Position=UDim2.new(0,20,0,20),
    BackgroundTransparency=1,
    Text=[[
✨ LYNX v2.1 ENHANCED

Modern Premium Interface
Optimized for All Devices

━━━━━━━━━━━━━━━━━━━━━━

🎣 AUTO FISHING
• Instant Fishing (Fast/Perfect)
• Unified slider controls
• Blatant Mode support
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
• Smart category organization

⚙️ SETTINGS
• Anti-AFK Protection
• FPS Unlocker (60-240 FPS)
• General preferences

━━━━━━━━━━━━━━━━━━━━━━

💡 NEW IN v2.1
✓ Enhanced vibrant colors
✓ Increased transparency
✓ No dark background overlay
✓ FIXED resize (right/down only)
✓ Improved glass morphism
✓ Better visual contrast
✓ Smoother animations

🎮 CONTROLS
• Click categories to expand
• Drag from top bar to move
• Drag corner to resize
• (─) Minimize window
• (×) Close GUI

━━━━━━━━━━━━━━━━━━━━━━

Created with 💎 by Lynx Team
Premium Enhanced Edition 2024
    ]],
    Font=Enum.Font.Gotham,
    TextSize=11,
    TextColor3=colors.text,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=7
})

-- Minimized Icon
local minimized = false
local icon
local savedIconPos = UDim2.new(0,20,0,120)

local function createMinimizedIcon()
    if icon then return end
    local iconSize = isMobile and 55 or 60
    icon = new("ImageLabel",{
        Parent=gui,
        Size=UDim2.new(0,iconSize,0,iconSize),
        Position=savedIconPos,
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        Image="https://raw.githubusercontent.com/habibihidayat/project-k/main/src/logo.jpg",
        ScaleType=Enum.ScaleType.Fit,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,15)})
    new("UIGradient",{
        Parent=icon,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(0.5, colors.accent),
            ColorSequenceKeypoint.new(1, colors.secondary)
        },
        Rotation=45
    })
    new("UIStroke",{
        Parent=icon,
        Color=colors.primary,
        Thickness=2,
        Transparency=0.5
    })
    
    local logoK = new("TextLabel",{
        Parent=icon,
        Text="L",
        Size=UDim2.new(1,0,1,0),
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 28 or 32,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Visible=icon.Image == "https://raw.githubusercontent.com/habibihidayat/project-k/main/src/logo.jpg",
        ZIndex=101
    })
    
    icon.Image = logoContainer.Image
    logoK.Visible = (icon.Image == "")
    
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
            local newPos = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y)
            TweenService:Create(icon,TweenInfo.new(0.05),{Position=newPos}):Play()
        end
    end)
    
    icon.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                savedIconPos = icon.Position
                if not dragMoved then
                    overlay.Visible,win.Visible = true,true
                    TweenService:Create(win,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                        Size=windowSize,
                        Position=UDim2.new(0.5,-windowSize.X.Offset/2,0.5,-windowSize.Y.Offset/2)
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
        local targetPos = UDim2.new(0.5,0,0.5,0)
        TweenService:Create(win,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
            Size=UDim2.new(0,0,0,0),
            Position=targetPos
        }):Play()
        task.wait(0.35)
        win.Visible,overlay.Visible = false,false
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0),
        Rotation=90
    }):Play()
    task.wait(0.35)
    gui:Destroy()
end)

-- SMOOTH DRAGGING SYSTEM
local dragging,dragStart,startPos = false,nil,nil
local dragTween = nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging,dragStart,startPos = true,input.Position,win.Position
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
        dragTween = TweenService:Create(win,TweenInfo.new(0.05,Enum.EasingStyle.Linear),{Position=newPos})
        dragTween:Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

-- FIXED RESIZING SYSTEM (Only expands RIGHT and DOWN)
local resizing = false
local resizeStart,startSize,startPos = nil,nil,nil
local resizeTween = nil

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing,resizeStart,startSize,startPos = true,input.Position,win.Size,win.Position
        if resizeTween then resizeTween:Cancel() end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        
        -- Calculate new size (only expand right and down)
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
        
        -- Keep the window position fixed (only expand from top-left corner)
        local newSize = UDim2.new(0,newWidth,0,newHeight)
        
        -- Super smooth resize without repositioning
        if resizeTween then resizeTween:Cancel() end
        resizeTween = TweenService:Create(win,TweenInfo.new(0.05,Enum.EasingStyle.Linear),{
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

-- Opening Animation (No dark background)
task.spawn(function()
    win.Size = UDim2.new(0,0,0,0)
    win.Position = UDim2.new(0.5,-windowSize.X.Offset/2,0.5,-windowSize.Y.Offset/2)
    win.Rotation = 0
    overlay.Visible = false  -- No overlay needed
    
    task.wait(0.1)
    
    TweenService:Create(win,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=windowSize
    }):Play()
end)

-- Hover effect for resize handle
resizeHandle.MouseEnter:Connect(function()
    TweenService:Create(resizeHandle,TweenInfo.new(0.2),{
        BackgroundTransparency=0.2,
        Size=UDim2.new(0,24,0,24)
    }):Play()
end)

resizeHandle.MouseLeave:Connect(function()
    if not resizing then
        TweenService:Create(resizeHandle,TweenInfo.new(0.2),{
            BackgroundTransparency=0.5,
            Size=UDim2.new(0,20,0,20)
        }):Play()
    end
end)

print("✨ Lynx GUI v2.1 Enhanced loaded!")
print("🎨 Ultra Premium Glass Edition")
print("📱 Mobile & PC Optimized")
print("🖱️ Drag from top | Resize from corner (right/down only)")
print("🎨 Enhanced colors & transparency")
print("💎 Created by Lynx Team")
