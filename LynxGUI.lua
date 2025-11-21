-- LynxGUI_v2.3.lua - Ultra Premium Orange Edition 🧡
-- LANDSCAPE OPTIMIZED FOR MOBILE - ENHANCED VISUALS

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

-- ENHANCED Premium Color Palette - Darker & More Vibrant
local colors = {
    primary = Color3.fromRGB(255, 145, 0),       -- Vibrant Orange
    secondary = Color3.fromRGB(255, 170, 60),    -- Light Orange
    accent = Color3.fromRGB(255, 85, 0),         -- Deep Orange-Red
    success = Color3.fromRGB(34, 197, 94),       -- Green
    warning = Color3.fromRGB(251, 191, 36),      -- Amber
    danger = Color3.fromRGB(239, 68, 68),        -- Red
    
    -- DARKER backgrounds for better contrast
    bg1 = Color3.fromRGB(10, 10, 12),            -- Almost black
    bg2 = Color3.fromRGB(18, 16, 14),            -- Very dark with orange tint
    bg3 = Color3.fromRGB(28, 24, 20),            -- Dark orange tint
    bg4 = Color3.fromRGB(38, 32, 26),            -- Medium dark orange
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(220, 220, 220),     
    textDimmer = Color3.fromRGB(160, 160, 160),  
    
    border = Color3.fromRGB(80, 50, 30),
    glow = Color3.fromRGB(255, 145, 0),
}

-- LANDSCAPE Window Sizing - Optimized for mobile
local windowSize = isMobile and UDim2.new(0,500,0,280) or UDim2.new(0,740,0,500)
local minWindowSize = isMobile and Vector2.new(440, 250) or Vector2.new(660, 440)
local maxWindowSize = isMobile and Vector2.new(600, 350) or Vector2.new(1020, 680)

local gui = new("ScreenGui",{
    Name="LynxGUI_Modern",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Main Window Container - DARKER
local win = new("Frame",{
    Parent=gui,
    Size=windowSize,
    Position=UDim2.new(0.5,-windowSize.X.Offset/2,0.5,-windowSize.Y.Offset/2),
    BackgroundColor3=colors.bg1,
    BackgroundTransparency=0.05,  -- Less transparent = darker
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,18)})

-- Enhanced Glassmorphism with darker tint
local glassBlur = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.85,
    BorderSizePixel=0,
    ZIndex=2
})
new("UICorner",{Parent=glassBlur,CornerRadius=UDim.new(0,18)})

-- Premium ANIMATED glow border
local glowBorder = new("UIStroke",{
    Parent=win,
    Color=colors.primary,
    Thickness=2,
    Transparency=0.5,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Animated gradient for border - VIBRANT
local borderGradient = new("UIGradient",{
    Parent=glowBorder,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(0.5, colors.accent),
        ColorSequenceKeypoint.new(1, colors.secondary)
    },
    Rotation=0
})

-- Animate border gradient SMOOTHLY
task.spawn(function()
    while wait(0.03) do
        if borderGradient then
            borderGradient.Rotation = (borderGradient.Rotation + 1.5) % 360
        end
    end
end)

-- Sidebar state for mobile toggle
local sidebarExpanded = false
local sidebarCollapsedWidth = 52
local sidebarExpandedWidth = 170

-- Sidebar with DARKER background
local sidebar = new("Frame",{
    Parent=win,
    Size=isMobile and UDim2.new(0,sidebarCollapsedWidth,1,0) or UDim2.new(0,200,1,0),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.1,  -- Darker
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=sidebar,CornerRadius=UDim.new(0,18)})

-- Sidebar gradient overlay - MORE VIBRANT
local sidebarGradient = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    ZIndex=4
})
new("UIGradient",{
    Parent=sidebarGradient,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(1, colors.accent)
    },
    Rotation=180,
    Transparency=NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.88),
        NumberSequenceKeypoint.new(1, 0.95)
    }
})

