RegisterUICallback('addContact', function(contactData, cb)
    local success, insertId = RPC:execute('addContact', contactData)

    cb({ state = success, id = insertId })
end)

RegisterUICallback('deleteContact', function(contactData, cb)
    local success = RPC:execute('deleteContact', contactData)

    cb({ state = success })
end)

RegisterUICallback('editContact', function(contactData, cb)
    local success = RPC:execute('editContact', contactData)

    cb({ state = success })
end)