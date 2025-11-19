-- LynxGUI_v1.0.lua - Minimalist Modern Edition
-- Clean & Transparent Design with Category System

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

-- Modern Color Palette with Gradients
local colors = {
    primary = Color3.fromRGB(0, 200, 255),
    secondary = Color3.fromRGB(138, 43, 226),
    accent = Color3.fromRGB(0, 255, 180),
    success = Color3.fromRGB(0, 220, 120),
    warning = Color3.fromRGB(255, 190, 0),
    danger = Color3.fromRGB(255, 70, 90),
    bg = Color3.fromRGB(18, 18, 24),
    bgLight = Color3.fromRGB(28, 28, 38),
    bgDark = Color3.fromRGB(12, 12, 18),
    glass = Color3.fromRGB(25, 25, 35),
    text = Color3.fromRGB(245, 245, 250),
    textDim = Color3.fromRGB(170, 175, 190),
    border = Color3.fromRGB(50, 55, 70),
}

-- Icon System (Unicode symbols)
local icons = {
    home = "⌂",
    teleport = "⚡",
    shop = "◆",
    settings = "⚙",
    info = "ⓘ",
    fish = "⟩",
    speed = "►",
    location = "●",
    player = "▲",
    sell = "■",
    timer = "◉",
    weather = "◇",
    general = "▼",
    protection = "◈",
    fps = "◀",
    arrow = "›",
    check = "✓",
    close = "✕",
    minimize = "−",
}

local gui = new("ScreenGui",{
    Name="LynxGUI",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

local inputBlocker = new("Frame",{
    Parent=gui,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(0,0,0),
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    Visible=false,
    ZIndex=1,
    Active=true
})

-- Main Window (ukuran lebih proporsional)
local win = new("Frame",{
    Parent=gui,
    Size=UDim2.new(0,620,0,420),
    Position=UDim2.new(0.5,-310,0.5,-210),
    BackgroundColor3=colors.bg,
    BackgroundTransparency=0.08,
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,16)})

-- Glass effect border
local winStroke = new("UIStroke",{
    Parent=win,
    Color=colors.primary,
    Thickness=1.5,
    Transparency=0.7,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Subtle gradient overlay
local winGradient = new("UIGradient",{
    Parent=win,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 22))
    },
    Rotation=45
})

-- Top Bar (improved design)
local topBar = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,0,52),
    BackgroundColor3=colors.bgDark,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,16)})

-- Top bar gradient
local topBarGradient = new("UIGradient",{
    Parent=topBar,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.bgDark),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 28))
    },
    Rotation=90
})

-- Logo Container dengan glow effect
local logoContainer = new("ImageLabel",{
    Parent=topBar,
    Size=UDim2.new(0,36,0,36),
    Position=UDim2.new(0,12,0.5,-18),
    BackgroundColor3=colors.glass,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    Image="rbxasset://textures/ui/GuiImagePlaceholder.png",
    ScaleType=Enum.ScaleType.Fit,
    ZIndex=5
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,10)})

local logoStroke = new("UIStroke",{
    Parent=logoContainer,
    Color=colors.primary,
    Thickness=2,
    Transparency=0.4
})

-- Glow effect
local logoGlow = new("ImageLabel",{
    Parent=logoContainer,
    Size=UDim2.new(1.4,0,1.4,0),
    Position=UDim2.new(0.5,0,0.5,0),
    AnchorPoint=Vector2.new(0.5,0.5),
    BackgroundTransparency=1,
    Image="rbxasset://textures/ui/GuiImagePlaceholder.png",
    ImageColor3=colors.primary,
    ImageTransparency=0.7,
    ZIndex=4
})

