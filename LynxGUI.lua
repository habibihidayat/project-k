-- KeabyGUI_v4.1.lua - Enhanced Categorized Edition 🌟
-- Ultra Modern with Smart Categories & Status Display

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

-- Enhanced Transparent Cyberpunk Palette
local colors = {
    primary = Color3.fromRGB(0, 255, 255),
    secondary = Color3.fromRGB(255, 0, 255),
    accent = Color3.fromRGB(138, 43, 226),
    success = Color3.fromRGB(0, 255, 157),
    warning = Color3.fromRGB(255, 215, 0),
    danger = Color3.fromRGB(255, 20, 147),
    dark = Color3.fromRGB(8, 8, 12),
    darker = Color3.fromRGB(12, 12, 18),
    darkest = Color3.fromRGB(4, 4, 8),
    glass = Color3.fromRGB(15, 15, 25),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(160, 180, 220),
    border = Color3.fromRGB(0, 200, 255),
    sidebarBg = Color3.fromRGB(10, 10, 16),
    categoryBg = Color3.fromRGB(18, 18, 28),
}

local gui = new("ScreenGui",{
    Name="KeabyGUI_Ultra",
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

local blurBg = new("Frame",{
    Parent=gui,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(0,0,0),
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    Visible=false,
    ZIndex=2
})

local win = new("Frame",{
    Parent=gui,
    Size=UDim2.new(0,520,0,380),
    Position=UDim2.new(0.5,-260,0.5,-190),
    BackgroundColor3=colors.darkest,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,16)})

local neonBorder = new("UIStroke",{
    Parent=win,
    Color=colors.primary,
    Thickness=2,
    Transparency=0.2,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})

local neonGradient = new("UIGradient",{
    Parent=neonBorder,
    Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.primary),
        ColorSequenceKeypoint.new(0.33, colors.secondary),
        ColorSequenceKeypoint.new(0.66, colors.accent),
        ColorSequenceKeypoint.new(1, colors.primary)
    },
    Rotation=0
})

task.spawn(function()
    while gui.Parent do
        for i = 0, 360, 2 do
            if not gui.Parent then break end
            neonGradient.Rotation = i
            task.wait(0.03)
        end
    end
end)

-- Top Bar
local topBar = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,0,50),
    BackgroundColor3=colors.dark,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,16)})

local logoContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,38,0,38),
    Position=UDim2.new(0,10,0.5,-19),
    BackgroundColor3=colors.darkest,
    BackgroundTransparency=0.2,
    BorderSizePixel=0,
    ZIndex=5
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,10)})

local logoStroke = new("UIStroke",{
    Parent=logoContainer,
    Color=colors.primary,
    Thickness=1.8,
    Transparency=0.3
})

local logoText = new("TextLabel",{
    Parent=logoContainer,
    Text="K",
    Size=UDim2.new(1,0,1,0),
    Font=Enum.Font.GothamBold,
    TextSize=22,
    BackgroundTransparency=1,
    TextColor3=colors.primary,
    ZIndex=6
})

local titleLabel = new("TextLabel",{
    Parent=topBar,
    Text="Keabyy v4.1",
    Size=UDim2.new(0,150,1,0),
    Position=UDim2.new(0,55,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=16,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=5
})

local controlsContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,75,0,30),
    Position=UDim2.new(1,-82,0.5,-15),
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
        Size=UDim2.new(0,30,0,30),
        BackgroundColor3=colors.glass,
        BackgroundTransparency=0.5,
        BorderSizePixel=0,
        Font=Enum.Font.GothamBold,
        TextSize=icon == "×" and 20 or 16,
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,8)})
    new("UIStroke",{Parent=btn,Color=colors.border,Thickness=1.2,Transparency=0.6})
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{
            BackgroundColor3=hoverColor,
            BackgroundTransparency=0.2,
            TextColor3=colors.text,
            Size=UDim2.new(0,32,0,32)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{
            BackgroundColor3=colors.glass,
            BackgroundTransparency=0.5,
            TextColor3=colors.textDim,
            Size=UDim2.new(0,30,0,30)
        }):Play()
    end)
    return btn
end

local btnMin = createControlButton("─", colors.warning)
local btnClose = createControlButton("×", colors.danger)

