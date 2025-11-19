-- LynxGUI_v3.0.lua - iOS Style Edition
-- Clean, Minimal, Professional Design

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

-- iOS Color Palette (Black, Gray, Orange)
local colors = {
    primary = Color3.fromRGB(255, 149, 0),
    secondary = Color3.fromRGB(255, 179, 64),
    success = Color3.fromRGB(52, 199, 89),
    danger = Color3.fromRGB(255, 59, 48),
    bg = Color3.fromRGB(0, 0, 0),
    bgLight = Color3.fromRGB(28, 28, 30),
    bgMedium = Color3.fromRGB(44, 44, 46),
    bgCard = Color3.fromRGB(58, 58, 60),
    text = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(174, 174, 178),
    textTertiary = Color3.fromRGB(99, 99, 102),
    separator = Color3.fromRGB(56, 56, 58),
    border = Color3.fromRGB(72, 72, 74),
}

local gui = new("ScreenGui",{
    Name="LynxGUI_iOS",
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
    BackgroundTransparency=1,
    BorderSizePixel=0,
    Visible=false,
    ZIndex=1,
    Active=true
})

local win = new("Frame",{
    Parent=gui,
    Size=UDim2.new(0,700,0,500),
    Position=UDim2.new(0.5,-350,0.5,-250),
    BackgroundColor3=colors.bg,
    BackgroundTransparency=0,
    BorderSizePixel=0,
    ClipsDescendants=true,
    ZIndex=3
})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,20)})
new("UIStroke",{Parent=win,Color=colors.border,Thickness=1,Transparency=0.5})

local topBar = new("Frame",{
    Parent=win,
    Size=UDim2.new(1,0,0,64),
    BackgroundColor3=colors.bgLight,
    BorderSizePixel=0,
    ZIndex=4
})
new("UICorner",{Parent=topBar,CornerRadius=UDim.new(0,20)})
new("Frame",{Parent=topBar,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=colors.separator,BorderSizePixel=0,ZIndex=4})

local titleContainer = new("Frame",{Parent=topBar,Size=UDim2.new(0,200,1,0),Position=UDim2.new(0,20,0,0),BackgroundTransparency=1,ZIndex=5})
new("TextLabel",{Parent=titleContainer,Text="Lynx",Size=UDim2.new(1,0,0,28),Position=UDim2.new(0,0,0,12),Font=Enum.Font.GothamBold,TextSize=22,BackgroundTransparency=1,TextColor3=colors.text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5})
new("TextLabel",{Parent=titleContainer,Text="iOS Edition",Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,1,-26),Font=Enum.Font.Gotham,TextSize=12,BackgroundTransparency=1,TextColor3=colors.textSecondary,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5})

local controlsContainer = new("Frame",{Parent=topBar,Size=UDim2.new(0,90,0,36),Position=UDim2.new(1,-110,0.5,-18),BackgroundTransparency=1,ZIndex=5})
new("UIListLayout",{Parent=controlsContainer,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,Padding=UDim.new(0,10)})

local function createControlButton(text, color)
    local btn = new("TextButton",{Parent=controlsContainer,Text=text,Size=UDim2.new(0,36,0,36),BackgroundColor3=colors.bgMedium,BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=18,TextColor3=colors.text,AutoButtonColor=false,ZIndex=6})
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(1,0)})
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=color}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=colors.bgMedium}):Play() end)
    btn.MouseButton1Down:Connect(function() TweenService:Create(btn,TweenInfo.new(0.1),{Size=UDim2.new(0,32,0,32)}):Play() end)
    btn.MouseButton1Up:Connect(function() TweenService:Create(btn,TweenInfo.new(0.1),{Size=UDim2.new(0,36,0,36)}):Play() end)
    return btn
end

local btnMin = createControlButton("−", colors.primary)
local btnClose = createControlButton("✕", colors.danger)

local sidebar = new("Frame",{Parent=win,Size=UDim2.new(0,180,1,-64),Position=UDim2.new(0,0,0,64),BackgroundColor3=colors.bgLight,BorderSizePixel=0,ZIndex=4})
new("Frame",{Parent=sidebar,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,0,0,0),BackgroundColor3=colors.separator,BorderSizePixel=0,ZIndex=4})

