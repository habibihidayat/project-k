-- LynxGUI_v2.2.lua - Ultra Premium Dark Orange Edition 🧡
-- LANDSCAPE OPTIMIZED FOR MOBILE (Horizontal Rectangle)

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

-- DARKER Premium Color Palette Based on Logo (Dark Orange Theme)
local colors = {
    primary = Color3.fromRGB(255, 120, 0),       -- Darker Orange from logo
    secondary = Color3.fromRGB(255, 145, 40),    -- Darker Light orange
    accent = Color3.fromRGB(220, 59, 0),         -- Darker Red-orange
    success = Color3.fromRGB(34, 197, 94),       -- Green
    warning = Color3.fromRGB(251, 191, 36),      -- Amber
    danger = Color3.fromRGB(239, 68, 68),        -- Red
    
    bg1 = Color3.fromRGB(8, 8, 8),               -- Much darker
    bg2 = Color3.fromRGB(18, 13, 8),             -- Darker orange tint
    bg3 = Color3.fromRGB(28, 18, 12),            -- Darker orange tint
    bg4 = Color3.fromRGB(38, 28, 18),            -- Darker orange
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(180, 190, 200),     -- Darker gray
    textDimmer = Color3.fromRGB(120, 130, 140),  -- Much dimmer gray
    
    border = Color3.fromRGB(80, 50, 20),         -- Darker border
    glow = Color3.fromRGB(200, 100, 30),         -- Darker glow
}

-- LANDSCAPE Window Sizing - Horizontal Rectangle for Mobile
local windowSize = isMobile and UDim2.new(0,520,0,300) or UDim2.new(0,750,0,500)
local minWindowSize = isMobile and Vector2.new(450, 260) or Vector2.new(680, 440)
local maxWindowSize = isMobile and Vector2.new(600, 360) or Vector2.new(1050, 680)

local gui = new("ScreenGui",{
    Name="LynxGUI_Modern",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Main Window Container with Enhanced DARK Glass effect
local win = new("Frame",{
    Parent=gui,
    Size=windowSize,
    Position=UDim2.new(0.5,-windowSize.X.Offset/2,0.5,-windowSize.Y.Offset/2),
    BackgroundColor3=colors.bg1,
    BackgroundTransparency=0.08,  -- Less transparent for darker look
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,18)})

-- Enhanced DARK Glassmorphism with orange tint
local glassBlur = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=colors.bg1,
    BackgroundTransparency=0.92,  -- More opaque
    BorderSizePixel=0,
    ZIndex=2
})
new("UICorner",{Parent=glassBlur,CornerRadius=UDim.new(0,18)})

-- Premium DARK glow border with gradient
local glowBorder = new("UIStroke",{
    Parent=win,
    Color=Color3.fromRGB(150, 80, 30),  -- Darker orange
    Thickness=2,  -- Thicker for premium look
    Transparency=0.6,  -- Less transparent
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

-- Animated gradient for border - DARKER
local borderGradient = new("UIGradient",{
    Parent=glowBorder,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 100, 40)),   -- Dark orange
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 80, 30)),  -- Medium dark orange
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 70, 20))     -- Very dark orange
    },
    Rotation=0
})

-- Animate border gradient
task.spawn(function()
    while wait(0.04) do
        if borderGradient then
            borderGradient.Rotation = (borderGradient.Rotation + 3) % 360
        end
    end
end)

-- Sidebar state for mobile toggle
local sidebarExpanded = false
local sidebarCollapsedWidth = 55
local sidebarExpandedWidth = 170

-- Sidebar with DARKER transparency - COLLAPSIBLE for mobile
local sidebar = new("Frame",{
    Parent=win,
    Size=isMobile and UDim2.new(0,sidebarCollapsedWidth,1,0) or UDim2.new(0,210,1,0),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.1,  -- Less transparent
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=sidebar,CornerRadius=UDim.new(0,18)})

