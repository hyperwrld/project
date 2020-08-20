RegisterUiCallback('getHistory', function(data, cb)
    local hisotryData = CRP.RPC:execute('crp-phone:getHistory')

    cb(hisotryData)
end)