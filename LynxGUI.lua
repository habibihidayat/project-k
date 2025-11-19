-- LynxGUI_v2.0.lua - Premium Glass Edition
-- Ultra Modern Design with Acrylic Effects & Icon Fonts

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

repeat task.wait() until localPlayer:FindFirstChild("PlayerGui")

local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

-- Load Modules
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

-- Premium Color Palette
local colors = {
    primary = Color3.fromRGB(99, 102, 241),      -- Indigo
    secondary = Color3.fromRGB(139, 92, 246),    -- Purple
    accent = Color3.fromRGB(34, 211, 238),       -- Cyan
    success = Color3.fromRGB(34, 197, 94),       -- Green
    warning = Color3.fromRGB(251, 191, 36),      -- Amber
    danger = Color3.fromRGB(239, 68, 68),        -- Red
    bg = Color3.fromRGB(15, 23, 42),             -- Slate 900
    bgLight = Color3.fromRGB(30, 41, 59),        -- Slate 800
    bgDark = Color3.fromRGB(8, 15, 30),          -- Darker
    glass = Color3.fromRGB(51, 65, 85),          -- Slate 700
    text = Color3.fromRGB(248, 250, 252),        -- Slate 50
    textDim = Color3.fromRGB(148, 163, 184),     -- Slate 400
    border = Color3.fromRGB(71, 85, 105),        -- Slate 600
}

-- Lucide Icons (using Unicode similar characters)
local icons = {
    home = "🏠",
    teleport = "⚡",
    shop = "🛒",
    settings = "⚙️",
    info = "ℹ️",
    fish = "🐟",
    speed = "⚡",
    location = "📍",
    player = "👤",
    sell = "💰",
    timer = "⏱️",
    weather = "🌤️",
    general = "⚙️",
    protection = "🛡️",
    fps = "📊",
    check = "✓",
    close = "✕",
    minimize = "−",
    chevronDown = "›",
    chevronRight = "›",
}

local gui = new("ScreenGui",{
    Name="LynxGUI_v2",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Blur Effect Background
local blur = new("BlurEffect", {
    Parent = game.Lighting,
    Size = 0
})

local inputBlocker = new("Frame",{
    Parent=gui,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(0,0,0),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    Visible=false,
    ZIndex=1,
    Active=true
})

-- Main Window with Acrylic Effect
local win = new("Frame",{
    Parent=gui,
    Size=UDim2.new(0,680,0,460),
    Position=UDim2.new(0.5,-340,0.5,-230),
    BackgroundColor3=colors.bg,
    BackgroundTransparency=0.25,
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,20)})

-- Layered Glass Effect
local glassLayer1 = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=0.98,
    BorderSizePixel=0,
    ZIndex=3
})
new("UICorner",{Parent=glassLayer1,CornerRadius=UDim.new(0,20)})

local glassLayer2 = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.97,
    BorderSizePixel=0,
    ZIndex=3
})
new("UICorner",{Parent=glassLayer2,CornerRadius=UDim.new(0,20)})

-- Premium Border with Gradient
local winStroke = new("UIStroke",{
    Parent=win,
    Color=colors.primary,
    Thickness=2,
    Transparency=0.5,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

local strokeGradient = new("UIGradient",{
    Parent=winStroke,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(0.5, colors.accent),
        ColorSequenceKeypoint.new(1, colors.secondary)
    },
    Rotation=45
})

-- Animated gradient rotation
task.spawn(function()
    while win.Parent do
        for i = 0, 360, 2 do
            if not win.Parent then break end
            strokeGradient.Rotation = i
            task.wait(0.05)
        end
    end
end)

-- Top Bar
local topBar = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,0,60),
    BackgroundColor3=colors.bgDark,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,20)})

local topBarGlass = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=0.97,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=topBarGlass,CornerRadius=UDim.new(0,20)})

-- Logo with glow
local logoContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,44,0,44),
    Position=UDim2.new(0,12,0.5,-22),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,12)})

local logoGradient = new("UIGradient",{
    Parent=logoContainer,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(1, colors.secondary)
    },
    Rotation=45
})

local logoStroke = new("UIStroke",{
    Parent=logoContainer,
    Color=colors.primary,
    Thickness=2,
    Transparency=0.3
})

local logoText = new("TextLabel",{
    Parent=logoContainer,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Text="L",
    Font=Enum.Font.GothamBold,
    TextSize=24,
    TextColor3=colors.text,
    ZIndex=6
})

-- Title
local titleLabel = new("TextLabel",{
    Parent=topBar,
    Text="LYNX",
    Size=UDim2.new(0,120,1,0),
    Position=UDim2.new(0,64,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=20,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=5
})

local titleGradient = new("UIGradient",{
    Parent=titleLabel,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.text),
        ColorSequenceKeypoint.new(1, colors.primary)
    }
})

-- Version Badge
local versionBadge = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,50,0,22),
    Position=UDim2.new(0,190,0.5,-11),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=versionBadge,CornerRadius=UDim.new(0,11)})

local versionLabel = new("TextLabel",{
    Parent=versionBadge,
    Text="v2.0",
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,
    TextSize=10,
    TextColor3=colors.text,
    ZIndex=6
})

-- Control Buttons
local controlsContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,80,0,36),
    Position=UDim2.new(1,-88,0.5,-18),
    BackgroundTransparency=1,
    ZIndex=5
})
new("UIListLayout",{
    Parent=controlsContainer,
    FillDirection=Enum.FillDirection.Horizontal,
    HorizontalAlignment=Enum.HorizontalAlignment.Right,
    Padding=UDim.new(0,8)
})