-- Title dengan shadow
local titleShadow = new("TextLabel",{
    Parent=topBar,
    Text="Lynx",
    Size=UDim2.new(0,120,1,2),
    Position=UDim2.new(0,56,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=18,
    BackgroundTransparency=1,
    TextColor3=Color3.fromRGB(0,0,0),
    TextTransparency=0.5,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=4
})

local titleLabel = new("TextLabel",{
    Parent=topBar,
    Text="Lynx",
    Size=UDim2.new(0,120,1,0),
    Position=UDim2.new(0,56,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=18,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=5
})

-- Version badge
local versionBadge = new("TextLabel",{
    Parent=topBar,
    Text="v1.0",
    Size=UDim2.new(0,40,0,18),
    Position=UDim2.new(0,180,0.5,-9),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.2,
    Font=Enum.Font.GothamBold,
    TextSize=9,
    TextColor3=colors.text,
    ZIndex=5
})
new("UICorner",{Parent=versionBadge,CornerRadius=UDim.new(0,5)})
new("UIStroke",{Parent=versionBadge,Color=colors.primary,Thickness=1,Transparency=0.5})

-- Control Buttons (improved)
local controlsContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,75,0,32),
    Position=UDim2.new(1,-82,0.5,-16),
    BackgroundTransparency=1,
    ZIndex=5
})
new("UIListLayout",{
    Parent=controlsContainer,
    FillDirection=Enum.FillDirection.Horizontal,
    HorizontalAlignment=Enum.HorizontalAlignment.Right,
    Padding=UDim.new(0,6)
})

local function createControlButton(icon, hoverColor)
    local btn = new("TextButton",{
        Parent=controlsContainer,
        Text=icon,
        Size=UDim2.new(0,32,0,32),
        BackgroundColor3=colors.glass,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,8)})
    
    local btnStroke = new("UIStroke",{
        Parent=btn,
        Color=colors.border,
        Thickness=1.5,
        Transparency=0.5
    })
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{
            BackgroundColor3=hoverColor,
            BackgroundTransparency=0.1,
            TextColor3=colors.text,
            Size=UDim2.new(0,34,0,34)
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.25),{
            Color=hoverColor,
            Transparency=0.2
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{
            BackgroundColor3=colors.glass,
            BackgroundTransparency=0.4,
            TextColor3=colors.textDim,
            Size=UDim2.new(0,32,0,32)
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.25),{
            Color=colors.border,
            Transparency=0.5
        }):Play()
    end)
    return btn
end

local btnMin = createControlButton(icons.minimize, colors.warning)
local btnClose = createControlButton(icons.close, colors.danger)

-- Sidebar (improved design)
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,140,1,-60),
    Position=UDim2.new(0,7,0,56),
    BackgroundColor3=colors.bgDark,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=sidebar,CornerRadius=UDim.new(0,12)})

local sidebarStroke = new("UIStroke",{
    Parent=sidebar,
    Color=colors.border,
    Thickness=1.5,
    Transparency=0.6
})

-- Sidebar gradient
local sidebarGradient = new("UIGradient",{
    Parent=sidebar,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 26)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
    },
    Rotation=90
})

local navContainer = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1,-12,1,-12),
    Position=UDim2.new(0,6,0,6),
    BackgroundTransparency=1,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
})

local currentPage = "Main"
local navButtons = {}

