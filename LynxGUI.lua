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

-- Minimalist Color Palette
local colors = {
    primary = Color3.fromRGB(0, 180, 255),
    secondary = Color3.fromRGB(138, 43, 226),
    accent = Color3.fromRGB(0, 255, 200),
    success = Color3.fromRGB(0, 200, 100),
    warning = Color3.fromRGB(255, 180, 0),
    danger = Color3.fromRGB(255, 60, 80),
    bg = Color3.fromRGB(15, 15, 20),
    bgLight = Color3.fromRGB(22, 22, 30),
    bgDark = Color3.fromRGB(10, 10, 15),
    text = Color3.fromRGB(240, 240, 245),
    textDim = Color3.fromRGB(160, 165, 180),
    border = Color3.fromRGB(40, 45, 55),
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

-- Main Window
local win = new("Frame",{
    Parent=gui,
    Size=UDim2.new(0,550,0,400),
    Position=UDim2.new(0.5,-275,0.5,-200),
    BackgroundColor3=colors.bg,
    BackgroundTransparency=0.15,
    BorderSizePixel=0,
    ClipsDescendants=false,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,12)})
new("UIStroke",{Parent=win,Color=colors.border,Thickness=1})

-- Top Bar
local topBar = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,0,45),
    BackgroundColor3=colors.bgDark,
    BackgroundTransparency=0.3,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,12)})

-- Logo Container (untuk gambar custom)
local logoContainer = new("ImageLabel",{
    Parent=topBar,
    Size=UDim2.new(0,32,0,32),
    Position=UDim2.new(0,10,0.5,-16),
    BackgroundColor3=colors.bgLight,
    BackgroundTransparency=0.5,
    BorderSizePixel=0,
    Image="rbxasset://textures/ui/GuiImagePlaceholder.png", -- Placeholder, ganti dengan URL logo
    ScaleType=Enum.ScaleType.Fit,
    ZIndex=5
})
new("UICorner",{Parent=logoContainer,CornerRadius=UDim.new(0,8)})
new("UIStroke",{Parent=logoContainer,Color=colors.primary,Thickness=1,Transparency=0.5})

-- Title
local titleLabel = new("TextLabel",{
    Parent=topBar,
    Text="Lynx",
    Size=UDim2.new(0,100,1,0),
    Position=UDim2.new(0,48,0,0),
    Font=Enum.Font.GothamBold,
    TextSize=16,
    BackgroundTransparency=1,
    TextColor3=colors.text,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=5
})

-- Control Buttons
local controlsContainer = new("Frame",{
    Parent=topBar,
    Size=UDim2.new(0,70,0,28),
    Position=UDim2.new(1,-75,0.5,-14),
    BackgroundTransparency=1,
    ZIndex=5
})
new("UIListLayout",{
    Parent=controlsContainer,
    FillDirection=Enum.FillDirection.Horizontal,
    HorizontalAlignment=Enum.HorizontalAlignment.Right,
    Padding=UDim.new(0,5)
})

local function createControlButton(text, hoverColor)
    local btn = new("TextButton",{
        Parent=controlsContainer,
        Text=text,
        Size=UDim2.new(0,28,0,28),
        BackgroundColor3=colors.bgLight,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        Font=Enum.Font.GothamBold,
        TextSize=text == "X" and 16 or 14,
        TextColor3=colors.textDim,
        AutoButtonColor=false,
        ZIndex=6
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,6)})
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{
            BackgroundColor3=hoverColor,
            BackgroundTransparency=0,
            TextColor3=colors.text
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.2),{
            BackgroundColor3=colors.bgLight,
            BackgroundTransparency=0.3,
            TextColor3=colors.textDim
        }):Play()
    end)
    return btn
end

local btnMin = createControlButton("-", colors.warning)
local btnClose = createControlButton("X", colors.danger)

-- Sidebar
local sidebar = new("Frame",{
    Parent=win,
    Size=UDim2.new(0,120,1,-50),
    Position=UDim2.new(0,5,0,48),
    BackgroundColor3=colors.bgDark,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=sidebar,CornerRadius=UDim.new(0,10)})
new("UIStroke",{Parent=sidebar,Color=colors.border,Thickness=1})

local navContainer = new("Frame",{
    Parent=sidebar,
    Size=UDim2.new(1,-10,1,-10),
    Position=UDim2.new(0,5,0,5),
    BackgroundTransparency=1,
    ZIndex=5
})
new("UIListLayout",{
    Parent=navContainer,
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder
})

local currentPage = "Main"
local navButtons = {}

local function createNavButton(text, page)
    local btn = new("TextButton",{
        Parent=navContainer,
        Size=UDim2.new(1,0,0,36),
        BackgroundColor3=page == currentPage and colors.primary or colors.bgLight,
        BackgroundTransparency=page == currentPage and 0.2 or 0.5,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,8)})
    
    local textLabel = new("TextLabel",{
        Parent=btn,
        Size=UDim2.new(1,-10,1,0),
        Position=UDim2.new(0,5,0,0),
        BackgroundTransparency=1,
        Text=text,
        Font=Enum.Font.GothamSemibold,
        TextSize=11,
        TextColor3=page == currentPage and colors.text or colors.textDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    navButtons[page] = {btn=btn, text=textLabel}
    return btn
end

-- Content Area
local contentBg = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,-135,1,-55),
    Position=UDim2.new(0,130,0,50),
    BackgroundColor3=colors.bgLight,
    BackgroundTransparency=0.4,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=4
})
new("UICorner",{Parent=contentBg,CornerRadius=UDim.new(0,10)})
new("UIStroke",{Parent=contentBg,Color=colors.border,Thickness=1})

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
    for _, page in pairs(pages) do page.Visible = false end
    
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        btnData.btn.BackgroundTransparency = isActive and 0.2 or 0.5
        btnData.btn.BackgroundColor3 = isActive and colors.primary or colors.bgLight
        btnData.text.TextColor3 = isActive and colors.text or colors.textDim
    end
    
    pages[pageName].Visible = true
    currentPage = pageName
