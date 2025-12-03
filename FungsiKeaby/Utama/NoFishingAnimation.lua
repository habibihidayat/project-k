-- NoFishingAnimation.lua (No Log Version)
local NoFishingAnimation = {}
NoFishingAnimation.Enabled = false
NoFishingAnimation.Connection = nil
NoFishingAnimation.SavedPose = {}
NoFishingAnimation.ReelingTrack = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local REELING_ANIMATION_ID = "rbxassetid://YOUR_REELING_ID"

local function getOrCreateReelingAnimation()
    local result
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then return end

        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            local name = track.Name
            if name:find("Reel") and name:find("Idle") then
                result = track
                return
            end
        end

        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, anim in pairs(tool:GetDescendants()) do
                    if anim:IsA("Animation") then
                        local name = anim.Name
                        if name:find("Reel") and name:find("Idle") then
                            result = animator:LoadAnimation(anim)
                            return
                        end
                    end
                end
            end
        end
    end)
    return result
end

local function capturePose()
    NoFishingAnimation.SavedPose = {}
    local count = 0
    pcall(function()
        local character = localPlayer.Character
        if not character then return end
        for _, descendant in pairs(character:GetDescendants()) do
            if descendant:IsA("Motor6D") then
                NoFishingAnimation.SavedPose[descendant.Name] = {
                    Part = descendant,
                    C0 = descendant.C0,
                    C1 = descendant.C1,
                    Transform = descendant.Transform
                }
                count = count + 1
            end
        end
    end)
    return count > 0
end

local function freezePose()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
    end
    NoFishingAnimation.Connection = RunService.RenderStepped:Connect(function()
        if not NoFishingAnimation.Enabled then return end
        pcall(function()
            local character = localPlayer.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
            for jointName, poseData in pairs(NoFishingAnimation.SavedPose) do
                local motor = character:FindFirstChild(jointName, true)
                if motor and motor:IsA("Motor6D") then
                    motor.C0 = poseData.C0
                    motor.C1 = poseData.C1
                end
            end
        end)
    end)
end

local function stopFreeze()
    if NoFishingAnimation.Connection then
        NoFishingAnimation.Connection:Disconnect()
        NoFishingAnimation.Connection = nil
    end
    if NoFishingAnimation.ReelingTrack then
        NoFishingAnimation.ReelingTrack:Stop()
        NoFishingAnimation.ReelingTrack = nil
    end
    NoFishingAnimation.SavedPose = {}
end

function NoFishingAnimation.Start()
    if NoFishingAnimation.Enabled then return end
    local character = localPlayer.Character
    if not character then return end

    local reelingTrack = getOrCreateReelingAnimation()
    if reelingTrack then
        reelingTrack:Play()
        reelingTrack:AdjustSpeed(0)
        NoFishingAnimation.ReelingTrack = reelingTrack

        task.wait(0.2)
        local success = capturePose()
        if success then
            NoFishingAnimation.Enabled = true
            freezePose()
        else
            reelingTrack:Stop()
        end
    end
end

function NoFishingAnimation.StartWithDelay()
    if NoFishingAnimation.Enabled then return end
    task.wait(2)
    local success = capturePose()
    if success then
        NoFishingAnimation.Enabled = true
        freezePose()
    end
end

function NoFishingAnimation.Stop()
    if not NoFishingAnimation.Enabled then return end
    NoFishingAnimation.Enabled = false
    stopFreeze()
end

localPlayer.CharacterAdded:Connect(function(character)
    if NoFishingAnimation.Enabled then
        NoFishingAnimation.Enabled = false
        stopFreeze()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player == localPlayer and NoFishingAnimation.Enabled then
        NoFishingAnimation.Stop()
    end
end)

return NoFishingAnimation
