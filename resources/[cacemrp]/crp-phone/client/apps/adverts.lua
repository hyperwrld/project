RegisterUICallback('postAdvert', function(data, cb)
    local success, advertData = RPC:execute('postAdvert', data)

    cb({ state = success, advertData = advertData })
end)

RegisterUICallback('removeAdvert', function(data, cb)
    local success = RPC:execute('removeAdvert', data)

    cb({ state = success })
end)