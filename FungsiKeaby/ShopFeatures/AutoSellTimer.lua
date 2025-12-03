local AutoSellTimer = {
    Enabled = false,
    Interval = 5,
    Thread = nil
}

function AutoSellTimer.Start(interval)
    if AutoSellTimer.Enabled then
        return
    end

    if interval and tonumber(interval) and tonumber(interval) >= 1 then
        AutoSellTimer.Interval = tonumber(interval)
    end

    local AutoSell = _G.AutoSell
    if not AutoSell then
        return
    end

    AutoSellTimer.Enabled = true

    AutoSellTimer.Thread = task.spawn(function()
        while AutoSellTimer.Enabled do
            task.wait(AutoSellTimer.Interval)
            if AutoSellTimer.Enabled and AutoSell and AutoSell.SellOnce then
                pcall(AutoSell.SellOnce)
            end
        end
    end)
end

function AutoSellTimer.Stop()
    if not AutoSellTimer.Enabled then
        return
    end
    AutoSellTimer.Enabled = false
end

function AutoSellTimer.SetInterval(seconds)
    if tonumber(seconds) and seconds >= 1 then
        AutoSellTimer.Interval = tonumber(seconds)
    end
end

function AutoSellTimer.GetStatus()
    return {
        Enabled = AutoSellTimer.Enabled,
        Interval = AutoSellTimer.Interval
    }
end

return AutoSellTimer
