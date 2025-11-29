-- ============================================
-- AUTO QUEST MODULE - FISH IT (REAL DETECTION)
-- ============================================
-- Detects quest completion from Player attributes and inventory

local AutoQuestModule = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Quest Data
AutoQuestModule.Quests = {
    DeepSeaQuest = {
        Name = "Deep Sea Quest",
        Reward = "Ghostfinn Rod",
        Completed = false,
        Tasks = {
            {Name = "Catch 300 Rare/Epic fish in Treasure Room", Current = 0, Required = 300, Location = "Treasure Room", Type = "CatchFish"},
            {Name = "Catch 3 Mythic fish at Sisyphus Statue", Current = 0, Required = 3, Location = "Sisyphus Statue", Type = "CatchFish"},
            {Name = "Catch 1 SECRET fish at Sisyphus Statue", Current = 0, Required = 1, Location = "Sisyphus Statue", Type = "CatchFish"},
            {Name = "Earn 1M Coins", Current = 0, Required = 1000000, Type = "EarnCoins"}
        }
    },
    ElementQuest = {
        Name = "Element Quest",
        Reward = "Element Rod",
        Completed = false,
        Tasks = {
            {Name = "Own Ghostfinn Rod", Current = 0, Required = 1, Type = "OwnItem"},
            {Name = "Catch 1 SECRET fish at Ancient Jungle", Current = 0, Required = 1, Location = "Ancient Jungle", Type = "CatchFish"},
            {Name = "Catch 1 SECRET fish at Sacred Temple", Current = 0, Required = 1, Location = "Sacred Temple", Type = "CatchFish"},
            {Name = "Create 3 Transcended Stones", Current = 0, Required = 3, Type = "CraftItem"}
        }
    }
}

-- ============================================
-- DETECT FROM PLAYER ATTRIBUTES (MAIN METHOD)
-- ============================================

function AutoQuestModule.DetectFromAttributes()
    print("🔍 Detecting quest progress from Player attributes...")
    
    -- Check current fishing rod (PALING PENTING!)
    local currentRod = Player:GetAttribute("FishingRod")
    if currentRod then
        print("   🎣 Current Rod: " .. currentRod)
        
        -- If has Ghostfinn Rod -> Deep Sea Quest COMPLETED
        if currentRod:find("Ghostfinn") then
            AutoQuestModule.Quests.DeepSeaQuest.Completed = true
            for _, task in ipairs(AutoQuestModule.Quests.DeepSeaQuest.Tasks) do
                task.Current = task.Required
            end
            
            -- Element Quest Task 1 auto complete
            AutoQuestModule.Quests.ElementQuest.Tasks[1].Current = 1
            print("   ✅ Deep Sea Quest COMPLETED (owns Ghostfinn Rod)")
        end
        
        -- If has Element Rod -> Element Quest COMPLETED
        if currentRod:find("Element") then
            AutoQuestModule.Quests.ElementQuest.Completed = true
            for _, task in ipairs(AutoQuestModule.Quests.ElementQuest.Tasks) do
                task.Current = task.Required
            end
            print("   ✅ Element Quest COMPLETED (owns Element Rod)")
        end
    end
    
    -- Get location (untuk tracking task yang location-specific)
    local location = Player:GetAttribute("LocationName")
    if location then
        print("   📍 Current Location: " .. location)
    end
    
    return true
end

-- ============================================
-- CHECK INVENTORY FOR RODS
-- ============================================

function AutoQuestModule.CheckInventoryRods()
    print("🎒 Checking inventory for rods...")
    
    local hasGhostfinn = false
    local hasElement = false
    
    -- Method 1: Check backpack
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                if item.Name:find("Ghostfinn") then
                    hasGhostfinn = true
                    print("   ✅ Found Ghostfinn Rod in Backpack")
                end
                if item.Name:find("Element") and item.Name:find("Rod") then
                    hasElement = true
                    print("   ✅ Found Element Rod in Backpack")
                end
            end
        end
    end
    
    -- Method 2: Check character
    local character = Player.Character
    if character then
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Tool") then
                if item.Name:find("Ghostfinn") then
                    hasGhostfinn = true
                    print("   ✅ Found Ghostfinn Rod equipped")
                end
                if item.Name:find("Element") and item.Name:find("Rod") then
                    hasElement = true
                    print("   ✅ Found Element Rod equipped")
                end
            end
        end
    end
    
    -- Update quest status
    if hasGhostfinn then
        AutoQuestModule.Quests.DeepSeaQuest.Completed = true
        for _, task in ipairs(AutoQuestModule.Quests.DeepSeaQuest.Tasks) do
            task.Current = task.Required
        end
        AutoQuestModule.Quests.ElementQuest.Tasks[1].Current = 1
    end
    
    if hasElement then
        AutoQuestModule.Quests.ElementQuest.Completed = true
        for _, task in ipairs(AutoQuestModule.Quests.ElementQuest.Tasks) do
            task.Current = task.Required
        end
    end
    
    return hasGhostfinn, hasElement
