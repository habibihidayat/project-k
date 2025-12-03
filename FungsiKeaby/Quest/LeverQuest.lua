--========================================================--
--               AutoTempleModule.lua (FINAL)
--========================================================--

local AutoTemple = {}
local Run = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Replion (Temple Progress)
local Replion = require(game.ReplicatedStorage:WaitForChild("Replion"))
local data = Replion.Client:Get("Data")

-- Temple lever types (exact names)
local LeverTypes = {
    "Crescent Artifact",
    "Arrow Artifact",
    "Diamond Artifact",
    "Hourglass Diamond Artifact"
}

-- Folder lever di workspace
local JungleFolder = workspace:WaitForChild("JUNGLE INTERACTIONS")

---------------------------------------------------------------------
-- CARI LEVER DI WORKSPACE BERDASARKAN TYPE
---------------------------------------------------------------------
local function FindLeverByType(typeName)
    for _, obj in ipairs(JungleFolder:GetChildren()) do
        if obj.Name == "TempleLever" then
            local leverType = obj:GetAttribute("Type")
            if leverType == typeName then
                local part = obj:FindFirstChild("MovePiece") or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    return obj, part.Position
                end
            end
        end
    end
    return nil
end

---------------------------------------------------------------------
-- AMBIL PROGRESS TEMPLE
---------------------------------------------------------------------
local function GetProgress()
    local tab = data:GetExpect("TempleLevers")
    if typeof(tab) ~= "table" then
        return {
            ["Crescent Artifact"] = false,
            ["Arrow Artifact"] = false,
            ["Diamond Artifact"] = false,
            ["Hourglass Diamond Artifact"] = false
        }
    end
    return tab
end

---------------------------------------------------------------------
-- TEXT UNTUK GUI (PROGRESS)
---------------------------------------------------------------------
function AutoTemple.GetTempleInfoText()
    local prog = GetProgress()
    local t = {}

    for _, typeName in ipairs(LeverTypes) do
        local done = prog[typeName]
        table.insert(t, typeName .. " : " .. (done and "✅" or "❌"))
    end

    return table.concat(t, "\n")
end

---------------------------------------------------------------------
-- TELEPORT INSTAN CFRAME
---------------------------------------------------------------------
local function TeleportTo(pos)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end

---------------------------------------------------------------------
-- MENCARI LEVER YANG BELUM DONE
---------------------------------------------------------------------
local function GetNextLever()
    local prog = GetProgress()

    for _, typeName in ipairs(LeverTypes) do
        if not prog[typeName] then
            local model, pos = FindLeverByType(typeName)
            if pos then
                return typeName, pos
            end
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

            if typeName and pos then
                -- Teleport ke lever yang belum selesai
                TeleportTo(pos)
            else
                -- Semua lever selesai
                Run = false
                break
            end

            task.wait(1.2)
        end
    end)
end

---------------------------------------------------------------------
-- STOP
---------------------------------------------------------------------
function AutoTemple.Stop()
    Run = false
end

return AutoTemple
