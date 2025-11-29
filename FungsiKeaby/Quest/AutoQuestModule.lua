-- ============================================
-- AUTO QUEST MODULE - FISH IT (FIXED)
-- ============================================
-- Automatic Quest Detection & Progress Tracking

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
-- SCAN QUEST PROGRESS FROM PLAYER DATA
-- ============================================

function AutoQuestModule.ScanPlayerData()
    print("🔍 Scanning player quest data...")
    
    -- Method 1: Check PlayerGui Quest data
    local questGui = PlayerGui:FindFirstChild("Quest")
    if questGui then
        local content = questGui:FindFirstChild("Content")
        if content then
            for _, tile in pairs(content:GetChildren()) do
                if tile:IsA("Frame") and tile.Name == "Tile" then
                    AutoQuestModule.ParseQuestTile(tile)
                end
            end
        end
    end
    
    -- Method 2: Check ReplicatedStorage for quest data
    local questData = ReplicatedStorage:FindFirstChild("QuestData")
    if questData then
        local playerQuests = questData:FindFirstChild(Player.UserId)
        if playerQuests then
            AutoQuestModule.ParseReplicatedData(playerQuests)
        end
    end
    
    -- Method 3: Check Player's leaderstats or Data folder
    local playerData = Player:FindFirstChild("Data") or Player:FindFirstChild("leaderstats")
    if playerData then
        AutoQuestModule.ParsePlayerStats(playerData)
    end
    
    -- Method 4: Check inventory for quest items
    AutoQuestModule.CheckQuestItems()
    
    print("✅ Quest scan complete!")
    return true
end

-- ============================================
-- PARSE QUEST TILE FROM GUI
-- ============================================

function AutoQuestModule.ParseQuestTile(tile)
    local items = tile:FindFirstChild("Items")
    if not items then return end
    
    local questLabel = items:FindFirstChild("QuestLabel")
    if not questLabel then return end
    
    local text = questLabel.Text
    
    -- Detect Deep Sea Quest
    if text:find("Deep Sea") or text:find("Treasure Room") or text:find("Sisyphus") then
        print("📋 Parsing Deep Sea Quest from GUI...")
        
        -- Look for progress indicators in the tile
        for _, child in pairs(items:GetChildren()) do
            if child:IsA("TextLabel") then
                local progressText = child.Text
                
                -- Parse progress like "150/300" or "1/3"
                local current, required = progressText:match("(%d+)/(%d+)")
                if current and required then
                    -- Try to match which task this belongs to
                    AutoQuestModule.MatchTaskProgress("DeepSeaQuest", tonumber(current), tonumber(required), progressText)
                end
            end
        end
        
        -- Check progress bar
        local progressBar = items:FindFirstChild("Progress") or items:FindFirstChild("ProgressBar")
        if progressBar then
            local fill = progressBar:FindFirstChild("Fill")
            if fill and fill:IsA("Frame") then
                local percentage = fill.Size.X.Scale
                print("   Progress bar: " .. math.floor(percentage * 100) .. "%")
            end
        end
    end
    
    -- Detect Element Quest
    if text:find("Element") or text:find("Ancient Jungle") or text:find("Sacred Temple") then
        print("📋 Parsing Element Quest from GUI...")
        
        for _, child in pairs(items:GetChildren()) do
            if child:IsA("TextLabel") then
                local progressText = child.Text
                local current, required = progressText:match("(%d+)/(%d+)")
                if current and required then
                    AutoQuestModule.MatchTaskProgress("ElementQuest", tonumber(current), tonumber(required), progressText)
                end
            end
        end
    end
end

-- ============================================
-- MATCH TASK PROGRESS
-- ============================================

function AutoQuestModule.MatchTaskProgress(questName, current, required, text)
    local quest = AutoQuestModule.Quests[questName]
    if not quest then return end
    
    -- Match by required amount
    for i, task in ipairs(quest.Tasks) do
        if task.Required == required then
            task.Current = current
            print("   ✅ Task " .. i .. ": " .. current .. "/" .. required)
            break
        end
    end
end

-- ============================================
-- PARSE REPLICATED DATA
-- ============================================