-- Sidebar DARK gradient overlay
local sidebarGradient = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    ZIndex=4
})
new("UIGradient",{
    Parent=sidebarGradient,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 100, 40)),  -- Dark orange
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 80, 25))    -- Very dark orange
    },
    Rotation=180,
    Transparency=NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.88),  -- Less transparent
        NumberSequenceKeypoint.new(1, 1)
    }
})

-- Mobile Sidebar Toggle Button - IMPROVED POSITIONING
local sidebarToggle
if isMobile then
    sidebarToggle = new("TextButton",{
        Parent=win,
        Size=UDim2.new(0,32,0,48),
        Position=UDim2.new(0,sidebarCollapsedWidth-4,1,-60),  -- Better positioning
        BackgroundColor3=colors.bg3,
        BackgroundTransparency=0.2,  -- Less transparent
        BorderSizePixel=0,
        Text="▶",  -- Arrow icon
        Font=Enum.Font.GothamBlack,
        TextSize=16,
        TextColor3=Color3.fromRGB(180, 100, 40),  -- Dark orange
        ZIndex=101,
        ClipsDescendants=false
    })
    new("UICorner",{Parent=sidebarToggle,CornerRadius=UDim.new(0,10)})
    new("UIStroke",{
        Parent=sidebarToggle,
        Color=Color3.fromRGB(160, 80, 25),  -- Darker orange
        Thickness=1.5,
        Transparency=0.6
    })
end

-- Sidebar Header with Logo - IMPROVED COMPACT DESIGN
local sidebarHeader = new("Frame",{
    Parent=sidebar,
    Size=isMobile and UDim2.new(1,0,0,60) or UDim2.new(1,0,0,110),
    BackgroundTransparency=1,
    ClipsDescendants=true,
    ZIndex=5
})

-- Logo Container with enhanced DARK styling - PROPER SIZING
local logoContainer = new("ImageLabel",{
    Parent=sidebarHeader,
    Size=isMobile and UDim2.new(0,32,0,32) or UDim2.new(0,65,0,65),
    Position=isMobile and UDim2.new(0.5,-16,0,12) or UDim2.new(0.5,-32.5,0,22),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.2,  -- Less transparent
    BorderSizePixel=0,
    Image="rbxassetid://135183099972655",
    ScaleType=Enum.ScaleType.Fit,
    ImageTransparency=0,
    ZIndex=6
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,10)})

-- Logo DARK glow effect
new("UIStroke",{
    Parent=logoContainer,
    Color=Color3.fromRGB(160, 80, 25),  -- Darker orange
    Thickness=isMobile and 1.2 or 2.5,
    Transparency=0.5
})

-- Brand name with FIXED positioning - NO CUTOFF
local brandName = new("TextLabel",{
    Parent=sidebarHeader,
    Text="LYNX",
    Size=UDim2.new(1,-10,0,22),  -- Added padding to prevent cutoff
    Position=isMobile and UDim2.new(0,5,0,46) or UDim2.new(0,5,0,90),
    Font=Enum.Font.GothamBlack,
    TextSize=isMobile and 15 or 20,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    Visible=isMobile and sidebarExpanded or not isMobile,
    TextXAlignment=Enum.TextXAlignment.Center,  -- Center aligned
    ZIndex=6
})

-- Gradient text effect - DARKER
new("UIGradient",{
    Parent=brandName,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(0.5, colors.secondary),
        ColorSequenceKeypoint.new(1, colors.accent)
    }
})

local brandVersion = new("TextLabel",{
    Parent=sidebarHeader,
    Text="v2.2 Dark Orange",
    Size=UDim2.new(1,-10,0,16),
    Position=UDim2.new(0,5,0,110),
    Font=Enum.Font.GothamMedium,
    TextSize=11,
    BackgroundTransparency=1,
    TextColor3=colors.accent,
    TextXAlignment=Enum.TextXAlignment.Center,
    Visible=not isMobile,
    ZIndex=6
})