local navContainer = new("ScrollingFrame",{Parent=sidebar,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=5})
new("UIListLayout",{Parent=navContainer,Padding=UDim.new(0,2)})
new("UIPadding",{Parent=navContainer,PaddingTop=UDim.new(0,12),PaddingBottom=UDim.new(0,12),PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12)})

local currentPage = "Main"
local navButtons = {}

local function createNavButton(text, icon, page)
    local isActive = page == currentPage
    local btn = new("TextButton",{Parent=navContainer,Size=UDim2.new(1,0,0,50),BackgroundColor3=isActive and colors.bgCard or colors.bgLight,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=7})
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,12)})
    local indicator = new("Frame",{Parent=btn,Size=UDim2.new(0,3,0.7,0),Position=UDim2.new(0,0,0.15,0),BackgroundColor3=colors.primary,BorderSizePixel=0,Visible=isActive,ZIndex=8})
    new("UICorner",{Parent=indicator,CornerRadius=UDim.new(1,0)})
    local content = new("Frame",{Parent=btn,Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,ZIndex=8})
    local iconLabel = new("TextLabel",{Parent=content,Size=UDim2.new(0,40,1,0),BackgroundTransparency=1,Text=icon,Font=Enum.Font.GothamBold,TextSize=20,TextColor3=isActive and colors.primary or colors.textSecondary,ZIndex=9})
    local textLabel = new("TextLabel",{Parent=content,Size=UDim2.new(1,-50,1,0),Position=UDim2.new(0,45,0,0),BackgroundTransparency=1,Text=text,Font=Enum.Font.GothamSemibold,TextSize=14,TextColor3=isActive and colors.text or colors.textSecondary,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=9})
    btn.MouseEnter:Connect(function() if currentPage ~= page then TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=colors.bgCard}):Play() end end)
    btn.MouseLeave:Connect(function() if currentPage ~= page then TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=colors.bgLight}):Play() end end)
    navButtons[page] = {btn=btn, icon=iconLabel, text=textLabel, indicator=indicator}
    return btn
end

local contentBg = new("Frame",{Parent=win,Size=UDim2.new(1,-180,1,-64),Position=UDim2.new(0,180,0,64),BackgroundColor3=colors.bg,BorderSizePixel=0,ClipsDescendants=true,ZIndex=4})

local pages = {}
local function createPage(name)
    local page = new("ScrollingFrame",{Parent=contentBg,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ScrollBarThickness=6,ScrollBarImageColor3=colors.primary,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,ClipsDescendants=true,ZIndex=5})
    new("UIListLayout",{Parent=page,Padding=UDim.new(0,16),HorizontalAlignment=Enum.HorizontalAlignment.Center})
    new("UIPadding",{Parent=page,PaddingTop=UDim.new(0,20),PaddingBottom=UDim.new(0,20),PaddingLeft=UDim.new(0,20),PaddingRight=UDim.new(0,20)})
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
    pages[currentPage].Visible = false
    for name, btnData in pairs(navButtons) do
        local isActive = name == pageName
        TweenService:Create(btnData.btn,TweenInfo.new(0.25),{BackgroundColor3 = isActive and colors.bgCard or colors.bgLight}):Play()
        TweenService:Create(btnData.icon,TweenInfo.new(0.25),{TextColor3 = isActive and colors.primary or colors.textSecondary}):Play()
        TweenService:Create(btnData.text,TweenInfo.new(0.25),{TextColor3 = isActive and colors.text or colors.textSecondary}):Play()
        btnData.indicator.Visible = isActive
    end
    pages[pageName].Visible = true
    currentPage = pageName
end

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