-- Sidebar
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,130,1,-60),
    Position=UDim2.new(0,6,0,54),
    BackgroundColor3=colors.sidebarBg,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=sidebar,CornerRadius=UDim.new(0,12)})
new("UIStroke",{Parent=sidebar,Color=colors.border,Thickness=1.2,Transparency=0.7})

local navContainer = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1,-12,1,-12),
    Position=UDim2.new(0,6,0,6),
    BackgroundTransparency=1,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0,8),
    SortOrder=Enum.SortOrder.LayoutOrder
})

local currentPage = "Main"
local navButtons = {}

local function createNavButton(text, icon, page)
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1,0,0,38),
        BackgroundColor3=colors.glass,
        BackgroundTransparency=page == currentPage and 0.2 or 0.6,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,10)})
    
    local btnStroke = new("UIStroke",{
        Parent=btn,
        Color=page == currentPage and colors.primary or colors.border,
        Thickness=page == currentPage and 1.8 or 1.2,
        Transparency=page == currentPage and 0.4 or 0.8
    })
    
    local iconLabel = new("TextLabel",{
        Parent=btn,
        Size=UDim2.new(0,28,1,0),
        Position=UDim2.new(0,6,0,0),
        BackgroundTransparency=1,
        Text=icon,
        Font=Enum.Font.GothamBold,
        TextSize=15,
        TextColor3=page == currentPage and colors.primary or colors.textDim,
        ZIndex=8
    })
    
    local textLabel = new("TextLabel",{
        Parent=btn,
        Size=UDim2.new(1,-38,1,0),
        Position=UDim2.new(0,34,0,0),
        BackgroundTransparency=1,
        Text=text,
        Font=Enum.Font.GothamSemibold,
        TextSize=11,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    navButtons[page] = {btn=btn, icon=iconLabel, text=textLabel, stroke=btnStroke}
    return btn
end

-- Content Area
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-145,1,-64),
    Position=UDim2.new(0,142,0,57),
    BackgroundColor3=colors.darker,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg,CornerRadius=UDim.new(0,12)})
new("UIStroke",{Parent=contentBg,Color=colors.border,Thickness=1.2,Transparency=0.7})

local pages = {}