local function createControlButton(text, color)
    local btn = new("TextButton",{
        Parent=controlsContainer,
        Text=text,
        Size=UDim2.new(0,36,0,36),
        BackgroundColor3=colors.glass,
        BackgroundTransparency=0.5,
        BorderSizePixel=0,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,10)})
    
    local btnStroke = new("UIStroke",{
        Parent=btn,
        Color=colors.border,
        Thickness=1.5,
        Transparency=0.6
    })
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quart),{
            BackgroundColor3=color,
            BackgroundTransparency=0.2,
            TextColor3=colors.text,
            Size=UDim2.new(0,38,0,38)
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.2),{
            Color=color,
            Transparency=0.3
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quart),{
            BackgroundColor3=colors.glass,
            BackgroundTransparency=0.5,
            TextColor3=colors.textDim,
            Size=UDim2.new(0,36,0,36)
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.2),{
            Color=colors.border,
            Transparency=0.6
        }):Play()
    end)
    
    return btn
end

local btnMin = createControlButton(icons.minimize, colors.warning)
local btnClose = createControlButton(icons.close, colors.danger)

-- Sidebar
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,160,1,-68),
    Position=UDim2.new(0,8,0,64),
    BackgroundColor3=colors.bgDark,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=sidebar,CornerRadius=UDim.new(0,16)})

local sidebarGlass = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=0.97,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=sidebarGlass,CornerRadius=UDim.new(0,16)})

local sidebarStroke = new("UIStroke",{
    Parent=sidebar,
    Color=colors.border,
    Thickness=1.5,
    Transparency=0.7
})

local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1,-12,1,-12),
    Position=UDim2.new(0,6,0,6),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=2,
    ScrollBarImageColor3=colors.primary,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0,8),
    SortOrder=Enum.SortOrder.LayoutOrder
})
new("UIPadding",{
    Parent=navContainer,
    PaddingTop=UDim.new(0,4),
    PaddingBottom=UDim.new(0,4)
})

local currentPage = "Main"
local navButtons = {}

local function createNavButton(text, icon, page)
    local isActive = page == currentPage
    
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1,0,0,48),
        BackgroundColor3=isActive and colors.primary or colors.glass,
        BackgroundTransparency=isActive and 0.3 or 0.7,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,12)})
    
    local btnStroke = new("UIStroke",{
        Parent=btn,
        Color=isActive and colors.primary or colors.border,
        Thickness=1.5,
        Transparency=isActive and 0.5 or 0.8
    })
    
    -- Active indicator
    local indicator = new("Frame",{
        Parent=btn,
        Size=UDim2.new(0,3,0.7,0),
        Position=UDim2.new(0,0,0.15,0),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        Visible=isActive,
        ZIndex=8
    })
    new("UICorner",{Parent=indicator,CornerRadius=UDim.new(1,0)})
    
    local content = new("Frame",{
        Parent=btn,
        Size=UDim2.new(1,-16,1,0),
        Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,
        ZIndex=8
    })
    
    local iconLabel = new("TextLabel",{
        Parent=content,
        Size=UDim2.new(0,32,1,0),
        Position=UDim2.new(0,4,0,0),
        BackgroundTransparency=1,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextColor3=isActive and colors.text or colors.textDim,
        ZIndex=9
    })
    
    local textLabel = new("TextLabel",{
        Parent=content,
        Size=UDim2.new(1,-44,1,0),
        Position=UDim2.new(0,40,0,0),
        BackgroundTransparency=1,
        Text=text,
        Font=Enum.Font.GothamBold,
        TextSize=12,
        TextColor3=isActive and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    btn.MouseEnter:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{
                BackgroundTransparency=0.4,
                BackgroundColor3=colors.primary
            }):Play()
            TweenService:Create(btnStroke,TweenInfo.new(0.25),{
                Color=colors.primary,
                Transparency=0.6
            }):Play()
            TweenService:Create(iconLabel,TweenInfo.new(0.25),{
                TextColor3=colors.text,
                TextSize=20
            }):Play()
            TweenService:Create(textLabel,TweenInfo.new(0.25),{
                TextColor3=colors.text
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{
                BackgroundTransparency=0.7,
                BackgroundColor3=colors.glass
            }):Play()
            TweenService:Create(btnStroke,TweenInfo.new(0.25),{
                Color=colors.border,
                Transparency=0.8
            }):Play()
            TweenService:Create(iconLabel,TweenInfo.new(0.25),{
                TextColor3=colors.textDim,
                TextSize=18
            }):Play()
            TweenService:Create(textLabel,TweenInfo.new(0.25),{
                TextColor3=colors.textDim
            }):Play()
        end
    end)
    
    navButtons[page] = {btn=btn, icon=iconLabel, text=textLabel, stroke=btnStroke, indicator=indicator}
    return btn
end

-- Content Area
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-180,1,-73),
    Position=UDim2.new(0,172,0,67),
    BackgroundColor3=colors.glass,
    BackgroundTransparency=0.6,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg,CornerRadius=UDim.new(0,16)})

local contentGlass = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=0.97,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=contentGlass,CornerRadius=UDim.new(0,16)})

local contentStroke = new("UIStroke",{
    Parent=contentBg,
    Color=colors.border,
    Thickness=1.5,
    Transparency=0.7
})

local pages = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,-16,1,-16),
        Position=UDim2.new(0,8,0,8),
        BackgroundTransparency=1,
        ScrollBarThickness=4,
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
        SortOrder=Enum.SortOrder.LayoutOrder,
        HorizontalAlignment=Enum.HorizontalAlignment.Center
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

