RegisterUICallback('getHistory', function(data, cb)
    local historyData = CRP.RPC:execute('crp-phone:getHistory')

    cb(historyData)
end)