-- Remote Merchant System (Standalone Version)
-- Script ini dibuat untuk dijalankan via loadstring + raw link

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Net package (remote event paths)
local Net = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local PurchaseMarketItem = Net:WaitForChild("RF/PurchaseMarketItem")

-- Merchant UI
local MerchantUI = PlayerGui:WaitForChild("Merchant")

-- =============================
--  FUNCTIONS
-- =============================

local function OpenMerchant()
    if MerchantUI then
        MerchantUI.Enabled = true
    end
end

local function CloseMerchant()
    if MerchantUI then
        MerchantUI.Enabled = false
    end
end

local function PurchaseItem(id)
    local success, err = pcall(function()
        PurchaseMarketItem:InvokeServer(id)
    end)

    if not success then
        warn("Purchase failed:", err)
    end
end

-- Export table
return {
    Open = OpenMerchant,
    Close = CloseMerchant,
    Buy = PurchaseItem
}