local function createCategory(parent, title)
    local categoryFrame = new("Frame",{Parent=parent,Size=UDim2.new(1,0,0,0),BackgroundColor3=colors.bgLight,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
    new("UICorner",{Parent=categoryFrame,CornerRadius=UDim.new(0,16)})
    local header = new("TextButton",{Parent=categoryFrame,Size=UDim2.new(1,0,0,54),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=7})
    new("TextLabel",{Parent=header,Text=title,Size=UDim2.new(1,-60,1,0),Position=UDim2.new(0,20,0,0),Font=Enum.Font.GothamBold,TextSize=16,TextColor3=colors.text,BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8})
    local arrow = new("TextLabel",{Parent=header,Text="›",Size=UDim2.new(0,30,1,0),Position=UDim2.new(1,-40,0,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=20,TextColor3=colors.textSecondary,Rotation=0,ZIndex=8})
    local separator = new("Frame",{Parent=header,Size=UDim2.new(1,-40,0,1),Position=UDim2.new(0,20,1,-1),BackgroundColor3=colors.separator,BorderSizePixel=0,ZIndex=8})
    local container = new("Frame",{Parent=categoryFrame,Size=UDim2.new(1,-32,0,0),Position=UDim2.new(0,16,0,54),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,Visible=false,ZIndex=7})
    new("UIListLayout",{Parent=container,Padding=UDim.new(0,12)})
    new("UIPadding",{Parent=container,PaddingBottom=UDim.new(0,16)})
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        container.Visible = isOpen
        separator.Visible = not isOpen
        TweenService:Create(arrow,TweenInfo.new(0.3),{Rotation = isOpen and 90 or 0,TextColor3 = isOpen and colors.primary or colors.textSecondary}):Play()
    end)
    return container
end

local function makeToggle(parent,label,callback)
    local f=new("Frame",{Parent=parent,Size=UDim2.new(1,0,0,44),BackgroundTransparency=1,ZIndex=6})
    new("TextLabel",{Parent=f,Text=label,Size=UDim2.new(0.7,0,1,0),TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,TextColor3=colors.text,Font=Enum.Font.GothamMedium,TextSize=14,TextWrapped=true,ZIndex=7})
    local toggleBg=new("Frame",{Parent=f,Size=UDim2.new(0,51,0,31),Position=UDim2.new(1,-55,0.5,-15.5),BackgroundColor3=colors.bgCard,BorderSizePixel=0,ZIndex=7})
    new("UICorner",{Parent=toggleBg,CornerRadius=UDim.new(1,0)})
    local toggleCircle=new("Frame",{Parent=toggleBg,Size=UDim2.new(0,27,0,27),Position=UDim2.new(0,2,0.5,-13.5),BackgroundColor3=colors.text,BorderSizePixel=0,ZIndex=8})
    new("UICorner",{Parent=toggleCircle,CornerRadius=UDim.new(1,0)})
    local btn=new("TextButton",{Parent=toggleBg,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=9})
    local on=false
    btn.MouseButton1Click:Connect(function()
        on=not on
        TweenService:Create(toggleBg,TweenInfo.new(0.3),{BackgroundColor3=on and colors.primary or colors.bgCard}):Play()
        TweenService:Create(toggleCircle,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{Position=on and UDim2.new(1,-29,0.5,-13.5) or UDim2.new(0,2,0.5,-13.5)}):Play()
        callback(on)
    end)
end

local function makeSlider(parent,label,min,max,def,onChange)
    local f=new("Frame",{Parent=parent,Size=UDim2.new(1,0,0,60),BackgroundTransparency=1,ZIndex=6})
    local lbl=new("TextLabel",{Parent=f,Text=("%s: %.2f"):format(label,def),Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,TextColor3=colors.text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamSemibold,TextSize=13,ZIndex=7})
    local valueBg = new("Frame",{Parent=f,Size=UDim2.new(0,60,0,24),Position=UDim2.new(1,-64,0,-2),BackgroundColor3=colors.bgCard,BorderSizePixel=0,ZIndex=7})
    new("UICorner",{Parent=valueBg,CornerRadius=UDim.new(0,6)})
    local valueLabel = new("TextLabel",{Parent=valueBg,Text=string.format("%.2f",def),Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,TextColor3=colors.primary,Font=Enum.Font.GothamBold,TextSize=11,ZIndex=8})
    local bar=new("Frame",{Parent=f,Size=UDim2.new(1,0,0,4),Position=UDim2.new(0,0,0,32),BackgroundColor3=colors.bgCard,BorderSizePixel=0,ZIndex=7})
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(1,0)})
    local fill=new("Frame",{Parent=bar,Size=UDim2.new((def-min)/(max-min),0,1,0),BackgroundColor3=colors.primary,BorderSizePixel=0,ZIndex=8})
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(1,0)})
    local knob=new("Frame",{Parent=bar,Size=UDim2.new(0,20,0,20),Position=UDim2.new((def-min)/(max-min),-10,0.5,-10),BackgroundColor3=colors.text,BorderSizePixel=0,ZIndex=9})
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    local dragging=false
    local function update(x)
        local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        local val=min+(max-min)*rel
        fill.Size=UDim2.new(rel,0,1,0)
        knob.Position=UDim2.new(rel,-10,0.5,-10)
        lbl.Text=("%s: %.2f"):format(label,val)
        valueLabel.Text=string.format("%.2f",val)
        onChange(val)
    end
    bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true update(i.Position.X) TweenService:Create(knob,TweenInfo.new(0.1),{Size=UDim2.new(0,24,0,24)}):Play() end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then update(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false TweenService:Create(knob,TweenInfo.new(0.1),{Size=UDim2.new(0,20,0,20)}):Play() end end)