local function createNavButton(text, icon, page)
    local isActive = page == currentPage
    
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1,0,0,42),
        BackgroundColor3=isActive and colors.primary or colors.glass,
        BackgroundTransparency=isActive and 0.2 or 0.6,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,10)})
    
    local btnStroke = new("UIStroke",{
        Parent=btn,
        Color=isActive and colors.primary or colors.border,
        Thickness=1.5,
        Transparency=isActive and 0.4 or 0.7
    })
    
    -- Icon
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Size=UDim2.new(0,32,1,0),
        Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=isActive and colors.text or colors.textDim,
        ZIndex=8
    })
    
    -- Text
    local textLabel = new("TextLabel",{
        Parent=btn,
        Size=UDim2.new(1,-45,1,0),
        Position=UDim2.new(0,40,0,0),
        BackgroundTransparency=1,
        Text=text,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=isActive and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{
                BackgroundTransparency=0.3,
                BackgroundColor3=colors.primary
            }):Play()
            TweenService:Create(btnStroke,TweenInfo.new(0.3),{
                Color=colors.primary,
                Transparency=0.5
            }):Play()
            TweenService:Create(iconLabel,TweenInfo.new(0.3),{
                TextColor3=colors.text
            }):Play()
            TweenService:Create(textLabel,TweenInfo.new(0.3),{
                TextColor3=colors.text
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{
                BackgroundTransparency=0.6,
                BackgroundColor3=colors.glass
            }):Play()
            TweenService:Create(btnStroke,TweenInfo.new(0.3),{
                Color=colors.border,
                Transparency=0.7
            }):Play()
            TweenService:Create(iconLabel,TweenInfo.new(0.3),{
                TextColor3=colors.textDim
            }):Play()
            TweenService:Create(textLabel,TweenInfo.new(0.3),{
                TextColor3=colors.textDim
            }):Play()
        end
    end)
    
    navButtons[page] = {btn=btn, icon=iconLabel, text=textLabel, stroke=btnStroke}
    return btn
end

-- Content Area (improved)
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-160,1,-65),
    Position=UDim2.new(0,152,0,59),
    BackgroundColor3=colors.glass,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg,CornerRadius=UDim.new(0,12)})

local contentStroke = new("UIStroke",{
    Parent=contentBg,
    Color=colors.border,
    Thickness=1.5,
    Transparency=0.6
})

-- Content gradient
local contentGradient = new("UIGradient",{
    Parent=contentBg,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 22))
    },
    Rotation=135
})

local pages = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,-10,1,-10),
        Position=UDim2.new(0,5,0,5),
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
        Padding=UDim.new(0,8),
        SortOrder=Enum.SortOrder.LayoutOrder,
        HorizontalAlignment=Enum.HorizontalAlignment.Center
    })
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0,5),
        PaddingBottom=UDim.new(0,5)
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
    
    -- Fade out current page
    local currentPageFrame = pages[currentPage]
    if currentPageFrame then
        TweenService:Create(currentPageFrame,TweenInfo.new(0.2),{
            Position=UDim2.new(0,-20,0,5)
        }):Play()
        task.wait(0.1)
        currentPageFrame.Visible = false
    end
    
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        TweenService:Create(btnData.btn,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{
            BackgroundTransparency = isActive and 0.2 or 0.6,
            BackgroundColor3 = isActive and colors.primary or colors.glass
        }):Play()
        TweenService:Create(btnData.stroke,TweenInfo.new(0.3),{
            Color = isActive and colors.primary or colors.border,
            Thickness = 1.5,
            Transparency = isActive and 0.4 or 0.7
        }):Play()
        TweenService:Create(btnData.icon,TweenInfo.new(0.3),{
            TextColor3 = isActive and colors.text or colors.textDim
        }):Play()
        TweenService:Create(btnData.text,TweenInfo.new(0.3),{
            TextColor3 = isActive and colors.text or colors.textDim
        }):Play()
    end
    
    -- Fade in new page
    local newPageFrame = pages[pageName]
    newPageFrame.Position = UDim2.new(0,20,0,5)
    newPageFrame.Visible = true
    TweenService:Create(newPageFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{
        Position=UDim2.new(0,5,0,5)
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

-- Category System (improved design)
local function createCategory(parent, title, icon)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(0.97,0,0,44),
        BackgroundColor3=colors.glass,
        BackgroundTransparency=0.4,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,12)})
    
    local catStroke = new("UIStroke",{
        Parent=categoryFrame,
        Color=colors.primary,
        Thickness=1.5,
        Transparency=0.7
    })
    
    -- Gradient
    local catGradient = new("UIGradient",{
        Parent=categoryFrame,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 26))
        },
        Rotation=90
    })
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,0,40),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    
    -- Icon
    local iconLabel = new("TextLabel",{
        Parent=header,
        Text=icon,
        Size=UDim2.new(0,28,1,0),
        Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=15,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    -- Title
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-90,1,0),
        Position=UDim2.new(0,42,0,0),
        Font=Enum.Font.GothamBold,
        TextSize=12,
        TextColor3=colors.text,
        BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    -- Arrow
    local arrow = new("TextLabel",{
        Parent=header,
        Text=icons.arrow,
        Size=UDim2.new(0,24,1,0),
        Position=UDim2.new(1,-32,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    local container = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1,-12,0,0),
        Position=UDim2.new(0,6,0,46),
        BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y,
        Visible=false,
        ZIndex=7
    })
    new("UIListLayout",{
        Parent=container,
        Padding=UDim.new(0,6),
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=container,
        PaddingBottom=UDim.new(0,6)
    })
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        container.Visible = isOpen
        
        TweenService:Create(arrow,TweenInfo.new(0.3,Enum.EasingStyle.Back),{
            Rotation = isOpen and 90 or 0,
            TextColor3 = isOpen and colors.accent or colors.primary
        }):Play()
        
        TweenService:Create(catStroke,TweenInfo.new(0.3),{
            Color = isOpen and colors.accent or colors.primary,
            Transparency = isOpen and 0.4 or 0.7
        }):Play()
    end)
    
    -- Hover effect
    header.MouseEnter:Connect(function()
        TweenService:Create(categoryFrame,TweenInfo.new(0.2),{
            BackgroundTransparency=0.2
        }):Play()
    end)
    header.MouseLeave:Connect(function()
        TweenService:Create(categoryFrame,TweenInfo.new(0.2),{
            BackgroundTransparency=0.4
        }):Play()
    end)
    
    return container
