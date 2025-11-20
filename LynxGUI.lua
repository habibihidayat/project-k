-- LynxGUI_v1.0.lua - Modern Premium Edition ✨
-- Ultra Modern Dark Theme with Glass Morphism

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

-- Modern Premium Color Palette
local colors = {
    primary = Color3.fromRGB(88, 101, 242),      -- Discord Blurple
    secondary = Color3.fromRGB(114, 137, 218),   -- Light Blurple
    accent = Color3.fromRGB(255, 115, 250),      -- Pink Accent
    success = Color3.fromRGB(67, 181, 129),      -- Green
    warning = Color3.fromRGB(250, 166, 26),      -- Orange
    danger = Color3.fromRGB(237, 66, 69),        -- Red
    
    bg1 = Color3.fromRGB(16, 18, 24),            -- Darkest BG
    bg2 = Color3.fromRGB(22, 25, 33),            -- Dark BG
    bg3 = Color3.fromRGB(28, 32, 42),            -- Medium BG
    bg4 = Color3.fromRGB(35, 39, 52),            -- Light BG
    
    text = Color3.fromRGB(255, 255, 255),        -- White
    textDim = Color3.fromRGB(163, 170, 188),     -- Gray
    textDimmer = Color3.fromRGB(114, 118, 125),  -- Darker Gray
    
    border = Color3.fromRGB(47, 49, 54),         -- Border
    glow = Color3.fromRGB(88, 101, 242),         -- Glow effect
}

local gui = new("ScreenGui",{
    Name="LynxGUI_Modern",
    Parent=localPlayer.PlayerGui,
    IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999
})

-- Background overlay
local overlay = new("Frame",{
    Parent=gui,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(0,0,0),
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    Visible=false,
    ZIndex=1
})

-- Main Window Container
local win = new("Frame",{
    Parent=gui,
    Size=UDim2.new(0,700,0,480),
    Position=UDim2.new(0.5,-350,0.5,-240),
    BackgroundColor3=colors.bg1,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,20)})

-- Subtle outer glow
local outerGlow = new("ImageLabel",{
    Parent=win,
    Size=UDim2.new(1,40,1,40),
    Position=UDim2.new(0,-20,0,-20),
    BackgroundTransparency=1,
    Image="rbxasset://textures/ui/GuiImagePlaceholder.png",
    ImageColor3=colors.glow,
    ImageTransparency=0.85,
    ZIndex=2
})

-- Sidebar
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,200,1,0),
    BackgroundColor3=colors.bg2,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=sidebar,CornerRadius=UDim.new(0,20)})

-- Sidebar Header with Logo
local sidebarHeader = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1,0,0,80),
    BackgroundTransparency=1,
    ZIndex=5
})

-- Logo Container with gradient
local logoContainer = new("Frame",{
    Parent=sidebarHeader,
    Size=UDim2.new(0,50,0,50),
    Position=UDim2.new(0.5,-25,0,15),
    BackgroundColor3=colors.primary,
    BorderSizePixel=0,
    ZIndex=6
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,14)})
new("UIGradient",{
    Parent=logoContainer,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(1, colors.secondary)
    },
    Rotation=45
})

-- Animated glow effect
local logoGlow = new("Frame",{
    Parent=logoContainer,
    Size=UDim2.new(1,8,1,8),
    Position=UDim2.new(0,-4,0,-4),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.7,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=logoGlow,CornerRadius=UDim.new(0,16)})

task.spawn(function()
    while logoGlow.Parent do
        TweenService:Create(logoGlow,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{
            BackgroundTransparency=0.9,
            Size=UDim2.new(1,12,1,12),
            Position=UDim2.new(0,-6,0,-6)
        }):Play()
        task.wait(1.5)
    end
end)

local logoText = new("TextLabel",{
    Parent=logoContainer,
    Text="L",
    Size=UDim2.new(1,0,1,0),
    Font=Enum.Font.GothamBold,
    TextSize=32,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    ZIndex=7
})

local brandName = new("TextLabel",{
    Parent=sidebarHeader,
    Text="LYNX",
    Size=UDim2.new(1,0,0,20),
    Position=UDim2.new(0,0,0,70),
    Font=Enum.Font.GothamBold,
    TextSize=18,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    ZIndex=6
})

