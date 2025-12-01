RemoteBuyer = {}

local RS = game:GetService("ReplicatedStorage")
local PurchaseRodRemote = RS.Packages["_Index"]["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]

function RemoteBuyer.BuyRod(id)
    task.spawn(function()
        local success, result = pcall(function()
            return PurchaseRodRemote:InvokeServer(id)
        end)

        if success then
            Notify.Send("Buy Rod", "Berhasil membeli rod!", 3)
        else
            Notify.Send("Error", "Gagal membeli rod!", 3)
        end
    end)
end

return RemoteBuyer