end

local function makeDropdown(parent, title, items, onSelect)
    local selectedItem = nil
    local dropdownFrame = new("Frame", {Parent = parent,Size = UDim2.new(1, 0, 0, 44),BackgroundColor3 = colors.bgCard,BorderSizePixel = 0,AutomaticSize = Enum.AutomaticSize.Y,ZIndex = 6})
    new("UICorner", {Parent = dropdownFrame, CornerRadius = UDim.new(0, 12)})
    local header = new("TextButton", {Parent = dropdownFrame,Size = UDim2.new(1, 0, 0, 44),BackgroundTransparency = 1,Text = "",AutoButtonColor = false,ZIndex = 7})
    new("TextLabel", {Parent = header,Text = title,Size = UDim2.new(1, -60, 1, 0),Position = UDim2.new(0, 16, 0, 0),BackgroundTransparency = 1,Font = Enum.Font.GothamMedium,TextSize = 14,TextColor3 = colors.text,TextXAlignment = Enum.TextXAlignment.Left,ZIndex = 8})
    local selectedLabel = new("TextLabel", {Parent = header,Text = "None",Size = UDim2.new(0, 100, 1, 0),Position = UDim2.new(1, -140, 0, 0),BackgroundTransparency = 1,Font = Enum.Font.Gotham,TextSize = 13,TextColor3 = colors.textSecondary,TextXAlignment = Enum.TextXAlignment.Right,TextTruncate = Enum.TextTruncate.AtEnd,ZIndex = 8})
    local arrow = new("TextLabel", {Parent = header,Text = "›",Size = UDim2.new(0, 30, 1, 0),Position = UDim2.new(1, -30, 0, 0),BackgroundTransparency = 1,Font = Enum.Font.GothamBold,TextSize = 18,TextColor3 = colors.textTertiary,Rotation = 0,ZIndex = 8})
    local listContainer = new("ScrollingFrame", {Parent = dropdownFrame,Size = UDim2.new(1, 0, 0, 0),Position = UDim2.new(0, 0, 0, 44),BackgroundTransparency = 1,Visible = false,AutomaticCanvasSize = Enum.AutomaticSize.Y,CanvasSize = UDim2.new(0, 0, 0, 0),ScrollBarThickness = 4,ScrollBarImageColor3 = colors.primary,BorderSizePixel = 0,ClipsDescendants = true,ZIndex = 10})
    new("UIListLayout", {Parent = listContainer, Padding = UDim.new(0, 0)})
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen
        TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = isOpen and 90 or 0,TextColor3 = isOpen and colors.primary or colors.textTertiary}):Play()
        if isOpen then listContainer.Size = UDim2.new(1, 0, 0, math.min(#items * 44, 220)) end
    end)
    for index, itemName in ipairs(items) do
        local isLastItem = index == #items
        local itemBtn = new("TextButton", {Parent = listContainer,Size = UDim2.new(1, 0, 0, 44),BackgroundTransparency = 1,BorderSizePixel = 0,Text = "",AutoButtonColor = false,ZIndex = 11})
        new("TextLabel", {Parent = itemBtn,Text = itemName,Size = UDim2.new(1, -60, 1, 0),Position = UDim2.new(0, 16, 0, 0),BackgroundTransparency = 1,Font = Enum.Font.Gotham,TextSize = 14,TextColor3 = colors.text,TextXAlignment = Enum.TextXAlignment.Left,TextTruncate = Enum.TextTruncate.AtEnd,ZIndex = 12})
        local checkIcon = new("TextLabel", {Parent = itemBtn,Text = "✓",Size = UDim2.new(0, 24, 1, 0),Position = UDim2.new(1, -36, 0, 0),BackgroundTransparency = 1,Font = Enum.Font.GothamBold,TextSize = 16,TextColor3 = colors.primary,Visible = false,ZIndex = 12})
        if not isLastItem then new("Frame", {Parent = itemBtn,Size = UDim2.new(1, -32, 0, 1),Position = UDim2.new(0, 16, 1, -1),BackgroundColor3 = colors.separator,BorderSizePixel = 0,ZIndex = 12}) end
        itemBtn.MouseEnter:Connect(function() TweenService:Create(itemBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.9,BackgroundColor3 = colors.bgMedium}):Play() end)
        itemBtn.MouseLeave:Connect(function() TweenService:Create(itemBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play() end)
        itemBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(listContainer:GetChildren()) do if child:IsA("TextButton") then for _, c in ipairs(child:GetChildren()) do if c:IsA("TextLabel") and c.Text == "✓" then c.Visible = false end end end end
            selectedItem = itemName
            checkIcon.Visible = true
            selectedLabel.Text = itemName
            TweenService:Create(selectedLabel, TweenInfo.new(0.2), {TextColor3 = colors.primary}):Play()
            onSelect(itemName)
            task.wait(0.1)
            isOpen = false
            listContainer.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0,TextColor3 = colors.textTertiary}):Play()
        end)
    end
    return dropdownFrame
