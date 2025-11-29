-- NotificationModule.lua
-- Notifikasi sederhana yang 100% muncul di Delta / Arceus / Solara

local NotificationModule = {}

function NotificationModule.Send(title, text, duration)
    duration = duration or 4

    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration
        })
    end)
end

return NotificationModule