end

local btnMain = createNavButton("Main", "Main")
local btnTeleport = createNavButton("Teleport", "Teleport")
local btnShop = createNavButton("Shop", "Shop")
local btnSettings = createNavButton("Settings", "Settings")
local btnInfo = createNavButton("Info", "Info")

btnMain.MouseButton1Click:Connect(function() switchPage("Main") end)
btnTeleport.MouseButton1Click:Connect(function() switchPage("Teleport") end)
btnShop.MouseButton1Click:Connect(function() switchPage("Shop") end)
btnSettings.MouseButton1Click:Connect(function() switchPage("Settings") end)
btnInfo.MouseButton1Click:Connect(function() switchPage("Info") end)

-- Category System
local function createCategory(parent, title)
    local categoryFrame = new("Frame",{
        Parent=parent,
        Size=UDim2.new(0.96,0,0,40),
        BackgroundColor3=colors.bgDark,
        BackgroundTransparency=0.3,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ZIndex=6
    })
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,10)})
    new("UIStroke",{Parent=categoryFrame,Color=colors.border,Thickness=1})
    
    local header = new("TextButton",{
        Parent=categoryFrame,
        Size=UDim2.new(1,0,0,36),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false,
        ZIndex=7
    })
    
    local titleLabel = new("TextLabel",{
        Parent=header,
        Text=title,
        Size=UDim2.new(1,-40,1,0),
        Position=UDim2.new(0,10,0,0),
        Font=Enum.Font.GothamBold,
        TextSize=12,
        TextColor3=colors.text,
        BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=8
    })
    
    local arrow = new("TextLabel",{
        Parent=header,
        Text=">",
        Size=UDim2.new(0,20,1,0),
        Position=UDim2.new(1,-25,0,0),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamBold,
        TextSize=14,
        TextColor3=colors.primary,
        ZIndex=8
    })
    
    local container = new("Frame",{
        Parent=categoryFrame,
        Size=UDim2.new(1,-10,0,0),
        Position=UDim2.new(0,5,0,40),
        BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y,
        Visible=false,
        ZIndex=7
    })
    new("UIListLayout",{
        Parent=container,
        Padding=UDim.new(0,5),
        SortOrder=Enum.SortOrder.LayoutOrder
    })
    new("UIPadding",{
        Parent=container,
        PaddingBottom=UDim.new(0,5)
    })
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        container.Visible = isOpen
        TweenService:Create(arrow,TweenInfo.new(0.2),{
            Rotation = isOpen and 90 or 0
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
local autoFishingCat = createCategory(mainPage, "Auto Fishing")

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
local supportFishingCat = createCategory(mainPage, "Support Fishing")

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

local teleportLocationCat = createCategory(teleportPage, "Location Teleport")
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

local teleportPlayerCat = createCategory(teleportPage, "Player Teleport")
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
local autoSellCat = createCategory(shopPage, "Auto Sell System")

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
local autoSellTimerCat = createCategory(shopPage, "Auto Sell Timer")

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
local autoWeatherCat = createCategory(shopPage, "Auto Buy Weather")

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
local generalCat = createCategory(settingsPage, "General Settings")

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
local antiAFKCat = createCategory(settingsPage, "Anti-AFK Protection")

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
local fpsCat = createCategory(settingsPage, "FPS Unlocker")

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

-- Minimized Icon
local minimized = false
local icon
local savedIconPos = UDim2.new(0,20,0,120)

local function createMinimizedIcon()
    if icon then return end
    icon = new("ImageLabel",{
        Parent=gui,
        Size=UDim2.new(0,45,0,45),
        Position=savedIconPos,
        BackgroundColor3=colors.bg,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        Image="rbxasset://textures/ui/GuiImagePlaceholder.png", -- Placeholder
        ScaleType=Enum.ScaleType.Fit,
        ZIndex=100
    })
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,12)})
    new("UIStroke",{Parent=icon,Color=colors.primary,Thickness=2})
    
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
                    inputBlocker.Visible,win.Visible = true,true
                    TweenService:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,550,0,400),Position=UDim2.new(0.5,-275,0.5,-200)}):Play()
                    if icon then icon:Destroy() icon = nil end
                    minimized = false
                end
            end
        end
    end)
end

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(win,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
        TweenService:Create(inputBlocker,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
        task.wait(0.3)
        win.Visible,inputBlocker.Visible = false,false
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
    TweenService:Create(inputBlocker,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
    task.wait(0.3)
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
    Size=UDim2.new(0,15,0,15),
    Position=UDim2.new(1,-15,1,-15),
    BackgroundColor3=colors.primary,
    BackgroundTransparency=0.7,
    BorderSizePixel=0,
    ZIndex=10
})
new("UICorner",{Parent=resizeHandle,CornerRadius=UDim.new(0,4)})

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
        local newWidth = math.max(450, startSize.X.Offset + delta.X)
        local newHeight = math.max(350, startSize.Y.Offset + delta.Y)
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
    inputBlocker.Visible = true
    inputBlocker.BackgroundTransparency = 1
    
    task.wait(0.1)
    
    TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=0.5}):Play()
    TweenService:Create(win,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,550,0,400),
        Position=UDim2.new(0.5,-275,0.5,-200)
    }):Play()
end)

print("Lynx GUI v1.0 loaded successfully!")
print("Minimalist Modern Edition")
print("Created by Lynx Team")
