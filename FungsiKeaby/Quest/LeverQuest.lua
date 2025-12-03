--========================================================--
--       AutoTempleModule (NO REPLION, FINAL FIXED)
--========================================================--

local AutoTemple = {}
local Run = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Temple data asli dari game (bukan Replion)
local TempleStateFolder = game.ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Types")
    :WaitForChild("TempleState")

local TempleLeverFolder = TempleStateFolder:WaitForChild("TempleLevers")

-- Folder lever fisik di map
local JungleFolder = workspace:WaitForChild("JUNGLE INTERACTIONS")

local LeverTypes = {
    "Crescent Artifact",
    "Arrow Artifact",
    "Diamond Artifact",
    "Hourglass Diamond Artifact"
}

---------------------------------------------------------------------
-- AMBIL STATUS LEVER DARI ATTRIBUTE ASLI GAME
---------------------------------------------------------------------
local function GetTempleProgress()
    local result = {}

    for _, typeName in ipairs(LeverTypes) do
        local lever = TempleLeverFolder:FindFirstChild(typeName)
        if lever then
            result[typeName] = lever:GetAttribute("Completed") == true
        else
            result[typeName] = false
        end
    end

    return result
end

---------------------------------------------------------------------
-- CARI LEVER FISIK DI MAP
---------------------------------------------------------------------
local function FindLeverByType(typeName)
    for _, obj in ipairs(JungleFolder:GetChildren()) do
        if obj.Name == "TempleLever" then
            local Type = obj:GetAttribute("Type")
            if Type == typeName then
                local part =
                    obj:FindFirstChild("MovePiece") or
                    obj:FindFirstChildWhichIsA("BasePart")

                if part then
                    return obj, part.Position
                end
            end
        end
    end
    return nil
end

---------------------------------------------------------------------
-- PROGRESS TEXT UNTUK GUI
---------------------------------------------------------------------
function AutoTemple.GetTempleInfoText()
    local prog = GetTempleProgress()
    local lines = {}

    for _, typeName in ipairs(LeverTypes) do
        table.insert(lines, typeName .. " : " .. (prog[typeName] and "✅" or "❌"))
    end

    return table.concat(lines, "\n")
end

---------------------------------------------------------------------
-- TELEPORT DIRECT CFRAME
---------------------------------------------------------------------
local function TeleportTo(pos)
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end

---------------------------------------------------------------------
-- AMBIL LEVER YANG BELUM SELESAI
---------------------------------------------------------------------
local function GetNextLever()
    local prog = GetTempleProgress()

    for _, typeName in ipairs(LeverTypes) do
        if not prog[typeName] then
            local model, pos = FindLeverByType(typeName)
            if pos then return typeName, pos end
        end
    end

    return nil
end

---------------------------------------------------------------------
-- START AUTO TEMPLE
---------------------------------------------------------------------
function AutoTemple.Start()
    if Run then return end
    Run = true

    task.spawn(function()
        while Run do
            local typeName, pos = GetNextLever()

            if not typeName then
                Run = false
                break
            end

            TeleportTo(pos)
            task.wait(1.2)
        end
    end)
end

---------------------------------------------------------------------
-- STOP AUTO TEMPLE
---------------------------------------------------------------------
function AutoTemple.Stop()
    Run = false
end

return AutoTemple
