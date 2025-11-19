-- ⚡ ULTRA SPEED AUTO FISHING v29.1 (PERFECT CAST MOD)
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
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.19,
        HookDetectionDelay = 0.01,
        RetryDelay = 0.1,
        MaxWaitTime = 0.8,
    },

    PerfectCastValue = 1.0,   -- 🎯 ALWAYS PERFECT CAST (1.0 = 100%)
}

_G.FishingScript = fishing

local function log(msg)
    print(("[Fishing] %s"):format(msg))
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
--                         🎯 PERFECT CAST HOOK                    --
---------------------------------------------------------------------
local function PerfectCast()
    local perfect = fishing.PerfectCastValue

    -- Inject perfect power
    RF_ChargeFishingRod:InvokeServer({
        [perfect] = tick(),  -- nilai chargetime perfect 1.0
    })

    -- Mulai perfect minigame request
    RF_RequestMinigame:InvokeServer(
        999999999999999999,   -- spoof param sama seperti original script
        perfect,              -- main perfect value
        tick()
    )
end


---------------------------------------------------------------------
--                         🎣 CUSTOM CAST                          --
---------------------------------------------------------------------
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1
    log("⚡ Cast (Cycle: " .. fishing.CurrentCycle .. ")")

    fishing.WaitingHook = true

    local ok = pcall(function()

        --------------------------------------------------------
        -- 🔥 ALWAYS PERFECT CAST (pengganti InvokeServer asli)
        --------------------------------------------------------
        PerfectCast()
        --------------------------------------------------------

        log("🎯 Menunggu hook...")

        task.delay(fishing.Settings.MaxWaitTime * 0.7, function()
            if fishing.WaitingHook and fishing.Running then
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
            end
        end)

        task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then

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
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0

    log("🚀 AUTO FISHING STARTED!")
    disableFishingAnim()

    RE_MinigameChanged.OnClientEvent:Connect(function(state)
        warn("STATE:", state)
    end)


    fishing.Connections = {}

    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local s = string.lower(state)
            if s:find("hook") or s:find("bite") or s:find("catch") then

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

    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function()
        fishing.WaitingHook = false
        fishing.TotalFish += 1

        task.wait(fishing.Settings.CancelDelay)
        pcall(function()
            RF_CancelFishingInputs:InvokeServer()
        end)

        task.wait(fishing.Settings.FishingDelay)
        if fishing.Running then
            fishing.Cast()
        end
    end)

    task.wait(0.4)
    fishing.Cast()
end


---------------------------------------------------------------------
--                         ⛔ STOP                                  --
---------------------------------------------------------------------
function fishing.Stop()
    fishing.Running = false
    fishing.WaitingHook = false

    for _, c in pairs(fishing.Connections) do
        if typeof(c) == "RBXScriptConnection" then
            c:Disconnect()
        elseif typeof(c) == "thread" then
            task.cancel(c)
        end
    end

    log("🛑 AUTO FISHING STOPPED")
end

return fishing

