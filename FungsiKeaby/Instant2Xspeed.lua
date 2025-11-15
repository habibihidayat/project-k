-- ⚡ ULTRA SPEED DUAL FISHING v30.0 (Two Hooks System)
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

-- Inisialisasi koneksi network
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

-- Modul utama dengan dual hook system
local fishing = {
    Running = false,
    Hooks = {
        [1] = { Active = false, CastTime = 0, TimeoutTask = nil },
        [2] = { Active = false, CastTime = 0, TimeoutTask = nil }
    },
    CurrentCycle = 0,
    TotalFish = 0,
    Connections = {},
    Settings = {
        FishingDelay = 0.01,
        CancelDelay = 0.15,
        HookDetectionDelay = 0.01,
        ChargeTime = 1.0, -- Konsisten 1 detik
        MaxWaitTime = 1.3,
        HookStagger = 0.15, -- Delay antara hook 1 dan 2
    }
}

_G.FishingScript = fishing

-- Logging ringkas
local function log(msg)
    print(("[Fishing] %s"):format(msg))
end

-- Fungsi disable animasi
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
        local rod = Character:FindFirstChild("Rod") or Character:FindFirstChildWhichIsA("Tool")
        if rod and rod:FindFirstChild("Handle") then
            local handle = rod.Handle
            local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("Motor6D")
            if weld then
                weld.C0 = CFrame.new(0, -1, -1.2) * CFrame.Angles(math.rad(-10), 0, 0)
            end
        end
    end)
end

-- Cleanup hook timeout
local function cleanupHookTimeout(hookId)
    local hook = fishing.Hooks[hookId]
    if hook.TimeoutTask then
        task.cancel(hook.TimeoutTask)
        hook.TimeoutTask = nil
    end
end

-- Check if any hook is available
local function hasAvailableHook()
    return not fishing.Hooks[1].Active or not fishing.Hooks[2].Active
end

-- Get next available hook ID
local function getAvailableHook()
    if not fishing.Hooks[1].Active then return 1 end
    if not fishing.Hooks[2].Active then return 2 end
    return nil
end

-- Reset specific hook
local function resetHook(hookId)
    local hook = fishing.Hooks[hookId]
    cleanupHookTimeout(hookId)
    hook.Active = false
    hook.CastTime = 0
end

-- Cast single hook dengan timing konsisten 1 detik
function fishing.CastHook(hookId)
    if not fishing.Running then return end
    
    local hook = fishing.Hooks[hookId]
    if hook.Active then return end
    
    disableFishingAnim()
    fishing.CurrentCycle += 1
    
    log("⚡ Hook #" .. hookId .. " Cast (Cycle: " .. fishing.CurrentCycle .. ")")

    local castSuccess = pcall(function()
        local castStartTime = tick()
        hook.CastTime = castStartTime
        
        -- Charge rod
        RF_ChargeFishingRod:InvokeServer({[1] = castStartTime})
        
        -- ⏱️ KONSISTEN 1 DETIK CHARGE
        local chargeTarget = fishing.Settings.ChargeTime
        local elapsed = 0
        
        repeat
            RunService.Heartbeat:Wait()
            elapsed = tick() - castStartTime
        until elapsed >= chargeTarget or not fishing.Running
        
        -- Request minigame TEPAT setelah 1 detik
        local minigameTime = tick()
        RF_RequestMinigame:InvokeServer(1, 0, minigameTime)
        
        hook.Active = true
        log("🎯 Hook #" .. hookId .. " ready! (Charge: " .. string.format("%.3f", elapsed) .. "s)")

        -- Timeout system untuk hook ini
        hook.TimeoutTask = task.delay(fishing.Settings.MaxWaitTime, function()
            if hook.Active and fishing.Running then
                log("⏰ Hook #" .. hookId .. " timeout - trying reel")
                
                -- Try to reel this hook
                pcall(function()
                    RE_FishingCompleted:FireServer()
                end)
                
                task.wait(fishing.Settings.CancelDelay)
                
                pcall(function()
                    RF_CancelFishingInputs:InvokeServer()
                end)
                
                -- Reset this hook
                resetHook(hookId)
                
                -- Cast ulang hook ini
                task.wait(fishing.Settings.FishingDelay)
                if fishing.Running and hasAvailableHook() then
                    fishing.CastHook(hookId)
                end
            end
        end)
    end)

    if not castSuccess then
        log("❌ Hook #" .. hookId .. " cast failed, retrying...")
        resetHook(hookId)
        task.wait(0.1)
        if fishing.Running then
            fishing.CastHook(hookId)
        end
    end