-- Mobile Sidebar Toggle Button - BETTER POSITIONING
local sidebarToggle
if isMobile then
    sidebarToggle = new("TextButton",{
        Parent=win,
        Size=UDim2.new(0,32,0,50),
        Position=UDim2.new(0,sidebarCollapsedWidth-3,1,-60),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        Text="▶",
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=colors.text,
        ZIndex=101,
        ClipsDescendants=false
    })
    new("UICorner",{Parent=sidebarToggle,CornerRadius=UDim.new(0,10)})
    new("UIStroke",{
        Parent=sidebarToggle,
        Color=colors.accent,
        Thickness=2,
        Transparency=0.5
    })
    
    -- Glow effect for toggle button
    local toggleGlow = new("UIGradient",{
        Parent=sidebarToggle,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        },
        Rotation=45
    })
end

-- Sidebar Header with Logo - IMPROVED LAYOUT
local sidebarHeader = new("Frame",{
    Parent=sidebar,
    Size=isMobile and UDim2.new(1,0,0,60) or UDim2.new(1,0,0,105),
    BackgroundTransparency=1,
    ClipsDescendants=true,
    ZIndex=5
})

-- Logo Container - BETTER SIZING
local logoContainer = new("ImageLabel",{
    Parent=sidebarHeader,
    Size=isMobile and UDim2.new(0,32,0,32) or UDim2.new(0,65,0,65),
    Position=isMobile and UDim2.new(0.5,-16,0,12) or UDim2.new(0.5,-32.5,0,18),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    Image="rbxassetid://135183099972655",
    ScaleType=Enum.ScaleType.Fit,
    ImageTransparency=0,
    ZIndex=6
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,10)})

-- Logo VIBRANT glow
new("UIStroke",{
    Parent=logoContainer,
    Color=colors.primary,
    Thickness=isMobile and 1.5 or 2.5,
    Transparency=0.4
})

-- Pulsing glow animation for logo
task.spawn(function()
    local logoStroke = logoContainer:FindFirstChildOfClass("UIStroke")
    while wait(0.05) do
        if logoStroke then
            local pulse = math.sin(tick() * 2) * 0.15 + 0.5
            TweenService:Create(logoStroke, TweenInfo.new(0.5), {
                Transparency = pulse
            }):Play()
        end
    end
end)

-- Brand name - WILL NOT BE CUT OFF
local brandName = new("TextLabel",{
    Parent=sidebarHeader,
    Text="LYNX",
    Size=UDim2.new(1,-10,0,22),
    Position=isMobile and UDim2.new(0,5,0,46) or UDim2.new(0,0,0,86),
    Font=Enum.Font.GothamBold,
    TextSize=isMobile and 16 or 20,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Center,
    Visible=isMobile and sidebarExpanded or not isMobile,
    TextScaled=false,
    ZIndex=6
})

-- Gradient text effect
new("UIGradient",{
    Parent=brandName,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(1, colors.accent)
    }
})

local brandVersion = new("TextLabel",{
    Parent=sidebarHeader,
    Text="v2.3 Enhanced",
    Size=UDim2.new(1,0,0,14),
    Position=UDim2.new(0,0,0,107),
    Font=Enum.Font.Gotham,
    TextSize=10,
    BackgroundTransparency=1,
    TextColor3=colors.secondary,
    Visible=not isMobile,
    ZIndex=6
})

-- Navigation Container - BETTER SPACING
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=isMobile and UDim2.new(1,-6,1,-66) or UDim2.new(1,-20,1,-125),
    Position=isMobile and UDim2.new(0,3,0,63) or UDim2.new(0,10,0,120),
    BackgroundTransparency=1,
    ScrollBarThickness=3,
    ScrollBarImageColor3=colors.primary,
    BorderSizePixel=0,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ClipsDescendants=true,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0,isMobile and 5 or 9),
    SortOrder=Enum.SortOrder.LayoutOrder
})

