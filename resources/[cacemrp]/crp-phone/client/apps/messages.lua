RegisterUICallback('getMessages', function(number, cb)
	local success, messages = RPC:execute('getMessages', number)

    cb({ state = success, messages = messages })
end)

RegisterUICallback('sendMessage', function(data, cb)
    local success, message = RPC:execute('sendMessage', tonumber(data.number), data.message)

    cb({ state = success, message = message })
end)

RegisterNetEvent('crp-phone:receiveMessage')
AddEventHandler('crp-phone:receiveMessage', function(data)
	exports['crp-ui']:setMessage(data)
end)