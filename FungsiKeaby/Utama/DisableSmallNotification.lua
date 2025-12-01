-- DisableSmallNotification.lua
local module = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local active = false

-- Fungsi utama untuk disable small notification
local function disableNotifications()
    if not player or not player:FindFirstChild("PlayerGui") then return end
    local gui = player.PlayerGui

    -- Hapus jika sudah ada
    local existing = gui:FindFirstChild("Small Notification")
    if existing then
        existing:Destroy()
    end
end

-- Loop terus menerus untuk memaksa disable
local function startLoop()
    if active then return end
    active = true

    -- Cek setiap frame
    RunService.Heartbeat:Connect(function()
        if active then
            disableNotifications()
        end
    end)

    -- Juga deteksi ketika ada yang ditambahkan
    player.PlayerGui.ChildAdded:Connect(function(child)
        if active and child.Name == "Small Notification" then
            child:Destroy()
        end
    end)
end

local function stopLoop()
    active = false
end

module.Start = startLoop
module.Stop = stopLoop

return module