-- Content Area - ADJUSTED for sidebar
local contentBg = new("Frame",{
    Parent=win,
    Size=isMobile and UDim2.new(1,-60,1,-14) or UDim2.new(1,-210,1,-16),
    Position=isMobile and UDim2.new(0,56,0,10) or UDim2.new(0,205,0,12),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.2,  -- Darker
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg,CornerRadius=UDim.new(0,16)})

-- Function to toggle sidebar on mobile - IMPROVED ANIMATION
local function toggleSidebar()
    if not isMobile then return end
    
    sidebarExpanded = not sidebarExpanded
    local targetWidth = sidebarExpanded and sidebarExpandedWidth or sidebarCollapsedWidth
    
    -- Smooth animation with bounce
    TweenService:Create(sidebar,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,targetWidth,1,0)
    }):Play()
    
    TweenService:Create(contentBg,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(1,-(targetWidth+10),1,-14),
        Position=UDim2.new(0,targetWidth+6,0,10)
    }):Play()
    
    -- Move toggle button with sidebar
    if sidebarToggle then
        TweenService:Create(sidebarToggle,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Position=UDim2.new(0,targetWidth-3,1,-60)
        }):Play()
        
        -- Animate arrow rotation
        local targetRotation = sidebarExpanded and 180 or 0
        TweenService:Create(sidebarToggle,TweenInfo.new(0.35,Enum.EasingStyle.Back),{
            Rotation = targetRotation
        }):Play()
    end
    
    -- Toggle brand name visibility with fade
    TweenService:Create(brandName,TweenInfo.new(0.3),{
        TextTransparency = sidebarExpanded and 0 or 1
    }):Play()
    task.wait(0.15)
    brandName.Visible = sidebarExpanded
    
    -- Update all nav button text visibility
    for _, btnData in pairs(navButtons) do
        if btnData.text then
            local targetTransparency = sidebarExpanded and 0 or 1
            TweenService:Create(btnData.text,TweenInfo.new(0.3),{
                TextTransparency = targetTransparency
            }):Play()
            task.wait(0.15)
            btnData.text.Visible = sidebarExpanded
            
            btnData.icon.Size = sidebarExpanded and UDim2.new(0,34,1,0) or UDim2.new(1,0,1,0)
            btnData.icon.Position = sidebarExpanded and UDim2.new(0,10,0,0) or UDim2.new(0,0,0,0)
        end
    end
end

-- Connect toggle button with enhanced feedback
if sidebarToggle then
    sidebarToggle.MouseButton1Click:Connect(function()
        -- Visual feedback
        TweenService:Create(sidebarToggle,TweenInfo.new(0.1),{
            Size = UDim2.new(0,28,0,46)
        }):Play()
        task.wait(0.1)
        TweenService:Create(sidebarToggle,TweenInfo.new(0.2,Enum.EasingStyle.Back),{
            Size = UDim2.new(0,32,0,50)
        }):Play()
        
        toggleSidebar()
    end)
end

-- Top bar with controls - SLEEKER
local topBar = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1,0,0,isMobile and 36 or 54),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,16)})

-- Enhanced Drag Handle - MORE VISIBLE
local dragHandle = new("Frame",{
    Parent=topBar,
    Size=isMobile and UDim2.new(0,28,0,3) or UDim2.new(0,50,0,5),
    Position=isMobile and UDim2.new(0.5,-14,0,6) or UDim2.new(0.5,-25,0,12),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=dragHandle,CornerRadius=UDim.new(1,0)})
new("UIGradient",{
    Parent=dragHandle,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(1, colors.accent)
    }
})