-- Navigation Container - IMPROVED spacing
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=isMobile and UDim2.new(1,-6,1,-65) or UDim2.new(1,-20,1,-125),
    Position=isMobile and UDim2.new(0,3,0,62) or UDim2.new(0,10,0,118),
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
    Padding=UDim.new(0,isMobile and 6 or 10),
    SortOrder=Enum.SortOrder.LayoutOrder
})

-- Content Area - IMPROVED sizing
local contentBg = new("Frame",{
    Parent=win,
    Size=isMobile and UDim2.new(1,-62,1,-15) or UDim2.new(1,-220,1,-18),
    Position=isMobile and UDim2.new(0,58,0,10) or UDim2.new(0,215,0,12),
    BackgroundColor3=colors.bg2,
    BackgroundTransparency=0.2,  -- Less transparent
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg,CornerRadius=UDim.new(0,16)})

-- Function to toggle sidebar on mobile - IMPROVED
local function toggleSidebar()
    if not isMobile then return end
    
    sidebarExpanded = not sidebarExpanded
    local targetWidth = sidebarExpanded and sidebarExpandedWidth or sidebarCollapsedWidth
    
    TweenService:Create(sidebar,TweenInfo.new(0.35,Enum.EasingStyle.Quint),{
        Size=UDim2.new(0,targetWidth,1,0)
    }):Play()
    
    TweenService:Create(contentBg,TweenInfo.new(0.35,Enum.EasingStyle.Quint),{
        Size=UDim2.new(1,-(targetWidth+10),1,-15),
        Position=UDim2.new(0,targetWidth+6,0,10)
    }):Play()
    
    -- Move toggle button with sidebar
    if sidebarToggle then
        TweenService:Create(sidebarToggle,TweenInfo.new(0.35,Enum.EasingStyle.Quint),{
            Position=UDim2.new(0,targetWidth-4,1,-60)
        }):Play()
        
        -- Change arrow direction with animation
        TweenService:Create(sidebarToggle,TweenInfo.new(0.2),{
            TextColor3=sidebarExpanded and colors.accent or Color3.fromRGB(180, 100, 40)
        }):Play()
        sidebarToggle.Text = sidebarExpanded and "◀" or "▶"
    end
    
    -- Toggle brand name visibility with fade
    if sidebarExpanded then
        brandName.Visible = true
        TweenService:Create(brandName,TweenInfo.new(0.3),{
            TextTransparency=0
        }):Play()
    else
        TweenService:Create(brandName,TweenInfo.new(0.2),{
            TextTransparency=1
        }):Play()
        task.wait(0.2)
        brandName.Visible = false
    end
    
    -- Update all nav button text visibility
    for _, btnData in pairs(navButtons) do
        if btnData.text then
            if sidebarExpanded then
                btnData.text.Visible = true
                TweenService:Create(btnData.text,TweenInfo.new(0.3),{
                    TextTransparency=0
                }):Play()
            else
                TweenService:Create(btnData.text,TweenInfo.new(0.2),{
                    TextTransparency=1
                }):Play()
                task.wait(0.2)
                btnData.text.Visible = false
            end
            
            btnData.icon.Size = sidebarExpanded and UDim2.new(0,34,1,0) or UDim2.new(1,0,1,0)
            btnData.icon.Position = sidebarExpanded and UDim2.new(0,10,0,0) or UDim2.new(0,0,0,0)
        end
    end
end

