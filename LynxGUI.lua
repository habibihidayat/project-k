-- LynxGUI_v3.1.lua - Mobile Optimized iOS Edition
-- Perfect iOS Design, Compact Mobile Layout, Premium Details

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

-- Enhanced iOS Color Palette
local colors = {
    primary = Color3.fromRGB(10, 132, 255),        -- iOS Blue
    primaryLight = Color3.fromRGB(64, 156, 255),
    primaryDark = Color3.fromRGB(0, 122, 255),
    success = Color3.fromRGB(52, 199, 89),
    danger = Color3.fromRGB(255, 69, 58),
    warning = Color3.fromRGB(255, 214, 10),
    
    -- Glassmorphism backgrounds
    glassBg = Color3.fromRGB(18, 18, 20),
    glassCard = Color3.fromRGB(28, 28, 30),
    glassSidebar = Color3.fromRGB(22, 22, 24),
    glassHeader = Color3.fromRGB(25, 25, 27),
    
    -- Text colors
    text = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(152, 152, 157),
    textTertiary = Color3.fromRGB(99, 99, 102),
    
    -- UI Elements
    separator = Color3.fromRGB(56, 56, 58),
    border = Color3.fromRGB(72, 72, 74),
    shadow = Color3.fromRGB(0, 0, 0),
}

local gui = new("ScreenGui",{
    Name="LynxGUI_iOS_Mobile",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Blur Background Effect
local blur = new("Frame",{
    Parent=gui,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(0,0,0),
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    Visible=false,
    ZIndex=1,
    Active=true
})

-- Main Window - Optimized for Mobile (Smaller Size)
local win = new("Frame",{
    Parent=gui,
    Size=UDim2.new(0,460,0,380),        -- Reduced from 720x520
    Position=UDim2.new(0.5,-230,0.5,-190),
    BackgroundColor3=colors.glassBg,
    BackgroundTransparency=0.08,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,20)})  -- iOS standard radius
new("UIStroke",{Parent=win,Color=colors.border,Thickness=0.5,Transparency=0.5,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})

-- Subtle Shadow with Gradient
local shadowGradient = new("UIGradient",{
    Parent=win,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,22))
    }),
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0)
    })
})

-- Top Bar - Compact
local topBar = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,0,56),
    BackgroundColor3=colors.glassHeader,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,20)})

-- Bottom mask for topBar
local topBarMask = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(1,0,0,20),
    Position=UDim2.new(0,0,1,-20),
    BackgroundColor3=colors.glassHeader,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    ZIndex=4
})

-- Separator line with gradient
local separator = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(1,-32,0,0.5),
    Position=UDim2.new(0,16,1,-0.5),
    BackgroundColor3=colors.separator,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=5
})

-- Title with badge effect
local titleContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,200,1,0),
    Position=UDim2.new(0,16,0,0),
    BackgroundTransparency=1,
    ZIndex=5
})

local titleLabel = new("TextLabel",{
    Parent=titleContainer,
    Text="Lynx",
    Size=UDim2.new(1,0,0,24),
    Position=UDim2.new(0,0,0,10),
    Font=Enum.Font.GothamBold,
    TextSize=20,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Add gradient to title
local titleGradient = new("UIGradient",{
    Parent=titleLabel,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(1, colors.primaryLight)
    })
})

local subtitleLabel = new("TextLabel",{
    Parent=titleContainer,
    Text="v3.1 Mobile",
    Size=UDim2.new(1,0,0,14),
    Position=UDim2.new(0,0,1,-20),
    Font=Enum.Font.Gotham,
    TextSize=10,
    BackgroundTransparency=1,
    TextColor3=colors.textSecondary,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Control Buttons Container - Compact
local controlsContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,76,0,32),
    Position=UDim2.new(1,-88,0.5,-16),
    BackgroundTransparency=1,
    ZIndex=5
})
new("UIListLayout",{
    Parent=controlsContainer,
    FillDirection=Enum.FillDirection.Horizontal,
    HorizontalAlignment=Enum.HorizontalAlignment.Right,
    Padding=UDim.new(0,8)
})

