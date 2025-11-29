-- NotificationModule.lua
-- Custom Notification System (Slide-In, Bottom Right, Stackable)

local Notification = {}
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Folder untuk semua notifikasi
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomNotificationUI"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local NotificationsFolder = Instance.new("Frame")
NotificationsFolder.Name = "NotificationContainer"
NotificationsFolder.Parent = ScreenGui
NotificationsFolder.AnchorPoint = Vector2.new(1,1)
NotificationsFolder.Position = UDim2.new(1, -20, 1, -20)
NotificationsFolder.Size = UDim2.new(0, 300, 1, 0)
NotificationsFolder.BackgroundTransparency = 1

-- Offset untuk stacking
local stackOffset = 0

-- Fungsi utama notifikasi
function Notification.Send(title, text, duration)
    duration = duration or 4

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 70)
    notif.Position = UDim2.new(1, 310, 1, -(stackOffset + 80))
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notif.BackgroundTransparency = 0.15
    notif.BorderSizePixel = 0
    notif.Parent = NotificationsFolder
    notif.ClipsDescendants = true
    notif.ZIndex = 10
    notif:SetAttribute("Alive", true)

    -- Corner
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 12)

    -- Stroke
    local stroke = Instance.new("UIStroke", notif)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Thickness = 1

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notif
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = notif
    textLabel.Size = UDim2.new(1, -20, 0, 40)
    textLabel.Position = UDim2.new(0, 10, 0, 28)
    textLabel.Text = text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.BackgroundTransparency = 1
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true

    -- Slide-in animation
    TweenService:Create(notif, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, 0, 1, -(stackOffset + 80))
    }):Play()

    -- Tambahkan offset untuk notifikasi berikutnya
    stackOffset = stackOffset + 80

    -- Auto remove
    task.delay(duration, function()
        if notif:GetAttribute("Alive") then
            notif:SetAttribute("Alive", false)

            -- Slide-out animation
            TweenService:Create(notif, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 310, 1, -(stackOffset + 80))
            }):Play()

            task.wait(0.45)
            notif:Destroy()

            -- Kurangi offset untuk stack
            stackOffset = math.max(0, stackOffset - 80)
        end
    end)
end

return Notification