local function switchPage(pageName)
    if currentPage == pageName then return end
    
    local currentPageFrame = pages[currentPage]
    if currentPageFrame then
        TweenService:Create(currentPageFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{
            Position=UDim2.new(-0.1,8,0,8)
        }):Play()
        task.wait(0.15)
        currentPageFrame.Visible = false
    end
    
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        TweenService:Create(btnData.btn,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{
            BackgroundTransparency = isActive and 0.3 or 0.7,
            BackgroundColor3 = isActive and colors.primary or colors.glass
        }):Play()
        TweenService:Create(btnData.stroke,TweenInfo.new(0.3),{
            Color = isActive and colors.primary or colors.border,
            Transparency = isActive and 0.5 or 0.8
        }):Play()
        TweenService:Create(btnData.icon,TweenInfo.new(0.3),{
            TextColor3 = isActive and colors.text or colors.textDim
        }):Play()
        TweenService:Create(btnData.text,TweenInfo.new(0.3),{
            TextColor3 = isActive and colors.text or colors.textDim
        }):Play()
        btnData.indicator.Visible = isActive
        if isActive then
            btnData.indicator.Size = UDim2.new(0,0,0.7,0)
            TweenService:Create(btnData.indicator,TweenInfo.new(0.4,Enum.EasingStyle.Back),{
                Size=UDim2.new(0,3,0.7,0)
            }):Play()
        end
    end
    
    local newPageFrame = pages[pageName]
    newPageFrame.Position = UDim2.new(0.1,8,0,8)
    newPageFrame.Visible = true
    TweenService:Create(newPageFrame,TweenInfo.new(0.4,Enum.EasingStyle.Quart),{
        Position=UDim2.new(0,8,0,8)
    }):Play()
    
    currentPage = pageName
end

local btnMain = createNavButton("Main", icons.home, "Main")
local btnTeleport = createNavButton("Teleport", icons.teleport, "Teleport")
local btnShop = createNavButton("Shop", icons.shop, "Shop")
local btnSettings = createNavButton("Settings", icons.settings, "Settings")
local btnInfo = createNavButton("Info", icons.info, "Info")

btnMain.MouseButton1Click:Connect(function() switchPage("Main") end)
btnTeleport.MouseButton1Click:Connect(function() switchPage("Teleport") end)
btnShop.MouseButton1Click:Connect(function() switchPage("Shop") end)
btnSettings.MouseButton1Click:Connect(function() switchPage("Settings") end)
btnInfo.MouseButton1Click:Connect(function() switchPage("Info") end)

-- Enhanced Category
local function createCategory(parent, title, icon)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(0.98,0,0,54),
        BackgroundColor3=colors.glass,
        BackgroundTransparency=0.6,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,14)})
    
    local catGlass = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.97,
        BorderSizePixel=0,
        ZIndex=6
    })
    new("UICorner",{Parent=catGlass,CornerRadius=UDim.new(0,14)})
    
    local catStroke = new("UIStroke",{
        Parent=categoryFrame,
        Color=colors.primary,
        Thickness=1.5,
        Transparency=0.75
    })
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,0,50),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    
    local iconBg = new("Frame",{
        Parent=header,
        Size=UDim2.new(0,38,0,38),
        Position=UDim2.new(0,12,0.5,-19),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.7,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=iconBg,CornerRadius=UDim.new(0,10)})
    
    local iconLabel = new("TextLabel",{
        Parent=iconBg,
        Text=icon,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextColor3=colors.text,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-110,1,0),
        Position=UDim2.new(0,56,0,0),
        Font=Enum.Font.GothamBold,
        TextSize=13,
        TextColor3=colors.text,
        BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text=icons.chevronRight,
        Size=UDim2.new(0,28,1,0),
        Position=UDim2.new(1,-36,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextColor3=colors.primary,
        Rotation=0,
        ZIndex=8
    })
    
    local container = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1,-16,0,0),
        Position=UDim2.new(0,8,0,56),
        BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y,
        Visible=false,
        ZIndex=7
    })
    new("UIListLayout",{
        Parent=container,
        Padding=UDim.new(0,8),
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=container,
        PaddingBottom=UDim.new(0,8)
    })
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        container.Visible = isOpen
        
        TweenService:Create(arrow,TweenInfo.new(0.35,Enum.EasingStyle.Back),{
            Rotation = isOpen and 90 or 0,
            TextColor3 = isOpen and colors.accent or colors.primary
        }):Play()
        
        TweenService:Create(catStroke,TweenInfo.new(0.35),{
            Color = isOpen and colors.accent or colors.primary,
            Transparency = isOpen and 0.5 or 0.75
        }):Play()
        
        TweenService:Create(iconBg,TweenInfo.new(0.35),{
            BackgroundColor3 = isOpen and colors.accent or colors.primary,
            BackgroundTransparency = isOpen and 0.5 or 0.7
        }):Play()
    end)
    
    header.MouseEnter:Connect(function()
        TweenService:Create(categoryFrame,TweenInfo.new(0.2),{
            BackgroundTransparency=0.4
        }):Play()
        TweenService:Create(iconBg,TweenInfo.new(0.2),{
            Size=UDim2.new(0,40,0,40)
        }):Play()
    end)
    
    header.MouseLeave:Connect(function()
        TweenService:Create(categoryFrame,TweenInfo.new(0.2),{
            BackgroundTransparency=0.6
        }):Play()
        TweenService:Create(iconBg,TweenInfo.new(0.2),{
            Size=UDim2.new(0,38,0,38)
        }):Play()
    end)
    
    return container
end

