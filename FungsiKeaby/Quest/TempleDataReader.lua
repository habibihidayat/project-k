--==============================================================--
--    TempleDataReader (FAST + SAFE VERSION, LOADSTRING READY)
--==============================================================--

local TempleDataReader = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)

local Data = nil
local Ready = false
local Callbacks = {}
local Started = false

----------------------------------------------------------------
-- 🔒 Utility: Safe Get Table
----------------------------------------------------------------
local function safeGet(tbl, key)
    if type(tbl) ~= "table" then return nil end
    return tbl[key]
end

----------------------------------------------------------------
-- 🔥 Convert Raw Replion Data → Status Table
----------------------------------------------------------------
local function BuildStatus()
    if not Ready or not Data then
        return {
            ["Crescent Artifact"] = false,
            ["Arrow Artifact"] = false,
            ["Diamond Artifact"] = false,
            ["Hourglass Diamond Artifact"] = false
        }
    end

    local leverData = Data:Get("TempleLevers") or {}

    return {
        ["Crescent Artifact"] = safeGet(leverData, "Crescent Artifact") == true,
        ["Arrow Artifact"] = safeGet(leverData, "Arrow Artifact") == true,
        ["Diamond Artifact"] = safeGet(leverData, "Diamond Artifact") == true,
        ["Hourglass Diamond Artifact"] = safeGet(leverData, "Hourglass Diamond Artifact") == true
    }
end

----------------------------------------------------------------
-- 📢 Fire Callbacks (Real-time)
----------------------------------------------------------------
local function Dispatch()
    if not Ready then return end
    local status = BuildStatus()

    for _, fn in ipairs(Callbacks) do
        task.spawn(fn, status)
    end
end

----------------------------------------------------------------
-- 🌐 Public: Get Temple Status
----------------------------------------------------------------
function TempleDataReader.GetTempleStatus()
    return BuildStatus()
end

----------------------------------------------------------------
-- 🧩 Public: Listen for Updates (Instant if Ready)
----------------------------------------------------------------
function TempleDataReader.OnTempleUpdate(callback)
    table.insert(Callbacks, callback)

    if Ready then
        task.spawn(callback, BuildStatus())
    end
end

----------------------------------------------------------------
-- 🟢 Public: Check Ready Status (For GUI)
----------------------------------------------------------------
function TempleDataReader.IsReady()
    return Ready
end

----------------------------------------------------------------
-- 🚀 INTERNAL: Initialize Once
----------------------------------------------------------------
local function Start()
    if Started then return end
    Started = true

    task.spawn(function()
        -- Wait Replion Data Object
        Data = Replion.Client:WaitReplion("Data")

        -- Mark ready as soon as object exists
        Ready = true

        -- Fire initial
        Dispatch()

        ----------------------------------------------------------------
        -- 📡 Listen to changes: ultra fast, no polling needed
        ----------------------------------------------------------------
        Data:OnChange("TempleLevers", function()
            Dispatch()
        end)
    end)
end

-- AUTO INIT
Start()

return TempleDataReader