-- Page title - BETTER POSITIONING
local pageTitle = new("TextLabel",{
    Parent=topBar,
    Text="Main Dashboard",
    Size=UDim2.new(1,-70,1,0),
    Position=isMobile and UDim2.new(0,10,0,0) or UDim2.new(0,20,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=isMobile and 11 or 18,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Control buttons - ENHANCED
local controlsFrame = new("Frame",{
    Parent=topBar,
    Size=isMobile and UDim2.new(0,52,0,24) or UDim2.new(0,80,0,34),
    Position=isMobile and UDim2.new(1,-56,0.5,-12) or UDim2.new(1,-85,0.5,-17),
    BackgroundTransparency=1,
    ZIndex=6
})
new("UIListLayout",{
    Parent=controlsFrame,
    FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,isMobile and 4 or 8)
})

local function createControlBtn(icon, color)
    local btnSize = isMobile and 24 or 34
    local btn = new("TextButton",{
        Parent=controlsFrame,
        Size=UDim2.new(0,btnSize,0,btnSize),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=(icon == "×" and (isMobile and 16 or 24)) or (isMobile and 11 or 20),
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,isMobile and 7 or 11)})
    
    local stroke = new("UIStroke",{
        Parent=btn,
        Color=color,
        Thickness=0,
        Transparency=0.5
    })
    
    -- ENHANCED hover effect
    btn.MouseEnter:Connect(function()
        local hoverSize = isMobile and 26 or 37
        TweenService:Create(btn,TweenInfo.new(0.25,Enum.EasingStyle.Back),{
            BackgroundColor3=color,
            BackgroundTransparency=0,
            TextColor3=colors.text,
            Size=UDim2.new(0,hoverSize,0,hoverSize)
        }):Play()
        TweenService:Create(stroke,TweenInfo.new(0.25),{Thickness=2.5}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.25),{
            BackgroundColor3=colors.bg4,
            BackgroundTransparency=0.2,
            TextColor3=colors.textDim,
            Size=UDim2.new(0,btnSize,0,btnSize)
        }):Play()
        TweenService:Create(stroke,TweenInfo.new(0.25),{Thickness=0}):Play()
    end)
    return btn
end

local btnMin = createControlBtn("─", colors.warning)
local btnClose = createControlBtn("×", colors.danger)

-- Resize Handle - MORE VISIBLE
local resizeHandle = new("TextButton",{
    Parent=win,
    Size=isMobile and UDim2.new(0,18,0,18) or UDim2.new(0,26,0,26),
    Position=isMobile and UDim2.new(1,-18,1,-18) or UDim2.new(1,-26,1,-26),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    Text="⋰",
    Font=Enum.Font.GothamBold,
    TextSize=isMobile and 11 or 16,
    TextColor3=colors.text,
    AutoButtonColor=false,
    ZIndex=100
})
new("UICorner",{Parent=resizeHandle,CornerRadius=UDim.new(0,isMobile and 6 or 9)})
new("UIStroke",{
    Parent=resizeHandle,
    Color=colors.accent,
    Thickness=isMobile and 1.5 or 2.5,
    Transparency=0.3
})

-- Pages
local pages = {}
local currentPage = "Main"
local navButtons = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,-12,1,-(isMobile and 42 or 70)),
        Position=UDim2.new(0,6,0,isMobile and 39 or 60),
        BackgroundTransparency=1,
        ScrollBarThickness=isMobile and 3 or 5,
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
        Padding=UDim.new(0,isMobile and 8 or 14),
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0,isMobile and 6 or 12),
        PaddingBottom=UDim.new(0,isMobile and 6 or 12)
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