-- Enhanced Toggle
local function makeToggle(parent,label,callback)
    local f=new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,36),
        BackgroundColor3=colors.bgLight,
        BackgroundTransparency=0.6,
        BorderSizePixel=0,
        ZIndex=6
    })
    new("UICorner",{Parent=f,CornerRadius=UDim.new(0,10)})
    new("UIStroke",{Parent=f,Color=colors.border,Thickness=1,Transparency=0.8})
    
    local fGlass = new("Frame",{
        Parent=f,
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.98,
        BorderSizePixel=0,
        ZIndex=6
    })
    new("UICorner",{Parent=fGlass,CornerRadius=UDim.new(0,10)})
    
    new("TextLabel",{
        Parent=f,
        Text=label,
        Size=UDim2.new(0.7,-10,1,0),
        Position=UDim2.new(0,12,0,0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=11,
        TextWrapped=true,
        ZIndex=7
    })
    
    local toggleBg=new("Frame",{
        Parent=f,
        Size=UDim2.new(0,48,0,24),
        Position=UDim2.new(1,-56,0.5,-12),
        BackgroundColor3=colors.border,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=toggleBg,CornerRadius=UDim.new(1,0)})
    
    local toggleCircle=new("Frame",{
        Parent=toggleBg,
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new(0,3,0.5,-9),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=toggleCircle,CornerRadius=UDim.new(1,0)})
    
    local circleStroke = new("UIStroke",{
        Parent=toggleCircle,
        Color=colors.border,
        Thickness=2,
        Transparency=0.5
    })
    
    local btn=new("TextButton",{
        Parent=toggleBg,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text="",
        ZIndex=9
    })
    
    local on=false
    btn.MouseButton1Click:Connect(function()
        on=not on
        TweenService:Create(toggleBg,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{
            BackgroundColor3=on and colors.success or colors.border,
            BackgroundTransparency=on and 0.2 or 0.3
        }):Play()
        TweenService:Create(toggleCircle,TweenInfo.new(0.35,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
            BackgroundColor3=on and colors.text or colors.text
        }):Play()
        TweenService:Create(circleStroke,TweenInfo.new(0.3),{
            Color=on and colors.success or colors.border
        }):Play()
        callback(on)
    end)
    
    f.MouseEnter:Connect(function()
        TweenService:Create(f,TweenInfo.new(0.2),{
            BackgroundTransparency=0.4
        }):Play()
    end)
    f.MouseLeave:Connect(function()
        TweenService:Create(f,TweenInfo.new(0.2),{
            BackgroundTransparency=0.6
        }):Play()
    end)
end

-- Enhanced Slider
local function makeSlider(parent,label,min,max,def,onChange)
    local f=new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,52),
        BackgroundColor3=colors.bgLight,
        BackgroundTransparency=0.6,
        BorderSizePixel=0,
        ZIndex=6
    })
    new("UICorner",{Parent=f,CornerRadius=UDim.new(0,10)})
    new("UIStroke",{Parent=f,Color=colors.border,Thickness=1,Transparency=0.8})
    
    local fGlass = new("Frame",{
        Parent=f,
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.98,
        BorderSizePixel=0,
        ZIndex=6
    })
    new("UICorner",{Parent=fGlass,CornerRadius=UDim.new(0,10)})
    
    local lbl=new("TextLabel",{
        Parent=f,
        Text=("%s: %.2fs"):format(label,def),
        Size=UDim2.new(1,-20,0,18),
        Position=UDim2.new(0,10,0,6),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamSemibold,
        TextSize=10,
        ZIndex=7
    })
    
    local bar=new("Frame",{
        Parent=f,
        Size=UDim2.new(1,-24,0,8),
        Position=UDim2.new(0,12,0,30),
        BackgroundColor3=colors.border,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(1,0)})
    
    local fill=new("Frame",{
        Parent=bar,
        Size=UDim2.new((def-min)/(max-min),0,1,0),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(1,0)})
    
    local fillGradient = new("UIGradient",{
        Parent=fill,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        }
    })
    
    local knob=new("Frame",{
        Parent=bar,
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new((def-min)/(max-min),-9,0.5,-9),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    
    local knobStroke = new("UIStroke",{
        Parent=knob,
        Color=colors.primary,
        Thickness=2.5,
        Transparency=0.4
    })
    
    local dragging=false
    local function update(x)
        local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        local val=min+(max-min)*rel
        fill.Size=UDim2.new(rel,0,1,0)
        knob.Position=UDim2.new(rel,-9,0.5,-9)
        lbl.Text=("%s: %.2fs"):format(label,val)
        onChange(val)
    end
    
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
            dragging=true 
            update(i.Position.X)
            TweenService:Create(knob,TweenInfo.new(0.2),{
                Size=UDim2.new(0,22,0,22)
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
            dragging=false
            TweenService:Create(knob,TweenInfo.new(0.2),{
                Size=UDim2.new(0,18,0,18)
            }):Play()
        end 
    end)
    
    f.MouseEnter:Connect(function()
        TweenService:Create(f,TweenInfo.new(0.2),{
            BackgroundTransparency=0.4
        }):Play()
    end)
    f.MouseLeave:Connect(function()
        TweenService:Create(f,TweenInfo.new(0.2),{
            BackgroundTransparency=0.6
        }):Play()
    end)
end

-- Premium Dropdown with Selection Indicator
local function makeDropdown(parent, title, items, onSelect)
    local selectedItem = nil
    
    local dropdownFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = colors.bgLight,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 6
    })
    new("UICorner", {Parent = dropdownFrame, CornerRadius = UDim.new(0, 10)})
    new("UIStroke", {Parent = dropdownFrame, Color = colors.border, Thickness = 1, Transparency = 0.8})
    
    local dropGlass = new("Frame",{
        Parent=dropdownFrame,
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.98,
        BorderSizePixel=0,
        ZIndex=6
    })
    new("UICorner",{Parent=dropGlass,CornerRadius=UDim.new(0,10)})
    
    local header = new("TextButton", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, -16, 0, 36),
        Position = UDim2.new(0, 8, 0, 2),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 7
    })
    
    local headerLabel = new("TextLabel", {
        Parent = header,
        Text = title,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    local selectedLabel = new("TextLabel", {
        Parent = header,
        Text = "",
        Size = UDim2.new(1, -40, 0, 14),
        Position = UDim2.new(0, 8, 1, -16),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = colors.accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
        ZIndex = 8
    })
    
    local arrow = new("TextLabel", {
        Parent = header,
        Text = "⌄",
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(1, -24, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = colors.primary,
        ZIndex = 8
    })
    
    local listContainer = new("ScrollingFrame", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, 42),
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = colors.primary,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 10
    })
    new("UIListLayout", {Parent = listContainer, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
    new("UIPadding", {Parent = listContainer, PaddingBottom = UDim.new(0, 6)})
    
    local isOpen = false
    
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Rotation = isOpen and 180 or 0,
            TextColor3 = isOpen and colors.accent or colors.primary
        }):Play()
        
        TweenService:Create(dropdownFrame:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.3), {
            Color = isOpen and colors.accent or colors.border
        }):Play()
        
        if isOpen and #items > 5 then
            listContainer.Size = UDim2.new(1, -16, 0, 140)
        else
            listContainer.Size = UDim2.new(1, -16, 0, math.min(#items * 30, 150))
        end
    end)
    
    for _, itemName in ipairs(items) do
        local itemBtn = new("TextButton", {
            Parent = listContainer,
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = colors.bgDark,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 11
        })
        new("UICorner", {Parent = itemBtn, CornerRadius = UDim.new(0, 8)})
        
        local itemStroke = new("UIStroke", {
            Parent = itemBtn,
            Color = colors.border,
            Thickness = 1,
            Transparency = 0.9
        })
        
        local checkIcon = new("TextLabel", {
            Parent = itemBtn,
            Text = icons.check,
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = colors.success,
            Visible = false,
            ZIndex = 12
        })
        
        local btnLabel = new("TextLabel", {
            Parent = itemBtn,
            Text = itemName,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            TextColor3 = colors.textDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 12
        })
        
        itemBtn.MouseEnter:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.primary,
                BackgroundTransparency = 0.3
            }):Play()
            TweenService:Create(itemStroke, TweenInfo.new(0.2), {
                Color = colors.primary,
                Transparency = 0.5
            }):Play()
            TweenService:Create(btnLabel, TweenInfo.new(0.2), {
                TextColor3 = colors.text
            }):Play()
        end)
        
        itemBtn.MouseLeave:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = colors.bgDark,
                    BackgroundTransparency = 0.5
                }):Play()
                TweenService:Create(itemStroke, TweenInfo.new(0.2), {
                    Color = colors.border,
                    Transparency = 0.9
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.2), {
                    TextColor3 = colors.textDim
                }):Play()
            end
        end)
        
        itemBtn.MouseButton1Click:Connect(function()
            -- Clear previous selection
            for _, child in ipairs(listContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    local check = child:FindFirstChild("TextLabel")
                    if check and check.Text == icons.check then
                        check.Visible = false
                    end
                    child.BackgroundColor3 = colors.bgDark
                    child.BackgroundTransparency = 0.5
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Color = colors.border
                        stroke.Transparency = 0.9
                    end
                end
            end
            
            -- Set new selection
            selectedItem = itemName
            checkIcon.Visible = true
            selectedLabel.Text = "Selected: " .. itemName
            TweenService:Create(selectedLabel, TweenInfo.new(0.3), {
                TextTransparency = 0
            }):Play()
            
            itemBtn.BackgroundColor3 = colors.success
            itemBtn.BackgroundTransparency = 0.7
            itemStroke.Color = colors.success
            itemStroke.Transparency = 0.5
            btnLabel.TextColor3 = colors.text
            
            onSelect(itemName)
            
            task.wait(0.15)
            isOpen = false
            listContainer.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Rotation = 0,
                TextColor3 = colors.primary
            }):Play()
            TweenService:Create(dropdownFrame:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.3), {
                Color = colors.border
            }):Play()
        end)
    end
    
    dropdownFrame.MouseEnter:Connect(function()
        TweenService:Create(dropdownFrame,TweenInfo.new(0.2),{
            BackgroundTransparency=0.4
        }):Play()
    end)
    dropdownFrame.MouseLeave:Connect(function()
        TweenService:Create(dropdownFrame,TweenInfo.new(0.2),{
            BackgroundTransparency=0.6
        }):Play()
    end)
    
    return dropdownFrame
