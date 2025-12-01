local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)

local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)

local RF = Net:RemoteFunction("PurchaseFishingRod")

local RodBuyer = {}

function RodBuyer.Buy(id)
    -- id adalah angka (126, 168, 258, dst.)
    local data = ItemUtility.GetItemDataFromItemType("Fishing Rods", id)
    if not data then
        warn("Rod ID not found:", id)
        return
    end

    local price = data.Price
    local rodName = data.Data.Name

    local msg = "Buy <b>" .. rodName .. "</b> for <font color='rgb(255, 196, 57)'>" ..
        StringLibrary:Shorten(price) .. " Coins</font>?"

    PromptController:FirePrompt(msg)
        :andThen(function(confirmed)
            if confirmed then
                return RF:InvokeServer(id)
            end
        end)
        :catch(warn)
end

return RodBuyer
