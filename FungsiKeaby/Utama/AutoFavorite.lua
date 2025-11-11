-- ⚡ FungsiKeaby/Inventory/AutoFavorite.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local AutoFavorite = {
	Enabled = false,
	SelectedRarities = { "Epic" },
	AllRarities = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret" },
}

-- 🧩 Debug untuk menemukan lokasi inventory sebenarnya
task.defer(function()
	print("🔍 [AutoFavorite DEBUG] Memindai kemungkinan lokasi inventory player...")

	for _, obj in ipairs(game:GetDescendants()) do
		local name = string.lower(obj.Name)
		if string.find(name, "fish") or string.find(name, "inventory") or string.find(name, "bag") then
			if not obj:IsDescendantOf(localPlayer:WaitForChild("PlayerGui")) then
				print("📁 Kandidat Inventory:", obj:GetFullName())
			end
		end
	end

	print("🔍 [AutoFavorite DEBUG] Selesai scanning.")
end)


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

-- 🔍 Deep scan cari inventory secara rekursif
local function deepSearchInventory(root, depth)
	if depth > 5 then return nil end
	for _, child in ipairs(root:GetChildren()) do
		local name = string.lower(child.Name)
		if string.find(name, "inventory") or string.find(name, "fish") or string.find(name, "bag") or string.find(name, "storage") or string.find(name, "item") then
			if #child:GetChildren() > 0 then
				print("📦 [AutoFavorite] Inventory ditemukan di:", child:GetFullName())
				return child
			end
		end
		local found = deepSearchInventory(child, depth + 1)
		if found then return found end
	end
	return nil
end

-- Cari di lokasi umum + scan fallback
local function findInventory()
	local locations = {
		localPlayer,
		localPlayer:FindFirstChild("PlayerGui"),
		localPlayer:FindFirstChild("Backpack"),
		ReplicatedStorage,
	}

	for _, loc in ipairs(locations) do
		local found = deepSearchInventory(loc, 1)
		if found then return found end
	end

	print("⚠️ [AutoFavorite] Tidak menemukan inventory setelah pencarian penuh.")
	return nil
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