local function createPage(name)
    local page = new("ScrollingFrame",{
        Parent=contentBg,
        Size=UDim2.new(1,-12,1,-12),
        Position=UDim2.new(0,6,0,6),
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
        PaddingTop=UDim.new(0,6),
        PaddingBottom=UDim.new(0,6),
        PaddingLeft=UDim.new(0,3),
        PaddingRight=UDim.new(0,3)
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
    for _, page in pairs(pages) do page.Visible = false end
    
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        btnData.btn.BackgroundTransparency = isActive and 0.2 or 0.6
        btnData.stroke.Color = isActive and colors.primary or colors.border
        btnData.stroke.Thickness = isActive and 1.8 or 1.2
        btnData.stroke.Transparency = isActive and 0.4 or 0.8
        btnData.icon.TextColor3 = isActive and colors.primary or colors.textDim
        btnData.text.TextColor3 = isActive and colors.text or colors.textDim
    end
    
    pages[pageName].Visible = true
    currentPage = pageName
end

local btnMain = createNavButton("Main", "🏠", "Main")
local btnTeleport = createNavButton("Teleport", "🌍", "Teleport")
local btnShop = createNavButton("Shop Features", "🛒", "Shop")
local btnSettings = createNavButton("Settings", "⚙️", "Settings")
local btnInfo = createNavButton("Info", "ℹ️", "Info")

btnMain.MouseButton1Click:Connect(function() switchPage("Main") end)
btnTeleport.MouseButton1Click:Connect(function() switchPage("Teleport") end)
btnShop.MouseButton1Click:Connect(function() switchPage("Shop") end)
btnSettings.MouseButton1Click:Connect(function() switchPage("Settings") end)
btnInfo.MouseButton1Click:Connect(function() switchPage("Info") end)

-- Enhanced Toggle
local function makeToggle(parent,label,callback)
    local f=new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,32),
        BackgroundTransparency=1,
        ZIndex=6
    })
    
    new("TextLabel",{
        Parent=f,
        Text=label,
        Size=UDim2.new(0.6,0,1,0),
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
        Size=UDim2.new(0,42,0,22),
        Position=UDim2.new(1,-44,0.5,-11),
        BackgroundColor3=colors.border,
        BackgroundTransparency=0.5,
        BorderSizePixel=0,
        ZIndex=7
    })
    new("UICorner",{Parent=toggleBg,CornerRadius=UDim.new(1,0)})
    new("UIStroke",{Parent=toggleBg,Color=colors.border,Thickness=1.2,Transparency=0.6})
    
    local toggleCircle=new("Frame",{
        Parent=toggleBg,
        Size=UDim2.new(0,16,0,16),
        Position=UDim2.new(0,3,0.5,-8),
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
        TweenService:Create(toggleBg,TweenInfo.new(0.25),{
            BackgroundColor3=on and colors.primary or colors.border,
            BackgroundTransparency=on and 0.2 or 0.5
        }):Play()
        TweenService:Create(toggleCircle,TweenInfo.new(0.3,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3=on and colors.text or colors.textDim
        }):Play()
        callback(on)
    end)
end

-- Enhanced Slider
local function makeSlider(parent,label,min,max,def,onChange)
    local f=new("Frame",{
        Parent=parent,
        Size=UDim2.new(1,0,0,45),
        BackgroundTransparency=1,
        ClipsDescendants=true,
        ZIndex=6
    })
    
    local lbl=new("TextLabel",{
        Parent=f,
        Text=("%s: %.2fs"):format(label,def),
        Size=UDim2.new(1,0,0,16),
        BackgroundTransparency=1,
        TextColor3=colors.text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium,
        TextSize=10,
        ZIndex=7
    })
    
    local bar=new("Frame",{
        Parent=f,
        Size=UDim2.new(1,-6,0,8),
        Position=UDim2.new(0,3,0,26),
        BackgroundColor3=colors.glass,
        BackgroundTransparency=0.5,
        BorderSizePixel=0,
        ClipsDescendants=false,
        ZIndex=7
    })
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(1,0)})
    new("UIStroke",{Parent=bar,Color=colors.border,Thickness=1.2,Transparency=0.7})
    
    local fill=new("Frame",{
        Parent=bar,
        Size=UDim2.new((def-min)/(max-min),0,1,0),
        BackgroundColor3=colors.primary,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        ZIndex=8
    })
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(1,0)})
    
    local knob=new("Frame",{
        Parent=bar,
        Size=UDim2.new(0,16,0,16),
        Position=UDim2.new((def-min)/(max-min),-8,0.5,-8),
        BackgroundColor3=colors.text,
        BorderSizePixel=0,
        ZIndex=9
    })
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    new("UIStroke",{Parent=knob,Color=colors.primary,Thickness=1.5,Transparency=0.4})
    
    local dragging=false
    local function update(x)
        local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        local val=min+(max-min)*rel
        fill.Size=UDim2.new(rel,0,1,0)
        knob.Position=UDim2.new(rel,-8,0.5,-8)
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

