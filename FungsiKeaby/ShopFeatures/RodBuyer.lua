local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)

local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)

local RF = Net:RemoteFunction("PurchaseFishingRod")

local RodBuyer = {}

function RodBuyer.Buy(identifier)
    local data = ItemUtility.GetItemDataFromItemType("Fishing Rods", identifier)
    if not data then
        warn("Rod identifier not found:", identifier)
        return
    end

    local price = data.Price
    local rodName = data.Data.Name

    local msg = "Buy <b>" .. rodName .. "</b> for <font color='rgb(255, 196, 57)'>" ..
                StringLibrary:Shorten(price) .. " Coins</font>?"

    PromptController:FirePrompt(msg)
        :andThen(function(confirmed)
            if confirmed then
                return RF:InvokeServer(identifier)
            end
        end)
        :catch(warn)
end

return RodBuyer
