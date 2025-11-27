-- LynxGUI_v2.2.lua - Minimalis Black Edition - BAGIAN 1
-- Mobile First - Compact & Minimalist Design

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

repeat task.wait() until localPlayer:FindFirstChild("PlayerGui")

-- Detect if mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Helper function
local function new(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k] = v end
    return inst
end

-- Load modules
local instant = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant.lua"))()
local instant2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Instant2.lua"))()
local blatantv1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/BlatantV1.lua"))()
local blatantv2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/BlatantV2.lua"))()
local NoFishingAnimation = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Utama/NoFishingAnimation.lua"))()
local TeleportModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportModule.lua"))()
local TeleportToPlayer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/TeleportSystem/TeleportToPlayer.lua"))()
local AutoSell = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSell.lua"))()
local AutoSellTimer = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoSellTimer.lua"))()
local AntiAFK = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/AntiAFK.lua"))()
local UnlockFPS = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/Misc/UnlockFPS.lua"))()
local AutoBuyWeather = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibihidayat/project-k/refs/heads/main/FungsiKeaby/ShopFeatures/AutoBuyWeather.lua"))()

-- Color Palette - Black & Orange Minimalist
local colors = {
    primary = Color3.fromRGB(255, 140, 0),
    secondary = Color3.fromRGB(255, 165, 50),
    accent = Color3.fromRGB(255, 69, 0),
    success = Color3.fromRGB(34, 197, 94),
    warning = Color3.fromRGB(251, 191, 36),
    danger = Color3.fromRGB(239, 68, 68),
    
    bg1 = Color3.fromRGB(0, 0, 0),
    bg2 = Color3.fromRGB(10, 10, 10),
    bg3 = Color3.fromRGB(20, 20, 20),
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(150, 150, 150),
    textDimmer = Color3.fromRGB(100, 100, 100),
    
    border = Color3.fromRGB(50, 50, 50),
}

-- Window sizing - Mobile first
local windowSize = UDim2.new(0, 320, 0, 500)
local minWindowSize = Vector2.new(280, 400)
local maxWindowSize = Vector2.new(400, 600)

local gui = new("ScreenGui", {
    Name = "LynxGUI_Minimalist",
    Parent = localPlayer.PlayerGui,
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999
})

-- Main window
local win = new("Frame", {
    Parent = gui,
    Size = windowSize,
    Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
    BackgroundColor3 = colors.bg1,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    ClipsDescendants = false,
    ZIndex = 3
})
new("UICorner", {Parent = win, CornerRadius = UDim.new(0, 8)})

-- Glow border - subtle
local glowBorder = new("UIStroke", {
    Parent = win,
    Color = colors.primary,
    Thickness = 1,
    Transparency = 0.8,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
})

-- Top bar - minimal
local topBar = new("Frame", {
    Parent = win,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = colors.bg2,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 5
})
new("UICorner", {Parent = topBar, CornerRadius = UDim.new(0, 8)})

-- Title
local pageTitle = new("TextLabel", {
    Parent = topBar,
    Text = "LYNX",
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundTransparency = 1,
    TextColor3 = colors.text,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6
})

-- Minimize button
local btnMin = new("TextButton", {
    Parent = topBar,
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0.5, -15),
    BackgroundColor3 = colors.primary,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Text = "─",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = colors.text,
    AutoButtonColor = false,
    ZIndex = 7
})
new("UICorner", {Parent = btnMin, CornerRadius = UDim.new(0, 6)})

-- Content area
local contentBg = new("Frame", {
    Parent = win,
    Size = UDim2.new(1, -12, 1, -55),
    Position = UDim2.new(0, 6, 0, 45),
    BackgroundColor3 = colors.bg1,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 4
})

-- Pages container
local pagesContainer = new("ScrollingFrame", {
    Parent = contentBg,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = colors.primary,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ClipsDescendants = true,
    ZIndex = 5
})
new("UIListLayout", {
    Parent = pagesContainer,
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
})
new("UIPadding", {
    Parent = pagesContainer,
    PaddingTop = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6)
})