end

-- Enhanced Button
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = colors.primary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 7
    })
    new("UICorner", { Parent = btnFrame, CornerRadius = UDim.new(0, 10) })
    
    local btnGradient = new("UIGradient",{
        Parent=btnFrame,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.secondary)
        },
        Rotation=45
    })
    
    local btnStroke = new("UIStroke", { 
        Parent = btnFrame, 
        Color = colors.primary, 
        Thickness = 1.5,
        Transparency = 0.5
    })

    local button = new("TextButton", {
        Parent = btnFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = colors.text,
        AutoButtonColor = false,
        ZIndex = 8
    })

    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1, 0, 0, 40)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {
            Transparency = 0.3
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(1, 0, 0, 38)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {
            Transparency = 0.5
        }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.1), {
            Size = UDim2.new(0.98, 0, 0, 36)
        }):Play()
        task.wait(0.1)
        TweenService:Create(btnFrame, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 38)
        }):Play()
        
        pcall(function()
            callback()
        end)
    end)

    return btnFrame
end

-- CONTENT IMPLEMENTATION
-- Main Page - Auto Fishing
local autoFishingCat = createCategory(mainPage, "Auto Fishing", icons.fish)

local instantContainer = new("Frame",{
    Parent=autoFishingCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=instantContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

local selectedInstantMode = "Fast"
local instantActive = false

makeDropdown(instantContainer, "Instant Fishing Mode", {"Fast", "Perfect"}, function(mode)
    selectedInstantMode = mode
    print("Selected mode:", mode)
    if instantActive then
        instant.Stop()
        instant2.Stop()
    end
end)

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
end)

makeSlider(instantContainer, "Fishing Delay", 0.01, 5.0, 1.30, function(v)
    instant.Settings.MaxWaitTime = v
    instant2.Settings.MaxWaitTime = v
end)

makeSlider(instantContainer, "Cancel Delay", 0.01, 1.5, 0.19, function(v)
    instant.Settings.CancelDelay = v
    instant2.Settings.CancelDelay = v
end)

-- Blatant Fishing
local blatantContainer = new("Frame",{
    Parent=autoFishingCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=blatantContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

local warningLabel = new("Frame",{
    Parent=blatantContainer,
    Size=UDim2.new(1,0,0,28),
    BackgroundColor3=colors.danger,
    BackgroundTransparency=0.85,
    BorderSizePixel=0,
    ZIndex=7
})
new("UICorner",{Parent=warningLabel,CornerRadius=UDim.new(0,8)})
new("UIStroke",{Parent=warningLabel,Color=colors.danger,Thickness=1.5,Transparency=0.5})

new("TextLabel",{
    Parent=warningLabel,
    Text="⚠️ TRUE BLATANT MODE - HIGH RISK",
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    TextColor3=colors.text,
    Font=Enum.Font.GothamBold,
    TextSize=10,
    ZIndex=8
})

makeToggle(blatantContainer, "Enable Extreme Blatant", function(on)
    if on then 
        BlatantAutoFishing.Start()
    else 
        BlatantAutoFishing.Stop() 
    end 
end)

makeToggle(blatantContainer, "Instant Catch (No Wait)", function(on) 
    BlatantAutoFishing.Settings.InstantCatch = on
end)

makeToggle(blatantContainer, "Auto Complete Everything", function(on) 
    BlatantAutoFishing.Settings.AutoComplete = on
end)

makeSlider(blatantContainer, "Spam Rate (ms)", 0.001, 0.1, 0.001, function(v) 
    BlatantAutoFishing.Settings.SpamRate = v
end)

-- Support Fishing Category
local supportFishingCat = createCategory(mainPage, "Support Fishing", icons.speed)

local noAnimContainer = new("Frame",{
    Parent=supportFishingCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=noAnimContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

makeToggle(noAnimContainer, "Manual Capture (2s)", function(on) 
    if on then 
        NoFishingAnimation.StartWithDelay()
    else 
        NoFishingAnimation.Stop() 
    end 
end)

-- Teleport Page
local locationItems = {}
for name, _ in pairs(TeleportModule.Locations) do
    table.insert(locationItems, name)
end
table.sort(locationItems)

local teleportLocationCat = createCategory(teleportPage, "Location Teleport", icons.location)
makeDropdown(teleportLocationCat, "Select Location", locationItems, function(selectedLocation)
    TeleportModule.TeleportTo(selectedLocation)
    print("Teleporting to:", selectedLocation)
end)

local playerItems = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        table.insert(playerItems, player.Name)
    end
end
table.sort(playerItems)

local teleportPlayerCat = createCategory(teleportPage, "Player Teleport", icons.player)

local playerDropdown = makeDropdown(teleportPlayerCat, "Select Player", playerItems, function(selectedPlayer)
    TeleportToPlayer.TeleportTo(selectedPlayer)
    print("Teleporting to player:", selectedPlayer)
end)

-- Dynamic Player List Update
local function refreshPlayerList()
    if playerDropdown then
        playerDropdown:Destroy()
    end
    
    table.clear(playerItems)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerItems, player.Name)
        end
    end
    table.sort(playerItems)
    
    playerDropdown = makeDropdown(teleportPlayerCat, "Select Player", playerItems, function(selectedPlayer)
        TeleportToPlayer.TeleportTo(selectedPlayer)
        print("Teleporting to player:", selectedPlayer)
    end)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Shop Page - Auto Sell Category
local autoSellCat = createCategory(shopPage, "Auto Sell System", icons.sell)

local sellContainer = new("Frame",{
    Parent=autoSellCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=sellContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

makeButton(sellContainer, "💰 Sell All Items", function()
    if AutoSell and AutoSell.SellOnce then
        print("Sell All button pressed")
        AutoSell.SellOnce()
    else
        warn("AutoSell module not loaded")
    end
end)

-- Auto Sell Timer Category
local autoSellTimerCat = createCategory(shopPage, "Auto Sell Timer", icons.timer)

local timerContainer = new("Frame",{
    Parent=autoSellTimerCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=timerContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

makeSlider(timerContainer, "Sell Interval (s)", 1, 60, 5, function(value)
    AutoSellTimer.SetInterval(value)
end)

makeButton(timerContainer, "▶️ Start Auto Sell", function()
    if AutoSellTimer then
        AutoSellTimer.Start(AutoSellTimer.Interval)
    else
        warn("AutoSellTimer not loaded")
    end
end)

makeButton(timerContainer, "⏹️ Stop Auto Sell", function()
    if AutoSellTimer then
        AutoSellTimer.Stop()
    else
        warn("AutoSellTimer not loaded")
    end
end)

-- Auto Buy Weather Category
local autoWeatherCat = createCategory(shopPage, "Auto Buy Weather", icons.weather)

local weatherContainer = new("Frame",{
    Parent=autoWeatherCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=weatherContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

local selectedWeathers = {}
makeDropdown(weatherContainer, "Select Weathers", AutoBuyWeather.AllWeathers, function(weather)
    local idx = table.find(selectedWeathers, weather)
    if idx then
        table.remove(selectedWeathers, idx)
    else
        table.insert(selectedWeathers, weather)
    end
    AutoBuyWeather.SetSelected(selectedWeathers)
end)

makeToggle(weatherContainer, "Enable Auto Weather", function(on)
    if on then
        AutoBuyWeather.Start()
    else
        AutoBuyWeather.Stop()
    end
end)

-- Settings Page
local generalCat = createCategory(settingsPage, "General Settings", icons.general)

local generalContainer = new("Frame",{
    Parent=generalCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=generalContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

makeToggle(generalContainer, "Auto Save Settings", function(on) print("Auto Save:", on) end)
makeToggle(generalContainer, "Show Notifications", function(on) print("Notifications:", on) end)
makeToggle(generalContainer, "Performance Mode", function(on) print("Performance:", on) end)

-- Anti-AFK Category
local antiAFKCat = createCategory(settingsPage, "Anti-AFK Protection", icons.protection)

local antiAFKContainer = new("Frame",{
    Parent=antiAFKCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=antiAFKContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

makeToggle(antiAFKContainer, "Enable Anti-AFK", function(on)
    if on then
        AntiAFK.Start()
    else
        AntiAFK.Stop()
    end
end)

-- FPS Unlocker Category
local fpsCat = createCategory(settingsPage, "FPS Unlocker", icons.fps)

local fpsContainer = new("Frame",{
    Parent=fpsCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=fpsContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

makeDropdown(fpsContainer, "FPS Limit", {"60 FPS", "90 FPS", "120 FPS", "240 FPS"}, function(selected)
    local fpsValue = tonumber(selected:match("%d+"))
    if fpsValue then
        if UnlockFPS and UnlockFPS.SetCap then
            UnlockFPS.SetCap(fpsValue)
            print("FPS cap set to:", fpsValue)
        else
            warn("UnlockFPS module not loaded")
        end
    end
end)

-- Info Page
local infoContainer = new("Frame",{
    Parent=infoPage,
    Size=UDim2.new(0.98,0,0,0),
    BackgroundColor3=colors.bgLight,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UICorner",{Parent=infoContainer,CornerRadius=UDim.new(0,14)})
new("UIStroke",{Parent=infoContainer,Color=colors.primary,Thickness=1.5,Transparency=0.7})

local infoGlass = new("Frame",{
    Parent=infoContainer,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=0.98,
    BorderSizePixel=0,
    ZIndex=7
})
new("UICorner",{Parent=infoGlass,CornerRadius=UDim.new(0,14)})

local infoText = new("TextLabel",{
    Parent=infoContainer,
    Size=UDim2.new(1,-32,0,0),
    Position=UDim2.new(0,16,0,16),
    BackgroundTransparency=1,
    Text=[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🌟 LYNX v2.0
   Premium Glass Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ FEATURES

🐟 AUTO FISHING
   • Instant Fishing (Fast/Perfect)
   • Blatant Mode (High Risk)
   • No Animation Support
   • Configurable Delays

⚡ TELEPORT
   • Location Teleporter
   • Player Teleporter
   • Dynamic Player List

🛒 SHOP
   • Auto Sell System
   • Auto Sell Timer
   • Auto Buy Weather
   • Multi-Select Weather

⚙️ SETTINGS
   • Anti-AFK Protection
   • FPS Unlocker
   • General Settings
   • Performance Mode

━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 TIPS & TRICKS

• Lower delay = Faster but risky
• Higher delay = Safer but slower
• Recommended: 1.30s fishing
• Recommended: 0.19s cancel
• Use dropdown selections wisely
• Check icon shows active selection

━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎨 UI FEATURES

• Premium Glass Morphism
• Smooth Animations
• Selection Indicators
• Mobile Optimized
• Resizable Window
• Draggable Interface

━━━━━━━━━━━━━━━━━━━━━━━━━━━

Created with ❤️ by Lynx Team
© 2024 All Rights Reserved
    ]],
    Font=Enum.Font.GothamMedium,
    TextSize=10,
    TextColor3=colors.text,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=8
})

new("UIPadding",{
    Parent=infoContainer,
    PaddingTop=UDim.new(0,16),
    PaddingBottom=UDim.new(0,16),
    PaddingLeft=UDim.new(0,16),
    PaddingRight=UDim.new(0,16)
})

-- Minimized Icon
local minimized = false
local icon
local savedIconPos = UDim2.new(0,20,0,120)

local function createMinimizedIcon()
    if icon then return end
    icon = new("Frame",{
        Parent=gui,
        Size=UDim2.new(0,60,0,60),
        Position=savedIconPos,
        BackgroundColor3=colors.bg,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,16)})
    
    local iconGlass = new("Frame",{
        Parent=icon,
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.96,
        BorderSizePixel=0,
        ZIndex=100
    })
    new("UICorner",{Parent=iconGlass,CornerRadius=UDim.new(0,16)})
    
    local iconStroke = new("UIStroke",{
        Parent=icon,
        Color=colors.primary,
        Thickness=3,
        Transparency=0.4
    })
    
    local iconGradient = new("UIGradient",{
        Parent=iconStroke,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(0.5, colors.accent),
            ColorSequenceKeypoint.new(1, colors.secondary)
        },
        Rotation=0
    })
    
    -- Rotating gradient
    task.spawn(function()
        while icon and icon.Parent do
            for i = 0, 360, 3 do
                if not icon or not icon.Parent then break end
                iconGradient.Rotation = i
                task.wait(0.03)
            end
        end
    end)
    
    local iconLabel = new("TextLabel",{
        Parent=icon,
        Text="L",
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=32,
        TextColor3=colors.text,
        ZIndex=101
    })
    
    local dragging,dragStart,startPos,dragMoved = false,nil,nil,false
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging,dragMoved,dragStart,startPos = true,false,input.Position,icon.Position
            TweenService:Create(icon,TweenInfo.new(0.2),{Size=UDim2.new(0,56,0,56)}):Play()
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
                TweenService:Create(icon,TweenInfo.new(0.2),{Size=UDim2.new(0,60,0,60)}):Play()
                dragging = false
                savedIconPos = icon.Position
                if not dragMoved then
                    inputBlocker.Visible,win.Visible = true,true
                    TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=0.3}):Play()
                    TweenService:Create(blur,TweenInfo.new(0.3),{Size=12}):Play()
                    TweenService:Create(win,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                        Size=UDim2.new(0,680,0,460),
                        Position=UDim2.new(0.5,-340,0.5,-230)
                    }):Play()
                    task.wait(0.6)
                    if icon then icon:Destroy() icon = nil end
                    minimized = false
                end
            end
        end
    end)
end

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(win,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
            Size=UDim2.new(0,0,0,0),
            Position=UDim2.new(0.5,0,0.5,0),
            Rotation=180
        }):Play()
        TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        TweenService:Create(blur,TweenInfo.new(0.3),{Size=0}):Play()
        task.wait(0.5)
        win.Visible,inputBlocker.Visible = false,false
        win.Rotation = 0
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0),
        Rotation=360
    }):Play()
    TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
    TweenService:Create(blur,TweenInfo.new(0.3),{Size=0}):Play()
    task.wait(0.5)
    blur:Destroy()
    gui:Destroy()
end)

-- Draggable Window
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

-- Resizable Window
local resizeHandle = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,22,0,22),
    Position=UDim2.new(1,-22,1,-22),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=10
})
new("UICorner",{Parent=resizeHandle,CornerRadius=UDim.new(0,8)})

local resizeGradient = new("UIGradient",{
    Parent=resizeHandle,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(1, colors.accent)
    },
    Rotation=45
})

local resizeStroke = new("UIStroke",{
    Parent=resizeHandle,
    Color=colors.primary,
    Thickness=1.5,
    Transparency=0.5
})

local resizeIcon = new("TextLabel",{
    Parent=resizeHandle,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Text="⋰",
    Font=Enum.Font.GothamBold,
    TextSize=14,
    TextColor3=colors.text,
    ZIndex=11
})

resizeHandle.MouseEnter:Connect(function()
    TweenService:Create(resizeHandle,TweenInfo.new(0.2),{
        BackgroundTransparency=0.2,
        Size=UDim2.new(0,24,0,24)
    }):Play()
end)

resizeHandle.MouseLeave:Connect(function()
    TweenService:Create(resizeHandle,TweenInfo.new(0.2),{
        BackgroundTransparency=0.4,
        Size=UDim2.new(0,22,0,22)
    }):Play()
end)

local resizing = false
local resizeStart = nil
local startSize = nil

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startSize = win.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local newWidth = math.max(550, startSize.X.Offset + delta.X)
        local newHeight = math.max(420, startSize.Y.Offset + delta.Y)
        win.Size = UDim2.new(0, newWidth, 0, newHeight)
        win.Position = UDim2.new(0.5, -newWidth/2, 0.5, -newHeight/2)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

-- Opening Animation
task.spawn(function()
    win.Size = UDim2.new(0,0,0,0)
    win.Position = UDim2.new(0.5,0,0.5,0)
    win.Rotation = -360
    inputBlocker.Visible = true
    inputBlocker.BackgroundTransparency = 1
    
    task.wait(0.1)
    
    TweenService:Create(inputBlocker,TweenInfo.new(0.5),{BackgroundTransparency=0.3}):Play()
    TweenService:Create(blur,TweenInfo.new(0.5),{Size=12}):Play()
    TweenService:Create(win,TweenInfo.new(0.8,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,680,0,460),
        Position=UDim2.new(0.5,-340,0.5,-230),
        Rotation=0
    }):Play()
    
    -- Logo pulse
    task.wait(0.4)
    for i = 1, 3 do
        TweenService:Create(logoStroke,TweenInfo.new(0.4),{Transparency=0.1}):Play()
        TweenService:Create(logoContainer,TweenInfo.new(0.4),{Size=UDim2.new(0,46,0,46)}):Play()
        task.wait(0.4)
        TweenService:Create(logoStroke,TweenInfo.new(0.4),{Transparency=0.3}):Play()
        TweenService:Create(logoContainer,TweenInfo.new(0.4),{Size=UDim2.new(0,44,0,44)}):Play()
        task.wait(0.4)
    end
end)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✨ LYNX GUI v2.0 - Premium Glass Edition")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎨 Features:")
print("   • Acrylic Glass Morphism")
print("   • Premium Animations")
print("   • Selection Indicators")
print("   • Smooth Transitions")
print("   • Modern Icon System")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🚀 Status: Loaded Successfully!")
print("💻 Created by Lynx Team © 2024")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