function AutoQuestModule.ParseReplicatedData(playerQuests)
    print("📊 Parsing ReplicatedStorage quest data...")
    
    -- Look for quest progress values
    for _, value in pairs(playerQuests:GetChildren()) do
        if value:IsA("NumberValue") or value:IsA("IntValue") then
            local name = value.Name
            local amount = value.Value
            
            -- Match quest task names
            if name:find("TreasureRoom") or name:find("RareEpic") then
                AutoQuestModule.Quests.DeepSeaQuest.Tasks[1].Current = amount
            elseif name:find("Mythic") and name:find("Sisyphus") then
                AutoQuestModule.Quests.DeepSeaQuest.Tasks[2].Current = amount
            elseif name:find("SECRET") and name:find("Sisyphus") then
                AutoQuestModule.Quests.DeepSeaQuest.Tasks[3].Current = amount
            elseif name:find("Coins") then
                AutoQuestModule.Quests.DeepSeaQuest.Tasks[4].Current = amount
            elseif name:find("Ancient") and name:find("Jungle") then
                AutoQuestModule.Quests.ElementQuest.Tasks[2].Current = amount
            elseif name:find("Sacred") and name:find("Temple") then
                AutoQuestModule.Quests.ElementQuest.Tasks[3].Current = amount
            elseif name:find("Transcended") then
                AutoQuestModule.Quests.ElementQuest.Tasks[4].Current = amount
            end
        end
    end
end

-- ============================================
-- PARSE PLAYER STATS
-- ============================================

function AutoQuestModule.ParsePlayerStats(playerData)
    print("💎 Parsing player stats...")
    
    -- Check coins
    local coins = playerData:FindFirstChild("Coins") or playerData:FindFirstChild("Cash")
    if coins and (coins:IsA("NumberValue") or coins:IsA("IntValue")) then
        AutoQuestModule.Quests.DeepSeaQuest.Tasks[4].Current = coins.Value
        print("   💰 Coins: " .. coins.Value)
    end
    
    -- Check quest-specific values
    local questProgress = playerData:FindFirstChild("QuestProgress")
    if questProgress then
        for _, value in pairs(questProgress:GetChildren()) do
            if value:IsA("NumberValue") or value:IsA("IntValue") then
                -- Match by name pattern
                print("   📊 Found: " .. value.Name .. " = " .. value.Value)
            end
        end
    end
end

-- ============================================
-- CHECK QUEST ITEMS
-- ============================================

function AutoQuestModule.CheckQuestItems()
    print("🎒 Checking quest items...")
    
    -- Check Ghostfinn Rod
    local hasGhostfinn = AutoQuestModule.CheckHasItem("Ghostfinn Rod") or 
                         AutoQuestModule.CheckHasItem("!!! Ghostfinn Rod")
    if hasGhostfinn then
        AutoQuestModule.Quests.DeepSeaQuest.Completed = true
        AutoQuestModule.Quests.ElementQuest.Tasks[1].Current = 1
        print("   ✅ Ghostfinn Rod owned")
    end
    
    -- Check Element Rod
    local hasElement = AutoQuestModule.CheckHasItem("Element Rod") or 
                       AutoQuestModule.CheckHasItem("!!! Element Rod")
    if hasElement then
        AutoQuestModule.Quests.ElementQuest.Completed = true
        print("   ✅ Element Rod owned")
    end
end

function AutoQuestModule.CheckHasItem(itemName)
    -- Check backpack
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:find(itemName) then
                return true
            end
        end
    end
    
    -- Check character
    local character = Player.Character
    if character then
        for _, item in pairs(character:GetChildren()) do
            if item.Name:find(itemName) then
                return true
            end
        end
    end
    
    -- Check PlayerGui inventory
    local inventory = PlayerGui:FindFirstChild("Inventory")
    if inventory then
        for _, item in pairs(inventory:GetDescendants()) do
            if item:IsA("TextLabel") and item.Text:find(itemName) then
                return true
            end
        end
    end
    
    return false
end

-- ============================================
-- AUTO-DETECT FROM CHAT/NOTIFICATIONS
-- ============================================

