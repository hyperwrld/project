RegisterUICallback('addContact', function(data, cb)
    local success, insertId = RPC:execute('addContact', data.name, tonumber(data.number))

    cb({ state = success, id = insertId })
end)

RegisterUICallback('deleteContact', function(data, cb)
    local success = RPC:execute('deleteContact', data)

    cb({ state = success })
end)

RegisterUICallback('editContact', function(data, cb)
    local success = RPC:execute('editContact', data)

    cb({ state = success })
end)