local function createControlButton(icon, color)
    local btnContainer = new("Frame",{
        Parent=controlsContainer,
        Size=UDim2.new(0,32,0,32),
        BackgroundTransparency=1,
        ZIndex=6
    })
    
    local btn = new("TextButton",{
        Parent=btnContainer,
        Text=icon,
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=colors.text,
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(1,0)})
    new("UIStroke",{
        Parent=btn,
        Color=color,
        Thickness=1,
        Transparency=0.5,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
            BackgroundColor3=color,
            BackgroundTransparency=0.05,
            TextColor3=Color3.fromRGB(255,255,255)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
            BackgroundColor3=colors.glassCard,
            BackgroundTransparency=0.2,
            TextColor3=colors.text
        }):Play()
    end)
    
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.08),{Size=UDim2.new(0,28,0,28)}):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.08),{Size=UDim2.new(1,0,1,0)}):Play()
    end)
    
    return btn
end

local btnMin = createControlButton("−", colors.primary)
local btnClose = createControlButton("✕", colors.danger)

-- Sidebar - Compact
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,140,1,-56),
    Position=UDim2.new(0,0,0,56),
    BackgroundColor3=colors.glassSidebar,
    BackgroundTransparency=0.15,
    BorderSizePixel=0,
    ZIndex=4
})

-- Sidebar separator with subtle glow
new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(0,0.5,1,0),
    Position=UDim2.new(1,0,0,0),
    BackgroundColor3=colors.separator,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=5
})

-- Navigation Container
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=3,
    ScrollBarImageColor3=colors.primary,
    ScrollBarImageTransparency=0.5,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ZIndex=5
})
new("UIListLayout",{Parent=navContainer,Padding=UDim.new(0,4)})
new("UIPadding",{
    Parent=navContainer,
    PaddingTop=UDim.new(0,12),
    PaddingBottom=UDim.new(0,12),
    PaddingLeft=UDim.new(0,8),
    PaddingRight=UDim.new(0,8)
})

local currentPage = "Main"
local navButtons = {}

local function createNavButton(text, icon, page)
    local isActive = page == currentPage
    
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1,0,0,44),
        BackgroundColor3=isActive and colors.glassCard or colors.glassSidebar,
        BackgroundTransparency=isActive and 0.15 or 0.3,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,12)})
    
    if isActive then
        new("UIStroke",{
            Parent=btn,
            Color=colors.primary,
            Thickness=1,
            Transparency=0.3,
            ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        })
    end
    
    -- Active indicator with glow
    local indicator = new("Frame",{
        Parent=btn,
        Size=UDim2.new(0,2.5,0.5,0),
        Position=UDim2.new(0,0,0.25,0),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        Visible=isActive,
        ZIndex=8
    })
    new("UICorner",{Parent=indicator,CornerRadius=UDim.new(1,0)})
    
    -- Content container
    local content = new("Frame",{
        Parent=btn,
        Size=UDim2.new(1,-12,1,0),
        Position=UDim2.new(0,6,0,0),
        BackgroundTransparency=1,
        ZIndex=8
    })
    
    -- Icon with background
    local iconBg = new("Frame",{
        Parent=content,
        Size=UDim2.new(0,32,0,32),
        Position=UDim2.new(0,0,0.5,-16),
        BackgroundColor3=isActive and colors.primary or colors.glassCard,
        BackgroundTransparency=isActive and 0.85 or 0.5,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=iconBg,CornerRadius=UDim.new(0,8)})
    
    local iconLabel = new("TextLabel",{
        Parent=iconBg,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=isActive and colors.primary or colors.textSecondary,
        ZIndex=10
    })
    
    -- Text
    local textLabel = new("TextLabel",{
        Parent=content,
        Size=UDim2.new(1,-38,1,0),
        Position=UDim2.new(0,36,0,0),
        BackgroundTransparency=1,
        Text=text,
        Font=Enum.Font.GothamSemibold,
        TextSize=12,
        TextColor3=isActive and colors.text or colors.textSecondary,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    btn.MouseEnter:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
                BackgroundColor3=colors.glassCard,
                BackgroundTransparency=0.2
            }):Play()
            TweenService:Create(iconBg,TweenInfo.new(0.2),{
                BackgroundTransparency=0.3
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
                BackgroundColor3=colors.glassSidebar,
                BackgroundTransparency=0.3
            }):Play()
            TweenService:Create(iconBg,TweenInfo.new(0.2),{
                BackgroundTransparency=0.5
            }):Play()
        end
    end)
    
    navButtons[page] = {
        btn=btn,
        iconBg=iconBg,
        icon=iconLabel,
        text=textLabel,
        indicator=indicator,
        stroke=btn:FindFirstChildOfClass("UIStroke")
    }
    
    return btn
