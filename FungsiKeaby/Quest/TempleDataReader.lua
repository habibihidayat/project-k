--========================================================--
--       TempleDataReader (FULL DEBUG - FIND ROOT CAUSE)
--========================================================--

local TempleDataReader = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Replion = Packages and require(Packages:WaitForChild("Replion"))

local Data = nil
local Ready = false
local Listeners = {}
local Started = false

local EXPECT_KEYS = {
    "Crescent Artifact",
    "Arrow Artifact",
    "Diamond Artifact",
    "Hourglass Diamond Artifact"
}

---------------------------------------------------------
-- INTERNAL: Print table safely
---------------------------------------------------------
local function dump(tbl)
    if type(tbl) ~= "table" then return tostring(tbl) end
    local str = ""
    for k,v in pairs(tbl) do
        str = str .. tostring(k) .. " = " .. tostring(v) .. "\n"
    end
    return str
end

---------------------------------------------------------
-- Get Status (safe)
---------------------------------------------------------
function TempleDataReader.GetTempleStatus()
    if not Ready or not Data then
        return {}
    end

    local leverData = Data:Get("TempleLevers")
    if type(leverData) ~= "table" then
        print("[TDR] TempleLevers bukan table. Value =", leverData)
        return {}
    end

    local result = {}
    for _, key in ipairs(EXPECT_KEYS) do
        result[key] = leverData[key] == true
    end
    return result
end

---------------------------------------------------------
-- Listener
---------------------------------------------------------
function TempleDataReader.OnTempleUpdate(cb)
    table.insert(Listeners, cb)
    if Ready then
        cb(TempleDataReader.GetTempleStatus())
    end
end

---------------------------------------------------------
-- NOTIFY ALL LISTENERS
---------------------------------------------------------
local function FireUpdate()
    if not Ready then return end
    local status = TempleDataReader.GetTempleStatus()
    for _, cb in ipairs(Listeners) do
        task.spawn(cb, status)
    end
end

---------------------------------------------------------
-- START
---------------------------------------------------------
local function Start()
    if Started then return end
    Started = true

    task.spawn(function()

        print("\n==============================")
        print("[TDR] STARTING DEBUG MODE")
        print("==============================")

        print("[TDR] Menunggu Replion Client...")

        if not Replion then
            warn("[TDR] ERROR: Replion tidak ada di ReplicatedStorage.Packages!")
            return
        end

        Data = Replion.Client:WaitReplion("Data")

        if not Data then
            warn("[TDR] ERROR: Replion 'Data' tidak ditemukan!")
            return
        end

        print("[TDR] Replion Data ditemukan!")
        print("[TDR] Keys dalam Data:", dump(Data:GetAll()))

        -- Tunggu TempleLevers
        print("[TDR] Menunggu key TempleLevers...")
        while not Data:Get("TempleLevers") do
            task.wait(0.25)
        end

        local leverTable = Data:Get("TempleLevers")
        print("[TDR] TempleLevers ditemukan:")
        print(dump(leverTable))

        Ready = true

        -- Listener perubahan
        Data:OnChange("TempleLevers", function(newValue)
            print("[TDR] TempleLevers UPDATED:")
            print(dump(newValue))
            FireUpdate()
        end)

        FireUpdate()
    end)
end

Start()

return TempleDataReader
