--========================================================--
--            TempleDataReader.lua (LOADSTRING READY)
--========================================================--

local TempleDataReader = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)

local Data = nil
local Ready = false
local Listeners = {}
local Started = false

-----------------------------------------------------------
-- INTERNAL: Trigger callbacks on data update
-----------------------------------------------------------
local function FireUpdate()
    if not Ready then return end

    local status = TempleDataReader.GetTempleStatus()

    for _, cb in ipairs(Listeners) do
        task.spawn(cb, status)
    end
end

-----------------------------------------------------------
-- PUBLIC: Read current temple lever status
-----------------------------------------------------------
function TempleDataReader.GetTempleStatus()
    if not Ready or not Data then
        return {
            ["Crescent Artifact"] = false,
            ["Arrow Artifact"] = false,
            ["Diamond Artifact"] = false,
            ["Hourglass Diamond Artifact"] = false
        }
    end

    local leverData = Data:Get("TempleLevers")

    return {
        ["Crescent Artifact"] = leverData["Crescent Artifact"] == true,
        ["Arrow Artifact"] = leverData["Arrow Artifact"] == true,
        ["Diamond Artifact"] = leverData["Diamond Artifact"] == true,
        ["Hourglass Diamond Artifact"] = leverData["Hourglass Diamond Artifact"] == true
    }
end

-----------------------------------------------------------
-- PUBLIC: Register callback for updates
-----------------------------------------------------------
function TempleDataReader.OnTempleUpdate(callback)
    table.insert(Listeners, callback)

    -- If ready, trigger immediately once
    if Ready then
        task.spawn(callback, TempleDataReader.GetTempleStatus())
    end
end

-----------------------------------------------------------
-- INTERNAL: Auto-start listener once
-----------------------------------------------------------
local function Start()
    if Started then return end
    Started = true

    task.spawn(function()
        print("[TempleDataReader] Waiting for Replion Data...")

        Data = Replion.Client:WaitReplion("Data")

        -- Wait for TempleLevers to be initialized
        while not Data:Get("TempleLevers") do
            task.wait(0.25)
        end

        Ready = true

        print("[TempleDataReader] TempleLevers ready:")
        print(Data:Get("TempleLevers"))

        -- Listener for updates
        Data:OnChange("TempleLevers", function()
            print("[TempleDataReader] TempleLevers updated!")
            FireUpdate()
        end)

        -- First update
        FireUpdate()
    end)
end

-- AUTO-START immediately when module is loaded
Start()

return TempleDataReader
