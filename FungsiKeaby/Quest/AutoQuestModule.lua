-- ============================================
-- AUTO QUEST MODULE - FISH IT (REAL)
-- ============================================
-- For Ghostfinn Rod & Element Rod Quests

local AutoQuestModule = {}

local Players = game:GetService("Players")
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
-- SCAN QUEST PROGRESS FROM GUI
-- ============================================

function AutoQuestModule.ScanQuestProgress()
    local questGui = PlayerGui:FindFirstChild("Quest")
    if not questGui then
        warn("❌ Quest GUI not found!")
        return false
    end
    
    print("🔍 Scanning quest progress from GUI...")
    
    -- Scan Deep Sea Quest
    local deepSeaTile = questGui:FindFirstChild("Content")
    if deepSeaTile then
        for _, tile in pairs(deepSeaTile:GetChildren()) do
            if tile:IsA("Frame") and tile.Name == "Tile" then
                local items = tile:FindFirstChild("Items")
                if items then
                    local questLabel = items:FindFirstChild("QuestLabel")
                    if questLabel and questLabel.Text then
                        -- Check if it's Deep Sea Quest or Element Quest
                        local text = questLabel.Text
                        
                        if text:find("Deep Sea") or text:find("Treasure Room") or text:find("Sisyphus") then
                            print("📋 Found Deep Sea Quest tile")
                            -- Update progress from GUI
                            AutoQuestModule.UpdateProgressFromGUI("DeepSeaQuest", tile)
                        elseif text:find("Element") or text:find("Ancient Jungle") or text:find("Sacred Temple") then
                            print("📋 Found Element Quest tile")
                            AutoQuestModule.UpdateProgressFromGUI("ElementQuest", tile)
                        end
                    end
                end
            end
        end
    end
    
    print("✅ Quest scan complete!")
    return true
end

function AutoQuestModule.UpdateProgressFromGUI(questName, tile)
    local quest = AutoQuestModule.Quests[questName]
    if not quest then return end
    
    -- Check progress bar
    local items = tile:FindFirstChild("Items")
    if items then
        local progress = items:FindFirstChild("Progress")
        if progress then
            -- Game might store progress info here
            print("   Progress frame found for " .. questName)
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
-- CHECK IF PLAYER HAS ITEM
-- ============================================

function AutoQuestModule.CheckHasItem(itemName)
    -- Check backpack
    local backpack = Player:FindFirstChild("Backpack")
    if backpack and backpack:FindFirstChild(itemName) then
        return true
    end
    
    -- Check character
    local character = Player.Character
    if character and character:FindFirstChild(itemName) then
        return true
    end
    
    return false
end

-- ============================================
-- GET QUEST PROGRESS INFO
-- ============================================

function AutoQuestModule.GetQuestInfo(questName)
    local quest = AutoQuestModule.Quests[questName]
    if not quest then return "Quest not found" end
    
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
-- MANUAL PROGRESS UPDATE
-- ============================================

function AutoQuestModule.UpdateTaskProgress(questName, taskIndex, amount)
    local quest = AutoQuestModule.Quests[questName]
    if not quest or not quest.Tasks[taskIndex] then return false end
    
    local task = quest.Tasks[taskIndex]
    task.Current = math.min(task.Current + amount, task.Required)
    
    print("✅ Updated: " .. task.Name .. " → " .. task.Current .. "/" .. task.Required)
    
    -- Check if task completed
    if task.Current >= task.Required then
        print("🎉 Task completed: " .. task.Name)
    end
    
    -- Check overall quest completion
    AutoQuestModule.CheckQuestCompletion(questName)
    
    return true
end

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

function AutoQuestModule.DebugCheckItems()
    print("\n🎒 ═══ CHECKING QUEST ITEMS ═══")
    
    -- Check Ghostfinn Rod
    local hasGhostfinn = AutoQuestModule.CheckHasItem("!!! Ghostfinn Rod")
    print((hasGhostfinn and "✅" or "❌") .. " Ghostfinn Rod")
    
    -- Check Element Rod
    local hasElement = AutoQuestModule.CheckHasItem("!!! Element Rod")
    print((hasElement and "✅" or "❌") .. " Element Rod")
    
    -- Auto update Element Quest task 1 if has Ghostfinn
    if hasGhostfinn then
        AutoQuestModule.SetTaskProgress("ElementQuest", 1, 1)
    end
    
    print("═══════════════════════════════════\n")
end

-- ============================================
-- RESET QUEST
-- ============================================

function AutoQuestModule.ResetQuest(questName)
    local quest = AutoQuestModule.Quests[questName]
    if not quest then return false end
    
    quest.Completed = false
    for _, task in ipairs(quest.Tasks) do
        task.Current = 0
    end
    
    print("🔄 " .. quest.Name .. " has been reset!")
    return true
end

-- ============================================
-- AUTO INIT
-- ============================================

task.spawn(function()
    task.wait(3)
    
    print("\n╔════════════════════════════════════════╗")
    print("║   FISH IT AUTO QUEST - INITIALIZING    ║")
    print("╚════════════════════════════════════════╝\n")
    
    -- Auto scan GUI
    AutoQuestModule.ScanQuestProgress()
    
    -- Auto check items
    AutoQuestModule.DebugCheckItems()
    
    -- Print all quests
    AutoQuestModule.DebugPrintAll()
end)

-- ============================================
-- INFO
-- ============================================
print("╔════════════════════════════════════════╗")
print("║   FISH IT AUTO QUEST MODULE - READY    ║")
print("╚════════════════════════════════════════╝")
print("► Deep Sea Quest (Ghostfinn Rod): TRACKED")
print("► Element Quest (Element Rod): TRACKED")
print("► Manual Progress Update: ENABLED")
print("═════════════════════════════════════════")

return AutoQuestModule