end

-- ============================================
-- LISTEN TO REMOTE EVENTS (QUEST COMPLETION)
-- ============================================

function AutoQuestModule.ListenToQuestRemotes()
    print("👂 Listening to quest remotes...")
    
    -- Find quest-related remote events
    local questRemotes = {
        "RF_ClaimMegalodonQuest",
        "ActivateQuestLine",
        "FishCaught"
    }
    
    for _, remoteName in ipairs(questRemotes) do
        local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
        if remote then
            if remote:IsA("RemoteEvent") then
                remote.OnClientEvent:Connect(function(...)
                    print("   🔔 Remote fired: " .. remoteName)
                    task.wait(1)
                    AutoQuestModule.SmartDetect()
                end)
            end
        end
    end
end

-- ============================================
-- MONITOR ATTRIBUTE CHANGES
-- ============================================

function AutoQuestModule.MonitorAttributeChanges()
    print("👁️ Monitoring Player attribute changes...")
    
    -- Monitor FishingRod change
    Player:GetAttributeChangedSignal("FishingRod"):Connect(function()
        local rod = Player:GetAttribute("FishingRod")
        print("   🎣 Rod changed to: " .. tostring(rod))
        AutoQuestModule.SmartDetect()
    end)
    
    -- Monitor location change (for location-specific quests)
    Player:GetAttributeChangedSignal("LocationName"):Connect(function()
        local location = Player:GetAttribute("LocationName")
        print("   📍 Location changed to: " .. tostring(location))
    end)
end

-- ============================================
-- SMART DETECTION (ALL METHODS)
-- ============================================

function AutoQuestModule.SmartDetect()
    print("\n🧠 Running smart detection...")
    
    -- Priority 1: Check attributes (most reliable)
    AutoQuestModule.DetectFromAttributes()
    
    -- Priority 2: Check inventory
    AutoQuestModule.CheckInventoryRods()
    
    -- Check quest completion
    for questName, quest in pairs(AutoQuestModule.Quests) do
        AutoQuestModule.CheckQuestCompletion(questName)
    end
    
    print("✅ Smart detection complete!\n")
end

-- ============================================
-- CHECK QUEST COMPLETION
-- ============================================

function AutoQuestModule.CheckQuestCompletion(questName)
    local quest = AutoQuestModule.Quests[questName]
    if not quest then return false end
    
    local allCompleted = true
    for _, task in ipairs(quest.Tasks) do
        if task.Current < task.Required then
            allCompleted = false
            break
        end
    end
    
    quest.Completed = allCompleted
    return allCompleted
end

-- ============================================
-- GET QUEST INFO
-- ============================================

function AutoQuestModule.GetQuestInfo(questName)
    local quest = AutoQuestModule.Quests[questName]
    if not quest then return "Quest not found" end
    
    -- Force check before displaying
    AutoQuestModule.SmartDetect()
    
    local info = "📋 " .. quest.Name .. "\n"
    info = info .. "━━━━━━━━━━━━━━━━━━━━━━\n"
    info = info .. "🎁 Reward: " .. quest.Reward .. "\n\n"
    
    for i, task in ipairs(quest.Tasks) do
        local status = task.Current >= task.Required and "✅" or "⏳"
        local progress = task.Current .. "/" .. task.Required
        local percentage = math.floor((task.Current / task.Required) * 100)
        
        info = info .. status .. " " .. task.Name .. "\n"
        info = info .. "   " .. progress .. " (" .. percentage .. "%)\n"
    end
    
    info = info .. "\n━━━━━━━━━━━━━━━━━━━━━━\n"
    info = info .. "Status: " .. (quest.Completed and "✅ COMPLETED" or "⏳ IN PROGRESS")
    
    return info
