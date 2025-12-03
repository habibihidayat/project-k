local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AutoSell = {}

local function findSellRemotes()
    local sellRemotes = {}
    local keywords = { "sell", "vendor", "trade", "shop", "merchant", "salvage", "exchange", "deposit", "convert" }

    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = string.lower(obj.Name)
            for _, key in ipairs(keywords) do
                if string.find(name, key) then
                    table.insert(sellRemotes, obj)
                    if string.find(name, "sellall") then
                        return obj
                    end
                end
            end
        end
    end
    return sellRemotes[1]
end

function AutoSell.SellOnce()
    local remote = findSellRemotes()
    if not remote then
        return
    end

    pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer("all")
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer("all")
        end
    end)
end

_G.AutoSell = AutoSell
return AutoSell
