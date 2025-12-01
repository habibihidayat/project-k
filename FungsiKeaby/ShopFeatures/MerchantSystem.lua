--// OPEN GUI SHOPS FROM EXTERNAL SCRIPT
-- Fungsi ini membuka GUI apa pun berdasarkan nama folder di PlayerGui

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Shops = {
    Merchant = "Merchant",
    RodShop = "Rod Shop",
    BaitShop = "Bait Shop"
}

local function OpenShop(shopKey)
    local guiName = Shops[shopKey]
    if not guiName then
        warn("Shop key tidak ditemukan:", shopKey)
        return
    end

    local shopGui = PlayerGui:FindFirstChild(guiName)
    if shopGui then
        shopGui.Enabled = true
    else
        warn("GUI tidak ditemukan di PlayerGui:", guiName)
    end
end

return {
    OpenMerchant = function()
        OpenShop("Merchant")
    end,

    OpenRodShop = function()
        OpenShop("RodShop")
    end,

    OpenBaitShop = function()
        OpenShop("BaitShop")
    end
}