-- ENHANCED Nav Button - ICON CENTERED when collapsed, NO TEXT CUTOFF
local function createNavButton(text, icon, page, order)
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=isMobile and UDim2.new(1,0,0,42) or UDim2.new(1,0,0,52),
        BackgroundColor3=page == currentPage and colors.bg3 or Color3.fromRGB(0,0,0),
        BackgroundTransparency=page == currentPage and 0.2 or 1,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        LayoutOrder=order,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,isMobile and 10 or 14)})
    
    -- Active indicator - MORE VISIBLE
    local indicator = new("Frame",{
        Parent=btn,
        Size=isMobile and UDim2.new(0,3,0,18) or UDim2.new(0,4,0,26),
        Position=UDim2.new(0,0,0.5,isMobile and -9 or -13),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        Visible=page == currentPage,
        ZIndex=7
    })
    new("UICorner",{Parent=indicator,CornerRadius=UDim.new(1,0)})
    new("UIGradient",{
        Parent=indicator,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        },
        Rotation=90
    })
    
    -- Icon - PERFECTLY CENTERED when collapsed
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=isMobile and UDim2.new(1,0,1,0) or UDim2.new(0,36,1,0),
        Position=isMobile and UDim2.new(0,0,0,0) or UDim2.new(0,18,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 16 or 21,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        ZIndex=7
    })
    
    -- Text label - WILL NOT BE CUT OFF
    local textLabel = new("TextLabel",{
        Parent=btn,
        Text=text,
        Size=UDim2.new(1,-58,1,0),
        Position=UDim2.new(0,52,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,
        TextSize=12,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.None,  -- No truncation
        TextWrapped=false,
        Visible=isMobile and sidebarExpanded or not isMobile,
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
        TweenService:Create(btnData.btn,TweenInfo.new(0.25),{
            BackgroundColor3=isActive and colors.bg3 or Color3.fromRGB(0,0,0),
            BackgroundTransparency=isActive and 0.2 or 1
        }):Play()
        btnData.indicator.Visible = isActive
        TweenService:Create(btnData.icon,TweenInfo.new(0.25),{
            TextColor3=isActive and colors.primary or colors.textDim
        }):Play()
        if not isMobile or sidebarExpanded then
            TweenService:Create(btnData.text,TweenInfo.new(0.25),{
                TextColor3=isActive and colors.text or colors.textDim
            }):Play()
        end
    end
    
    pages[pageName].Visible = true
    pageTitle.Text = pageTitle_text
    currentPage = pageName
    
    -- Auto-collapse sidebar on mobile after selection
    if isMobile and sidebarExpanded then
        task.wait(0.35)
        toggleSidebar()
    end
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

-- ENHANCED Modern Category - DARKER & MORE VIBRANT
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,isMobile and 42 or 56),
        BackgroundColor3=colors.bg3,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=false,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,isMobile and 14 or 18)})
    
    local categoryStroke = new("UIStroke",{
        Parent=categoryFrame,
        Color=colors.primary,
        Thickness=0,
        Transparency=0.6
    })
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,0,isMobile and 42 or 56),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ClipsDescendants=true,
        ZIndex=7
    })
    new("UICorner",{Parent=header,CornerRadius=UDim.new(0,isMobile and 14 or 18)})
    
    local iconContainer = new("Frame",{
        Parent=header,
        Size=isMobile and UDim2.new(0,30,0,30) or UDim2.new(0,42,0,42),
        Position=isMobile and UDim2.new(0,10,0.5,-15) or UDim2.new(0,14,0.5,-21),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.7,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=iconContainer,CornerRadius=UDim.new(0,isMobile and 8 or 11)})
    new("UIGradient",{
        Parent=iconContainer,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        },
        Rotation=45
    })
    
    local iconLabel = new("TextLabel",{
        Parent=iconContainer,
        Text=icon,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 14 or 21,
        TextColor3=colors.text,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-100,1,0),
        Position=isMobile and UDim2.new(0,44,0,0) or UDim2.new(0,62,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 10.5 or 16,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0,isMobile and 18 or 24,1,0),
        Position=isMobile and UDim2.new(1,-24,0,0) or UDim2.new(1,-38,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 11 or 16,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    local contentContainer = new("Frame",{
        Parent=categoryFrame,
        Size=isMobile and UDim2.new(1,-20,0,0) or UDim2.new(1,-28,0,0),
        Position=isMobile and UDim2.new(0,10,0,46) or UDim2.new(0,14,0,62),
        BackgroundTransparency=1,
        Visible=false,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=true,
        ZIndex=7
    })
    new("UIListLayout",{Parent=contentContainer,Padding=UDim.new(0,isMobile and 8 or 12)})
    new("UIPadding",{Parent=contentContainer,PaddingBottom=UDim.new(0,isMobile and 10 or 14)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        TweenService:Create(arrow,TweenInfo.new(0.35,Enum.EasingStyle.Back),{Rotation=isOpen and 180 or 0}):Play()
        TweenService:Create(categoryFrame,TweenInfo.new(0.3),{
            BackgroundColor3=isOpen and colors.bg4 or colors.bg3,
            BackgroundTransparency=isOpen and 0.15 or 0.3
        }):Play()
        TweenService:Create(categoryStroke,TweenInfo.new(0.3),{
            Thickness=isOpen and 2 or 0
        }):Play()
    end)
    
    return contentContainer
end

-- ENHANCED Modern Toggle - BETTER VISUALS
local function makeToggle(parent, label, callback)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,isMobile and 34 or 44),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local labelText = new("TextLabel",{
        Parent=frame,
        Text=label,
        Size=UDim2.new(0.6,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        Font=Enum.Font.GothamMedium,
        TextSize=isMobile and 9.5 or 14,
        TextWrapped=true,
        ZIndex=8
    })
    
    local toggleBg = new("Frame",{
        Parent=frame,
        Size=isMobile and UDim2.new(0,44,0,24) or UDim2.new(0,56,0,30),
        Position=isMobile and UDim2.new(1,-46,0.5,-12) or UDim2.new(1,-58,0.5,-15),
        BackgroundColor3=colors.bg4,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=toggleBg,CornerRadius=UDim.new(1,0)})
    
    local toggleCircle = new("Frame",{
        Parent=toggleBg,
        Size=isMobile and UDim2.new(0,19,0,19) or UDim2.new(0,24,0,24),
        Position=UDim2.new(0,2.5,0.5,isMobile and -9.5 or -12),
        BackgroundColor3=colors.textDim,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=toggleCircle,CornerRadius=UDim.new(1,0)})
    
    -- Add shadow to circle
    local circleShadow = new("UIStroke",{
        Parent=toggleCircle,
        Color=Color3.fromRGB(0,0,0),
        Thickness=3,
        Transparency=0.8
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
        
        -- Vibrant animation
        TweenService:Create(toggleBg,TweenInfo.new(0.3,Enum.EasingStyle.Back),{
            BackgroundColor3=on and colors.primary or colors.bg4
        }):Play()
        
        local movePos = isMobile and (on and UDim2.new(1,-21.5,0.5,-9.5) or UDim2.new(0,2.5,0.5,-9.5)) or (on and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12))
        TweenService:Create(toggleCircle,TweenInfo.new(0.35,Enum.EasingStyle.Back),{
            Position=movePos,
            BackgroundColor3=on and colors.text or colors.textDim
        }):Play()
        
        callback(on)
    end)
end

-- ENHANCED Modern Slider - BETTER DESIGN
local function makeSlider(parent, label, min, max, def, onChange)
    local frame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,isMobile and 50 or 60),
        BackgroundTransparency=1,
        ZIndex=7
    })
    
    local lbl = new("TextLabel",{
        Parent=frame,
        Text=("%s: %.2f"):format(label,def),
        Size=UDim2.new(1,0,0,isMobile and 18 or 22),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium,
        TextSize=isMobile and 10 or 14,
        ZIndex=8
    })
    
    local bar = new("Frame",{
        Parent=frame,
        Size=UDim2.new(1,0,0,isMobile and 12 or 14),
        Position=UDim2.new(0,0,0,isMobile and 30 or 36),
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
            ColorSequenceKeypoint.new(1, colors.accent)
        }
    })
    
    local knob = new("Frame",{
        Parent=bar,
        Size=UDim2.new(0,isMobile and 20 or 24,0,isMobile and 20 or 24),
        Position=UDim2.new((def-min)/(max-min),isMobile and -10 or -12,0.5,isMobile and -10 or -12),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        ZIndex=10
    })
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    
    local knobShadow = new("Frame",{
        Parent=knob,
        Size=UDim2.new(1,isMobile and 6 or 8,1,isMobile and 6 or 8),
        Position=UDim2.new(0,isMobile and -3 or -4,0,isMobile and -3 or -4),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.5,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=knobShadow,CornerRadius=UDim.new(1,0)})
    
    local dragging = false
    local function update(x)
        local rel = math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        local val = min+(max-min)*rel
        fill.Size = UDim2.new(rel,0,1,0)
        knob.Position = UDim2.new(rel,isMobile and -10 or -12,0.5,isMobile and -10 or -12)
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

