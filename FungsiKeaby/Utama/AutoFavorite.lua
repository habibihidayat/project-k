-- ⚡ FungsiKeaby/Inventory/AutoFavorite.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local AutoFavorite = {
    Enabled = false,
    SelectedRarities = { "Epic" },
    AllRarities = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret" },
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

-- 🔍 Cari lokasi inventory pemain
local function findInventory()
    local possibleLocations = {
        localPlayer:FindFirstChild("Inventory"),
        localPlayer:FindFirstChild("Backpack"),
        ReplicatedStorage:FindFirstChild("Inventory"),
        ReplicatedStorage:FindFirstChild("PlayerInventories") and ReplicatedStorage.PlayerInventories:FindFirstChild(localPlayer.Name),
        localPlayer:FindFirstChild("PlayerGui") and localPlayer.PlayerGui:FindFirstChild("InventoryFrame"),
    }

    for _, inv in ipairs(possibleLocations) do
        if inv and #inv:GetChildren() > 0 then
            print("📦 [AutoFavorite] Inventory ditemukan di:", inv:GetFullName())
            return inv
        end
    end

    print("⚠️ [AutoFavorite] Tidak menemukan inventory, gunakan default localPlayer.Inventory jika muncul belakangan.")
    return localPlayer:FindFirstChild("Inventory") or nil
end

local favoriteRemote = findFavoriteRemote()
local inventory = findInventory()

-- 💫 Favorite semua ikan dengan rarity tertentu
local function favoriteFishByRarities()
    inventory = inventory or findInventory()
    if not inventory then
        warn("❌ Inventory tidak ditemukan!")
        return
    end

    if not favoriteRemote then
        warn("❌ Favorite remote not found!")
        return
    end

    for _, item in ipairs(inventory:GetChildren()) do
        local rarityValue = item:FindFirstChild("Rarity")
        local rarity = rarityValue and rarityValue.Value or item:GetAttribute("Rarity")
        if rarity and table.find(AutoFavorite.SelectedRarities, rarity) then
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
    print("🟢 [AutoFavorite] Aktif untuk rarity:", table.concat(AutoFavorite.SelectedRarities, ", "))

    task.spawn(function()
        while AutoFavorite.Enabled do
            favoriteFishByRarities()
            task.wait(5)
        end
    end)
end

function AutoFavorite.Stop()
    AutoFavorite.Enabled = false
    print("🔴 [AutoFavorite] Dinonaktifkan")
end

-- 🧭 Tambah / hapus rarity dari daftar aktif
function AutoFavorite.ToggleRarity(rarity)
    local idx = table.find(AutoFavorite.SelectedRarities, rarity)
    if idx then
        table.remove(AutoFavorite.SelectedRarities, idx)
        print("❌ [AutoFavorite] Rarity dimatikan:", rarity)
    else
        table.insert(AutoFavorite.SelectedRarities, rarity)
        print("✅ [AutoFavorite] Rarity diaktifkan:", rarity)
    end
end

return AutoFavorite