-- Resize handle - minimalis
local resizeHandle = new("TextButton", {
    Parent = win,
    Size = UDim2.new(0, 14, 0, 14),
    Position = UDim2.new(1, -14, 1, -14),
    BackgroundColor3 = colors.primary,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Text = "⋰",
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextColor3 = colors.text,
    AutoButtonColor = false,
    ZIndex = 100
})
new("UICorner", {Parent = resizeHandle, CornerRadius = UDim.new(0, 5)})
new("UIStroke", {
    Parent = resizeHandle,
    Color = colors.primary,
    Thickness = 0.8,
    Transparency = 0.5
})

-- LynxGUI_v2.2.lua - Bagian 2: Components (Category, Toggle, Input)
-- Dilanjutkan dari Bagian 1

-- ============ COMPONENT FUNCTIONS ============

-- Modern Category (Collapsible)
local function makeCategory(parent, title, icon)
    local categoryFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = colors.bg2,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = false,
        ZIndex = 6
    })
    new("UICorner", {Parent = categoryFrame, CornerRadius = UDim.new(0, 8)})

    local categoryStroke = new("UIStroke", {
        Parent = categoryFrame,
        Color = colors.primary,
        Thickness = 0,
        Transparency = 0.8
    })

    local header = new("TextButton", {
        Parent = categoryFrame,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        ZIndex = 7
    })

    local iconLabel = new("TextLabel", {
        Parent = header,
        Text = icon,
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = colors.primary,
        ZIndex = 8
    })

    local titleLabel = new("TextLabel", {
        Parent = header,
        Text = title,
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 36, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })

    local arrow = new("TextLabel", {
        Parent = header,
        Text = "▼",
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -24, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = colors.primary,
        ZIndex = 8
    })

    local contentContainer = new("Frame", {
        Parent = categoryFrame,
        Size = UDim2.new(1, -12, 0, 0),
        Position = UDim2.new(0, 6, 0, 38),
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        ZIndex = 7
    })
    new("UIListLayout", {Parent = contentContainer, Padding = UDim.new(0, 6)})
    new("UIPadding", {Parent = contentContainer, PaddingBottom = UDim.new(0, 8)})

    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Rotation = isOpen and 180 or 0}):Play()
        TweenService:Create(categoryFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = isOpen and colors.bg3 or colors.bg2,
            BackgroundTransparency = isOpen and 0.2 or 0.4
        }):Play()
        TweenService:Create(categoryStroke, TweenInfo.new(0.2), {Thickness = isOpen and 1 or 0}):Play()
    end)

    -- Hover effect
    header.MouseEnter:Connect(function()
        TweenService:Create(categoryFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.3
        }):Play()
    end)
    header.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(categoryFrame, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.4
            }):Play()
        end
    end)

    return contentContainer
end

-- Modern Toggle
local function makeToggle(parent, label, callback)
    local frame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        ZIndex = 7
    })

    local labelText = new("TextLabel", {
        Parent = frame,
        Text = label,
        Size = UDim2.new(0.6, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        TextColor3 = colors.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextWrapped = true,
        ZIndex = 8
    })

    local toggleBg = new("Frame", {
        Parent = frame,
        Size = UDim2.new(0, 44, 0, 24),
        Position = UDim2.new(1, -46, 0.5, -12),
        BackgroundColor3 = colors.bg2,
        BorderSizePixel = 0,
        ZIndex = 8
    })
    new("UICorner", {Parent = toggleBg, CornerRadius = UDim.new(1, 0)})

    local toggleCircle = new("Frame", {
        Parent = toggleBg,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 2, 0.5, -10),
        BackgroundColor3 = colors.textDim,
        BorderSizePixel = 0,
        ZIndex = 9
    })
    new("UICorner", {Parent = toggleCircle, CornerRadius = UDim.new(1, 0)})

    local btn = new("TextButton", {
        Parent = toggleBg,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 10
    })

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(toggleBg, TweenInfo.new(0.25), {
            BackgroundColor3 = on and colors.primary or colors.bg2
        }):Play()
        TweenService:Create(toggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
            BackgroundColor3 = on and colors.text or colors.textDim
        }):Play()
        callback(on)
    end)

    return frame
