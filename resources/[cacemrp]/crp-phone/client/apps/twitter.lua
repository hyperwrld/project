RegisterUICallback('sendTweet', function(data, cb)
    local success = RPC:execute('sendTweet', data)

    cb({ state = success })
end)

RegisterUICallback('sendRetweet', function(data, cb)
    local success = RPC:execute('sendRetweet', data)

    cb({ state = success })
end)