end

-- Toggle Component
local function makeToggle(parent,label,callback)
    local f=new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,30),
        BackgroundTransparency=1,
        ZIndex=6
    })
    
    new("TextLabel",{
        Parent=f,
        Text=label,
        Size=UDim2.new(0.65,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=10,
        TextWrapped=true,
        ZIndex=7
    })
    
    local toggleBg=new("Frame",{
        Parent=f,
        Size=UDim2.new(0,40,0,20),
        Position=UDim2.new(1,-42,0.5,-10),
        BackgroundColor3=colors.border,
        BackgroundTransparency=0,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=toggleBg,CornerRadius=UDim.new(1,0)})
    
    local toggleCircle=new("Frame",{
        Parent=toggleBg,
        Size=UDim2.new(0,14,0,14),
        Position=UDim2.new(0,3,0.5,-7),
        BackgroundColor3=colors.textDim,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=toggleCircle,CornerRadius=UDim.new(1,0)})
    
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
        TweenService:Create(toggleBg,TweenInfo.new(0.2),{
            BackgroundColor3=on and colors.primary or colors.border
        }):Play()
        TweenService:Create(toggleCircle,TweenInfo.new(0.25,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
            BackgroundColor3=on and colors.text or colors.textDim
        }):Play()
        callback(on)
    end)
end