end

-- Content Area
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-140,1,-56),
    Position=UDim2.new(0,140,0,56),
    BackgroundColor3=colors.glassBg,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})

local pages = {}
local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        ScrollBarThickness=4,
        ScrollBarImageColor3=colors.primary,
        ScrollBarImageTransparency=0.4,
        BorderSizePixel=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false,
        ClipsDescendants=true,
        ZIndex=5
    })
    new("UIListLayout",{Parent=page,Padding=UDim.new(0,12),HorizontalAlignment=Enum.HorizontalAlignment.Center})
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0,16),
        PaddingBottom=UDim.new(0,16),
        PaddingLeft=UDim.new(0,16),
        PaddingRight=UDim.new(0,16)
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
    TweenService:Create(currentPageFrame,TweenInfo.new(0.18),{
        Position=UDim2.new(0,-20,0,0)
    }):Play()
    
    task.wait(0.12)
    currentPageFrame.Visible = false
    currentPageFrame.Position = UDim2.new(0,0,0,0)
    
    -- Update navigation buttons
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        
        TweenService:Create(btnData.btn,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            BackgroundColor3 = isActive and colors.glassCard or colors.glassSidebar,
            BackgroundTransparency = isActive and 0.15 or 0.3
        }):Play()
        
        TweenService:Create(btnData.iconBg,TweenInfo.new(0.25),{
            BackgroundColor3 = isActive and colors.primary or colors.glassCard,
            BackgroundTransparency = isActive and 0.85 or 0.5
        }):Play()
        
        TweenService:Create(btnData.icon,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            TextColor3 = isActive and colors.primary or colors.textSecondary
        }):Play()
        
        TweenService:Create(btnData.text,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            TextColor3 = isActive and colors.text or colors.textSecondary
        }):Play()
        
        btnData.indicator.Visible = isActive
        
        if isActive then
            if not btnData.stroke then
                btnData.stroke = new("UIStroke",{
                    Parent=btnData.btn,
                    Color=colors.primary,
                    Thickness=1,
                    Transparency=1,
                    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
                })
            end
            TweenService:Create(btnData.stroke,TweenInfo.new(0.25),{Transparency=0.3}):Play()
        elseif btnData.stroke then
            TweenService:Create(btnData.stroke,TweenInfo.new(0.25),{Transparency=1}):Play()
        end
    end
    
    -- Fade in new page
    local newPageFrame = pages[pageName]
    newPageFrame.Position = UDim2.new(0,20,0,0)
    newPageFrame.Visible = true
    TweenService:Create(newPageFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
        Position=UDim2.new(0,0,0,0)
    }):Play()
    
    currentPage = pageName
end

-- Create Navigation Buttons
local btnMain = createNavButton("Main", "🏠", "Main")
local btnTeleport = createNavButton("Teleport", "⚡", "Teleport")
local btnShop = createNavButton("Shop", "🛒", "Shop")
local btnSettings = createNavButton("Settings", "⚙️", "Settings")
local btnInfo = createNavButton("Info", "ℹ️", "Info")

btnMain.MouseButton1Click:Connect(function() switchPage("Main") end)
btnTeleport.MouseButton1Click:Connect(function() switchPage("Teleport") end)
btnShop.MouseButton1Click:Connect(function() switchPage("Shop") end)
btnSettings.MouseButton1Click:Connect(function() switchPage("Settings") end)
btnInfo.MouseButton1Click:Connect(function() switchPage("Info") end)

-- Enhanced Category Creation - Compact
local function createCategory(parent, title)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,0),
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.18,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,14)})
    new("UIStroke",{
        Parent=categoryFrame,
        Color=colors.border,
        Thickness=0.5,
        Transparency=0.5,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,0,48),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    
    new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-60,1,0),
        Position=UDim2.new(0,16,0,0),
        Font=Enum.Font.GothamBold,
        TextSize=14,
        TextColor3=colors.text,
        BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="›",
        Size=UDim2.new(0,32,1,0),
        Position=UDim2.new(1,-40,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=20,
        TextColor3=colors.textTertiary,
        Rotation=0,
        ZIndex=8
    })
    
    local separator = new("Frame",{
        Parent=header,
        Size=UDim2.new(1,-32,0,0.5),
        Position=UDim2.new(0,16,1,-0.5),
        BackgroundColor3=colors.separator,
        BackgroundTransparency=0.5,
        BorderSizePixel=0,
        ZIndex=8
    })
    
    local container = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1,-28,0,0),
        Position=UDim2.new(0,14,0,48),
        BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y,
        Visible=false,
        ZIndex=7
    })
    new("UIListLayout",{Parent=container,Padding=UDim.new(0,10)})
    new("UIPadding",{Parent=container,PaddingBottom=UDim.new(0,14)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        container.Visible = isOpen
        separator.Visible = not isOpen
        
        TweenService:Create(arrow,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            Rotation = isOpen and 90 or 0,
            TextColor3 = isOpen and colors.primary or colors.textTertiary
        }):Play()
    end)
    
    return container