local brandVersion = new("TextLabel",{
    Parent=sidebarHeader,
    Text="v1.0 Premium",
    Size=UDim2.new(1,0,0,14),
    Position=UDim2.new(0,0,0,92),
    Font=Enum.Font.Gotham,
    TextSize=10,
    BackgroundTransparency=1,
    TextColor3=colors.textDimmer,
    ZIndex=6
})

-- Navigation Container
local navContainer = new("ScrollingFrame",{
    Parent=sidebar,
    Size=UDim2.new(1,-20,1,-120),
    Position=UDim2.new(0,10,0,110),
    BackgroundTransparency=1,
    ScrollBarThickness=3,
    ScrollBarImageColor3=colors.primary,
    BorderSizePixel=0,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0,8),
    SortOrder=Enum.SortOrder.LayoutOrder
})

-- Content Area
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-220,1,-20),
    Position=UDim2.new(0,210,0,10),
    BackgroundColor3=colors.bg2,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg,CornerRadius=UDim.new(0,16)})

-- Top bar with controls
local topBar = new("Frame",{
    Parent=contentBg,
    Size=UDim2.new(1,0,0,50),
    BackgroundColor3=colors.bg3,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,16)})

local pageTitle = new("TextLabel",{
    Parent=topBar,
    Text="Main Dashboard",
    Size=UDim2.new(1,-100,1,0),
    Position=UDim2.new(0,20,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=18,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6
})

-- Control buttons
local controlsFrame = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,80,0,30),
    Position=UDim2.new(1,-90,0.5,-15),
    BackgroundTransparency=1,
    ZIndex=6
})
new("UIListLayout",{
    Parent=controlsFrame,
    FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,8)
})

local function createControlBtn(icon, color)
    local btn = new("TextButton",{
        Parent=controlsFrame,
        Size=UDim2.new(0,30,0,30),
        BackgroundColor3=colors.bg4,
        BorderSizePixel=0,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=icon == "×" and 22 or 18,
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,8)})
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{
            BackgroundColor3=color,
            TextColor3=colors.text,
            Size=UDim2.new(0,32,0,32)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{
            BackgroundColor3=colors.bg4,
            TextColor3=colors.textDim,
            Size=UDim2.new(0,30,0,30)
        }):Play()
    end)
    return btn
end

local btnMin = createControlBtn("─", colors.warning)
local btnClose = createControlBtn("×", colors.danger)

-- Pages
local pages = {}
local currentPage = "Main"
local navButtons = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,-20,1,-70),
        Position=UDim2.new(0,10,0,60),
        BackgroundTransparency=1,
        ScrollBarThickness=4,
        ScrollBarImageColor3=colors.primary,
        BorderSizePixel=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false,
        ZIndex=5
    })
    new("UIListLayout",{
        Parent=page,
        Padding=UDim.new(0,12),
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=page,
        PaddingTop=UDim.new(0,10),
        PaddingBottom=UDim.new(0,10)
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

-- Nav Button Function
local function createNavButton(text, icon, page, order)
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1,0,0,44),
        BackgroundColor3=page == currentPage and colors.bg3 or Color3.fromRGB(0,0,0),
        BackgroundTransparency=page == currentPage and 0 or 1,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        LayoutOrder=order,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,12)})
    
    local indicator = new("Frame",{
        Parent=btn,
        Size=UDim2.new(0,3,0,24),
        Position=UDim2.new(0,0,0.5,-12),
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        Visible=page == currentPage,
        ZIndex=7
    })
    new("UICorner",{Parent=indicator,CornerRadius=UDim.new(1,0)})
    
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Text=icon,
        Size=UDim2.new(0,30,1,0),
        Position=UDim2.new(0,15,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        ZIndex=7
    })
    
    local textLabel = new("TextLabel",{
        Parent=btn,
        Text=text,
        Size=UDim2.new(1,-55,1,0),
        Position=UDim2.new(0,48,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,
        TextSize=13,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
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
        TweenService:Create(btnData.btn,TweenInfo.new(0.2),{
            BackgroundColor3=isActive and colors.bg3 or Color3.fromRGB(0,0,0),
            BackgroundTransparency=isActive and 0 or 1
        }):Play()
        btnData.indicator.Visible = isActive
        btnData.icon.TextColor3 = isActive and colors.primary or colors.textDim
        btnData.text.TextColor3 = isActive and colors.text or colors.textDim
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
btnSettings.MouseButton1Click:Connect(function() switchPage("Settings", "Settings & Config") end)
btnInfo.MouseButton1Click:Connect(function() switchPage("Info", "About Lynx") end)

-- Modern Category
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,50),
        BackgroundColor3=colors.bg3,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,16)})
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,0,50),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    
    local iconContainer = new("Frame",{
        Parent=header,
        Size=UDim2.new(0,36,0,36),
        Position=UDim2.new(0,12,0.5,-18),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.9,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=iconContainer,CornerRadius=UDim.new(0,10)})
    
    local iconLabel = new("TextLabel",{
        Parent=iconContainer,
        Text=icon,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=18,
        TextColor3=colors.primary,
        ZIndex=9
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-130,1,0),
        Position=UDim2.new(0,56,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=15,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text="▼",
        Size=UDim2.new(0,20,1,0),
        Position=UDim2.new(1,-35,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=14,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    local contentContainer = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1,-24,0,0),
        Position=UDim2.new(0,12,0,58),
        BackgroundTransparency=1,
        Visible=false,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=7
    })
    new("UIListLayout",{Parent=contentContainer,Padding=UDim.new(0,10)})
    new("UIPadding",{Parent=contentContainer,PaddingBottom=UDim.new(0,12)})
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        TweenService:Create(arrow,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Rotation=isOpen and 180 or 0}):Play()
        TweenService:Create(categoryFrame,TweenInfo.new(0.3),{BackgroundColor3=isOpen and colors.bg4 or colors.bg3}):Play()
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
        TweenService:Create(dropdownFrame,TweenInfo.new(0.2),{BackgroundColor3=isOpen and colors.bg3 or colors.bg4}):Play()
        
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
            TweenService:Create(dropdownFrame,TweenInfo.new(0.2),{BackgroundColor3=colors.bg4}):Play()
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
        TweenService:Create(btnFrame,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,44)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,40)}):Play()
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
✨ LYNX v1.0 PREMIUM

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