-- Enhanced Collapsible Category
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(0.96, 0, 0, 45),
        BackgroundColor3 = colors.categoryBg,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 6
    })
    new("UICorner", {Parent = categoryFrame, CornerRadius = UDim.new(0, 14)})
    new("UIStroke", {Parent = categoryFrame, Color = colors.primary, Thickness = 1.5, Transparency = 0.6})
    
    local header = new("TextButton", {
        Parent = categoryFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 7
    })
    
    local iconLabel = new("TextLabel", {
        Parent = header,
        Text = icon,
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = colors.primary,
        ZIndex = 8
    })
    
    local titleLabel = new("TextLabel", {
        Parent = header,
        Text = title,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 42, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    local arrow = new("TextLabel", {
        Parent = header,
        Text = "▼",
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(1, -32, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = colors.primary,
        ZIndex = 8
    })
    
    local contentContainer = new("Frame", {
        Parent = categoryFrame,
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, 48),
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 7
    })
    new("UIListLayout", {Parent = contentContainer, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
    new("UIPadding", {Parent = contentContainer, PaddingBottom = UDim.new(0, 10)})
    
    local isOpen = false
    
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Rotation = isOpen and 180 or 0
        }):Play()
    end)
    
    return contentContainer
end

-- Enhanced Dropdown with Status Display
local function makeDropdown(parent, title, icon, items, onSelect, uniqueId)
    local dropdownFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = colors.glass,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 6,
        Name = uniqueId or "Dropdown"
    })
    new("UICorner", {Parent = dropdownFrame, CornerRadius = UDim.new(0, 12)})
    
    local dropStroke = new("UIStroke", {
        Parent = dropdownFrame, 
        Color = colors.primary, 
        Thickness = 1.5, 
        Transparency = 0.6
    })
    
    local header = new("TextButton", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, -16, 0, 38),
        Position = UDim2.new(0, 8, 0, 3),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 7
    })
    
    local iconLabel = new("TextLabel", {
        Parent = header,
        Text = icon,
        Size = UDim2.new(0, 24, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = colors.primary,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    local headerLabel = new("TextLabel", {
        Parent = header,
        Text = title,
        Size = UDim2.new(1, -80, 0, 18),
        Position = UDim2.new(0, 28, 0, 2),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    -- Status Label (shows selected item)
    local statusLabel = new("TextLabel", {
        Parent = header,
        Text = "None Selected",
        Size = UDim2.new(1, -80, 0, 14),
        Position = UDim2.new(0, 28, 0, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        TextColor3 = colors.textDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    
    local arrow = new("TextLabel", {
        Parent = header,
        Text = "▼",
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = colors.primary,
        ZIndex = 8
    })
    
    local listContainer = new("ScrollingFrame", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, 46),
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
    new("UIListLayout", {Parent = listContainer, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
    new("UIPadding", {Parent = listContainer, PaddingBottom = UDim.new(0, 8)})
    
    local isOpen = false
    local selectedItem = nil
    
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Rotation = isOpen and 180 or 0
        }):Play()
        
        TweenService:Create(dropStroke, TweenInfo.new(0.2), {
            Color = isOpen and colors.success or colors.primary,
            Thickness = isOpen and 2 or 1.5,
            Transparency = isOpen and 0.4 or 0.6
        }):Play()
        
        if isOpen and #items > 6 then
            listContainer.Size = UDim2.new(1, -16, 0, 180)
        else
            listContainer.Size = UDim2.new(1, -16, 0, math.min(#items * 35, 210))
        end
    end)
    
    local itemButtons = {}
    
    local function resetAllButtons()
        for _, btn in pairs(itemButtons) do
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.darker,
                BackgroundTransparency = 0.5,
                TextColor3 = colors.textDim
            }):Play()
            if btn:FindFirstChild("UIStroke") then
                btn.UIStroke.Color = colors.border
                btn.UIStroke.Transparency = 0.7
            end
        end
    end
    
    for _, itemName in ipairs(items) do
        local itemBtn = new("TextButton", {
            Parent = listContainer,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = colors.darker,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 11
        })
        new("UICorner", {Parent = itemBtn, CornerRadius = UDim.new(0, 9)})
        
        local btnStroke = new("UIStroke", {
            Parent = itemBtn, 
            Color = colors.border, 
            Thickness = 1.2, 
            Transparency = 0.7
        })
        
        local btnIcon = new("TextLabel", {
            Parent = itemBtn,
            Text = "◆",
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            TextColor3 = colors.primary,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 12
        })
        
        local btnLabel = new("TextLabel", {
            Parent = itemBtn,
            Text = itemName,
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 28, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            TextColor3 = colors.textDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 12
        })
        
        table.insert(itemButtons, itemBtn)
        
        itemBtn.MouseEnter:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = colors.primary,
                    BackgroundTransparency = 0.3,
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.15), {
                    TextColor3 = colors.text
                }):Play()
                TweenService:Create(btnIcon, TweenInfo.new(0.15), {
                    TextColor3 = colors.text
                }):Play()
                TweenService:Create(btnStroke, TweenInfo.new(0.15), {
                    Color = colors.primary,
                    Transparency = 0.4
                }):Play()
            end
        end)
        
        itemBtn.MouseLeave:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = colors.darker,
                    BackgroundTransparency = 0.5,
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.15), {
                    TextColor3 = colors.textDim
                }):Play()
                TweenService:Create(btnIcon, TweenInfo.new(0.15), {
                    TextColor3 = colors.primary
                }):Play()
                TweenService:Create(btnStroke, TweenInfo.new(0.15), {
                    Color = colors.border,
                    Transparency = 0.7
                }):Play()
            end
        end)
        
        itemBtn.MouseButton1Click:Connect(function()
            resetAllButtons()
            selectedItem = itemName
            statusLabel.Text = "✓ " .. itemName
            statusLabel.TextColor3 = colors.success
            onSelect(itemName)
            
            task.wait(0.1)
            isOpen = false
            listContainer.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Rotation = 0
            }):Play()
            TweenService:Create(dropStroke, TweenInfo.new(0.2), {
                Color = colors.primary,
                Thickness = 1.5,
                Transparency = 0.6
            }):Play()
        end)
    end
    
    return dropdownFrame