end

-- INPUT DELAY - Menggantikan Slider
local function makeInputDelay(parent, label, defaultValue, onChange)
    local frame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 7
    })

    local labelText = new("TextLabel", {
        Parent = frame,
        Text = label,
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        TextColor3 = colors.text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })

    local inputBg = new("Frame", {
        Parent = frame,
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 18),
        BackgroundColor3 = colors.bg2,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 8
    })
    new("UICorner", {Parent = inputBg, CornerRadius = UDim.new(0, 6)})

    local inputStroke = new("UIStroke", {
        Parent = inputBg,
        Color = colors.primary,
        Thickness = 0,
        Transparency = 0.8
    })

    local inputBox = new("TextBox", {
        Parent = inputBg,
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(defaultValue),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = colors.text,
        PlaceholderColor3 = colors.textDimmer,
        PlaceholderText = "0.00",
        ClearTextOnFocus = false,
        ZIndex = 9
    })

    local currentValue = defaultValue

    local function updateValue()
        local inputText = inputBox.Text:gsub("%s", "")
        local numValue = tonumber(inputText)

        if numValue and numValue >= 0 then
            currentValue = numValue
            inputBox.TextColor3 = colors.success
            onChange(numValue)
            TweenService:Create(inputStroke, TweenInfo.new(0.15), {
                Color = colors.success,
                Thickness = 1
            }):Play()
            task.wait(0.3)
            TweenService:Create(inputStroke, TweenInfo.new(0.15), {
                Color = colors.primary,
                Thickness = 0
            }):Play()
        else
            inputBox.TextColor3 = colors.danger
            TweenService:Create(inputStroke, TweenInfo.new(0.15), {
                Color = colors.danger,
                Thickness = 1
            }):Play()
            task.wait(0.5)
            TweenService:Create(inputStroke, TweenInfo.new(0.15), {
                Color = colors.primary,
                Thickness = 0
            }):Play()
            inputBox.Text = tostring(currentValue)
            inputBox.TextColor3 = colors.text
        end
    end

    -- Event untuk focus
    inputBox.FocusLost:Connect(function()
        updateValue()
    end)

    -- Hover effect
    inputBg.MouseEnter:Connect(function()
        TweenService:Create(inputBg, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(inputStroke, TweenInfo.new(0.15), {
            Thickness = 1
        }):Play()
    end)

    inputBg.MouseLeave:Connect(function()
        if not inputBox:IsFocused() then
            TweenService:Create(inputBg, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.4
            }):Play()
            TweenService:Create(inputStroke, TweenInfo.new(0.15), {
                Thickness = 0
            }):Play()
        end
    end)

    return frame
end

-- Modern Button
local function makeButton(parent, label, callback)
    local btnFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = colors.primary,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 8
    })
    new("UICorner", {Parent = btnFrame, CornerRadius = UDim.new(0, 6)})
    new("UIGradient", {
        Parent = btnFrame,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        },
        Rotation = 45
    })

    local btnStroke = new("UIStroke", {
        Parent = btnFrame,
        Color = colors.primary,
        Thickness = 0,
        Transparency = 0.6
    })

    local button = new("TextButton", {
        Parent = btnFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = colors.text,
        AutoButtonColor = false,
        ZIndex = 9
    })

    button.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0,
            Size = UDim2.new(1, 0, 0, 35)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Thickness = 1.5}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(1, 0, 0, 32)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Thickness = 0}):Play()
    end)

    button.MouseButton1Click:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.08), {Size = UDim2.new(0.96, 0, 0, 30)}):Play()
        task.wait(0.08)
        TweenService:Create(btnFrame, TweenInfo.new(0.08), {Size = UDim2.new(1, 0, 0, 32)}):Play()
        pcall(callback)
    end)

    return btnFrame
end