-- Slider Component
local function makeSlider(parent,label,min,max,def,onChange)
    local f=new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,42),
        BackgroundTransparency=1,
        ZIndex=6
    })
    
    local lbl=new("TextLabel",{
        Parent=f,
        Text=("%s: %.2fs"):format(label,def),
        Size=UDim2.new(1,0,0,14),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium,
        TextSize=9,
        ZIndex=7
    })
    
    local bar=new("Frame",{
        Parent=f,
        Size=UDim2.new(1,-5,0,6),
        Position=UDim2.new(0,2,0,22),
        BackgroundColor3=colors.border,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(1,0)})
    
    local fill=new("Frame",{
        Parent=bar,
        Size=UDim2.new((def-min)/(max-min),0,1,0),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(1,0)})
    
    local knob=new("Frame",{
        Parent=bar,
        Size=UDim2.new(0,14,0,14),
        Position=UDim2.new((def-min)/(max-min),-7,0.5,-7),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    
    local dragging=false
    local function update(x)
        local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        local val=min+(max-min)*rel
        fill.Size=UDim2.new(rel,0,1,0)
        knob.Position=UDim2.new(rel,-7,0.5,-7)
        lbl.Text=("%s: %.2fs"):format(label,val)
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

-- Dropdown Component
local function makeDropdown(parent, title, items, onSelect)
    local dropdownFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = colors.bgDark,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 6
    })
    new("UICorner", {Parent = dropdownFrame, CornerRadius = UDim.new(0, 8)})
    new("UIStroke", {Parent = dropdownFrame, Color = colors.border, Thickness = 1})
    
    local header = new("TextButton", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, -10, 0, 28),
        Position = UDim2.new(0, 5, 0, 2),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 7
    })
    
    local headerLabel = new("TextLabel", {
        Parent = header,
        Text = title,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        TextSize = 10,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    local arrow = new("TextLabel", {
        Parent = header,
        Text = "v",
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = colors.primary,
        ZIndex = 8
    })
    
    local listContainer = new("ScrollingFrame", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 0, 34),
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = colors.primary,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 10
    })
    new("UIListLayout", {Parent = listContainer, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
    new("UIPadding", {Parent = listContainer, PaddingBottom = UDim.new(0, 5)})
    
    local isOpen = false
    
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.2), {
            Rotation = isOpen and 180 or 0
        }):Play()
        
        if isOpen and #items > 5 then
            listContainer.Size = UDim2.new(1, -10, 0, 120)
        else
            listContainer.Size = UDim2.new(1, -10, 0, math.min(#items * 26, 130))
        end
    end)
    
    for _, itemName in ipairs(items) do
        local itemBtn = new("TextButton", {
            Parent = listContainer,
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = colors.bgLight,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 11
        })
        new("UICorner", {Parent = itemBtn, CornerRadius = UDim.new(0, 6)})
        
        local btnLabel = new("TextLabel", {
            Parent = itemBtn,
            Text = itemName,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 9,
            TextColor3 = colors.textDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 12
        })
        
        itemBtn.MouseEnter:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = colors.primary,
                BackgroundTransparency = 0.2
            }):Play()
            TweenService:Create(btnLabel, TweenInfo.new(0.15), {
                TextColor3 = colors.text
            }):Play()
        end)
        
        itemBtn.MouseLeave:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = colors.bgLight,
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(btnLabel, TweenInfo.new(0.15), {
                TextColor3 = colors.textDim
            }):Play()
        end)
        
        itemBtn.MouseButton1Click:Connect(function()
            onSelect(itemName)
            task.wait(0.1)
            isOpen = false
            listContainer.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
        end)
    end
    
    return dropdownFrame
end

-- Button Component
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = colors.bgDark,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 7
    })
    new("UICorner", { Parent = btnFrame, CornerRadius = UDim.new(0, 8) })
    new("UIStroke", { Parent = btnFrame, Color = colors.border, Thickness = 1 })

    local button = new("TextButton", {
        Parent = btnFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = colors.text,
        AutoButtonColor = false,
        ZIndex = 8
    })

    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0,
            BackgroundColor3 = colors.primary
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.3,
            BackgroundColor3 = colors.bgDark
        }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        pcall(function()
            callback()
        end)
    end)

    return btnFrame
end

-- Main Page Content - Auto Fishing Category
local autoFishingCat = createCategory(mainPage, "Auto Fishing", icons.fish)

-- Instant Fishing dengan sub-dropdown
local instantContainer = new("Frame",{
    Parent=autoFishingCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{
    Parent=instantContainer,
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder
})

-- Instant Fishing Mode Selector
local selectedInstantMode = "Fast"
local instantActive = false

makeDropdown(instantContainer, "Instant Fishing Mode", {"Fast", "Perfect"}, function(mode)
    selectedInstantMode = mode
    print("Selected mode:", mode)
    
    -- Stop both if active
    if instantActive then
        instant.Stop()
        instant2.Stop()
    end
end)

-- Toggle untuk enable/disable
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

-- Unified Sliders
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
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder
})