function AutoQuestModule.MonitorNotifications()
    local chatGui = PlayerGui:WaitForChild("Chat", 5)
    if not chatGui then return end
    
    local function onMessageAdded(message)
        if not message or not message.Text then return end
        
        local text = message.Text
        
        -- Detect quest completion messages
        if text:find("Quest Completed") or text:find("You earned") then
            print("🎉 Quest completion detected!")
            task.wait(1)
            AutoQuestModule.ScanPlayerData()
        end
        
        -- Detect fish catch notifications
        if text:find("Caught") and text:find("Rare") or text:find("Epic") then
            -- Increment rare/epic counter
            local task = AutoQuestModule.Quests.DeepSeaQuest.Tasks[1]
            task.Current = math.min(task.Current + 1, task.Required)
        end
    end
    
    -- Monitor chat messages
    for _, message in pairs(chatGui:GetDescendants()) do
        if message:IsA("TextLabel") then
            message:GetPropertyChangedSignal("Text"):Connect(function()
                onMessageAdded(message)
            end)
        end
    end
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
-- GET QUEST PROGRESS INFO
-- ============================================

function AutoQuestModule.GetQuestInfo(questName)
    local quest = AutoQuestModule.Quests[questName]
    if not quest then return "Quest not found" end
    
    -- Auto-check completion
    AutoQuestModule.CheckQuestCompletion(questName)
    
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
-- MANUAL UPDATE (Backup)
-- ============================================

function AutoQuestModule.SetTaskProgress(questName, taskIndex, current)
    local quest = AutoQuestModule.Quests[questName]
    if not quest or not quest.Tasks[taskIndex] then return false end
    
    local task = quest.Tasks[taskIndex]
    task.Current = math.min(current, task.Required)
    
    print("📊 Set: " .. task.Name .. " → " .. task.Current .. "/" .. task.Required)
    
    AutoQuestModule.CheckQuestCompletion(questName)
    return true
end

-- ============================================
-- AUTO-REFRESH LOOP
-- ============================================

function AutoQuestModule.StartAutoRefresh(interval)
    interval = interval or 10 -- Default: refresh every 10 seconds
    
    task.spawn(function()
        while true do
            task.wait(interval)
            AutoQuestModule.ScanPlayerData()
        end
    end)
    
    print("🔄 Auto-refresh enabled (every " .. interval .. " seconds)")
end

-- ============================================
-- DEBUG FUNCTIONS
-- ============================================

function AutoQuestModule.DebugPrintAll()
    print("\n╔════════════════════════════════════════╗")
    print("║       FISH IT QUEST PROGRESS           ║")
    print("╚════════════════════════════════════════╝\n")
    
    for questName, quest in pairs(AutoQuestModule.Quests) do
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📜 " .. quest.Name)
        print("🎁 Reward: " .. quest.Reward)
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        
        for i, task in ipairs(quest.Tasks) do
            local status = task.Current >= task.Required and "✅" or "❌"
            local progress = task.Current .. "/" .. task.Required
            local percentage = math.floor((task.Current / task.Required) * 100)
            
            print(status .. " Task " .. i .. ": " .. task.Name)
            print("   Progress: " .. progress .. " (" .. percentage .. "%)")
        end
        
        print("\nQuest Status: " .. (quest.Completed and "✅ COMPLETED" or "⏳ IN PROGRESS"))
        print("")
    end
    
    print("╚════════════════════════════════════════╝\n")
end

-- ============================================
-- ALIAS FOR GUI COMPATIBILITY
-- ============================================

AutoQuestModule.ScanQuestProgress = AutoQuestModule.ScanPlayerData
AutoQuestModule.DebugCheckItems = AutoQuestModule.CheckQuestItems

-- ============================================
-- AUTO INIT
-- ============================================

task.spawn(function()
    task.wait(3)
    
    print("\n╔════════════════════════════════════════╗")
    print("║   FISH IT AUTO QUEST - INITIALIZING    ║")
    print("╚════════════════════════════════════════╝\n")
    
    -- Initial scan
    AutoQuestModule.ScanPlayerData()
    
    -- Start monitoring
    AutoQuestModule.MonitorNotifications()
    
    -- Start auto-refresh (every 15 seconds)
    AutoQuestModule.StartAutoRefresh(15)
    
    -- Print results
    AutoQuestModule.DebugPrintAll()
end)

-- ============================================
-- INFO
-- ============================================
print("╔════════════════════════════════════════╗")
print("║   FISH IT AUTO QUEST MODULE - READY    ║")
print("╚════════════════════════════════════════╝")
print("► Auto-detection: ENABLED")
print("► Real-time tracking: ENABLED")
print("► Manual backup: AVAILABLE")
print("═════════════════════════════════════════")

return AutoQuestModule
