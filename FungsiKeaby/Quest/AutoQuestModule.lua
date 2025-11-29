-- ============================================
-- AUTO QUEST MODULE - FISH IT (FINAL WORKING VERSION)
-- ============================================

local AutoQuestModule = {}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Quest Data
AutoQuestModule.Quests = {
    DeepSeaQuest = {
        Name = "Deep Sea Quest",
        Reward = "Ghostfinn Rod",
        Completed = false,
        Tasks = {
            {Name = "Catch 300 Rare/Epic fish in Treasure Room", Current = 0, Required = 300},
            {Name = "Catch 3 Mythic fish at Sisyphus Statue", Current = 0, Required = 3},
            {Name = "Catch 1 SECRET fish at Sisyphus Statue", Current = 0, Required = 1},
            {Name = "Earn 1M Coins", Current = 0, Required = 1000000}
        }
    },
    ElementQuest = {
        Name = "Element Quest",
        Reward = "Element Rod",
        Completed = false,
        Tasks = {
            {Name = "Own Ghostfinn Rod", Current = 0, Required = 1},
            {Name = "Catch 1 SECRET fish at Ancient Jungle", Current = 0, Required = 1},
            {Name = "Catch 1 SECRET fish at Sacred Temple", Current = 0, Required = 1},
            {Name = "Create 3 Transcended Stones", Current = 0, Required = 3}
        }
    }
}

-- ============================================
-- MAIN DETECTION FUNCTION
-- ============================================

function AutoQuestModule.DetectQuestCompletion()
    print("🔍 Detecting quest completion...")
    
    -- Check Player.FishingRod attribute (MOST RELIABLE)
    local currentRod = Player:GetAttribute("FishingRod")
    
    if currentRod then
        print("   🎣 Current Rod: " .. currentRod)
        
        -- Check for Ghostfinn Rod (Deep Sea Quest completed)
        if currentRod:find("Ghostfinn") then
            print("   ✅ GHOSTFINN ROD DETECTED!")
            AutoQuestModule.Quests.DeepSeaQuest.Completed = true
            for i, task in ipairs(AutoQuestModule.Quests.DeepSeaQuest.Tasks) do
                task.Current = task.Required
            end
            -- Element Quest Task 1 auto-complete
            AutoQuestModule.Quests.ElementQuest.Tasks[1].Current = 1
        end
        
        -- Check for Element Rod (Element Quest completed)
        if currentRod:find("Element") then
            print("   ✅ ELEMENT ROD DETECTED!")
            AutoQuestModule.Quests.ElementQuest.Completed = true
            -- Mark ALL Element Quest tasks as complete
            for i, task in ipairs(AutoQuestModule.Quests.ElementQuest.Tasks) do
                task.Current = task.Required
            end
            -- Also mark Deep Sea Quest as complete (prerequisite)
            AutoQuestModule.Quests.DeepSeaQuest.Completed = true
            for i, task in ipairs(AutoQuestModule.Quests.DeepSeaQuest.Tasks) do
                task.Current = task.Required
            end
        end
    else
        print("   ⚠️ FishingRod attribute not found")
    end
    
    return true
end

-- ============================================
-- GET QUEST INFO
-- ============================================

function AutoQuestModule.GetQuestInfo(questName)
    -- FORCE detection every time this is called
    AutoQuestModule.DetectQuestCompletion()
    
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
-- MANUAL UPDATE (BACKUP)
-- ============================================

function AutoQuestModule.SetTaskProgress(questName, taskIndex, current)
    local quest = AutoQuestModule.Quests[questName]
    if not quest or not quest.Tasks[taskIndex] then return false end
    
    quest.Tasks[taskIndex].Current = math.min(current, quest.Tasks[taskIndex].Required)
    
    -- Check if quest is completed
    local allCompleted = true
    for _, task in ipairs(quest.Tasks) do
        if task.Current < task.Required then
            allCompleted = false
            break
        end
    end
    quest.Completed = allCompleted
    
    return true
end

-- ============================================
-- MONITOR ATTRIBUTE CHANGES
-- ============================================

function AutoQuestModule.StartMonitoring()
    print("👁️ Monitoring Player.FishingRod attribute...")
    
    -- Monitor FishingRod changes
    Player:GetAttributeChangedSignal("FishingRod"):Connect(function()
        local rod = Player:GetAttribute("FishingRod")
        print("🔔 Rod changed to: " .. tostring(rod))
        AutoQuestModule.DetectQuestCompletion()
    end)
end

-- ============================================
-- DEBUG FUNCTIONS
-- ============================================

function AutoQuestModule.DebugPrintAll()
    print("\n╔════════════════════════════════════════╗")
    print("║       FISH IT QUEST STATUS             ║")
    print("╚════════════════════════════════════════╝\n")
    
    print(AutoQuestModule.GetQuestInfo("DeepSeaQuest"))
    print("\n")
    print(AutoQuestModule.GetQuestInfo("ElementQuest"))
    
    print("\n╚════════════════════════════════════════╝")
end

function AutoQuestModule.DebugCheckRod()
    local currentRod = Player:GetAttribute("FishingRod")
    print("\n🎣 CURRENT ROD CHECK:")
    print("   Rod: " .. tostring(currentRod))
    
    if currentRod then
        if currentRod:find("Ghostfinn") then
            print("   ✅ Has Ghostfinn Rod")
        end
        if currentRod:find("Element") then
            print("   ✅ Has Element Rod")
        end
    end
    print("")
end

-- ============================================
-- ALIASES FOR COMPATIBILITY
-- ============================================

AutoQuestModule.ScanQuestProgress = AutoQuestModule.DetectQuestCompletion
AutoQuestModule.ScanPlayerData = AutoQuestModule.DetectQuestCompletion
AutoQuestModule.DebugCheckItems = AutoQuestModule.DebugCheckRod
AutoQuestModule.SmartDetect = AutoQuestModule.DetectQuestCompletion

-- ============================================
-- AUTO INIT
-- ============================================

task.spawn(function()
    task.wait(2)
    
    print("\n╔════════════════════════════════════════╗")
    print("║   FISH IT AUTO QUEST - INITIALIZED     ║")
    print("╚════════════════════════════════════════╝\n")
    
    -- Initial detection
    AutoQuestModule.DetectQuestCompletion()
    
    -- Start monitoring
    AutoQuestModule.StartMonitoring()
    
    -- Print results
    AutoQuestModule.DebugPrintAll()
end)

print("╔════════════════════════════════════════╗")
print("║   AUTO QUEST MODULE - READY            ║")
print("╚════════════════════════════════════════╝")
print("► Attribute-based detection: ENABLED")
print("► Real-time monitoring: ENABLED")
print("═════════════════════════════════════════")

return AutoQuestModule
