-- ============================================
-- AUTO FAVORITE MODULE - FISH IT ROBLOX
-- ============================================
-- File: AutoFavoriteModule.lua

local AutoFavorite = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Variables
local Player = Players.LocalPlayer
local isRunning = false
local debugMode = true -- Set false untuk disable debug prints

-- Settings
AutoFavorite.Settings = {
    SelectedRarities = {}, -- Rarities yang akan di-favorite
    CheckInterval = 0.5, -- Check setiap 0.5 detik
}

-- All available rarities
AutoFavorite.AllRarities = {
    "Common",
    "Uncommon", 
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Secret"
}

-- ============================================
-- DEBUG FUNCTIONS
-- ============================================

local function DebugPrint(...)
    if debugMode then
        print("[AUTO FAVORITE DEBUG]", ...)
    end
end

local function DebugWarn(...)
    if debugMode then
        warn("[AUTO FAVORITE DEBUG]", ...)
    end
end

-- ============================================
-- INVENTORY DETECTION FUNCTIONS
-- ============================================

local function FindInventoryData()
    DebugPrint("========================================")
    DebugPrint("MENCARI INVENTORY DATA...")
    DebugPrint("========================================")
    
    -- Method 1: Cek ReplicatedStorage untuk Modules/Data
    DebugPrint("\n[1] Checking ReplicatedStorage...")
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        local name = item.Name:lower()
        if name:find("inventory") or name:find("backpack") or name:find("fish") or name:find("item") then
            DebugPrint("  → Found:", item:GetFullName(), "| Type:", item.ClassName)
        end
    end
    
    -- Method 2: Cek Player Data
    DebugPrint("\n[2] Checking Player Data...")
    if Player:FindFirstChild("Data") then
        DebugPrint("  → Player.Data found!")
        for _, item in pairs(Player.Data:GetDescendants()) do
            DebugPrint("    →", item:GetFullName(), "| Type:", item.ClassName, "| Value:", tostring(item.Value or "N/A"))
        end
    else
        DebugWarn("  → Player.Data NOT found!")
    end
    
    -- Method 3: Cek PlayerGui untuk Inventory UI
    DebugPrint("\n[3] Checking PlayerGui...")
    local PlayerGui = Player:WaitForChild("PlayerGui")
    for _, gui in pairs(PlayerGui:GetDescendants()) do
        local name = gui.Name:lower()
        if name:find("inventory") or name:find("backpack") or name:find("storage") then
            DebugPrint("  → Found GUI:", gui:GetFullName(), "| Type:", gui.ClassName)
        end
    end
    
    -- Method 4: Cek RemoteEvents/RemoteFunctions
    DebugPrint("\n[4] Checking Remote Events...")
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name:lower()
            if name:find("favorite") or name:find("inventory") or name:find("fish") or name:find("item") then
                DebugPrint("  → Found Remote:", remote:GetFullName(), "| Type:", remote.ClassName)
            end
        end
    end
    
    DebugPrint("\n========================================")
    DebugPrint("DEBUG SCAN SELESAI!")
    DebugPrint("========================================")
end

-- ============================================
-- INVENTORY LISTENER
-- ============================================

local function SetupInventoryListener()
    DebugPrint("\n[SETUP] Mencoba setup listener...")
    
    -- Method 1: Listen ke ChildAdded di PlayerGui
    local PlayerGui = Player:WaitForChild("PlayerGui")
    
    -- Cari Inventory GUI
    local inventoryGui = nil
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui.Name:lower():find("inventory") or gui.Name:lower():find("backpack") then
            inventoryGui = gui
            DebugPrint("[LISTENER] Found Inventory GUI:", gui.Name)
            break
        end
    end
    
    if inventoryGui then
        -- Listen ke perubahan di inventory
        inventoryGui.DescendantAdded:Connect(function(descendant)
            DebugPrint("[EVENT] New item added to inventory!")
            DebugPrint("  → Name:", descendant.Name)
            DebugPrint("  → Type:", descendant.ClassName)
            DebugPrint("  → Parent:", descendant.Parent.Name)
            
            -- Cek apakah ini fish item
            if descendant:IsA("Frame") or descendant:IsA("TextLabel") or descendant:IsA("ImageLabel") then
                for _, child in pairs(descendant:GetDescendants()) do
                    DebugPrint("    → Child:", child.Name, "=", tostring(child.Text or child.Value or "N/A"))
                end
            end
        end)
        
        DebugPrint("[LISTENER] Inventory listener setup complete!")
    else
        DebugWarn("[LISTENER] Inventory GUI not found!")
    end
    
    -- Method 2: Listen ke RemoteEvent
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("fish") or name:find("catch") or name:find("inventory") then
                DebugPrint("[REMOTE] Hooking to:", remote:GetFullName())
                
                -- Hook the remote (dapat menyebabkan error di beberapa executor)
                pcall(function()
                    local oldFireServer = remote.FireServer
                    remote.FireServer = function(...)
                        local args = {...}
                        DebugPrint("[REMOTE FIRED]", remote.Name)
                        for i, arg in pairs(args) do
                            DebugPrint("  → Arg", i, ":", tostring(arg))
                        end
                        return oldFireServer(...)
                    end
                end)
            end
        end
    end
