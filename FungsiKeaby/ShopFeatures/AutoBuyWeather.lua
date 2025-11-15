-- ============================================================================
-- 📦 AutoBuyWeather.lua
-- Lokasi: FungsiKeaby/ShopFeatures/AutoBuyWeather.lua
-- Sistem Auto Beli Weather sesuai pilihan user
-- ============================================================================

local AutoBuyWeather = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local enabled = false
local chosenWeather = nil
local connection

-- Remote path (sesuaikan bila berbeda)
local WeatherEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("BuyWeather")

-- 🌤️ Daftar cuaca yang tersedia (sesuaikan dengan server kamu)
local WeatherList = {
    "Stormy",
    "Rainy",
    "Sunny",
    "Foggy",
    "Windy"
}

function AutoBuyWeather.GetWeatherList()
    return WeatherList
end

-- 🔘 Dipanggil dari GUI ketika toggle ON/OFF berubah
function AutoBuyWeather.SetEnabled(state)
    enabled = state

    -- Jika mati → hentikan listener
    if not enabled then
        if connection then connection:Disconnect() end
        connection = nil
        return
    end

    -- Jika hidup → jalankan auto-buy loop
    if not connection then
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not enabled or not chosenWeather then return end
            
            -- Kirim remote request beli cuaca
            WeatherEvent:FireServer(chosenWeather)
        end)
    end
end

-- 🧭 Dipanggil GUI saat dropdown berubah
function AutoBuyWeather.SetWeather(name)
    chosenWeather = name
end

return AutoBuyWeather