end

-- Button Function
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = colors.darker,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 7
    })
    new("UICorner", { Parent = btnFrame, CornerRadius = UDim.new(0, 10) })
    new("UIStroke", { Parent = btnFrame, Color = colors.border, Thickness = 1.2, Transparency = 0.7 })

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
        TweenService:Create(btnFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = colors.primary
        }):Play()
        TweenService:Create(button, TweenInfo.new(0.15), {
            TextColor3 = colors.dark
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.4,
            BackgroundColor3 = colors.darker
        }):Play()
        TweenService:Create(button, TweenInfo.new(0.15), {
            TextColor3 = colors.text
        }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        pcall(function()
            callback()
        end)
    end)

    return btnFrame
end

-- ==== MAIN PAGE WITH CATEGORIES ====

-- 🎣 Auto Fishing Category
local catAutoFishing = makeCategory(mainPage, "Auto Fishing")

-- Instant Fishing Mode Selector
local currentInstantMode = "None"
local fishingDelayValue = 1.30
local cancelDelayValue = 0.19

makeDropdown(catAutoFishing, "Instant Fishing Mode", "⚡", {"Fast", "Perfect"}, function(mode)
    currentInstantMode = mode
    -- Stop all first
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

-- Blatant Mode
local catBlatant = makeCategory(mainPage, "TRUE BLATANT MODE")

makeToggle(catBlatant, "🔥 ENABLE EXTREME BLATANT 🔥", function(on)
    if on then
        BlatantAutoFishing.Start()
    else
        BlatantAutoFishing.Stop()
    end
end)

makeToggle(catBlatant, "Instant Catch (No Wait)", function(on)
    BlatantAutoFishing.Settings.InstantCatch = on
end)

makeToggle(catBlatant, "Auto Complete Everything", function(on)
    BlatantAutoFishing.Settings.AutoComplete = on
end)

makeSlider(catBlatant, "Spam Rate (ms)", 0.001, 0.1, 0.001, function(v)
    BlatantAutoFishing.Settings.SpamRate = v
end)

-- 🛠️ Support Fishing Category
local catSupport = makeCategory(mainPage, "Support Fishing")

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

-- ==== SHOP PAGE WITH CATEGORIES ====

-- 💰 Auto Sell Category
local catSell = makeCategory(shopPage, "Auto Sell System")

makeButton(catSell, "Sell All Now", function()
    if AutoSell and AutoSell.SellOnce then
        AutoSell.SellOnce()
    end
end)

-- ⏰ Auto Sell Timer Category
local catTimer = makeCategory(shopPage, "Auto Sell Timer")

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

-- 🌦️ Auto Buy Weather Category
local catWeather = makeCategory(shopPage, "Auto Buy Weather")

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

-- ==== SETTINGS PAGE WITH CATEGORIES ====

-- 🧍‍♂️ Anti-AFK Category
local catAFK = makeCategory(settingsPage, "Anti-AFK Protection", "🧍‍♂️")

makeToggle(catAFK, "Enable Anti-AFK", function(on)
    if on then
        AntiAFK.Start()
    else
        AntiAFK.Stop()
    end
end)

-- 🎞️ FPS Settings Category
local catFPS = makeCategory(settingsPage, "FPS Unlocker")

makeDropdown(catFPS, "Select FPS Limit", "⚙️", {"60 FPS", "90 FPS", "120 FPS", "240 FPS"}, function(selected)
    local fpsValue = tonumber(selected:match("%d+"))
    if fpsValue and UnlockFPS and UnlockFPS.SetCap then
        UnlockFPS.SetCap(fpsValue)
    end
end, "FPSDropdown")

-- ⚙️ General Settings Category
local catGeneral = makeCategory(settingsPage, "General Settings")

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
local infoText = new("TextLabel",{
    Parent=infoPage,
    Size=UDim2.new(0.96,0,0,380),
    BackgroundColor3=colors.glass,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    Text=[[
🌟 KEABY ULTRA v4.1

Enhanced Categorized Interface
Mobile Optimized Design

🎣 AUTO FISHING CATEGORY
• Instant Fishing (Fast/Perfect modes)
• Unified slider controls
• TRUE Blatant Mode
• Advanced automation

🛠️ SUPPORT FISHING
• No Fishing Animation
• Additional utilities

🌍 TELEPORT
• Location teleport with status
• Player teleport system
• Smart dropdown selection

💰 SHOP FEATURES
• Auto Sell (instant & timer)
• Auto Buy Weather
• Smart category organization

⚙️ SETTINGS
• Anti-AFK Protection
• FPS Unlocker
• General preferences

💡 NEW FEATURES v4.1
• Collapsible categories
• Status display in dropdowns
• Enhanced transparency
• Better organization
• Smooth animations

🎮 CONTROLS
• Click category to expand/collapse
• Drag top bar to move window
• (─) to minimize
• (×) to close

Created with 💎 by Keaby Team
Enhanced Edition 2024
    ]],
    Font=Enum.Font.Gotham,
    TextSize=9,
    TextColor3=colors.textDim,
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=7
})
new("UICorner",{Parent=infoText,CornerRadius=UDim.new(0,12)})
new("UIStroke",{Parent=infoText,Color=colors.primary,Thickness=1.5,Transparency=0.6})
new("UIPadding",{Parent=infoText,PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)})

