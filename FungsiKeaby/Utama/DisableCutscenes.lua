--=====================================================
--  MODULE: DisableCutscenes.lua
--=====================================================

local DisableCutscenes = {}
local enabled = false

local RS = game:GetService("ReplicatedStorage")

-- Path RemoteEvent net
local NetFolder = RS:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")
    :WaitForChild("RE")

local ReplicateCutscene = NetFolder:WaitForChild("ReplicateCutscene")
local StopCutscene = NetFolder:WaitForChild("StopCutscene")

local conn1, conn2

-- =====================================================
-- START (ENABLE)
-- =====================================================
function DisableCutscenes.Start()
    if enabled then return end
    enabled = true

    -- Block cutscene start
    conn1 = ReplicateCutscene.OnClientEvent:Connect(function(...)
        warn("[DisableCutscenes] Cutscene blocked!")
        -- Tidak menjalankan apapun, jadi cutscene tidak terjadi
    end)

    -- Ensure cutscene instantly stops (jika terlanjur dipicu)
    conn2 = StopCutscene.OnClientEvent:Connect(function(...)
        warn("[DisableCutscenes] Forced cutscene stop!")
    end)

    print("[DisableCutscenes] ENABLED")
end

-- =====================================================
-- STOP (DISABLE)
-- =====================================================
function DisableCutscenes.Stop()
    if not enabled then return end
    enabled = false

    if conn1 then conn1:Disconnect() end
    if conn2 then conn2:Disconnect() end

    print("[DisableCutscenes] DISABLED")
end

return DisableCutscenes
