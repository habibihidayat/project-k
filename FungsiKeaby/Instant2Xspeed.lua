-- ⚡ ULTRA SPEED AUTO FISHING v30 (Instant Hook Edition + Delay GUI)
-- Dibuat untuk memunculkan tanda seru SECEPAT MUNGKIN ⚡

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

-- 🔌 Network path
local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
	:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")
local RE_FishCaught = netFolder:WaitForChild("RE/FishCaught")

-- 🎣 Main module
local fishing = {
	Running = false,
	WaitingHook = false,
	CurrentCycle = 0,
	TotalFish = 0,
	Settings = {
		FishingDelay = 0.25,
		CancelDelay = 0.05,
		PreRequestDelay = 0.02, -- waktu sebelum ChargeRod (agar tanda seru muncul cepat)
		MaxWaitTime = 1.0,
	}
}
_G.FishingScript = fishing

local function log(msg)
	print("[Fishing] " .. msg)
end

-- 🪝 Event hook detection
RE_MinigameChanged.OnClientEvent:Connect(function(state)
	if fishing.WaitingHook and typeof(state) == "string" and string.find(string.lower(state), "hook") then
		fishing.WaitingHook = false
		task.wait(0.05)
		RE_FishingCompleted:FireServer()
		log("✅ Hook terdeteksi — ikan ditarik!")
		task.wait(fishing.Settings.CancelDelay)
		pcall(function() RF_CancelFishingInputs:InvokeServer() end)
		task.wait(fishing.Settings.FishingDelay)
		if fishing.Running then fishing.Cast() end
	end
end)

-- 🐟 Tangkap ikan event
RE_FishCaught.OnClientEvent:Connect(function(name, data)
	if fishing.Running then
		fishing.WaitingHook = false
		fishing.TotalFish += 1
		log("🐟 Ikan tertangkap: " .. tostring(name))
		task.wait(fishing.Settings.CancelDelay)
		pcall(function() RF_CancelFishingInputs:InvokeServer() end)
		task.wait(fishing.Settings.FishingDelay)
		if fishing.Running then fishing.Cast() end
	end
end)

-- 🎯 Casting logic (instant hook version)
function fishing.Cast()
	if not fishing.Running or fishing.WaitingHook then return end
	fishing.CurrentCycle += 1

	pcall(function()
		-- Panggil RequestMinigame lebih dulu agar "!" langsung muncul saat kail menyentuh air
		RF_RequestMinigame:InvokeServer(9, 0, tick())
		task.wait(fishing.Settings.PreRequestDelay)
		RF_ChargeFishingRod:InvokeServer({[22] = tick()})

		log("⚡ Lempar pancing (Cycle " .. fishing.CurrentCycle .. ")")
		fishing.WaitingHook = true

		-- Timeout (fallback jika hook tidak muncul)
		task.delay(fishing.Settings.MaxWaitTime, function()
			if fishing.WaitingHook and fishing.Running then
				fishing.WaitingHook = false
				RE_FishingCompleted:FireServer()
				log("⚠️ Timeout pendek — fallback tarik cepat.")
				task.wait(fishing.Settings.CancelDelay)
				pcall(function() RF_CancelFishingInputs:InvokeServer() end)
				task.wait(fishing.Settings.FishingDelay)
				if fishing.Running then fishing.Cast() end
			end
		end)
	end)
end

function fishing.Start()
	if fishing.Running then return end
	fishing.Running = true
	fishing.CurrentCycle = 0
	fishing.TotalFish = 0
	log("🚀 AUTO FISHING STARTED!")
	fishing.Cast()
end

function fishing.Stop()
	fishing.Running = false
	fishing.WaitingHook = false
	log("🛑 AUTO FISHING STOPPED")
end

-- ===============================
-- 🎛️ GUI PENGATUR DELAY
-- ===============================
local gui = Instance.new("ScreenGui")
gui.Name = "FishingDelayControl"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 230)
frame.Position = UDim2.new(0.03, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "🎣 Ultra Speed Fishing GUI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = frame

local y = 30
local function makeInput(label, key)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.6, 0, 0, 20)
	lbl.Position = UDim2.new(0, 5, 0, y)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Text = label .. ":"
	lbl.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.35, 0, 0, 20)
	box.Position = UDim2.new(0.63, 0, 0, y)
	box.BackgroundColor3 = Color3.fromRGB(40,40,40)
	box.TextColor3 = Color3.new(1,1,1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.Text = tostring(fishing.Settings[key])
	box.ClearTextOnFocus = false
	box.Parent = frame
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,5)

	box.FocusLost:Connect(function()
		local val = tonumber(box.Text)
		if val then
			fishing.Settings[key] = val
			log(label .. " diubah ke " .. val)
		end
	end)

	y += 25
end

makeInput("🎯 Fishing Delay", "FishingDelay")
makeInput("⏳ Cancel Delay", "CancelDelay")
makeInput("⚡ PreRequest Delay", "PreRequestDelay")
makeInput("🕒 Max Wait Time", "MaxWaitTime")

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.45, 0, 0, 25)
startBtn.Position = UDim2.new(0.03, 0, 1, -30)
startBtn.Text = "▶ START"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,5)
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.45, 0, 0, 25)
stopBtn.Position = UDim2.new(0.52, 0, 1, -30)
stopBtn.Text = "⏹ STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,5)
stopBtn.Parent = frame

startBtn.MouseButton1Click:Connect(function()
	fishing.Start()
end)

stopBtn.MouseButton1Click:Connect(function()
	fishing.Stop()
end)

log("✅ Fishing system ready (instant hook + GUI aktif)")
return fishing
