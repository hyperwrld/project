RegisterUiCallback('getContacts', function(data, cb)
    local contactsData = CRP.RPC:execute('crp-phone:getContacts')

    cb(contactsData)
end)

RegisterUiCallback('addContact', function(contactData, cb)
    local success, insertId = CRP.RPC:execute('crp-phone:addContact', contactData)

    cb({ state = success, id = insertId })
end)

RegisterUiCallback('deleteContact', function(contactData, cb)
    local success = CRP.RPC:execute('crp-phone:deleteContact', contactData)

    cb({ state = success })
end)

RegisterUiCallback('editContact', function(contactData, cb)
    local success = CRP.RPC:execute('crp-phone:editContact', contactData)

    cb({ state = success })
end)