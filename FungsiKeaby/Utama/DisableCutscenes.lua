--=====================================================
-- DisableCutscenes.lua (FINAL)
--=====================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Ambil folder net (aman karena sudah kamu cek ada di sini)
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Index = Packages:WaitForChild("_Index")
local NetFolder = Index:WaitForChild("sleitnick_net@0.2.0")
local net = NetFolder:WaitForChild("net")

-- Remote events yang akan dipaksa dimatikan
local ReplicateCutscene = net:FindFirstChild("ReplicateCutscene")
local StopCutscene = net:FindFirstChild("StopCutscene")
local BlackoutScreen = net:FindFirstChild("BlackoutScreen")

-- Opsional debug switch
local DEBUG = false

local function debugPrint(...)
	if DEBUG then
		print("[DisableCutscenes]", ...)
	end
end

debugPrint("Loaded. Disabling all cutscenes...")

--========================================
-- 1. Auto block jika server memanggil cutscene
--========================================
if ReplicateCutscene and ReplicateCutscene:IsA("RemoteEvent") then
	debugPrint("Blocking ReplicateCutscene...")

	ReplicateCutscene.OnClientEvent:Connect(function(...)
		debugPrint("Server tried to play cutscene, blocking...")
		if StopCutscene then
			StopCutscene:FireServer()
		end
	end)
end

--========================================
-- 2. Auto block blackout/fade
--========================================
if BlackoutScreen and BlackoutScreen:IsA("RemoteEvent") then
	debugPrint("Blocking BlackoutScreen...")

	BlackoutScreen.OnClientEvent:Connect(function(...)
		debugPrint("Blackout attempted -> Blocked")
	end)
end

--========================================
-- 3. Pastikan cutscene tetap dihentikan paksa
--========================================
task.spawn(function()
	while task.wait(1) do
		if StopCutscene then
			StopCutscene:FireServer()
		end
	end
end)

debugPrint("All cutscenes disabled successfully.")