end

-- ============================================
-- FISH DETECTION & FAVORITE LOGIC
-- ============================================

local function GetFishRarity(fishData)
    -- Coba berbagai cara untuk mendapatkan rarity
    if type(fishData) == "table" then
        return fishData.Rarity or fishData.rarity or fishData.Tier or fishData.tier
    elseif type(fishData) == "string" then
        -- Parse dari string jika format "Name [Rarity]"
        local rarity = fishData:match("%[(.-)%]")
        return rarity
    end
    return nil
end

local function ShouldFavorite(rarity)
    if not rarity then return false end
    
    for _, selectedRarity in pairs(AutoFavorite.Settings.SelectedRarities) do
        if rarity:lower() == selectedRarity:lower() then
            return true
        end
    end
    
    return false
end

local function FavoriteFish(fishId)
    DebugPrint("[FAVORITE] Attempting to favorite fish:", fishId)
    
    -- Cari RemoteEvent untuk favorite
    local favoriteRemote = ReplicatedStorage:FindFirstChild("FavoriteFish", true) or
                          ReplicatedStorage:FindFirstChild("Favorite", true) or
                          ReplicatedStorage:FindFirstChild("ToggleFavorite", true)
    
    if favoriteRemote and favoriteRemote:IsA("RemoteEvent") then
        DebugPrint("[FAVORITE] Found remote:", favoriteRemote:GetFullName())
        favoriteRemote:FireServer(fishId)
        DebugPrint("[FAVORITE] Successfully favorited!")
        return true
    else
        DebugWarn("[FAVORITE] Favorite remote not found!")
        return false
    end
end

-- ============================================
-- MAIN AUTO FAVORITE LOGIC
-- ============================================

local connection = nil

function AutoFavorite.Start()
    if isRunning then
        DebugWarn("Auto Favorite sudah berjalan!")
        return false
    end
    
    isRunning = true
    DebugPrint("========================================")
    DebugPrint("AUTO FAVORITE STARTED!")
    DebugPrint("Selected Rarities:", table.concat(AutoFavorite.Settings.SelectedRarities, ", "))
    DebugPrint("========================================")
    
    -- Setup listener
    SetupInventoryListener()
    
    -- Main loop untuk check inventory
    connection = RunService.Heartbeat:Connect(function()
        if not isRunning then return end
        
        -- TODO: Implement actual fish detection
        -- Ini akan diupdate setelah kita tahu struktur data yang benar
        
    end)
    
    return true
end

function AutoFavorite.Stop()
    if not isRunning then
        DebugWarn("Auto Favorite tidak sedang berjalan!")
        return false
    end
    
    isRunning = false
    
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    DebugPrint("========================================")
    DebugPrint("AUTO FAVORITE STOPPED!")
    DebugPrint("========================================")
    
    return true
end

function AutoFavorite.IsRunning()
    return isRunning
end

function AutoFavorite.SetRarities(rarities)
    AutoFavorite.Settings.SelectedRarities = rarities
    DebugPrint("[SETTINGS] Rarities updated:", table.concat(rarities, ", "))
end

function AutoFavorite.ToggleDebug(enable)
    debugMode = enable
    DebugPrint("Debug mode:", enable and "ENABLED" or "DISABLED")
end

function AutoFavorite.RunDebugScan()
    FindInventoryData()
end

-- ============================================
-- AUTO SCAN ON LOAD
-- ============================================
task.spawn(function()
    task.wait(2) -- Wait untuk game load
    DebugPrint("\n🔍 Running initial debug scan...")
    FindInventoryData()
end)

-- ============================================
-- INFO
-- ============================================
print("╔════════════════════════════════════════╗")
print("║     AUTO FAVORITE MODULE - LOADED      ║")
print("╚════════════════════════════════════════╝")
print("► Debug Mode: ENABLED")
print("► Call AutoFavorite.RunDebugScan() for manual scan")
print("═════════════════════════════════════════")

return AutoFavorite
