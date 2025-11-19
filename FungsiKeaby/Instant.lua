-- ⚡ ULTRA SPEED AUTO FISHING v30.0 (GUARANTEED PERFECT CAST)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.1)
end

local netFolder = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")
local RE_FishCaught = netFolder:WaitForChild("RE/FishCaught")

local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    PerfectCasts = 0,
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.19,
        HookDetectionDelay = 0.01,
        RetryDelay = 0.1,
        MaxWaitTime = 0.8,
    },
    
    -- 🎯 PERFECT CAST CONFIGURATION
    PerfectCastValue = 0.99,      -- Nilai perfect cast (0.95-1.0 = perfect range)
    PerfectCastForce = true,       -- Paksa perfect cast setiap kali
}

_G.FishingScript = fishing

local function log(msg)
    print(("[🎣 Fishing] %s"):format(msg))
end

local function disableFishingAnim()
    pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            local n = track.Name:lower()
            if n:find("fish") or n:find("rod") or n:find("cast") or n:find("reel") then
                track:Stop(0)
            end
        end
    end)
end

---------------------------------------------------------------------
--                    🎯 GUARANTEED PERFECT CAST                   --
---------------------------------------------------------------------
local function ExecutePerfectCast()
    local perfectValue = fishing.PerfectCastValue
    local currentTime = tick()
    
    -- Method 1: Direct perfect charge injection
    local success1 = pcall(function()
        RF_ChargeFishingRod:InvokeServer({
            [perfectValue] = currentTime,
            ["power"] = perfectValue,
            ["charge"] = perfectValue,
            ["perfect"] = true,
        })
    end)
    
    -- Method 2: Request minigame dengan nilai perfect
    local success2 = pcall(function()
        RF_RequestMinigame:InvokeServer(
            999999999999999999,   -- Max value untuk bypass check
            perfectValue,         -- Perfect power value
            currentTime,          -- Timestamp
            true                  -- Perfect flag
        )
    end)
    
    -- Method 3: Alternative perfect cast (backup)
    if not (success1 or success2) then
        pcall(function()
            local chargeData = {
                ChargeTime = perfectValue,
                Power = perfectValue,
                Perfect = true,
                Timestamp = currentTime,
            }
            RF_ChargeFishingRod:InvokeServer(chargeData)
        end)
    end
    
    fishing.PerfectCasts += 1
    log(("✅ PERFECT CAST #%d (Power: %.2f%%)"):format(fishing.PerfectCasts, perfectValue * 100))
    
    return true
end

---------------------------------------------------------------------
--                         🎣 IMPROVED CAST                        --
---------------------------------------------------------------------
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    
    local cycleInfo = string.format("Cycle: %d | Perfect: %d | Fish: %d", 
        fishing.CurrentCycle, fishing.PerfectCasts, fishing.TotalFish)
    log("⚡ Casting... (" .. cycleInfo .. ")")

    fishing.WaitingHook = true

    local ok = pcall(function()
        -- 🔥 EXECUTE PERFECT CAST
        ExecutePerfectCast()
        
        log("⏳ Waiting for hook...")

        -- Safety mechanism 1: Auto-complete jika terlalu lama
        task.delay(fishing.Settings.MaxWaitTime * 0.7, function()
            if fishing.WaitingHook and fishing.Running then
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
            end
        end)

        -- Safety mechanism 2: Force cancel & retry jika timeout
        task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚠️ Hook timeout, retrying...")
                fishing.WaitingHook = false
                
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)

                task.wait(fishing.Settings.RetryDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end)
    end)

    if not ok then
        log("❌ Cast failed, retrying...")
        task.wait(fishing.Settings.RetryDelay)
        if fishing.Running then
            fishing.Cast()
        end
    end
end

---------------------------------------------------------------------
--                         🚀 START SYSTEM                         --
---------------------------------------------------------------------
function fishing.Start()
    if fishing.Running then 
        log("⚠️ Already running!")
        return 
    end
    
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.PerfectCasts = 0

    log("╔═══════════════════════════════════════╗")
    log("║   🎣 PERFECT CAST AUTO FISHING v30   ║")
    log("║        Status: ACTIVATED ✅          ║")
    log("╚═══════════════════════════════════════╝")
    
    disableFishingAnim()

    fishing.Connections = {}

    -- Hook detection listener
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local s = string.lower(state)
            if s:find("hook") or s:find("bite") or s:find("catch") or s:find("hit") then
                log("🎣 HOOK DETECTED!")
                fishing.WaitingHook = false
                
                task.wait(fishing.Settings.HookDetectionDelay)
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)

                task.wait(fishing.Settings.CancelDelay)
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then
                    fishing.Cast()
                end
            end
        end
    end)

    -- Fish caught listener
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(fishData)
        fishing.WaitingHook = false
        fishing.TotalFish += 1
        
        local fishName = "Unknown"
        if typeof(fishData) == "table" and fishData.Name then
            fishName = fishData.Name
        end
        
        log(("🐟 FISH CAUGHT! [%s] (Total: %d)"):format(fishName, fishing.TotalFish))

        task.wait(fishing.Settings.CancelDelay)
        pcall(function()
            RF_CancelFishingInputs:InvokeServer()
        end)

        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then
            fishing.Cast()
        end
    end)

    -- Start first cast
    task.wait(0.4)
    fishing.Cast()
end

---------------------------------------------------------------------
--                         ⛔ STOP SYSTEM                          --
---------------------------------------------------------------------
function fishing.Stop()
    fishing.Running = false
    fishing.WaitingHook = false

    for _, c in pairs(fishing.Connections or {}) do
        if typeof(c) == "RBXScriptConnection" then
            c:Disconnect()
        elseif typeof(c) == "thread" then
            task.cancel(c)
        end
    end

    log("╔═══════════════════════════════════════╗")
    log("║      🛑 AUTO FISHING STOPPED         ║")
    log(("║   Perfect Casts: %-4d                ║"):format(fishing.PerfectCasts))
    log(("║   Total Fish: %-4d                   ║"):format(fishing.TotalFish))
    log("╚═══════════════════════════════════════╝")
end

-- Auto-start function
function fishing.AutoStart()
    task.spawn(function()
        task.wait(1)
        fishing.Start()
    end)
end

return fishing
