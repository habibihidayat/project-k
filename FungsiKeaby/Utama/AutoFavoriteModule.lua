-- ============================================
-- AUTO FAVORITE MODULE - FISH IT ROBLOX (UPDATED)
-- ============================================

local AutoFavorite = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local isRunning = false
local debugMode = true

-- Settings
AutoFavorite.Settings = {
    SelectedRarities = {},
    CheckInterval = 0.5,
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

-- Remotes (berdasarkan hasil scan)
local FavoriteItemRemote = nil
local FishCaughtRemote = nil

-- Connections
local fishCaughtConnection = nil

-- ============================================
-- DEBUG FUNCTIONS
-- ============================================

local function DebugPrint(...)
    if debugMode then
        print("[AUTO FAVORITE]", ...)
    end
end

local function DebugWarn(...)
    if debugMode then
        warn("[AUTO FAVORITE]", ...)
    end
end

-- ============================================
-- INITIALIZE REMOTES
-- ============================================

local function InitializeRemotes()
    DebugPrint("Initializing remotes...")
    
    -- Cari FavoriteItem RemoteEvent
    local netFolder = ReplicatedStorage:FindFirstChild("Packages")
    if netFolder then
        netFolder = netFolder:FindFirstChild("_Index")
        if netFolder then
            netFolder = netFolder:FindFirstChild("sleitnick_net@0.2.0")
            if netFolder then
                netFolder = netFolder:FindFirstChild("net")
                if netFolder then
                    local reFolder = netFolder:FindFirstChild("RE")
                    if reFolder then
                        FavoriteItemRemote = reFolder:FindFirstChild("FavoriteItem")
                        FishCaughtRemote = reFolder:FindFirstChild("FishCaught")
                        
                        if FavoriteItemRemote then
                            DebugPrint("✅ FavoriteItem remote found!")
                        else
                            DebugWarn("❌ FavoriteItem remote NOT found!")
                        end
                        
                        if FishCaughtRemote then
                            DebugPrint("✅ FishCaught remote found!")
                        else
                            DebugWarn("❌ FishCaught remote NOT found!")
                        end
                    end
                end
            end
        end
    end
    
    return FavoriteItemRemote ~= nil
end

-- ============================================
-- GET FISH DATA FROM REPLICATED STORAGE
-- ============================================

local function GetFishData(fishName)
    local Items = ReplicatedStorage:FindFirstChild("Items")
    if not Items then 
        DebugWarn("Items folder not found!")
        return nil 
    end
    
    local fishModule = Items:FindFirstChild(fishName)
    if not fishModule or not fishModule:IsA("ModuleScript") then
        return nil
    end
    
    local success, fishData = pcall(function()
        return require(fishModule)
    end)
    
    if success then
        return fishData
    else
        DebugWarn("Failed to require fish module:", fishName)
        return nil
    end
end

-- ============================================
-- CHECK IF SHOULD FAVORITE
-- ============================================

local function ShouldFavorite(rarity)
    if not rarity then return false end
    
    for _, selectedRarity in pairs(AutoFavorite.Settings.SelectedRarities) do
        if rarity:lower() == selectedRarity:lower() then
            return true
        end
    end
    
    return false
end

-- ============================================
-- FAVORITE FISH FUNCTION
-- ============================================

local function FavoriteFish(fishId, fishName)
    if not FavoriteItemRemote then
        DebugWarn("FavoriteItem remote not available!")
        return false
    end
    
    DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    DebugPrint("⭐ FAVORITING FISH:")
    DebugPrint("  → Name:", fishName)
    DebugPrint("  → ID:", fishId)
    
    local success, err = pcall(function()
        FavoriteItemRemote:FireServer(fishId)
    end)
    
    if success then
        DebugPrint("✅ Fish favorited successfully!")
        DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        return true
    else
        DebugWarn("❌ Failed to favorite fish:", err)
        DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        return false
    end
end

-- ============================================
-- FISH CAUGHT EVENT HANDLER
-- ============================================

local function OnFishCaught(...)
    local args = {...}
    
    DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    DebugPrint("🎣 FISH CAUGHT EVENT TRIGGERED!")
    DebugPrint("  → Arguments received:", #args)
    
    for i, arg in pairs(args) do
        DebugPrint("  → Arg[" .. i .. "]:", typeof(arg), "=", tostring(arg))
        
        -- Jika argument adalah table, print isinya
        if type(arg) == "table" then
            for key, value in pairs(arg) do
                DebugPrint("    →", key, "=", tostring(value))
            end
        end
    end
    
    -- Coba extract fish name dan ID dari arguments
    local fishName = nil
    local fishId = nil
    local rarity = nil
    
    -- Method 1: Cek apakah ada argument yang table dengan field Name/Rarity
    for _, arg in pairs(args) do
        if type(arg) == "table" then
            if arg.Name then fishName = arg.Name end
            if arg.Id or arg.ID or arg.id then 
                fishId = arg.Id or arg.ID or arg.id 
            end
            if arg.Rarity or arg.rarity then 
                rarity = arg.Rarity or arg.rarity 
            end
        elseif type(arg) == "string" then
            -- Bisa jadi ini fish name atau ID
            if not fishName then
                fishName = arg
            elseif not fishId then
                fishId = arg
            end
        end
    end
    
    DebugPrint("  → Extracted Name:", fishName)
    DebugPrint("  → Extracted ID:", fishId)
    DebugPrint("  → Extracted Rarity:", rarity)
    
    -- Jika belum ada rarity, coba ambil dari ReplicatedStorage
    if fishName and not rarity then
        local fishData = GetFishData(fishName)
        if fishData then
            rarity = fishData.Rarity or fishData.rarity or fishData.Tier or fishData.tier
            DebugPrint("  → Rarity from module:", rarity)
        end
    end
    
    -- Check apakah perlu di-favorite
    if rarity and ShouldFavorite(rarity) then
        DebugPrint("  → ✅ Rarity matches! Attempting to favorite...")
        
        if fishId then
            task.wait(0.5) -- Tunggu sebentar agar fish masuk inventory
            FavoriteFish(fishId, fishName or "Unknown")
        else
            DebugWarn("  → ❌ Fish ID not found, cannot favorite!")
        end
    else
        DebugPrint("  → ℹ️  Rarity doesn't match selected rarities, skipping.")
    end
    
    DebugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- ============================================
-- MAIN FUNCTIONS
-- ============================================

function AutoFavorite.Start()
    if isRunning then
        DebugWarn("Auto Favorite sudah berjalan!")
        return false
    end
    
    -- Initialize remotes
    if not InitializeRemotes() then
        DebugWarn("Failed to initialize remotes!")
        return false
    end
    
    isRunning = true
    
    DebugPrint("╔════════════════════════════════════════╗")
    DebugPrint("║     AUTO FAVORITE STARTED!             ║")
    DebugPrint("╚════════════════════════════════════════╝")
    DebugPrint("Selected Rarities:", table.concat(AutoFavorite.Settings.SelectedRarities, ", "))
    DebugPrint("Listening for fish caught events...")
    
    -- Connect ke FishCaught event
    if FishCaughtRemote then
        fishCaughtConnection = FishCaughtRemote.OnClientEvent:Connect(OnFishCaught)
        DebugPrint("✅ Connected to FishCaught event!")
    else
        DebugWarn("❌ FishCaught remote not found!")
    end
    
    return true
end

function AutoFavorite.Stop()
    if not isRunning then
        DebugWarn("Auto Favorite tidak sedang berjalan!")
        return false
    end
    
    isRunning = false
    
    -- Disconnect event
    if fishCaughtConnection then
        fishCaughtConnection:Disconnect()
        fishCaughtConnection = nil
    end
    
    DebugPrint("╔════════════════════════════════════════╗")
    DebugPrint("║     AUTO FAVORITE STOPPED!             ║")
    DebugPrint("╚════════════════════════════════════════╝")
    
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
    DebugPrint("Running debug scan...")
    DebugPrint("Remotes initialized:", FavoriteItemRemote ~= nil)
    DebugPrint("FishCaught remote:", FishCaughtRemote ~= nil)
    DebugPrint("Selected rarities:", table.concat(AutoFavorite.Settings.SelectedRarities, ", "))
    DebugPrint("Is running:", isRunning)
end

-- ============================================
-- TEST FUNCTION
-- ============================================

function AutoFavorite.TestFavorite(fishId, fishName)
    DebugPrint("Testing favorite function...")
    DebugPrint("Fish ID:", fishId)
    DebugPrint("Fish Name:", fishName)
    
    if not FavoriteItemRemote then
        InitializeRemotes()
    end
    
    FavoriteFish(fishId, fishName)
end

-- ============================================
-- AUTO INITIALIZE ON LOAD
-- ============================================
task.spawn(function()
    task.wait(2)
    InitializeRemotes()
end)

-- ============================================
-- INFO
-- ============================================
print("╔════════════════════════════════════════╗")
print("║   AUTO FAVORITE MODULE V2 - LOADED     ║")
print("╚════════════════════════════════════════╝")
print("► Based on actual Fish It game structure")
print("► RemoteEvent: FavoriteItem & FishCaught")
print("► Debug Mode: ENABLED")
print("═════════════════════════════════════════")

return AutoFavorite