-- Connect toggle button with hover effects
if sidebarToggle then
    sidebarToggle.MouseButton1Click:Connect(toggleSidebar)
    
    -- Hover effects for toggle button
    sidebarToggle.MouseEnter:Connect(function()
        TweenService:Create(sidebarToggle,TweenInfo.new(0.2),{
            BackgroundColor3=colors.primary,
            BackgroundTransparency=0.1,
            TextColor3=colors.text,
            Size=UDim2.new(0,36,0,52)
        }):Play()
    end)
    
    sidebarToggle.MouseLeave:Connect(function()
        TweenService:Create(sidebarToggle,TweenInfo.new(0.2),{
            BackgroundColor3=colors.bg3,
            BackgroundTransparency=0.2,
            TextColor3=sidebarExpanded and colors.accent or Color3.fromRGB(180, 100, 40),
            Size=UDim2.new(0,32,0,48)
        }):Play()
    end)
end

-- Top bar with controls - DARKER and COMPACT
local topBar = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1,0,0,isMobile and 36 or 55),
    BackgroundColor3=colors.bg3,
    BackgroundTransparency=0.3,  -- Less transparent
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,16)})

-- Enhanced Drag Handle - DARKER
local dragHandle = new("Frame",{
    Parent=topBar,
    Size=isMobile and UDim2.new(0,28,0,3) or UDim2.new(0,50,0,5),
    Position=isMobile and UDim2.new(0.5,-14,0,6) or UDim2.new(0.5,-25,0,12),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.3,  -- Less transparent
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=dragHandle,CornerRadius=UDim.new(1,0)})
new("UIGradient",{
    Parent=dragHandle,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(0.7, colors.accent),
        ColorSequenceKeypoint.new(1, colors.secondary)
    }
})

local pageTitle = new("TextLabel",{
    Parent=topBar,
    Text="Main Dashboard",
    Size=UDim2.new(1,-70,1,0),
    Position=UDim2.new(0,isMobile and 10 or 20,0,0),
    Font=Enum.Font.GothamBlack,
    TextSize=isMobile and 12 or 18,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Control buttons - DARKER and COMPACT
local controlsFrame = new("Frame",{
    Parent=topBar,
    Size=isMobile and UDim2.new(0,52,0,26) or UDim2.new(0,80,0,36),
    Position=isMobile and UDim2.new(1,-56,0.5,-13) or UDim2.new(1,-84,0.5,-18),
    BackgroundTransparency=1,
    ZIndex=6
})
new("UIListLayout",{
    Parent=controlsFrame,
    FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,isMobile and 4 or 8)
})

local function createControlBtn(icon, color)
    local btnSize = isMobile and 26 or 36
    local btn = new("TextButton",{
        Parent=controlsFrame,
        Size=UDim2.new(0,btnSize,0,btnSize),
        BackgroundColor3=colors.bg4,
        BackgroundTransparency=0.2,  -- Less transparent
        BorderSizePixel=0,
        Text=icon,
        Font=Enum.Font.GothamBlack,
        TextSize=(icon == "×" and (isMobile and 16 or 24)) or (isMobile and 12 or 20),
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,isMobile and 8 or 12)})
    
    local stroke = new("UIStroke",{
        Parent=btn,
        Color=color,
        Thickness=0,
        Transparency=0.4
    })
    
    btn.MouseEnter:Connect(function()
        local hoverSize = isMobile and 28 or 40
        TweenService:Create(btn,TweenInfo.new(0.2),{
            BackgroundColor3=color,
            BackgroundTransparency=0.05,
            TextColor3=colors.text,
            Size=UDim2.new(0,hoverSize,0,hoverSize)
        }):Play()
        TweenService:Create(stroke,TweenInfo.new(0.2),{Thickness=2.5}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{
            BackgroundColor3=colors.bg4,
            BackgroundTransparency=0.2,
            TextColor3=colors.textDim,
            Size=UDim2.new(0,btnSize,0,btnSize)
        }):Play()
        TweenService:Create(stroke,TweenInfo.new(0.2),{Thickness=0}):Play()
    end)
    return btn
end

local btnMin = createControlBtn("─", colors.warning)
local btnClose = createControlBtn("×", colors.danger)

