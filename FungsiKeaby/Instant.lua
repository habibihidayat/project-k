-- ⚡ ULTRA SPEED AUTO FISHING v29.3 (Perfect Cast Enhanced - Stable 100%)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Hentikan script lama jika masih aktif
if _G.FishingScript then
    _G.FishingScript.Stop()
    task.wait(0.1)
end

-- Init network
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

---------------------------------------------------------------------
-- MODULE FISHING
---------------------------------------------------------------------
local fishing = {
    Running = false,
    WaitingHook = false,
    CurrentCycle = 0,
    TotalFish = 0,
    PerfectCasts = 0,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.18,
        HookDetectionDelay = 0.01,
        RetryDelay = 0.60,
        MaxWaitTime = 1.3,
        ChargeTime = 1.0,      -- waktu charge untuk perfect
    }
}

_G.FishingScript = fishing

---------------------------------------------------------------------
-- LOGGING
---------------------------------------------------------------------
local function log(msg)
    print("[Fishing] " .. msg)
end

---------------------------------------------------------------------
-- Disable animasi fishing
---------------------------------------------------------------------
local function disableFishingAnim()
    pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            local name = track.Name:lower()
            if name:find("fish") or name:find("rod") or name:find("cast") or name:find("reel") then
                track:Stop(0)
            end
        end
    end)

    task.spawn(function()
        local rod = Character:FindFirstChild("Rod") 
            or Character:FindFirstChildWhichIsA("Tool")

        if rod and rod:FindFirstChild("Handle") then
            local handle = rod.Handle
            local weld = handle:FindFirstChildOfClass("Weld") 
                or handle:FindFirstChildOfClass("Motor6D")
            if weld then
                weld.C0 = CFrame.new(0, -1, -1.2) * CFrame.Angles(math.rad(-10), 0, 0)
            end
        end
    end)
end

---------------------------------------------------------------------
-- PERFECT CAST SYSTEM (Heartbeat Sync)
-- Force POWER = 1.0
-- Charge → Release → Minigame request dalam SATU frame
---------------------------------------------------------------------
function fishing.Cast()
    if not fishing.Running or fishing.WaitingHook then return end

    disableFishingAnim()
    fishing.CurrentCycle += 1

    log("⚡ PERFECT CAST | Cast #" .. fishing.CurrentCycle)

    fishing.WaitingHook = true

    local success = pcall(function()
        -- STEP 1: mulai charge
        local chargeStart = tick()
        RF_ChargeFishingRod:InvokeServer({[1] = chargeStart})

        -- STEP 2: Tunggu sampai chargeTime secara presisi (Heartbeat)
        while tick() - chargeStart < fishing.Settings.ChargeTime do
            RunService.Heartbeat:Wait()
        end

        -- STEP 3: Release + request minigame dalam frame yang sama
        local releaseTime = tick()
        local perfectPower = 1

        RF_RequestMinigame:InvokeServer(
            perfectPower,
            0,
            releaseTime
        )

        log("🎯 PERFECT CAST SENT | Δt = " .. string.format("%.4f", releaseTime - chargeStart))

        ---------------------------------------------------------------------
        -- TIMEOUT PROTECTION
        ---------------------------------------------------------------------
        task.delay(fishing.Settings.MaxWaitTime, function()
            if fishing.WaitingHook and fishing.Running then
                log("⚠️ Timeout — force reel")
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                fishing.WaitingHook = false
            end
        end)
    end)

    if not success then
        log("❌ Cast failed — retrying...")
        task.wait(fishing.Settings.RetryDelay)
        if fishing.Running then fishing.Cast() end
    end
end

---------------------------------------------------------------------
-- START
---------------------------------------------------------------------
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true

    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    fishing.PerfectCasts = 0

    log("🚀 PERFECT AUTO FISHING STARTED!")
    disableFishingAnim()

    -----------------------------------------------------------------
    -- HOOK DETECTED
    -----------------------------------------------------------------
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if fishing.WaitingHook and typeof(state) == "string" then
            local s = string.lower(state)
            if s:find("hook") or s:find("bite") or s:find("catch") then
                fishing.WaitingHook = false

                task.wait(fishing.Settings.HookDetectionDelay)

                pcall(function()
                    RE_FishingCompleted:FireServer()
                    log("✅ Hook detected — reeling!")
                end)

                task.wait(fishing.Settings.CancelDelay)

                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)

                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running then fishing.Cast() end
            end
        end
    end)

    -----------------------------------------------------------------
    -- FISH CAUGHT
    -----------------------------------------------------------------
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            fishing.WaitingHook = false
            fishing.TotalFish += 1
            fishing.PerfectCasts += 1

            local weight = data and data.Weight or 0
            log("🐟 Caught: " .. name .. " (" .. string.format("%.2f", weight) .. "kg)")

            task.wait(fishing.Settings.CancelDelay)
            pcall(function()
                RF_CancelFishingInputs:InvokeServer()
            end)

            task.wait(fishing.Settings.FishingDelay)
            if fishing.Running then fishing.Cast() end
        end
    end)

    -----------------------------------------------------------------
    -- Auto disable anim
    -----------------------------------------------------------------
    fishing.Connections.AnimFix = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.15)
        end
    end)

    task.wait(0.4)
    fishing.Cast()
end

---------------------------------------------------------------------
-- STOP
---------------------------------------------------------------------
function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    fishing.WaitingHook = false

    for _, c in pairs(fishing.Connections) do
        if typeof(c) == "RBXScriptConnection" then
            c:Disconnect()
        elseif typeof(c) == "thread" then
            task.cancel(c)
        end
    end

    fishing.Connections = {}
    log("🛑 STOPPED | Total Fish: " .. fishing.TotalFish)
end

return fishing