end

local function makeButton(parent, label, callback)
    local btnFrame = new("Frame", {Parent = parent,Size = UDim2.new(1, 0, 0, 44),BackgroundColor3 = colors.primary,BorderSizePixel = 0,ZIndex = 7})
    new("UICorner", {Parent = btnFrame, CornerRadius = UDim.new(0, 12)})
    local button = new("TextButton", {Parent = btnFrame,Size = UDim2.new(1, 0, 1, 0),BackgroundTransparency = 1,Text = label,Font = Enum.Font.GothamBold,TextSize = 15,TextColor3 = colors.text,AutoButtonColor = false,ZIndex = 8})
    button.MouseEnter:Connect(function() TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = colors.secondary}):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = colors.primary}):Play() end)
    button.MouseButton1Down:Connect(function() TweenService:Create(btnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 42)}):Play() end)
    button.MouseButton1Up:Connect(function() TweenService:Create(btnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 44)}):Play() pcall(callback) end)
    return btnFrame
end

-- CONTENT
local autoFishingCat = createCategory(mainPage, "Auto Fishing")
local instantContainer = new("Frame",{Parent=autoFishingCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=instantContainer,Padding=UDim.new(0,12)})

local selectedInstantMode = "Fast"
local instantActive = false

makeDropdown(instantContainer, "Instant Fishing Mode", {"Fast", "Perfect"}, function(mode)
    selectedInstantMode = mode
    if instantActive then instant.Stop() instant2.Stop() end
end)

makeToggle(instantContainer, "Enable Instant Fishing", function(on)
    instantActive = on
    if on then
        if selectedInstantMode == "Fast" then instant.Start() instant2.Stop() else instant2.Start() instant.Stop() end
    else instant.Stop() instant2.Stop() end
end)

makeSlider(instantContainer, "Fishing Delay", 0.01, 5.0, 1.30, function(v) instant.Settings.MaxWaitTime = v instant2.Settings.MaxWaitTime = v end)
makeSlider(instantContainer, "Cancel Delay", 0.01, 1.5, 0.19, function(v) instant.Settings.CancelDelay = v instant2.Settings.CancelDelay = v end)

local blatantCat = createCategory(mainPage, "Blatant Mode")
local blatantContainer = new("Frame",{Parent=blatantCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=blatantContainer,Padding=UDim.new(0,12)})