-- LynxGUI_v2.2.lua - Bagian 3: Dropdown & Helper Functions
-- Dilanjutkan dari Bagian 2

-- ============ DROPDOWN COMPONENT ============

local function makeDropdown(parent, title, icon, items, onSelect, uniqueId)
    local dropdownFrame = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = colors.bg2,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 7,
        Name = uniqueId or "Dropdown"
    })
    new("UICorner", {Parent = dropdownFrame, CornerRadius = UDim.new(0, 8)})

    local dropStroke = new("UIStroke", {
        Parent = dropdownFrame,
        Color = colors.primary,
        Thickness = 0,
        Transparency = 0.8
    })

    local header = new("TextButton", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, -8, 0, 36),
        Position = UDim2.new(0, 4, 0, 2),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 8
    })

    local iconLabel = new("TextLabel", {
        Parent = header,
        Text = icon,
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = colors.primary,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9
    })

    local titleLabel = new("TextLabel", {
        Parent = header,
        Text = title,
        Size = UDim2.new(1, -70, 0, 14),
        Position = UDim2.new(0, 32, 0, 4),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9
    })

    local statusLabel = new("TextLabel", {
        Parent = header,
        Text = "None Selected",
        Size = UDim2.new(1, -70, 0, 12),
        Position = UDim2.new(0, 32, 0, 18),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = colors.textDimmer,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9
    })

    local arrow = new("TextLabel", {
        Parent = header,
        Text = "▼",
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -24, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = colors.primary,
        ZIndex = 9
    })

    local listContainer = new("ScrollingFrame", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, -8, 0, 0),
        Position = UDim2.new(0, 4, 0, 40),
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
    new("UIListLayout", {Parent = listContainer, Padding = UDim.new(0, 4)})
    new("UIPadding", {Parent = listContainer, PaddingBottom = UDim.new(0, 6), PaddingTop = UDim.new(0, 4)})

    local isOpen = false
    local selectedItem = nil

    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listContainer.Visible = isOpen

        TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Rotation = isOpen and 180 or 0}):Play()
        TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = isOpen and colors.bg3 or colors.bg2,
            BackgroundTransparency = isOpen and 0.2 or 0.4
        }):Play()
        TweenService:Create(dropStroke, TweenInfo.new(0.2), {Thickness = isOpen and 1 or 0}):Play()

        if isOpen then
            local itemCount = #items
            local maxHeight = 160
            local itemHeight = 30
            local calculatedHeight = math.min(itemCount * itemHeight, maxHeight)
            listContainer.Size = UDim2.new(1, -8, 0, calculatedHeight)
        end
    end)

    -- Hover effect pada header
    header.MouseEnter:Connect(function()
        TweenService:Create(dropdownFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.3
        }):Play()
    end)
    header.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(dropdownFrame, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.4
            }):Play()
        end
    end)

    for _, itemName in ipairs(items) do
        local itemBtn = new("TextButton", {
            Parent = listContainer,
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = colors.bg3,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 11
        })
        new("UICorner", {Parent = itemBtn, CornerRadius = UDim.new(0, 6)})

        local itemStroke = new("UIStroke", {
            Parent = itemBtn,
            Color = colors.primary,
            Thickness = 0,
            Transparency = 0.8
        })

        local btnLabel = new("TextLabel", {
            Parent = itemBtn,
            Text = itemName,
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            TextColor3 = colors.textDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 12
        })

        itemBtn.MouseEnter:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = colors.primary,
                    BackgroundTransparency = 0.2
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.15), {TextColor3 = colors.text}):Play()
                TweenService:Create(itemStroke, TweenInfo.new(0.15), {Thickness = 1}):Play()
            end
        end)

        itemBtn.MouseLeave:Connect(function()
            if selectedItem ~= itemName then
                TweenService:Create(itemBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = colors.bg3,
                    BackgroundTransparency = 0.5
                }):Play()
                TweenService:Create(btnLabel, TweenInfo.new(0.15), {TextColor3 = colors.textDim}):Play()
                TweenService:Create(itemStroke, TweenInfo.new(0.15), {Thickness = 0}):Play()
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
            TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Rotation = 0}):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.bg2,
                BackgroundTransparency = 0.4
            }):Play()
            TweenService:Create(dropStroke, TweenInfo.new(0.2), {Thickness = 0}):Play()
        end)
    end

    return dropdownFrame
