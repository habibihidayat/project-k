-- ============================================
-- AUTO QUEST MODULE - FISH IT (DEEP INSPECTOR)
-- ============================================
-- Finds where game stores quest data automatically

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
            {Name = "Catch 300 Rare/Epic fish in Treasure Room", Current = 0, Required = 300, Location = "Treasure Room", Type = "CatchFish", Keywords = {"Rare", "Epic", "300", "Treasure"}},
            {Name = "Catch 3 Mythic fish at Sisyphus Statue", Current = 0, Required = 3, Location = "Sisyphus Statue", Type = "CatchFish", Keywords = {"Mythic", "3", "Sisyphus"}},
            {Name = "Catch 1 SECRET fish at Sisyphus Statue", Current = 0, Required = 1, Location = "Sisyphus Statue", Type = "CatchFish", Keywords = {"SECRET", "1", "Sisyphus"}},
            {Name = "Earn 1M Coins", Current = 0, Required = 1000000, Type = "EarnCoins", Keywords = {"Coin", "1000000", "1M", "Money"}}
        }
    },
    ElementQuest = {
        Name = "Element Quest",
        Reward = "Element Rod",
        Completed = false,
        Tasks = {
            {Name = "Own Ghostfinn Rod", Current = 0, Required = 1, Type = "OwnItem", Keywords = {"Ghostfinn", "Rod", "Own"}},
            {Name = "Catch 1 SECRET fish at Ancient Jungle", Current = 0, Required = 1, Location = "Ancient Jungle", Type = "CatchFish", Keywords = {"SECRET", "Ancient", "Jungle"}},
            {Name = "Catch 1 SECRET fish at Sacred Temple", Current = 0, Required = 1, Location = "Sacred Temple", Type = "CatchFish", Keywords = {"SECRET", "Sacred", "Temple"}},
            {Name = "Create 3 Transcended Stones", Current = 0, Required = 3, Type = "CraftItem", Keywords = {"Transcended", "Stone", "3", "Craft"}}
        }
    }
}

-- ============================================
-- DEEP GAME INSPECTION
-- ============================================

function AutoQuestModule.DeepInspectGame()
    print("\n╔════════════════════════════════════════╗")
    print("║     DEEP GAME STRUCTURE INSPECTION     ║")
    print("╚════════════════════════════════════════╝\n")
    
    -- 1. Inspect PlayerGui Quest
    print("🔍 [1] Inspecting PlayerGui.Quest...")
    local questGui = PlayerGui:FindFirstChild("Quest")
    if questGui then
        AutoQuestModule.InspectQuestGui(questGui)
    else
        print("   ❌ PlayerGui.Quest not found")
    end
    
    -- 2. Inspect Player data folders
    print("\n🔍 [2] Inspecting Player data folders...")
    AutoQuestModule.InspectPlayerFolders()
    
    -- 3. Inspect ReplicatedStorage
    print("\n🔍 [3] Inspecting ReplicatedStorage...")
    AutoQuestModule.InspectReplicatedStorage()
    
    -- 4. Look for remote events/functions
    print("\n🔍 [4] Searching for quest-related remotes...")
    AutoQuestModule.FindQuestRemotes()
    
    -- 5. Check for quest-related modules
    print("\n🔍 [5] Searching for quest modules...")
    AutoQuestModule.FindQuestModules()
    
    print("\n╚════════════════════════════════════════╝")
end

-- ============================================
-- INSPECT QUEST GUI IN DETAIL
-- ============================================