end

-- ============================================
-- MANUAL UPDATE (BACKUP)
-- ============================================

function AutoQuestModule.SetTaskProgress(questName, taskIndex, current)
    local quest = AutoQuestModule.Quests[questName]
    if not quest or not quest.Tasks[taskIndex] then return false end
    
    quest.Tasks[taskIndex].Current = math.min(current, quest.Tasks[taskIndex].Required)
    AutoQuestModule.CheckQuestCompletion(questName)
    return true
end

-- ============================================
-- DEBUG PRINT
-- ============================================

function AutoQuestModule.DebugPrintAll()
    print("\n╔════════════════════════════════════════╗")
    print("║       FISH IT QUEST PROGRESS           ║")
    print("╚════════════════════════════════════════╝\n")
    
    print(AutoQuestModule.GetQuestInfo("DeepSeaQuest"))
    print("\n")
    print(AutoQuestModule.GetQuestInfo("ElementQuest"))
    
    print("\n╚════════════════════════════════════════╝")
end

-- ============================================
-- AUTO REFRESH
-- ============================================

function AutoQuestModule.StartAutoRefresh(interval)
    interval = interval or 30 -- Refresh setiap 30 detik (tidak perlu terlalu sering)
    
    task.spawn(function()
        while true do
            task.wait(interval)
            AutoQuestModule.SmartDetect()
        end
    end)
    
    print("🔄 Auto-refresh enabled (every " .. interval .. " seconds)")
end

-- ============================================
-- CHECK SPECIFIC ROD OWNERSHIP
-- ============================================

function AutoQuestModule.HasGhostfinnRod()
    local currentRod = Player:GetAttribute("FishingRod")
    if currentRod and currentRod:find("Ghostfinn") then
        return true
    end
    
    local backpack = Player:FindFirstChild("Backpack")
    if backpack and backpack:FindFirstChild("Ghostfinn Rod", true) then
        return true
    end
    
    local character = Player.Character
    if character and character:FindFirstChild("Ghostfinn Rod", true) then
        return true
    end
    
    return false
end

function AutoQuestModule.HasElementRod()
    local currentRod = Player:GetAttribute("FishingRod")
    if currentRod and currentRod:find("Element") then
        return true
    end
    
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:find("Element") and item.Name:find("Rod") then
                return true
            end
        end
    end
    
    local character = Player.Character
    if character then
        for _, item in pairs(character:GetChildren()) do
            if item.Name:find("Element") and item.Name:find("Rod") then
                return true
            end
        end
    end
    
    return false
end

-- ============================================
-- ALIASES FOR COMPATIBILITY
-- ============================================

AutoQuestModule.ScanQuestProgress = AutoQuestModule.SmartDetect
AutoQuestModule.ScanPlayerData = AutoQuestModule.SmartDetect
AutoQuestModule.DebugCheckItems = AutoQuestModule.CheckInventoryRods

-- ============================================
-- AUTO INIT
-- ============================================

task.spawn(function()
    task.wait(3) -- Wait for game to load
    
    print("\n╔════════════════════════════════════════╗")
    print("║   FISH IT AUTO QUEST - INITIALIZING    ║")
    print("╚════════════════════════════════════════╝\n")
    
    -- Initial detection
    AutoQuestModule.SmartDetect()
    
    -- Setup monitoring
    AutoQuestModule.MonitorAttributeChanges()
    AutoQuestModule.ListenToQuestRemotes()
    
    -- Start auto-refresh (every 30 seconds)
    AutoQuestModule.StartAutoRefresh(30)
    
    -- Print results
    AutoQuestModule.DebugPrintAll()
    
    print("\n✅ Auto Quest Module fully initialized!")
end)

-- ============================================
-- INFO
-- ============================================
print("╔════════════════════════════════════════╗")
print("║   FISH IT AUTO QUEST MODULE - READY    ║")
print("╚════════════════════════════════════════╝")
print("► Attribute detection: ENABLED")
print("► Inventory detection: ENABLED")
print("► Real-time monitoring: ENABLED")
print("═════════════════════════════════════════")

return AutoQuestModule