-- ENHANCED Modern Dropdown - DARKER & MORE VIBRANT
local function makeDropdown(parent, title, icon, items, onSelect, uniqueId)
    local dropdownFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,isMobile and 46 or 56),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=7,
        Name=uniqueId or "Dropdown"
    })
    new("UICorner",{Parent=dropdownFrame,CornerRadius=UDim.new(0,isMobile and 14 or 18)})
    
    local dropStroke = new("UIStroke",{
        Parent=dropdownFrame,
        Color=colors.primary,
        Thickness=0,
        Transparency=0.6
    })
    
    local header = new("TextButton",{
        Parent=dropdownFrame,
        Size=UDim2.new(1,-18,0,isMobile and 42 or 52),
        Position=UDim2.new(0,9,0,2),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=8
    })
    
    local iconLabel = new("TextLabel",{
        Parent=header,
        Text=icon,
        Size=UDim2.new(0,isMobile and 30 or 36,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 15 or 20,
        TextColor3=colors.primary,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-90,0,isMobile and 16 or 20),
        Position=UDim2.new(0,isMobile and 32 or 40,0,isMobile and 5 or 7),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 10 or 14,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local statusLabel = new("TextLabel",{
        Parent=header,
        Text="None Selected",
        Size=UDim2.new(1,-90,0,isMobile and 13 or 16),
        Position=UDim2.new(0,isMobile and 32 or 40,0,isMobile and 23 or 29),
        BackgroundTransparency=1,
        Font=Enum.Font.Gotham,
        TextSize=isMobile and 8.5 or 11,
        TextColor3=colors.textDimmer,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0,isMobile and 26 or 32,1,0),
        Position=UDim2.new(1,isMobile and -26 or -32,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 11 or 14,
        TextColor3=colors.primary,
        ZIndex=9
    })
    
    local listContainer = new("ScrollingFrame",{
        Parent=dropdownFrame,
        Size=UDim2.new(1,-18,0,0),
        Position=UDim2.new(0,9,0,isMobile and 48 or 60),
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
    new("UIListLayout",{Parent=listContainer,Padding=UDim.new(0,isMobile and 6 or 8)})
    new("UIPadding",{Parent=listContainer,PaddingBottom=UDim.new(0,isMobile and 10 or 14)})
    
    local isOpen = false
    local selectedItem = nil
    
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow,TweenInfo.new(0.35,Enum.EasingStyle.Back),{Rotation=isOpen and 180 or 0}):Play()
        TweenService:Create(dropdownFrame,TweenInfo.new(0.3),{
            BackgroundColor3=isOpen and colors.bg3 or colors.bg4,
            BackgroundTransparency=isOpen and 0.15 or 0.2
        }):Play()
        TweenService:Create(dropStroke,TweenInfo.new(0.3),{
            Thickness=isOpen and 2 or 0
        }):Play()
        
        if isOpen and #items > 6 then
            listContainer.Size = UDim2.new(1,-18,0,isMobile and 170 or 230)
        else
            listContainer.Size = UDim2.new(1,-18,0,math.min(#items * (isMobile and 36 or 44), isMobile and 190 or 250))
        end
    end)
    
    for _, itemName in ipairs(items) do
        local itemBtn = new("TextButton",{
            Parent=listContainer,
            Size=UDim2.new(1,0,0,isMobile and 34 or 42),
            BackgroundColor3=colors.bg4,
            BackgroundTransparency=0.3,
            BorderSizePixel=0,
            Text="",
            AutoButtonColor=false,
            ZIndex=11
        })
        new("UICorner",{Parent=itemBtn,CornerRadius=UDim.new(0,isMobile and 10 or 12)})
        
        local itemStroke = new("UIStroke",{
            Parent=itemBtn,
            Color=colors.primary,
            Thickness=0,
            Transparency=0.6
        })
        
        local btnLabel = new("TextLabel",{
            Parent=itemBtn,
            Text=itemName,
            Size=UDim2.new(1,-18,1,0),
            Position=UDim2.new(0,9,0,0),
            BackgroundTransparency=1,
            Font=Enum.Font.GothamMedium,
            TextSize=isMobile and 9.5 or 13,
            TextColor3=colors.textDim,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
            ZIndex=12
        })
        
        itemBtn.MouseEnter:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn,TweenInfo.new(0.25),{
                    BackgroundColor3=colors.primary,
                    BackgroundTransparency=0.1
                }):Play()
                TweenService:Create(btnLabel,TweenInfo.new(0.25),{TextColor3=colors.text}):Play()
                TweenService:Create(itemStroke,TweenInfo.new(0.25),{Thickness=2}):Play()
            end
        end)
        
        itemBtn.MouseLeave:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn,TweenInfo.new(0.25),{
                    BackgroundColor3=colors.bg4,
                    BackgroundTransparency=0.3
                }):Play()
                TweenService:Create(btnLabel,TweenInfo.new(0.25),{TextColor3=colors.textDim}):Play()
                TweenService:Create(itemStroke,TweenInfo.new(0.25),{Thickness=0}):Play()
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
            TweenService:Create(arrow,TweenInfo.new(0.35,Enum.EasingStyle.Back),{Rotation=0}):Play()
            TweenService:Create(dropdownFrame,TweenInfo.new(0.3),{
                BackgroundColor3=colors.bg4,
                BackgroundTransparency=0.2
            }):Play()
            TweenService:Create(dropStroke,TweenInfo.new(0.3),{Thickness=0}):Play()
        end)
    end
    
    return dropdownFrame