function AutoQuestModule.InspectQuestGui(questGui)
    print("   📋 Found Quest GUI!")
    
    -- Print all children
    for _, child in pairs(questGui:GetChildren()) do
        print("      └─ " .. child.Name .. " (" .. child.ClassName .. ")")
        
        if child.Name == "Content" then
            print("         🎯 Inspecting Content folder...")
            for _, tile in pairs(child:GetChildren()) do
                if tile:IsA("Frame") and tile.Name == "Tile" then
                    AutoQuestModule.InspectQuestTile(tile)
                end
            end
        end
    end
    
    -- Look for any TextLabels with numbers
    for _, descendant in pairs(questGui:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
            local text = descendant.Text
            -- Look for progress patterns: "X/Y" or numbers
            if text:match("%d+/%d+") or text:match("%d+") then
                print("      📊 Found progress text: " .. text .. " in " .. descendant.Name)
            end
        end
    end
end

function AutoQuestModule.InspectQuestTile(tile)
    print("         📌 Quest Tile found!")
    
    local items = tile:FindFirstChild("Items")
    if not items then return end
    
    -- Print all text content
    for _, child in pairs(items:GetDescendants()) do
        if child:IsA("TextLabel") then
            print("            • " .. child.Name .. ": " .. child.Text)
            
            -- Try to extract quest data
            AutoQuestModule.ParseQuestText(child.Text)
        end
        
        -- Check for progress bars
        if child.Name == "Progress" or child.Name == "ProgressBar" or child.Name == "Bar" then
            print("            🟦 Progress element: " .. child.Name)
            local fill = child:FindFirstChild("Fill") or child:FindFirstChild("Bar")
            if fill and fill:IsA("Frame") then
                local percentage = fill.Size.X.Scale * 100
                print("               Progress: " .. math.floor(percentage) .. "%")
            end
        end
    end
end

-- ============================================
-- PARSE TEXT FOR QUEST DATA
-- ============================================

function AutoQuestModule.ParseQuestText(text)
    if not text or text == "" then return end
    
    -- Look for progress patterns
    local current, required = text:match("(%d+)%s*/%s*(%d+)")
    if current and required then
        print("               ✅ Found progress: " .. current .. "/" .. required)
        
        -- Try to match with our quests
        local curr = tonumber(current)
        local req = tonumber(required)
        
        -- Check Deep Sea Quest
        for i, task in ipairs(AutoQuestModule.Quests.DeepSeaQuest.Tasks) do
            if task.Required == req then
                task.Current = curr
                print("                  → Matched DeepSeaQuest Task " .. i)
            end
        end
        
        -- Check Element Quest
        for i, task in ipairs(AutoQuestModule.Quests.ElementQuest.Tasks) do
            if task.Required == req then
                task.Current = curr
                print("                  → Matched ElementQuest Task " .. i)
            end
        end
    end
    
    -- Look for keywords
    for questName, quest in pairs(AutoQuestModule.Quests) do
        for taskIndex, task in ipairs(quest.Tasks) do
            for _, keyword in ipairs(task.Keywords) do
                if text:lower():find(keyword:lower()) then
                    print("               🎯 Keyword match: '" .. keyword .. "' → " .. questName .. " Task " .. taskIndex)
                end
            end
        end
    end
end

-- ============================================
-- INSPECT PLAYER FOLDERS
-- ============================================

function AutoQuestModule.InspectPlayerFolders()
    local folders = {"Data", "leaderstats", "Stats", "QuestData", "Quests", "Progress", "PlayerData"}
    
    for _, folderName in ipairs(folders) do
        local folder = Player:FindFirstChild(folderName)
        if folder then
            print("   ✅ Found Player." .. folderName)
            AutoQuestModule.PrintFolder(folder, "      ")
        end
    end
end

function AutoQuestModule.PrintFolder(folder, indent)
    for _, child in pairs(folder:GetChildren()) do
        local valueStr = ""
        if child:IsA("NumberValue") or child:IsA("IntValue") then
            valueStr = " = " .. child.Value
        elseif child:IsA("StringValue") then
            valueStr = " = '" .. child.Value .. "'"
        elseif child:IsA("BoolValue") then
            valueStr = " = " .. tostring(child.Value)
        end
        
        print(indent .. "└─ " .. child.Name .. " (" .. child.ClassName .. ")" .. valueStr)
        
        -- Check if this matches our quest keywords
        AutoQuestModule.CheckKeywordMatch(child.Name, valueStr)
        
        -- Recursively print subfolders
        if child:IsA("Folder") or child:IsA("Configuration") then
            AutoQuestModule.PrintFolder(child, indent .. "   ")
        end
    end
end

function AutoQuestModule.CheckKeywordMatch(name, value)
    for questName, quest in pairs(AutoQuestModule.Quests) do
        for taskIndex, task in ipairs(quest.Tasks) do
            for _, keyword in ipairs(task.Keywords) do
                if name:lower():find(keyword:lower()) then
                    print("            🎯 Keyword match: '" .. keyword .. "' in " .. name)
                    
                    -- Try to extract value
                    local numValue = tonumber(value:match("%d+"))
                    if numValue then
                        task.Current = numValue
                        print("               → Set " .. questName .. " Task " .. taskIndex .. " = " .. numValue)
                    end
                end
            end
        end
    end
end

-- ============================================
-- INSPECT REPLICATED STORAGE
-- ============================================

function AutoQuestModule.InspectReplicatedStorage()
    local folders = {"QuestData", "Quests", "PlayerData", "Data", "Modules", "GameData"}
    
    for _, folderName in ipairs(folders) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        if folder then
            print("   ✅ Found ReplicatedStorage." .. folderName)
            AutoQuestModule.PrintFolder(folder, "      ")
        end
    end
end

-- ============================================
-- FIND QUEST REMOTES
-- ============================================

function AutoQuestModule.FindQuestRemotes()
    local remotes = {}
    
    -- Search in ReplicatedStorage
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            local name = descendant.Name:lower()
            if name:find("quest") or name:find("catch") or name:find("fish") or name:find("progress") then
                table.insert(remotes, descendant)
                print("   🌐 " .. descendant:GetFullName())
            end
        end
    end
    
    if #remotes == 0 then
        print("   ❌ No quest-related remotes found")
    end
    
    return remotes
end

-- ============================================
-- FIND QUEST MODULES
-- ============================================

function AutoQuestModule.FindQuestModules()
    -- Search for ModuleScripts
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            local name = descendant.Name:lower()
            if name:find("quest") or name:find("data") or name:find("progress") then
                print("   📦 Module: " .. descendant:GetFullName())
                
                -- Try to require it (safely)
                local success, result = pcall(function()
                    return require(descendant)
                end)
                
                if success and type(result) == "table" then
                    print("      ✅ Module loaded successfully")
                    -- Print module contents
                    for key, value in pairs(result) do
                        print("         • " .. tostring(key) .. " = " .. tostring(value))
                    end
                end
            end
        end
    end
end

-- ============================================
-- SMART AUTO-DETECT
-- ============================================

function AutoQuestModule.SmartDetect()
    print("\n🧠 Running smart detection...")
    
    -- Method 1: Scan GUI
    local questGui = PlayerGui:FindFirstChild("Quest")
    if questGui then
        for _, descendant in pairs(questGui:GetDescendants()) do
            if descendant:IsA("TextLabel") then
                AutoQuestModule.ParseQuestText(descendant.Text)
            end
        end
    end
    
    -- Method 2: Check coins
    local coins = Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Coins")
    if coins then
        AutoQuestModule.Quests.DeepSeaQuest.Tasks[4].Current = coins.Value
        print("   💰 Coins detected: " .. coins.Value)
    end
    
    -- Method 3: Check inventory for rods
    AutoQuestModule.CheckQuestItems()
    
    -- Method 4: Listen to attribute changes
    AutoQuestModule.ListenToAttributes()
    
    print("✅ Smart detection complete!\n")
end

-- ============================================
-- CHECK QUEST ITEMS
-- ============================================

function AutoQuestModule.CheckQuestItems()
    print("   🎒 Checking inventory...")
    
    -- Check Ghostfinn Rod
    local hasGhostfinn = false
    local backpack = Player:FindFirstChild("Backpack")
    local character = Player.Character
    
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:find("Ghostfinn") then
                hasGhostfinn = true
                break
            end
        end
    end
    
    if character and not hasGhostfinn then
        for _, item in pairs(character:GetChildren()) do
            if item.Name:find("Ghostfinn") then
                hasGhostfinn = true
                break
            end
        end
    end
    
    if hasGhostfinn then
        AutoQuestModule.Quests.DeepSeaQuest.Completed = true
        AutoQuestModule.Quests.ElementQuest.Tasks[1].Current = 1
        print("      ✅ Ghostfinn Rod owned")
    end
    
    -- Check Element Rod
    local hasElement = false
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:find("Element") and item.Name:find("Rod") then
                hasElement = true
                break
            end
        end
    end
    
    if character and not hasElement then
        for _, item in pairs(character:GetChildren()) do
            if item.Name:find("Element") and item.Name:find("Rod") then
                hasElement = true
                break
            end
        end
    end
    
    if hasElement then
        AutoQuestModule.Quests.ElementQuest.Completed = true
        print("      ✅ Element Rod owned")
    end
end

-- ============================================
-- LISTEN TO PLAYER ATTRIBUTES
-- ============================================

function AutoQuestModule.ListenToAttributes()
    -- Many Roblox games store data in attributes
    local function checkAttributes(instance, prefix)
        for attributeName, attributeValue in pairs(instance:GetAttributes()) do
            print("   🏷️ Attribute: " .. prefix .. attributeName .. " = " .. tostring(attributeValue))
            AutoQuestModule.CheckKeywordMatch(attributeName, tostring(attributeValue))
        end
    end
    
    checkAttributes(Player, "Player.")
    
    local data = Player:FindFirstChild("Data")
    if data then
        checkAttributes(data, "Player.Data.")
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
-- GET QUEST INFO
-- ============================================

function AutoQuestModule.GetQuestInfo(questName)
    local quest = AutoQuestModule.Quests[questName]
    if not quest then return "Quest not found" end
    
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
-- MANUAL BACKUP
-- ============================================

function AutoQuestModule.SetTaskProgress(questName, taskIndex, current)
    local quest = AutoQuestModule.Quests[questName]
    if not quest or not quest.Tasks[taskIndex] then return false end
    
    quest.Tasks[taskIndex].Current = math.min(current, quest.Tasks[taskIndex].Required)
    AutoQuestModule.CheckQuestCompletion(questName)
    return true
end

-- ============================================
-- AUTO REFRESH
-- ============================================

function AutoQuestModule.StartAutoRefresh(interval)
    interval = interval or 5
    
    task.spawn(function()
        while true do
            task.wait(interval)
            AutoQuestModule.SmartDetect()
        end
    end)
    
    print("🔄 Auto-refresh enabled (every " .. interval .. " seconds)")
end

-- ============================================
-- ALIASES
-- ============================================

AutoQuestModule.ScanQuestProgress = AutoQuestModule.SmartDetect
AutoQuestModule.DebugCheckItems = AutoQuestModule.CheckQuestItems
AutoQuestModule.ScanPlayerData = AutoQuestModule.SmartDetect

function AutoQuestModule.DebugPrintAll()
    print("\n" .. AutoQuestModule.GetQuestInfo("DeepSeaQuest"))
    print("\n" .. AutoQuestModule.GetQuestInfo("ElementQuest"))
end

-- ============================================
-- AUTO INIT
-- ============================================

task.spawn(function()
    task.wait(5) -- Wait for game to fully load
    
    print("\n╔════════════════════════════════════════╗")
    print("║   FISH IT AUTO QUEST - DEEP SCAN MODE  ║")
    print("╚════════════════════════════════════════╝\n")
    
    -- Run deep inspection once
    AutoQuestModule.DeepInspectGame()
    
    -- Run smart detection
    AutoQuestModule.SmartDetect()
    
    -- Start auto-refresh
    AutoQuestModule.StartAutoRefresh(10)
    
    -- Print results
    AutoQuestModule.DebugPrintAll()
end)

print("╔════════════════════════════════════════╗")
print("║ FISH IT AUTO QUEST - INSPECTION MODE   ║")
print("╚════════════════════════════════════════╝")
print("► Deep game inspection: ENABLED")
print("► Smart auto-detection: ENABLED")
print("► Check console for detailed results")
print("═════════════════════════════════════════")

return AutoQuestModule