end

-- ============ MINIMIZED ICON & WINDOW MANAGEMENT ============

local minimized = false
local icon
local savedIconPos = UDim2.new(0, 20, 0, 120)

local function createMinimizedIcon()
    if icon then return end
    icon = new("ImageLabel", {
        Parent = gui,
        Size = UDim2.new(0, 50, 0, 50),
        Position = savedIconPos,
        BackgroundColor3 = colors.primary,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Image = "rbxassetid://111416780887356",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 100
    })
    new("UICorner", {Parent = icon, CornerRadius = UDim.new(0, 8)})
    new("UIGradient", {
        Parent = icon,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.primary),
            ColorSequenceKeypoint.new(1, colors.accent)
        },
        Rotation = 45
    })
    new("UIStroke", {
        Parent = icon,
        Color = colors.primary,
        Thickness = 1,
        Transparency = 0.6
    })

    local dragging, dragStart, startPos, dragMoved = false, nil, nil, false
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragMoved, dragStart, startPos = true, false, input.Position, icon.Position
        end
    end)

    icon.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.sqrt(delta.X^2 + delta.Y^2) > 5 then dragMoved = true end
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(icon, TweenInfo.new(0.05), {Position = newPos}):Play()
        end
    end)

    icon.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                savedIconPos = icon.Position
                if not dragMoved then
                    win.Visible = true
                    TweenService:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = windowSize,
                        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
                    }):Play()
                    if icon then icon:Destroy() icon = nil end
                    minimized = false
                end
            end
        end
    end)
end

-- ============ WINDOW DRAGGING ============

local dragging, dragStart, startPos = false, nil, nil
local dragTween = nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, win.Position
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
        dragTween = TweenService:Create(win, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = newPos})
        dragTween:Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ============ WINDOW RESIZING ============

local resizing = false
local resizeStart, startSize = nil, nil
local resizeTween = nil

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing, resizeStart, startSize = true, input.Position, win.Size
        if resizeTween then resizeTween:Cancel() end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart

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

        local newSize = UDim2.new(0, newWidth, 0, newHeight)

        if resizeTween then resizeTween:Cancel() end
        resizeTween = TweenService:Create(win, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
            Size = newSize
        })
        resizeTween:Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

-- ============ MINIMIZE BUTTON ============

btnMin.MouseEnter:Connect(function()
    TweenService:Create(btnMin, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 33, 0, 33)
    }):Play()
end)

btnMin.MouseLeave:Connect(function()
    if not minimized then
        TweenService:Create(btnMin, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 30, 0, 30)
        }):Play()
    end
end)

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        local targetPos = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(win, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = targetPos
        }):Play()
        task.wait(0.3)
        win.Visible = false
        createMinimizedIcon()
        minimized = true
    end
end)

-- ============ OPENING ANIMATION ============

task.spawn(function()
    win.Size = UDim2.new(0, 0, 0, 0)
    win.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)

    task.wait(0.1)

    TweenService:Create(win, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = windowSize
    }):Play()
end)

-- ============ RESIZE HANDLE HOVER ============

resizeHandle.MouseEnter:Connect(function()
    TweenService:Create(resizeHandle, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2,
        Size = UDim2.new(0, 16, 0, 16)
    }):Play()
end)

resizeHandle.MouseLeave:Connect(function()
    if not resizing then
        TweenService:Create(resizeHandle, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.4,
            Size = UDim2.new(0, 14, 0, 14)
        }):Play()
    end
end)

-- LynxGUI_v2.2.lua - Bagian 4 FINAL: Pages & Integration
-- Dilanjutkan dari Bagian 3

-- ============ PAGE SYSTEM ============

