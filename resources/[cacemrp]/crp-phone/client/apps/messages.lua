RegisterUiCallback('getConversations', function(data, cb)
    local conversations = CRP.RPC:execute('crp-phone:getConversations')

    cb(conversations)
end)

RegisterUiCallback('getMessages', function(number, cb)
    local success, messages = CRP.RPC:execute('crp-phone:getMessages', number)

    cb({ state = success, messages = messages })
end)

RegisterUiCallback('sendMessage', function(data, cb)
    local success = CRP.RPC:execute('crp-phone:sendMessage', data)

    cb({ state = success })
end)