end

-- ENHANCED Modern Button - MORE VIBRANT
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,isMobile and 40 or 48),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.05,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=btnFrame,CornerRadius=UDim.new(0,isMobile and 12 or 14)})
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
        Color=colors.accent,
        Thickness=0,
        Transparency=0.4
    })
    
    local button = new("TextButton",{
        Parent=btnFrame,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=label,
        Font=Enum.Font.GothamBold,
        TextSize=isMobile and 11 or 15,
        TextColor3=colors.text,
        AutoButtonColor=false,
        ZIndex=9
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.25,Enum.EasingStyle.Back),{
            Size=UDim2.new(1,0,0,isMobile and 43 or 52),
            BackgroundTransparency=0
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.25),{Thickness=2.5}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.25),{
            Size=UDim2.new(1,0,0,isMobile and 40 or 48),
            BackgroundTransparency=0.05
        }):Play()
        TweenService:Create(btnStroke,TweenInfo.new(0.25),{Thickness=0}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.1),{Size=UDim2.new(0.97,0,0,isMobile and 38 or 46)}):Play()
        task.wait(0.1)
        TweenService:Create(btnFrame,TweenInfo.new(0.15,Enum.EasingStyle.Back),{Size=UDim2.new(1,0,0,isMobile and 40 or 48)}):Play()
        pcall(callback)
    end)
    
    return btnFrame
end