end

-- Enhanced Toggle Switch - Compact
local function makeToggle(parent,label,callback)
    local f=new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,40),
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
        TextSize=12,
        TextWrapped=true,
        ZIndex=7
    })
    
    local toggleBg=new("Frame",{
        Parent=f,
        Size=UDim2.new(0,46,0,26),
        Position=UDim2.new(1,-48,0.5,-13),
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.15,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=toggleBg,CornerRadius=UDim.new(1,0)})
    new("UIStroke",{
        Parent=toggleBg,
        Color=colors.border,
        Thickness=1,
        Transparency=0.5,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local toggleCircle=new("Frame",{
        Parent=toggleBg,
        Size=UDim2.new(0,22,0,22),
        Position=UDim2.new(0,2,0.5,-11),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=toggleCircle,CornerRadius=UDim.new(1,0)})
    new("UIStroke",{
        Parent=toggleCircle,
        Color=colors.shadow,
        Thickness=0.5,
        Transparency=0.9,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
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
        
        local stroke = toggleBg:FindFirstChildOfClass("UIStroke")
        
        TweenService:Create(toggleBg,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            BackgroundColor3=on and colors.primary or colors.glassCard,
            BackgroundTransparency=on and 0.05 or 0.15
        }):Play()
        
        if stroke then
            TweenService:Create(stroke,TweenInfo.new(0.25),{
                Color=on and colors.primary or colors.border,
                Transparency=on and 0.2 or 0.5
            }):Play()
        end
        
        TweenService:Create(toggleCircle,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{
            Position=on and UDim2.new(1,-24,0.5,-11) or UDim2.new(0,2,0.5,-11)
        }):Play()
        
        callback(on)
    end)
end

-- Enhanced Slider - Compact
local function makeSlider(parent,label,min,max,def,onChange)
    local f=new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,56),
        BackgroundTransparency=1,
        ZIndex=6
    })
    
    local headerFrame = new("Frame",{
        Parent=f,
        Size=UDim2.new(1,0,0,20),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local lbl=new("TextLabel",{
        Parent=headerFrame,
        Text=label,
        Size=UDim2.new(1,-60,1,0),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamSemibold,
        TextSize=11,
        ZIndex=8
    })
    
    local valueBg = new("Frame",{
        Parent=headerFrame,
        Size=UDim2.new(0,54,0,22),
        Position=UDim2.new(1,-56,0,-1),
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.25,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=valueBg,CornerRadius=UDim.new(0,6)})
    new("UIStroke",{
        Parent=valueBg,
        Color=colors.primary,
        Thickness=1,
        Transparency=0.4,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local valueLabel = new("TextLabel",{
        Parent=valueBg,
        Text=string.format("%.2f",def),
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        TextColor3=colors.primary,
        Font=Enum.Font.GothamBold,
        TextSize=10,
        ZIndex=9
    })
    
    local bar=new("Frame",{
        Parent=f,
        Size=UDim2.new(1,0,0,5),
        Position=UDim2.new(0,0,0,30),
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.25,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(1,0)})
    
    local fill=new("Frame",{
        Parent=bar,
        Size=UDim2.new((def-min)/(max-min),0,1,0),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.15,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(1,0)})
    
    local knob=new("Frame",{
        Parent=bar,
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new((def-min)/(max-min),-9,0.5,-9),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    new("UIStroke",{
        Parent=knob,
        Color=colors.primary,
        Thickness=1.5,
        Transparency=0.2,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local dragging=false
    local function update(x)
        local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        local val=min+(max-min)*rel
        fill.Size=UDim2.new(rel,0,1,0)
        knob.Position=UDim2.new(rel,-9,0.5,-9)
        valueLabel.Text=string.format("%.2f",val)
        onChange(val)
    end
    
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            update(i.Position.X)
            TweenService:Create(knob,TweenInfo.new(0.12,Enum.EasingStyle.Back),{Size=UDim2.new(0,22,0,22)}):Play()
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
            TweenService:Create(knob,TweenInfo.new(0.12,Enum.EasingStyle.Back),{Size=UDim2.new(0,18,0,18)}):Play()
        end
    end)
end

-- Enhanced Dropdown - Compact
local function makeDropdown(parent, title, items, onSelect)
    local selectedItem = nil
    local dropdownFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = colors.glassCard,
        BackgroundTransparency=0.25,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 6
    })
    new("UICorner", {Parent = dropdownFrame, CornerRadius = UDim.new(0, 12)})
    new("UIStroke",{
        Parent=dropdownFrame,
        Color=colors.border,
        Thickness=0.5,
        Transparency=0.5,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local header = new("TextButton", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 7
    })
    
    new("TextLabel", {
        Parent = header,
        Text = title,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    local selectedLabel = new("TextLabel", {
        Parent = header,
        Text = "None",
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -90, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextColor3 = colors.textSecondary,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 8
    })
    
    local arrow = new("TextLabel", {
        Parent = header,
        Text = "›",
        Size = UDim2.new(0, 28, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = colors.textTertiary,
        Rotation = 0,
        ZIndex = 8
    })
    
    local listContainer = new("ScrollingFrame", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.1,
        Visible = false,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = colors.primary,
        ScrollBarImageTransparency=0.4,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 10
    })
    new("UIListLayout", {Parent = listContainer, Padding = UDim.new(0, 0)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.25,Enum.EasingStyle.Quad), {
            Rotation = isOpen and 90 or 0,
            TextColor3 = isOpen and colors.primary or colors.textTertiary
        }):Play()
        
        if isOpen then
            local maxHeight = math.min(#items * 40, 200)
            TweenService:Create(listContainer, TweenInfo.new(0.25,Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, maxHeight)
            }):Play()
        else
            TweenService:Create(listContainer, TweenInfo.new(0.25,Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
        end
    end)
    
    for index, itemName in ipairs(items) do
        local isLastItem = index == #items
        local itemBtn = new("TextButton", {
            Parent = listContainer,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 11
        })
        
        new("TextLabel", {
            Parent = itemBtn,
            Text = itemName,
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = colors.text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 12
        })
        
        local checkIcon = new("TextLabel", {
            Parent = itemBtn,
            Text = "✓",
            Size = UDim2.new(0, 24, 1, 0),
            Position = UDim2.new(1, -32, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = colors.primary,
            Visible = false,
            ZIndex = 12
        })
        
        if not isLastItem then
            new("Frame", {
                Parent = itemBtn,
                Size = UDim2.new(1, -28, 0, 0.5),
                Position = UDim2.new(0, 14, 1, -0.5),
                BackgroundColor3 = colors.separator,
                BackgroundTransparency=0.5,
                BorderSizePixel = 0,
                ZIndex = 12
            })
        end
        
        itemBtn.MouseEnter:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.12), {
                BackgroundTransparency = 0.85,
                BackgroundColor3 = colors.primary
            }):Play()
        end)
        
        itemBtn.MouseLeave:Connect(function()
            TweenService:Create(itemBtn, TweenInfo.new(0.12), {
                BackgroundTransparency = 1
            }):Play()
        end)
        
        itemBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(listContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    for _, c in ipairs(child:GetChildren()) do
                        if c:IsA("TextLabel") and c.Text == "✓" then
                            c.Visible = false
                        end
                    end
                end
            end
            
            selectedItem = itemName
            checkIcon.Visible = true
            selectedLabel.Text = itemName
            
            TweenService:Create(selectedLabel, TweenInfo.new(0.2), {
                TextColor3 = colors.primary
            }):Play()
            
            onSelect(itemName)
            
            task.wait(0.1)
            isOpen = false
            listContainer.Visible = false
            
            TweenService:Create(listContainer, TweenInfo.new(0.25,Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(arrow, TweenInfo.new(0.25,Enum.EasingStyle.Quad), {
                Rotation = 0,
                TextColor3 = colors.textTertiary
            }):Play()
        end)
    end
    
    return dropdownFrame
end

-- Enhanced Button - Compact
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = colors.primary,
        BackgroundTransparency=0.05,
        BorderSizePixel = 0,
        ZIndex = 7
    })
    new("UICorner", {Parent = btnFrame, CornerRadius = UDim.new(0, 12)})
    new("UIStroke",{
        Parent=btnFrame,
        Color=colors.primary,
        Thickness=1,
        Transparency=0.2,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local button = new("TextButton", {
        Parent = btnFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = colors.text,
        AutoButtonColor = false,
        ZIndex = 8
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.18,Enum.EasingStyle.Quad), {
            BackgroundColor3 = colors.primaryLight,
            BackgroundTransparency=0.02
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.18,Enum.EasingStyle.Quad), {
            BackgroundColor3 = colors.primary,
            BackgroundTransparency=0.05
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.08,Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, 0, 0, 38)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.08,Enum.EasingStyle.Back), {
            Size = UDim2.new(1, 0, 0, 42)
        }):Play()
        pcall(callback)
    end)
    
    return btnFrame
end

-- CONTENT SECTIONS
local autoFishingCat = createCategory(mainPage, "Auto Fishing")
local instantContainer = new("Frame",{
    Parent=autoFishingCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=instantContainer,Padding=UDim.new(0,10)})

local selectedInstantMode = "Fast"
local instantActive = false

makeDropdown(instantContainer, "Instant Fishing Mode", {"Fast", "Perfect"}, function(mode)
    selectedInstantMode = mode
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

local blatantCat = createCategory(mainPage, "Blatant Mode")
local blatantContainer = new("Frame",{
    Parent=blatantCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=blatantContainer,Padding=UDim.new(0,10)})

makeToggle(blatantContainer, "Enable Extreme Blatant", function(on)
    if on then BlatantAutoFishing.Start() else BlatantAutoFishing.Stop() end
end)

makeToggle(blatantContainer, "Instant Catch", function(on)
    BlatantAutoFishing.Settings.InstantCatch = on
end)

makeToggle(blatantContainer, "Auto Complete", function(on)
    BlatantAutoFishing.Settings.AutoComplete = on
end)

makeSlider(blatantContainer, "Spam Rate", 0.001, 0.1, 0.001, function(v)
    BlatantAutoFishing.Settings.SpamRate = v
end)

local supportCat = createCategory(mainPage, "Support Fishing")
local supportContainer = new("Frame",{
    Parent=supportCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=supportContainer,Padding=UDim.new(0,10)})

makeToggle(supportContainer, "Manual Capture (2s)", function(on)
    if on then NoFishingAnimation.StartWithDelay() else NoFishingAnimation.Stop() end
end)

-- Teleport Page
local locationItems = {}
for name, _ in pairs(TeleportModule.Locations) do
    table.insert(locationItems, name)
end
table.sort(locationItems)

local teleportLocationCat = createCategory(teleportPage, "Location Teleport")
makeDropdown(teleportLocationCat, "Select Location", locationItems, function(loc)
    TeleportModule.TeleportTo(loc)
end)

local playerItems = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        table.insert(playerItems, player.Name)
    end
end
table.sort(playerItems)

local teleportPlayerCat = createCategory(teleportPage, "Player Teleport")
local playerDropdown = makeDropdown(teleportPlayerCat, "Select Player", playerItems, function(p)
    TeleportToPlayer.TeleportTo(p)
end)

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
    end)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Shop Page
local autoSellCat = createCategory(shopPage, "Auto Sell System")
local sellContainer = new("Frame",{
    Parent=autoSellCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=sellContainer,Padding=UDim.new(0,10)})

makeButton(sellContainer, "Sell All Items", function()
    if AutoSell and AutoSell.SellOnce then
        AutoSell.SellOnce()
    end
end)

local timerCat = createCategory(shopPage, "Auto Sell Timer")
local timerContainer = new("Frame",{
    Parent=timerCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=timerContainer,Padding=UDim.new(0,10)})

makeSlider(timerContainer, "Sell Interval", 1, 60, 5, function(v)
    AutoSellTimer.SetInterval(v)
end)

makeButton(timerContainer, "Start Auto Sell", function()
    if AutoSellTimer then
        AutoSellTimer.Start(AutoSellTimer.Interval)
    end
end)

makeButton(timerContainer, "Stop Auto Sell", function()
    if AutoSellTimer then
        AutoSellTimer.Stop()
    end
end)

local weatherCat = createCategory(shopPage, "Auto Buy Weather")
local weatherContainer = new("Frame",{
    Parent=weatherCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=weatherContainer,Padding=UDim.new(0,10)})

local selectedWeathers = {}
makeDropdown(weatherContainer, "Select Weathers", AutoBuyWeather.AllWeathers, function(w)
    local idx = table.find(selectedWeathers, w)
    if idx then
        table.remove(selectedWeathers, idx)
    else
        table.insert(selectedWeathers, w)
    end
    AutoBuyWeather.SetSelected(selectedWeathers)
end)

makeToggle(weatherContainer, "Enable Auto Weather", function(on)
    if on then AutoBuyWeather.Start() else AutoBuyWeather.Stop() end
end)

-- Settings Page
local generalCat = createCategory(settingsPage, "General")
local generalContainer = new("Frame",{
    Parent=generalCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=generalContainer,Padding=UDim.new(0,10)})

makeToggle(generalContainer, "Auto Save Settings", function(on) end)
makeToggle(generalContainer, "Show Notifications", function(on) end)
makeToggle(generalContainer, "Performance Mode", function(on) end)

local afkCat = createCategory(settingsPage, "Anti-AFK")
local afkContainer = new("Frame",{
    Parent=afkCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=afkContainer,Padding=UDim.new(0,10)})

makeToggle(afkContainer, "Enable Anti-AFK", function(on)
    if on then AntiAFK.Start() else AntiAFK.Stop() end
end)

local fpsCat = createCategory(settingsPage, "FPS Unlocker")
local fpsContainer = new("Frame",{
    Parent=fpsCat,
    Size=UDim2.new(1,0,0,0),
    BackgroundTransparency=1,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=6
})
new("UIListLayout",{Parent=fpsContainer,Padding=UDim.new(0,10)})

makeDropdown(fpsContainer, "FPS Limit", {"60 FPS", "90 FPS", "120 FPS", "240 FPS"}, function(s)
    local fps = tonumber(s:match("%d+"))
    if fps and UnlockFPS and UnlockFPS.SetCap then
        UnlockFPS.SetCap(fps)
    end
end)

-- Info Page
local infoCard = new("Frame",{
    Parent=infoPage,
    Size=UDim2.new(1,0,0,0),
    BackgroundColor3=colors.glassCard,
    BackgroundTransparency=0.18,
    BorderSizePixel=0,
    AutomaticSize=Enum.AutomaticSize.Y,
    ZIndex=7
})
new("UICorner",{Parent=infoCard,CornerRadius=UDim.new(0,14)})
new("UIStroke",{
    Parent=infoCard,
    Color=colors.border,
    Thickness=0.5,
    Transparency=0.5,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

local infoText = new("TextLabel",{
    Parent=infoCard,
    Size=UDim2.new(1,-32,0,0),
    Position=UDim2.new(0,16,0,16),
    BackgroundTransparency=1,
    Text=[[🦊 LYNX v3.1 Mobile Edition

✨ FEATURES
• Auto Fishing (Fast/Perfect)
• Blatant Mode + Instant Catch
• Location & Player Teleport
• Auto Sell System with Timer
• Auto Buy Weather Totem
• Anti-AFK Protection
• FPS Unlocker

⚡ OPTIMIZATIONS
• Compact mobile layout
• Smooth iOS animations
• Perfect corner radius
• Glassmorphism design

🎯 RECOMMENDED
• Fishing Delay: 1.30s
• Cancel Delay: 0.19s

💎 Lynx Team © 2024]],
    Font=Enum.Font.Gotham,
    TextSize=11,
    TextColor3=colors.text,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    AutomaticSize=Enum.AutomaticSize.Y,
    LineHeight=1.25,
    ZIndex=8
})

new("UIPadding",{
    Parent=infoCard,
    PaddingTop=UDim.new(0,16),
    PaddingBottom=UDim.new(0,16),
    PaddingLeft=UDim.new(0,16),
    PaddingRight=UDim.new(0,16)
})

-- Minimized Icon - Smaller for Mobile
local minimized = false
local icon
local savedIconPos = UDim2.new(0,16,0,80)

local function createMinimizedIcon()
    if icon then return end
    
    icon = new("Frame",{
        Parent=gui,
        Size=UDim2.new(0,52,0,52),
        Position=savedIconPos,
        BackgroundColor3=colors.glassCard,
        BackgroundTransparency=0.15,
        BorderSizePixel=0,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,14)})
    new("UIStroke",{
        Parent=icon,
        Color=colors.primary,
        Thickness=1.5,
        Transparency=0.25,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    })
    
    local glow = new("ImageLabel",{
        Parent=icon,
        Size=UDim2.new(1,16,1,16),
        Position=UDim2.new(0,-8,0,-8),
        BackgroundTransparency=1,
        Image="rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3=colors.primary,
        ImageTransparency=0.75,
        ZIndex=99
    })
    
    -- Pulsing animation for icon
    task.spawn(function()
        while icon and icon.Parent do
            TweenService:Create(glow,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{
                ImageTransparency=0.9
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
        TextSize=26,
        TextColor3=colors.primary,
        ZIndex=101
    })
    
    -- Add gradient to icon text
    local iconGradient = new("UIGradient",{
        Parent=iconLabel,
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.primaryLight)
        }),
        Rotation=45
    })
    
    local dragging,dragStart,startPos,dragMoved = false,nil,nil,false
    
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging,dragMoved,dragStart,startPos = true,false,input.Position,icon.Position
            TweenService:Create(icon,TweenInfo.new(0.12,Enum.EasingStyle.Back),{
                Size=UDim2.new(0,48,0,48)
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
                TweenService:Create(icon,TweenInfo.new(0.12,Enum.EasingStyle.Back),{
                    Size=UDim2.new(0,52,0,52)
                }):Play()
                
                dragging = false
                savedIconPos = icon.Position
                
                if not dragMoved then
                    -- Restore window with animation
                    win.Visible = true
                    blur.Visible = true
                    
                    TweenService:Create(blur,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
                        BackgroundTransparency=0.3
                    }):Play()
                    
                    win.Size = UDim2.new(0,420,0,340)
                    win.BackgroundTransparency = 1
                    
                    TweenService:Create(win,TweenInfo.new(0.35,Enum.EasingStyle.Back),{
                        BackgroundTransparency=0.08,
                        Size=UDim2.new(0,460,0,380)
                    }):Play()
                    
                    task.wait(0.35)
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
        TweenService:Create(win,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            BackgroundTransparency=1,
            Size=UDim2.new(0,420,0,340)
        }):Play()
        
        TweenService:Create(blur,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            BackgroundTransparency=1
        }):Play()
        
        task.wait(0.3)
        win.Visible = false
        blur.Visible = false
        win.BackgroundTransparency = 0.08
        win.Size = UDim2.new(0,460,0,380)
        
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
        BackgroundTransparency=1,
        Size=UDim2.new(0,420,0,340)
    }):Play()
    
    TweenService:Create(blur,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
        BackgroundTransparency=1
    }):Play()
    
    task.wait(0.3)
    gui:Destroy()
end)

-- Window Dragging
local dragging,dragStart,startPos = false,nil,nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging,dragStart,startPos = true,input.Position,win.Position
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
    win.Size = UDim2.new(0,420,0,340)
    blur.BackgroundTransparency = 1
    blur.Visible = true
    
    task.wait(0.1)
    
    TweenService:Create(blur,TweenInfo.new(0.45,Enum.EasingStyle.Quad),{
        BackgroundTransparency=0.3
    }):Play()
    
    TweenService:Create(win,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        BackgroundTransparency=0.08,
        Size=UDim2.new(0,460,0,380)
    }):Play()
    
    -- Animate sidebar buttons sequentially
    task.wait(0.3)
    for i, btnData in pairs(navButtons) do
        btnData.btn.Size = UDim2.new(0,0,0,44)
        btnData.btn.BackgroundTransparency = 1
        task.spawn(function()
            task.wait((i == "Main" and 0 or i == "Teleport" and 0.05 or i == "Shop" and 0.1 or i == "Settings" and 0.15 or 0.2))
            TweenService:Create(btnData.btn,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Size=UDim2.new(1,0,0,44),
                BackgroundTransparency=(currentPage == i) and 0.15 or 0.3
            }):Play()
        end)
    end
end)

-- Add subtle breathing animation to main window
task.spawn(function()
    while win and win.Parent do
        local stroke = win:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{
                Transparency=0.7
            }):Play()
        end
        task.wait(2)
    end
end)

print("✓ LYNX GUI v3.1 - Mobile Optimized Edition Loaded")
print("✓ Perfect iOS Design | Compact Layout | Smooth Animations")
print("✓ Window Size: 460x380 | Icon Size: 52x52")
print("✓ Optimized for Mobile Devices")
