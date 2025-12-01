--// OpenShop Module
-- Dibuat untuk membuka & menutup GUI toko melalui loadstring

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Shops = {
    Merchant = "Merchant",
    RodShop = "Rod Shop",
    BaitShop = "Bait Shop"
}

-- Fungsi umum membuka
local function OpenGUI(name)
    local gui = PlayerGui:FindFirstChild(name)
    if gui then
        gui.Enabled = true
    else
        warn("[OpenShop] GUI tidak ditemukan:", name)
    end
end

-- Fungsi umum menutup
local function CloseGUI(name)
    local gui = PlayerGui:FindFirstChild(name)
    if gui then
        gui.Enabled = false
    else
        warn("[OpenShop] GUI tidak ditemukan:", name)
    end
end

return {

    -- MERCHANT
    OpenMerchant = function()
        OpenGUI(Shops.Merchant)
    end,

    CloseMerchant = function()
        CloseGUI(Shops.Merchant)
    end,

    -- ROD SHOP
    OpenRodShop = function()
        OpenGUI(Shops.RodShop)
    end,

    CloseRodShop = function()
        CloseGUI(Shops.RodShop)
    end,

    -- BAIT SHOP
    OpenBaitShop = function()
        OpenGUI(Shops.BaitShop)
    end,

    CloseBaitShop = function()
        CloseGUI(Shops.BaitShop)
    end
}
