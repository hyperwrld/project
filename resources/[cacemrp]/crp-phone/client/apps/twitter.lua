RegisterUiCallback('getTweets', function(data, cb)
    local tweetsData = CRP.RPC:execute('crp-phone:getTweets')

    cb(tweetsData)
end)

RegisterUiCallback('sendTweet', function(data, cb)
    local success, tweetData = CRP.RPC:execute('crp-phone:sendTweet', data)

    cb({ state = success, tweetData = tweetData })
end)

RegisterUiCallback('sendRetweet', function(data, cb)
    local success, tweetData = CRP.RPC:execute('crp-phone:sendRetweet', data)

    cb({ state = success, tweetData = tweetData })
end)