makeToggle(blatantContainer, "Enable Extreme Blatant", function(on) if on then BlatantAutoFishing.Start() else BlatantAutoFishing.Stop() end end)
makeToggle(blatantContainer, "Instant Catch", function(on) BlatantAutoFishing.Settings.InstantCatch = on end)
makeToggle(blatantContainer, "Auto Complete", function(on) BlatantAutoFishing.Settings.AutoComplete = on end)
makeSlider(blatantContainer, "Spam Rate", 0.001, 0.1, 0.001, function(v) BlatantAutoFishing.Settings.SpamRate = v end)

local supportCat = createCategory(mainPage, "Support Fishing")
local supportContainer = new("Frame",{Parent=supportCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=supportContainer,Padding=UDim.new(0,12)})
makeToggle(supportContainer, "Manual Capture (2s)", function(on) if on then NoFishingAnimation.StartWithDelay() else NoFishingAnimation.Stop() end end)

local locationItems = {}
for name, _ in pairs(TeleportModule.Locations) do table.insert(locationItems, name) end
table.sort(locationItems)

local teleportLocationCat = createCategory(teleportPage, "Location Teleport")
makeDropdown(teleportLocationCat, "Select Location", locationItems, function(loc) TeleportModule.TeleportTo(loc) end)

local playerItems = {}
for _, player in ipairs(Players:GetPlayers()) do if player ~= localPlayer then table.insert(playerItems, player.Name) end end
table.sort(playerItems)

local teleportPlayerCat = createCategory(teleportPage, "Player Teleport")
local playerDropdown = makeDropdown(teleportPlayerCat, "Select Player", playerItems, function(p) TeleportToPlayer.TeleportTo(p) end)

local function refreshPlayerList()
    if playerDropdown then playerDropdown:Destroy() end
    table.clear(playerItems)
    for _, player in ipairs(Players:GetPlayers()) do if player ~= localPlayer then table.insert(playerItems, player.Name) end end
    table.sort(playerItems)
    playerDropdown = makeDropdown(teleportPlayerCat, "Select Player", playerItems, function(p) TeleportToPlayer.TeleportTo(p) end)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

local autoSellCat = createCategory(shopPage, "Auto Sell System")
local sellContainer = new("Frame",{Parent=autoSellCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=sellContainer,Padding=UDim.new(0,12)})
makeButton(sellContainer, "Sell All Items", function() if AutoSell and AutoSell.SellOnce then AutoSell.SellOnce() end end)

local timerCat = createCategory(shopPage, "Auto Sell Timer")
local timerContainer = new("Frame",{Parent=timerCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=timerContainer,Padding=UDim.new(0,12)})
makeSlider(timerContainer, "Sell Interval", 1, 60, 5, function(v) AutoSellTimer.SetInterval(v) end)
makeButton(timerContainer, "Start Auto Sell", function() if AutoSellTimer then AutoSellTimer.Start(AutoSellTimer.Interval) end end)
makeButton(timerContainer, "Stop Auto Sell", function() if AutoSellTimer then AutoSellTimer.Stop() end end)

local weatherCat = createCategory(shopPage, "Auto Buy Weather")
local weatherContainer = new("Frame",{Parent=weatherCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=weatherContainer,Padding=UDim.new(0,12)})
local selectedWeathers = {}
makeDropdown(weatherContainer, "Select Weathers", AutoBuyWeather.AllWeathers, function(w)
    local idx = table.find(selectedWeathers, w)
    if idx then table.remove(selectedWeathers, idx) else table.insert(selectedWeathers, w) end
    AutoBuyWeather.SetSelected(selectedWeathers)
end)
makeToggle(weatherContainer, "Enable Auto Weather", function(on) if on then AutoBuyWeather.Start() else AutoBuyWeather.Stop() end end)

local generalCat = createCategory(settingsPage, "General")
local generalContainer = new("Frame",{Parent=generalCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=generalContainer,Padding=UDim.new(0,12)})
makeToggle(generalContainer, "Auto Save Settings", function(on) end)
makeToggle(generalContainer, "Show Notifications", function(on) end)
makeToggle(generalContainer, "Performance Mode", function(on) end)

