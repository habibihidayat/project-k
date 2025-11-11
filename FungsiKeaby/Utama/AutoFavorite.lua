-- ⚡ FungsiKeaby/Inventory/AutoFavorite.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local AutoFavorite = {
    Enabled = false,
    SelectedRarity = "Epic",
}

-- 🔍 Cari Remote Favorite otomatis
local function findFavoriteRemote()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = string.lower(obj.Name)
            if string.find(name, "favorite") or string.find(name, "fav") then
                print("🌟 [AutoFavorite] Found Favorite Remote:", obj:GetFullName())
                return obj
            end
        end
    end
    return nil
end

local favoriteRemote = findFavoriteRemote()

-- 💫 Fungsi untuk favorite semua ikan dengan rarity tertentu
local function favoriteFishByRarity(rarity)
    if not favoriteRemote then
        warn("❌ Favorite remote not found!")
        return
    end

    local inv = localPlayer:FindFirstChild("Inventory")
    if not inv then
        warn("❌ Inventory tidak ditemukan!")
        return
    end

    for _, item in ipairs(inv:GetChildren()) do
        local rarityValue = item:FindFirstChild("Rarity")
        if rarityValue and rarityValue.Value == rarity then
            print("⭐ Favoriting:", item.Name, "(" .. rarity .. ")")
            pcall(function()
                if favoriteRemote:IsA("RemoteEvent") then
                    favoriteRemote:FireServer(item)
                elseif favoriteRemote:IsA("RemoteFunction") then
                    favoriteRemote:InvokeServer(item)
                end
            end)
        end
    end
end

-- 🚀 Start / Stop logic
function AutoFavorite.Start()
    if AutoFavorite.Enabled then return end
    AutoFavorite.Enabled = true

    task.spawn(function()
        while AutoFavorite.Enabled do
            favoriteFishByRarity(AutoFavorite.SelectedRarity)
            task.wait(5)
        end
    end)
    print("🟢 [AutoFavorite] Aktif untuk rarity:", AutoFavorite.SelectedRarity)
end

function AutoFavorite.Stop()
    AutoFavorite.Enabled = false
    print("🔴 [AutoFavorite] Dinonaktifkan")
end

function AutoFavorite.SetRarity(rarity)
    AutoFavorite.SelectedRarity = rarity
    print("🎯 [AutoFavorite] Rarity diatur ke:", rarity)
end

return AutoFavorite
