-- SKIN SWAP MODULE
-- To be hosted on raw link and called by main GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- ========================================
-- MODULE
-- ========================================

local SkinSwap = {}

-- ========================================
-- CONFIGURATIONS
-- ========================================

local SKINS = {
    Eclipse = {
        EquipIdle = "rbxassetid://103641983335689",
        RodThrow = "rbxassetid://82600073500966",
        FishCaught = "rbxassetid://107940819382815",
        ReelingIdle = "rbxassetid://115229621326605",
        ReelStart = "rbxassetid://115229621326605",
        ReelIntermission = "rbxassetid://115229621326605",
        StartRodCharge = "rbxassetid://115229621326605",
    },
    HolyTrident = {
        EquipIdle = "rbxassetid://83219020397849",
        RodThrow = "rbxassetid://114917462794864",
        FishCaught = "rbxassetid://128167068291703",
        ReelingIdle = "rbxassetid://126831815839724",
        ReelStart = "rbxassetid://126831815839724",
        ReelIntermission = "rbxassetid://126831815839724",
        StartRodCharge = "rbxassetid://83219020397849",
    },
}

local SPEEDS = {
    Eclipse = {
        RodThrow = 1.4,
        FishCaught = 1.0,
        default = 1.0,
    },
    HolyTrident = {
        RodThrow = 1.3,
        FishCaught = 1.2,
        default = 1.0,
    },
}

local ANIM_MAP = {
    ["96586569072385"] = "EquipIdle",
    ["139622307103608"] = "StartRodCharge",
    ["92624107165273"] = "RodThrow",
    ["136614469321844"] = "ReelStart",
    ["134965425664034"] = "ReelingIdle",
    ["114959536562596"] = "ReelIntermission",
    ["117319000848286"] = "FishCaught",
    ["137429009359442"] = "StartRodCharge",
}

-- State
local currentSkin = "Eclipse"
local isEnabled = false
local monitorConn = nil
local processed = {}

-- ========================================
-- INTERNAL FUNCTIONS
-- ========================================

local function getHumanoid()
    local char = LP.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getAnimator()
    local hum = getHumanoid()
    return hum and hum:FindFirstChildOfClass("Animator")
end

local function getAnimType(id)
    local num = id:match("(%d+)")
    return num and ANIM_MAP[num]
end

local function replaceAnimation(track)
    if not track or not track.Animation then return end
    
    local id = track.Animation.AnimationId
    local animType = getAnimType(id)
    
    if not animType then return end
    
    local trackKey = tostring(track)
    if processed[trackKey] then return end
    
    local skinAnims = SKINS[currentSkin]
    local newId = skinAnims[animType]
    
    if not newId then return end
    
    -- Check if already correct animation
    if id:find(newId:match("(%d+)")) then
        local speeds = SPEEDS[currentSkin]
        local speed = speeds[animType] or speeds.default or 1.0
        track.Speed = speed
        processed[trackKey] = true
        return
    end
    
    -- Replace animation
    local wasPlaying = track.IsPlaying
    local timePos = track.TimePosition
    local weight = track.WeightCurrent
    
    if wasPlaying then
        track:Stop(0)
    end
    
    -- Create new animation
    local newAnim = Instance.new("Animation")
    newAnim.AnimationId = newId
    
    local hum = getHumanoid()
    if not hum then return end
    
    -- Load new track
    local success, newTrack = pcall(function()
        return hum:LoadAnimation(newAnim)
    end)
    
    if not success or not newTrack then
        newAnim:Destroy()
        return
    end
    
    -- Set speed
    local speeds = SPEEDS[currentSkin]
    local speed = speeds[animType] or speeds.default or 1.0
    
    -- Play
    if wasPlaying then
        task.wait(0.02)
        newTrack:Play(0, weight, speed)
        
        pcall(function()
            newTrack.TimePosition = timePos
        end)
    end
    
    processed[trackKey] = true
    
    -- Cleanup
    newTrack.Ended:Connect(function()
        processed[trackKey] = nil
    end)
    
    newAnim:Destroy()
end

local function checkAllAnimations()
    local animator = getAnimator()
    if not animator then return end
    
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        pcall(function()
            replaceAnimation(track)
        end)
    end
end

-- ========================================
-- PUBLIC FUNCTIONS
-- ========================================

function SkinSwap.Start()
    if isEnabled then
        return false, "Sudah aktif!"
    end
    
    isEnabled = true
    processed = {}
    
    -- Monitor continuously
    monitorConn = RunService.Heartbeat:Connect(function()
        if not isEnabled then return end
        
        if tick() % 0.1 < 0.016 then
            pcall(checkAllAnimations)
        end
    end)
    
    -- Handle respawn
    LP.CharacterAdded:Connect(function()
        if not isEnabled then return end
        task.wait(2)
        processed = {}
        checkAllAnimations()
    end)
    
    task.wait(0.5)
    checkAllAnimations()
    
    return true, "Skin swap aktif!"
end

function SkinSwap.Stop()
    if not isEnabled then
        return false, "Sudah nonaktif!"
    end
    
    isEnabled = false
    processed = {}
    
    if monitorConn then
        monitorConn:Disconnect()
        monitorConn = nil
    end
    
    return true, "Skin swap dimatikan!"
end

function SkinSwap.SetSkin(skin)
    if not SKINS[skin] then
        return false, "Skin tidak ditemukan: " .. tostring(skin)
    end
    
    currentSkin = skin
    processed = {}
    
    if isEnabled then
        task.wait(0.1)
        checkAllAnimations()
    end
    
    return true, "Skin diganti ke " .. skin
end

function SkinSwap.GetCurrentSkin()
    return currentSkin
end

function SkinSwap.IsRunning()
    return isEnabled
end

function SkinSwap.GetAvailableSkins()
    local skins = {}
    for name, _ in pairs(SKINS) do
        table.insert(skins, name)
    end
    return skins
end

return SkinSwap