local afkCat = createCategory(settingsPage, "Anti-AFK")
local afkContainer = new("Frame",{Parent=afkCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=afkContainer,Padding=UDim.new(0,12)})
makeToggle(afkContainer, "Enable Anti-AFK", function(on) if on then AntiAFK.Start() else AntiAFK.Stop() end end)

local fpsCat = createCategory(settingsPage, "FPS Unlocker")
local fpsContainer = new("Frame",{Parent=fpsCat,Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=6})
new("UIListLayout",{Parent=fpsContainer,Padding=UDim.new(0,12)})
makeDropdown(fpsContainer, "FPS Limit", {"60 FPS", "90 FPS", "120 FPS", "240 FPS"}, function(s)
    local fps = tonumber(s:match("%d+"))
    if fps and UnlockFPS and UnlockFPS.SetCap then UnlockFPS.SetCap(fps) end
end)

local infoCard = new("Frame",{Parent=infoPage,Size=UDim2.new(1,0,0,0),BackgroundColor3=colors.bgLight,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=7})
new("UICorner",{Parent=infoCard,CornerRadius=UDim.new(0,16)})
new("TextLabel",{Parent=infoCard,Size=UDim2.new(1,-40,0,0),Position=UDim2.new(0,20,0,20),BackgroundTransparency=1,Text=[[LYNX v3.0
iOS Style Edition

FEATURES
• Auto Fishing (Fast/Perfect)
• Blatant Mode
• Location & Player Teleport
• Auto Sell System
• Auto Buy Weather
• Anti-AFK Protection
• FPS Unlocker

TIPS
Lower delay = Faster but risky
Higher delay = Safer but slower

Recommended:
• 1.30s fishing delay
• 0.19s cancel delay

Created by Lynx Team
© 2024 All Rights Reserved]],Font=Enum.Font.Gotham,TextSize=13,TextColor3=colors.text,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=8})
new("UIPadding",{Parent=infoCard,PaddingTop=UDim.new(0,20),PaddingBottom=UDim.new(0,20)})

local minimized = false
local icon
local savedIconPos = UDim2.new(0,20,0,120)

local function createMinimizedIcon()
    if icon then return end
    icon = new("Frame",{Parent=gui,Size=UDim2.new(0,56,0,56),Position=savedIconPos,BackgroundColor3=colors.bgLight,BorderSizePixel=0,ZIndex=100})
    new("UICorner",{Parent=icon,CornerRadius=UDim.new(0,16)})
    new("UIStroke",{Parent=icon,Color=colors.primary,Thickness=2,Transparency=0.5})
    new("TextLabel",{Parent=icon,Text="L",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=28,TextColor3=colors.primary,ZIndex=101})
    local dragging,dragStart,startPos,dragMoved = false,nil,nil,false
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging,dragMoved,dragStart,startPos = true,false,input.Position,icon.Position
            TweenService:Create(icon,TweenInfo.new(0.1),{Size=UDim2.new(0,52,0,52)}):Play()
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
                TweenService:Create(icon,TweenInfo.new(0.1),{Size=UDim2.new(0,56,0,56)}):Play()
                dragging = false
                savedIconPos = icon.Position
                if not dragMoved then
                    win.Visible = true
                    inputBlocker.Visible = true
                    TweenService:Create(win,TweenInfo.new(0.3),{BackgroundTransparency=0}):Play()
                    TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=0.5}):Play()
                    task.wait(0.3)
                    if icon then icon:Destroy() icon = nil end
                    minimized = false
                end
            end
        end
    end)
end

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(win,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.wait(0.3)
        win.Visible = false
        inputBlocker.Visible = false
        win.BackgroundTransparency = 0
        createMinimizedIcon()
        minimized = true
    end
end)

btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(win,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
    TweenService:Create(inputBlocker,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
    task.wait(0.3)
    gui:Destroy()
end)

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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

task.spawn(function()
    win.BackgroundTransparency = 1
    inputBlocker.BackgroundTransparency = 1
    inputBlocker.Visible = true
    task.wait(0.1)
    TweenService:Create(inputBlocker,TweenInfo.new(0.4),{BackgroundTransparency=0.5}):Play()
    TweenService:Create(win,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()
end)

print("✓ LYNX GUI v3.0 - iOS Edition Loaded")
print("✓ Clean Design | Orange Theme | Fade Animations")
