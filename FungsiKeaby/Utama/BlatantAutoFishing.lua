-- BlatantAutoFishing.lua
-- Mode Blatant: Ultra fast fishing for sleitnick_net system

local BlatantAutoFishing = {}
BlatantAutoFishing.Enabled = false
BlatantAutoFishing.Settings = {
    CastDelay = 0.001,
    ReelDelay = 0.001,
    RetryDelay = 0.001,
    ChargeTime = 1.0,        -- Waktu charge rod (1.0 = 100%)
    AutoShake = true,
    AutoReel = true,
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Variables
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local FishingConnection = nil
local ShakeConnection = nil
local MinigameConnection = nil
local isFishing = false
local isMinigameActive = false

-- Network events
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

print("✅ Network events loaded successfully!")

-- Fungsi untuk get rod
local function getRod()
    local character = localPlayer.Character
    if not character then return nil end
    
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("rod") or name:find("fishing") then
                return tool
            end
        end
    end
    
    -- Cari di backpack dan equip
    local backpack = localPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("rod") or name:find("fishing") then
                    character.Humanoid:EquipTool(tool)
                    task.wait(0.1)
                    return tool
                end
            end
        end
    end
    
    return nil
end

-- Fungsi untuk charge dan cast rod
local function chargeCast()
    pcall(function()
        local rod = getRod()
        if not rod then 
            warn("❌ Rod tidak ditemukan!")
            return 
        end
        
        if isFishing then
            print("⏳ Sudah dalam proses fishing, skip cast")
            return
        end
        
        print("🎣 Charging rod...")
        isFishing = true
        
        -- Invoke ChargeFishingRod dengan charge time
        local success, result = pcall(function()
            return RF_ChargeFishingRod:InvokeServer(BlatantAutoFishing.Settings.ChargeTime)
        end)
        
        if success then
            print("✅ Rod charged and casted! Charge:", BlatantAutoFishing.Settings.ChargeTime)
        else
            warn("❌ Failed to charge rod:", result)
            isFishing = false
        end
    end)
end

-- Fungsi untuk request minigame (reel)
local function requestMinigame()
    pcall(function()
        if not isFishing then
            print("⚠️ Tidak sedang fishing, skip minigame request")
            return
        end
        
        print("🎮 Requesting minigame...")
        
        local success, result = pcall(function()
            return RF_RequestMinigame:InvokeServer()
        end)
        
        if success then
            print("✅ Minigame requested!")
            isMinigameActive = true
        else
            warn("❌ Failed to request minigame:", result)
        end
    end)
end

-- Fungsi untuk cancel fishing
local function cancelFishing()
    pcall(function()
        print("❌ Canceling fishing...")
        
        RF_CancelFishingInputs:InvokeServer()
        
        isFishing = false
        isMinigameActive = false
        print("✅ Fishing canceled")
    end)
end

-- Listen untuk FishingCompleted event
local function setupFishingCompletedListener()
    RE_FishingCompleted.OnClientEvent:Connect(function(...)
        local args = {...}
        print("🐟 Fishing completed!", "Args:", table.concat(args, ", "))
        
        -- Reset state
        isFishing = false
        isMinigameActive = false
        
        -- Wait retry delay lalu cast lagi
        task.wait(BlatantAutoFishing.Settings.RetryDelay)
        
        if BlatantAutoFishing.Enabled then
            print("🔄 Retry fishing...")
            task.wait(BlatantAutoFishing.Settings.CastDelay)
            chargeCast()
        end
    end)
end

-- Listen untuk MinigameChanged event
local function setupMinigameListener()
    RE_MinigameChanged.OnClientEvent:Connect(function(state)
        print("🎮 Minigame state changed:", state)
        
        if state == true or state == "started" then
            isMinigameActive = true
            print("✅ Minigame active!")
            
            -- Auto complete minigame jika enabled
            if BlatantAutoFishing.Settings.AutoShake then
                -- Tunggu sebentar lalu spam complete
                task.wait(0.1)
                -- Minigame biasanya auto-complete atau perlu spam click
            end
        elseif state == false or state == "ended" then
            isMinigameActive = false
            print("🎮 Minigame ended")
        end
    end)
end

-- Auto shake untuk minigame UI
local function autoShake()
    if ShakeConnection then
        ShakeConnection:Disconnect()
    end
    
    ShakeConnection = RunService.RenderStepped:Connect(function()
        if not BlatantAutoFishing.Enabled or not BlatantAutoFishing.Settings.AutoShake then return end
        if not isMinigameActive then return end
        
        pcall(function()
            -- Cari minigame UI
            for _, gui in pairs(PlayerGUI:GetDescendants()) do
                if gui:IsA("ScreenGui") or gui:IsA("Frame") then
                    local name = gui.Name:lower()
                    
                    if (name:find("fishing") or name:find("mini") or name:find("game")) and 
                       (gui.Visible or (gui:IsA("ScreenGui") and gui.Enabled)) then
                        
                        -- Cari button atau clickable area
                        for _, button in pairs(gui:GetDescendants()) do
                            if button:IsA("TextButton") or button:IsA("ImageButton") or button:IsA("Frame") then
                                -- Spam click
                                pcall(function()
                                    for _, connection in pairs(getconnections(button.MouseButton1Click)) do
                                        connection:Fire()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end)
    end)
end

-- Main fishing loop
local function startFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
    end
    
    print("🔄 Starting fishing loop...")
    
    FishingConnection = RunService.Heartbeat:Connect(function()
        if not BlatantAutoFishing.Enabled then return end
        
        pcall(function()
            local rod = getRod()
            if not rod then return end
            
            -- State machine untuk fishing
            if not isFishing and not isMinigameActive then
                -- Idle state: perlu cast
                chargeCast()
                
            elseif isFishing and not isMinigameActive then
                -- Waiting for bite: coba request minigame
                if BlatantAutoFishing.Settings.AutoReel then
                    task.wait(BlatantAutoFishing.Settings.ReelDelay)
                    requestMinigame()
                end
            end
        end)
    end)
end

-- Fungsi Start
function BlatantAutoFishing.Start()
    if BlatantAutoFishing.Enabled then
        warn("⚠️ Blatant Auto Fishing sudah aktif!")
        return
    end
    
    print("="..string.rep("=", 50))
    print("🔥 BLATANT MODE STARTING...")
    print("="..string.rep("=", 50))
    
    -- Check rod
    local rod = getRod()
    if rod then
        print("✅ Rod found:", rod.Name)
    else
        warn("❌ ROD TIDAK DITEMUKAN!")
        return
    end
    
    BlatantAutoFishing.Enabled = true
    isFishing = false
    isMinigameActive = false
    
    -- Setup event listeners
    setupFishingCompletedListener()
    setupMinigameListener()
    
    -- Start loops
    startFishing()
    
    if BlatantAutoFishing.Settings.AutoShake then
        autoShake()
    end
    
    print("="..string.rep("=", 50))
    print("✅ BLATANT MODE AKTIF!")
    print("⚡ Cast Delay:", BlatantAutoFishing.Settings.CastDelay, "s")
    print("⚡ Reel Delay:", BlatantAutoFishing.Settings.ReelDelay, "s")
    print("⚡ Charge Time:", BlatantAutoFishing.Settings.ChargeTime)
    print("⚠️ WARNING: Mode ini sangat obvious!")
    print("="..string.rep("=", 50))
end

-- Fungsi Stop
function BlatantAutoFishing.Stop()
    if not BlatantAutoFishing.Enabled then
        warn("⚠️ Blatant Auto Fishing sudah tidak aktif!")
        return
    end
    
    BlatantAutoFishing.Enabled = false
    
    -- Cancel fishing yang sedang berjalan
    if isFishing then
        cancelFishing()
    end
    
    if FishingConnection then
        FishingConnection:Disconnect()
        FishingConnection = nil
    end
    
    if ShakeConnection then
        ShakeConnection:Disconnect()
        ShakeConnection = nil
    end
    
    print("🔴 Blatant Mode dinonaktifkan")
end

-- Handle respawn
localPlayer.CharacterAdded:Connect(function()
    if BlatantAutoFishing.Enabled then
        task.wait(2)
        
        isFishing = false
        isMinigameActive = false
        
        if FishingConnection then
            FishingConnection:Disconnect()
        end
        if ShakeConnection then
            ShakeConnection:Disconnect()
        end
        
        startFishing()
        if BlatantAutoFishing.Settings.AutoShake then
            autoShake()
        end
        
        print("🔄 Blatant Mode restarted")
    end
end)

-- Cleanup
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == localPlayer then
        if BlatantAutoFishing.Enabled then
            BlatantAutoFishing.Stop()
        end
    end
end)

return BlatantAutoFishing