new("TextLabel",{
    Parent=blatantContainer,
    Text="TRUE BLATANT MODE",
    Size=UDim2.new(1,0,0,16),
    BackgroundTransparency=1,
    TextColor3=colors.danger,
    Font=Enum.Font.GothamBold,
    TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=7
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
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder
})

new("TextLabel",{
    Parent=noAnimContainer,
    Text="No Fishing Animation",
    Size=UDim2.new(1,0,0,16),
    BackgroundTransparency=1,
    TextColor3=colors.accent,
    Font=Enum.Font.GothamBold,
    TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=7
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
makeDropdown(teleportPlayerCat, "Select Player", playerItems, function(selectedPlayer)
    TeleportToPlayer.TeleportTo(selectedPlayer)
    print("Teleporting to player:", selectedPlayer)
end)

-- Dynamic Player List Update
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
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder
})

makeButton(sellContainer, "Sell All", function()
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
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder
})

makeSlider(timerContainer, "Sell Interval (s)", 1, 60, 5, function(value)
    AutoSellTimer.SetInterval(value)
end)

makeButton(timerContainer, "Start Auto Sell", function()
    if AutoSellTimer then
        AutoSellTimer.Start(AutoSellTimer.Interval)
    else
        warn("AutoSellTimer not loaded")
    end
end)

makeButton(timerContainer, "Stop Auto Sell", function()
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
    Padding=UDim.new(0,5),
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
    Padding=UDim.new(0,5),
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
    Padding=UDim.new(0,5),
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
    Padding=UDim.new(0,5),
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
local infoText = new("TextLabel",{
    Parent=infoPage,
    Size=UDim2.new(0.96,0,0,300),
    BackgroundColor3=colors.bgDark,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    Text=[[

LYNX v1.0
Minimalist Modern Edition

FEATURES

AUTO FISHING
• Instant Fishing (Fast/Perfect)
• Blatant Mode
• No Animation

TELEPORT
• Location teleport
• Player teleport

SHOP
• Auto sell system
• Auto sell timer
• Auto buy weather

SETTINGS
• Anti-AFK
• FPS unlocker
• General settings

TIPS
• Lower delay = faster but risky
• Higher delay = safer but slow
• Recommended: 1.30s fishing, 0.19s cancel

Created by Lynx Team 2024
    ]],
    Font=Enum.Font.Gotham,
    TextSize=9,
    TextColor3=colors.textDim,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=7
})
new("UICorner",{Parent=infoText,CornerRadius=UDim.new(0,10)})
new("UIStroke",{Parent=infoText,Color=colors.border,Thickness=1})
new("UIPadding",{Parent=infoText,PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)})

-- Minimized Icon (improved)
local minimized = false
local icon
local savedIconPos = UDim2.new(0,20,0,120)

local function createMinimizedIcon()
    if icon then return end
    icon = new("ImageLabel",{
        Parent=gui,
        Size=UDim2.new(0,52,0,52),
        Position=savedIconPos,
        BackgroundColor3=colors.bg,
        BackgroundTransparency=0.1,
        BorderSizePixel=0,
        Image="rbxasset://textures/ui/GuiImagePlaceholder.png",
        ScaleType=Enum.ScaleType.Fit,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,14)})
    
    local iconStroke = new("UIStroke",{
        Parent=icon,
        Color=colors.primary,
        Thickness=2.5,
        Transparency=0.3
    })
    
    -- Glow effect
    local iconGlow = new("ImageLabel",{
        Parent=icon,
        Size=UDim2.new(1.3,0,1.3,0),
        Position=UDim2.new(0.5,0,0.5,0),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundTransparency=1,
        Image="rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3=colors.primary,
        ImageTransparency=0.7,
        ZIndex=99
    })
    
    local dragging,dragStart,startPos,dragMoved = false,nil,nil,false
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging,dragMoved,dragStart,startPos = true,false,input.Position,icon.Position
            TweenService:Create(icon,TweenInfo.new(0.2),{Size=UDim2.new(0,48,0,48)}):Play()
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
                TweenService:Create(icon,TweenInfo.new(0.2),{Size=UDim2.new(0,52,0,52)}):Play()
                dragging = false
                savedIconPos = icon.Position
                if not dragMoved then
                    inputBlocker.Visible,win.Visible = true,true
                    TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=0.5}):Play()
                    TweenService:Create(win,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                        Size=UDim2.new(0,620,0,420),
                        Position=UDim2.new(0.5,-310,0.5,-210)
                    }):Play()
                    task.wait(0.5)
                    if icon then icon:Destroy() icon = nil end
                    minimized = false
                end
            end
        end
    end)