end

-- Handle catch (bisa dari hook manapun)
local function handleCatch()
    if not fishing.Running then return end
    
    -- Cari hook mana yang berhasil (hook dengan Active = true)
    local caughtHookId = nil
    for id, hook in pairs(fishing.Hooks) do
        if hook.Active then
            caughtHookId = id
            break
        end
    end
    
    if not caughtHookId then return end
    
    local hook = fishing.Hooks[caughtHookId]
    log("✅ Hook #" .. caughtHookId .. " caught!")
    
    -- Reel
    pcall(function()
        RE_FishingCompleted:FireServer()
    end)
    
    task.wait(fishing.Settings.CancelDelay)
    
    pcall(function()
        RF_CancelFishingInputs:InvokeServer()
    end)
    
    -- Reset hook yang berhasil
    resetHook(caughtHookId)
    
    -- Cast ulang hook tersebut
    task.wait(fishing.Settings.FishingDelay)
    if fishing.Running then
        fishing.CastHook(caughtHookId)
    end
end

-- Start / Stop Functions
function fishing.Start()
    if fishing.Running then return end
    fishing.Running = true
    fishing.CurrentCycle = 0
    fishing.TotalFish = 0
    
    -- Reset all hooks
    for id, hook in pairs(fishing.Hooks) do
        resetHook(id)
    end

    log("🚀 DUAL FISHING STARTED!")
    log("⚡ Two hooks system - double the chance!")
    disableFishingAnim()

    -- Minigame state detector (bekerja untuk kedua hook)
    fishing.Connections.Minigame = RE_MinigameChanged.OnClientEvent:Connect(function(state)
        if typeof(state) == "string" then
            local stateLower = string.lower(state)
            if string.find(stateLower, "hook") or 
               string.find(stateLower, "bite") or 
               string.find(stateLower, "catch") or
               string.find(stateLower, "reel") then
                handleCatch()
            end
        end
    end)

    -- Fish caught detector
    fishing.Connections.Caught = RE_FishCaught.OnClientEvent:Connect(function(name, data)
        if fishing.Running then
            fishing.TotalFish += 1
            
            local weight = data and data.Weight or 0
            log("🐟 " .. tostring(name) .. " (" .. string.format("%.2f", weight) .. "kg) | Total: " .. fishing.TotalFish)
        end
    end)

    -- Disable animasi
    fishing.Connections.AnimDisabler = task.spawn(function()
        while fishing.Running do
            disableFishingAnim()
            task.wait(0.1)
        end
    end)

    -- Auto re-cast system untuk maintain 2 hooks aktif
    fishing.Connections.MaintainHooks = task.spawn(function()
        while fishing.Running do
            task.wait(0.1)
            
            -- Selalu pastikan ada 2 hook aktif
            for hookId = 1, 2 do
                if fishing.Running and not fishing.Hooks[hookId].Active then
                    -- Check jika hook sudah terlalu lama tidak aktif
                    local idleTime = tick() - fishing.Hooks[hookId].CastTime
                    if idleTime > 0.5 or fishing.Hooks[hookId].CastTime == 0 then
                        fishing.CastHook(hookId)
                        task.wait(fishing.Settings.HookStagger) -- Stagger untuk avoid collision
                    end
                end
            end
        end
    end)

    -- Start dengan cast kedua hook
    task.wait(0.3)
    fishing.CastHook(1) -- Cast hook pertama
    task.wait(fishing.Settings.HookStagger) -- Delay sedikit
    fishing.CastHook(2) -- Cast hook kedua
end

function fishing.Stop()
    if not fishing.Running then return end
    fishing.Running = false
    
    -- Reset all hooks
    for id, hook in pairs(fishing.Hooks) do
        resetHook(id)
    end

    -- Disconnect all connections
    for _, conn in pairs(fishing.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif typeof(conn) == "thread" then
            task.cancel(conn)
        end
    end
    fishing.Connections = {}

    log("🛑 DUAL FISHING STOPPED | Total: " .. fishing.TotalFish .. " fish")
end

-- 🎯 COMMANDS FOR GUI:
-- _G.FishingScript.Start()
-- _G.FishingScript.Stop()
-- _G.FishingScript.TotalFish
--
-- SETTINGS:
-- _G.FishingScript.Settings.ChargeTime = 1.0 (konsisten 1 detik)
-- _G.FishingScript.Settings.HookStagger = 0.15 (delay antar hook)

return fishing