local pages = {}
local currentPageName = "Main"

local function createPage(name)
    local page = new("ScrollingFrame", {
        Parent = pagesContainer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = colors.primary,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = name == "Main",
        ClipsDescendants = true,
        ZIndex = 5
    })
    new("UIListLayout", {
        Parent = page,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    new("UIPadding", {
        Parent = page,
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4)
    })
    pages[name] = page
    return page
end

local mainPage = createPage("Main")
local teleportPage = createPage("Teleport")
local shopPage = createPage("Shop")
local settingsPage = createPage("Settings")
local infoPage = createPage("Info")

-- ============ MAIN PAGE ============

local catAutoFishing = makeCategory(mainPage, "Auto Fishing", "🎣")

local currentInstantMode = "None"
local fishingDelayValue = 1.30
local cancelDelayValue = 0.19

makeDropdown(catAutoFishing, "Instant Mode", "⚡", {"Fast", "Perfect"}, function(mode)
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

makeToggle(catAutoFishing, "Enable Instant", function(on)
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

makeInputDelay(catAutoFishing, "Fishing Delay", 1.30, function(v)
    fishingDelayValue = v
    instant.Settings.MaxWaitTime = v
    instant2.Settings.MaxWaitTime = v
end)

makeInputDelay(catAutoFishing, "Cancel Delay", 0.19, function(v)
    cancelDelayValue = v
    instant.Settings.CancelDelay = v
    instant2.Settings.CancelDelay = v
end)

local catBlatantV1 = makeCategory(mainPage, "Blatant V1", "💀")

makeToggle(catBlatantV1, "Enable Blatant V1", function(on)
    if on then
        blatantv1.Start()
    else
        blatantv1.Stop()
    end
end)

makeInputDelay(catBlatantV1, "Complete Delay", 0.05, function(v)
    blatantv1.Settings.CompleteDelay = v
end)

makeInputDelay(catBlatantV1, "Cancel Delay", 0.1, function(v)
    blatantv1.Settings.CancelDelay = v
end)

local catBlatantV2 = makeCategory(mainPage, "Blatant V2", "🔥")

makeToggle(catBlatantV2, "Enable Blatant V2", function(on)
    if on then
        blatantv2.Start()
    else
        blatantv2.Stop()
    end
end)

makeInputDelay(catBlatantV2, "Fishing Delay", 0.05, function(v)
    blatantv2.Settings.FishingDelay = v
end)

makeInputDelay(catBlatantV2, "Cancel Delay", 0.01, function(v)
    blatantv2.Settings.CancelDelay = v
end)

makeInputDelay(catBlatantV2, "Hook Wait Time", 0.15, function(v)
    blatantv2.Settings.HookWaitTime = v
end)

makeInputDelay(catBlatantV2, "Cast Delay", 0.03, function(v)
    blatantv2.Settings.CastDelay = v
end)

makeInputDelay(catBlatantV2, "Timeout Delay", 0.8, function(v)
    blatantv2.Settings.TimeoutDelay = v
end)

local catSupport = makeCategory(mainPage, "Support Features", "🛠️")

makeToggle(catSupport, "No Fishing Animation", function(on)
    if on then
        NoFishingAnimation.StartWithDelay()
    else
        NoFishingAnimation.Stop()
    end
end)

-- ============ TELEPORT PAGE ============

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

-- ============ SHOP PAGE ============

local catSell = makeCategory(shopPage, "Auto Sell System", "💰")

makeButton(catSell, "Sell All Now", function()
    if AutoSell and AutoSell.SellOnce then
        AutoSell.SellOnce()
    end
end)

local catTimer = makeCategory(shopPage, "Auto Sell Timer", "⏰")

makeInputDelay(catTimer, "Sell Interval (seconds)", 5, function(value)
    if AutoSellTimer and AutoSellTimer.SetInterval then
        AutoSellTimer.SetInterval(value)
    end
end)

makeButton(catTimer, "Start Auto Sell", function()
    if AutoSellTimer and AutoSellTimer.Start then
        AutoSellTimer.Start(AutoSellTimer.Interval or 5)
    end
end)

makeButton(catTimer, "Stop Auto Sell", function()
    if AutoSellTimer and AutoSellTimer.Stop then
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
    if AutoBuyWeather.SetSelected then
        AutoBuyWeather.SetSelected(selectedWeathers)
    end
end, "WeatherDropdown")

makeToggle(catWeather, "Enable Auto Weather", function(on)
    if on then
        AutoBuyWeather.Start()
    else
        AutoBuyWeather.Stop()
    end
end)

-- ============ SETTINGS PAGE ============

local catAFK = makeCategory(settingsPage, "Anti-AFK Protection", "🧍")

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

-- ============ INFO PAGE ============

local infoContainer = new("Frame", {
    Parent = infoPage,
    Size = UDim2.new(1, 0, 0, 0),
    BackgroundColor3 = colors.bg2,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    AutomaticSize = Enum.AutomaticSize.Y,
    ZIndex = 6
})
new("UICorner", {Parent = infoContainer, CornerRadius = UDim.new(0, 8)})
new("UIStroke", {
    Parent = infoContainer,
    Color = colors.primary,
    Thickness = 1,
    Transparency = 0.8
})

local infoText = new("TextLabel", {
    Parent = infoContainer,
    Size = UDim2.new(1, -16, 1, -16),
    Position = UDim2.new(0, 8, 0, 8),
    BackgroundTransparency = 1,
    Text = [[
🧡 LYNX v2.2
ORANGE EDITION

━━━━━━━━━━━━━━━━

🎣 AUTO FISHING
• Instant Fishing Mode
• Blatant V1 & V2
• Input Delay Control
• No Animation

🌍 TELEPORT
• Location Teleport
• Player Teleport

💰 SHOP
• Auto Sell (Instant)
• Auto Sell Timer
• Auto Buy Weather

⚙️ SETTINGS
• Anti-AFK Protection
• FPS Unlocker
• General Settings

━━━━━━━━━━━━━━━━

💡 v2.2 IMPROVEMENTS
✓ Minimalist Design
✓ Black Transparent UI
✓ Input Delay System
✓ Smooth Animations
✓ Mobile Optimized
✓ Compact Layout
✓ Subtle Corners
✓ Minimize Only
✓ No Logo in Window

🎮 CONTROLS
• Drag top bar to move
• Drag corner to resize
• (─) Minimize window
• Click to restore

━━━━━━━━━━━━━━━━

Created with 🧡
Lynx Team 2024
    ]],
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = colors.text,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    ZIndex = 7
})

-- ============ PAGE NAVIGATION ============

local pageButtons = {}

local function switchPage(pageName)
    if currentPageName == pageName then return end
    
    for name, page in pairs(pages) do
        if name == pageName then
            TweenService:Create(page, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
            page.Visible = true
        else
            page.Visible = false
        end
    end
    
    pageTitle.Text = pageName
    currentPageName = pageName
end

-- Quick page switching (optional - dapat diakses via navigation di masa depan)
local function setupPageNavigation()
    -- Bisa ditambahkan navigation bar di sini jika diperlukan
    -- Untuk sekarang, hanya main page yang aktif
end

setupPageNavigation()

-- ============ FINAL SETUP ============

-- Hover effect untuk topBar
topBar.MouseEnter:Connect(function()
    TweenService:Create(topBar, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.3
    }):Play()
end)

topBar.MouseLeave:Connect(function()
    if not dragging then
        TweenService:Create(topBar, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.5
        }):Play()
    end
end)

-- Window open animation complete
task.wait(0.6)
print("🎉 LYNX GUI v2.2 FULLY LOADED!")
print("✨ Orange Edition - Minimalist Black Theme")
print("📱 Mobile First Design")
print("🖱️ Drag from top | Resize from corner")
print("─ Minimize | ✓ Restore")
print("")
print("🧡 Ready to use!")

return {
    gui = gui,
    switchPage = switchPage,
    pages = pages,
    colors = colors
}