end

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
            Size=UDim2.new(0,0,0,0),
            Position=UDim2.new(0.5,0,0.5,0),
            Rotation=90
        }):Play()
        TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.wait(0.4)
        win.Visible,inputBlocker.Visible = false,false
        win.Rotation = 0
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0),
        Rotation=180
    }):Play()
    TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
    task.wait(0.4)
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

-- Resizable Window (improved)
local resizeHandle = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,18,0,18),
    Position=UDim2.new(1,-18,1,-18),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    ZIndex=10
})
new("UICorner",{Parent=resizeHandle,CornerRadius=UDim.new(0,6)})

local resizeStroke = new("UIStroke",{
    Parent=resizeHandle,
    Color=colors.primary,
    Thickness=1.5,
    Transparency=0.3
})

-- Resize icon
local resizeIcon = new("TextLabel",{
    Parent=resizeHandle,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Text="⋰",
    Font=Enum.Font.GothamBold,
    TextSize=12,
    TextColor3=colors.text,
    ZIndex=11
})

resizeHandle.MouseEnter:Connect(function()
    TweenService:Create(resizeHandle,TweenInfo.new(0.2),{
        BackgroundTransparency=0.2,
        Size=UDim2.new(0,20,0,20)
    }):Play()
end)

resizeHandle.MouseLeave:Connect(function()
    TweenService:Create(resizeHandle,TweenInfo.new(0.2),{
        BackgroundTransparency=0.5,
        Size=UDim2.new(0,18,0,18)
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
        local newWidth = math.max(500, startSize.X.Offset + delta.X)
        local newHeight = math.max(380, startSize.Y.Offset + delta.Y)
        win.Size = UDim2.new(0, newWidth, 0, newHeight)
        win.Position = UDim2.new(0.5, -newWidth/2, 0.5, -newHeight/2)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

-- Opening Animation (improved)
task.spawn(function()
    win.Size = UDim2.new(0,0,0,0)
    win.Position = UDim2.new(0.5,0,0.5,0)
    win.Rotation = -180
    inputBlocker.Visible = true
    inputBlocker.BackgroundTransparency = 1
    
    task.wait(0.1)
    
    TweenService:Create(inputBlocker,TweenInfo.new(0.4),{BackgroundTransparency=0.5}):Play()
    TweenService:Create(win,TweenInfo.new(0.7,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,620,0,420),
        Position=UDim2.new(0.5,-310,0.5,-210),
        Rotation=0
    }):Play()
    
    -- Fade in logo with glow pulse
    task.wait(0.3)
    local pulseCount = 0
    while pulseCount < 2 do
        TweenService:Create(logoStroke,TweenInfo.new(0.5),{Transparency=0.1}):Play()
        task.wait(0.5)
        TweenService:Create(logoStroke,TweenInfo.new(0.5),{Transparency=0.4}):Play()
        task.wait(0.5)
        pulseCount = pulseCount + 1
    end
end)

print("✨ Lynx GUI v1.0 loaded successfully!")
print("🎨 Modern minimalist design")
print("⚡ Smooth animations & transitions")
print("📱 Mobile optimized")
print("Created by Lynx Team")