💡 NEW FEATURES v1.0
✓ Glass morphism design
✓ Gradient accents
✓ Smooth animations
✓ Modern sidebar navigation
✓ Collapsible categories
✓ Status display dropdowns
✓ Enhanced color palette

🎮 CONTROLS
• Click categories to expand
• Drag window to move
• (─) Minimize window
• (×) Close GUI

━━━━━━━━━━━━━━━━━━━━━━

Created with 💎 by Lynx Team
Premium Edition 2024
    ]],
    Font=Enum.Font.Gotham,
    TextSize=11,
    TextColor3=colors.textDim,
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
    icon = new("Frame",{
        Parent=gui,
        Size=UDim2.new(0,60,0,60),
        Position=savedIconPos,
        BackgroundColor3=colors.primary,
        BorderSizePixel=0,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,16)})
    new("UIGradient",{
        Parent=icon,
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.secondary)
        },
        Rotation=45
    })
    
    local logoK = new("TextLabel",{
        Parent=icon,
        Text="L",
        Size=UDim2.new(1,0,1,0),
        Font=Enum.Font.GothamBold,
        TextSize=32,
        BackgroundTransparency=1,
        TextColor3=colors.text,
        ZIndex=101
    })
    
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
            icon.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y)
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
                        Size=UDim2.new(0,700,0,480),
                        Position=UDim2.new(0.5,-350,0.5,-240)
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
        TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
            Size=UDim2.new(0,0,0,0),
            Position=UDim2.new(0.5,0,0.5,0)
        }):Play()
        TweenService:Create(overlay,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.wait(0.4)
        win.Visible,overlay.Visible = false,false
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
    TweenService:Create(overlay,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
    task.wait(0.4)
    gui:Destroy()
end)

-- Draggable Window
local dragging,dragStart,startPos = false,nil,nil
sidebar.InputBegan:Connect(function(input)
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

-- Opening Animation
task.spawn(function()
    win.Size = UDim2.new(0,0,0,0)
    win.Position = UDim2.new(0.5,0,0.5,0)
    overlay.Visible = true
    overlay.BackgroundTransparency = 1
    
    task.wait(0.1)
    
    TweenService:Create(overlay,TweenInfo.new(0.4),{BackgroundTransparency=0.4}):Play()
    TweenService:Create(win,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,700,0,480),
        Position=UDim2.new(0.5,-350,0.5,-240)
    }):Play()
end)

print("✨ Lynx GUI v1.0 loaded!")
print("🎨 Modern Premium Edition")
print("💎 Created by Lynx Team")