-- Minimized Icon
local minimized=false
local icon
local savedIconPos = UDim2.new(0,20,0,120)

local function createMinimizedIcon()
    if icon then return end
    icon=new("Frame",{
        Parent=gui,
        Size=UDim2.new(0,50,0,50),
        Position=savedIconPos,
        BackgroundColor3=colors.darkest,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,14)})
    
    local iconStroke = new("UIStroke",{Parent=icon,Color=colors.primary,Thickness=2,Transparency=0.3})
    
    local logoK = new("TextLabel",{
        Parent=icon,
        Text="K",
        Size=UDim2.new(1,0,1,0),
        Font=Enum.Font.GothamBold,
        TextSize=26,
        BackgroundTransparency=1,
        TextColor3=colors.primary,
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
                    inputBlocker.Visible,blurBg.Visible,win.Visible = true,true,true
                    TweenService:Create(win,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,520,0,380),Position=UDim2.new(0.5,-260,0.5,-190)}):Play()
                    if icon then icon:Destroy() icon = nil end
                    minimized = false
                end
            end
        end
    end)
end

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
        TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        TweenService:Create(blurBg,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.wait(0.4)
        win.Visible,inputBlocker.Visible,blurBg.Visible = false,false,false
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0),Rotation=180}):Play()
    TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
    TweenService:Create(blurBg,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
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

-- Opening Animation
task.spawn(function()
    win.Size = UDim2.new(0,0,0,0)
    win.Position = UDim2.new(0.5,0,0.5,0)
    inputBlocker.Visible,blurBg.Visible = true,true
    inputBlocker.BackgroundTransparency = 1
    blurBg.BackgroundTransparency = 1
    
    task.wait(0.1)
    
    TweenService:Create(inputBlocker,TweenInfo.new(0.4),{BackgroundTransparency=0.5}):Play()
    TweenService:Create(blurBg,TweenInfo.new(0.4),{BackgroundTransparency=0.3}):Play()
    TweenService:Create(win,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,520,0,380),
        Position=UDim2.new(0.5,-260,0.5,-190)
    }):Play()
end)

print("✨ Keaby GUI v4.1 Enhanced loaded!")
print("📱 Mobile optimized with categories")
print("🎯 Smart organization & status display")
print("💎 Created by Keaby Team")