-- Resize Handle - DARKER and IMPROVED
local resizeHandle = new("TextButton",{
    Parent=win,
    Size=isMobile and UDim2.new(0,20,0,20) or UDim2.new(0,28,0,28),
    Position=isMobile and UDim2.new(1,-20,1,-20) or UDim2.new(1,-28,1,-28),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.3,  -- Less transparent
    BorderSizePixel=0,
    Text="⋰",
    Font=Enum.Font.GothamBlack,
    TextSize=isMobile and 11 or 16,
    TextColor3=colors.text,
    AutoButtonColor=false,
    ZIndex=100
})
new("UICorner",{Parent=resizeHandle,CornerRadius=UDim.new(0,isMobile and 6 or 10)})
new("UIStroke",{
    Parent=resizeHandle,
    Color=colors.primary,
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
        Position=UDim2.new(0,6,0,isMobile and 38 or 62),
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

-- Enhanced Nav Button - DARKER and IMPROVED
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
    
    local indicator = new("Frame",{
        Parent=btn,
        Size=isMobile and UDim2.new(0,3,0,20) or UDim2.new(0,5,0,28),
        Position=UDim2.new(0,0,0.5,isMobile and -10 or -14),
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
            ColorSequenceKeypoint.new(0.7, colors.accent),
            ColorSequenceKeypoint.new(1, colors.secondary)
        },
        Rotation=90
    })
    
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=isMobile and UDim2.new(1,0,1,0) or UDim2.new(0,34,1,0),
        Position=isMobile and UDim2.new(0,0,0,0) or UDim2.new(0,16,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBlack,
        TextSize=isMobile and 16 or 22,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        ZIndex=7
    })
    
    local textLabel = new("TextLabel",{
        Parent=btn,
        Text=text,
        Size=UDim2.new(1,-58,1,0),
        Position=UDim2.new(0,50,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,
        TextSize=12,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        Visible=isMobile and sidebarExpanded or not isMobile,
        ZIndex=7
    })
    
    navButtons[page] = {btn=btn, icon=iconLabel, text=textLabel, indicator=indicator}
    
    -- Hover effects for nav buttons
    btn.MouseEnter:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.2),{
                BackgroundColor3=colors.bg4,
                BackgroundTransparency=0.3
            }):Play()
            TweenService:Create(iconLabel,TweenInfo.new(0.2),{
                TextColor3=colors.secondary
            }):Play()
            if not isMobile or sidebarExpanded then
                TweenService:Create(textLabel,TweenInfo.new(0.2),{
                    TextColor3=colors.text
                }):Play()
            end
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentPage ~= page then
            TweenService:Create(btn,TweenInfo.new(0.2),{
                BackgroundColor3=Color3.fromRGB(0,0,0),
                BackgroundTransparency=1
            }):Play()
            TweenService:Create(iconLabel,TweenInfo.new(0.2),{
                TextColor3=colors.textDim
            }):Play()
            if not isMobile or sidebarExpanded then
                TweenService:Create(textLabel,TweenInfo.new(0.2),{
                    TextColor3=colors.textDim
                }):Play()
            end
        end
    end)
    
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
            TextColor3=isActive and colors.primary :Lerp(colors.text, 0.2) or colors.textDim
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
        task.wait(0.4)
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

-- [Rest of the code remains the same for categories, toggles, sliders, dropdowns, buttons, and page content]
-- Only the visual styling has been enhanced with darker colors and improved aesthetics

-- ... [The rest of your existing code for categories, toggles, sliders, etc.] ...

print("✨ Lynx GUI v2.2 DARK ORANGE Edition loaded!")
print("🎨 ULTRA DARK THEME - Premium Aesthetics")
print("📱 Mobile Optimized (520x300) - No Cutoff")
print("🧡 DARK ORANGE Theme - Enhanced Visuals")
print("🖱️ Drag from top | Resize from corner")
print("💎 Created by Lynx Team - Premium Quality")
