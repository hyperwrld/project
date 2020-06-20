RegisterNUICallback('disconnect', function(data, cb)
    TriggerServerEvent('crp-base:disconnect')

    cb(true)
end)

RegisterNUICallback('error', function(message, cb)
    exports['crp-notifications']:SendAlert('error', message)

    cb(true)
end)

RegisterNUICallback('fetchCharacters', function(data, cb)
    cb(CRP.RPC:execute('FetchCharacters'))
end)

RegisterNUICallback('createCharacter', function(characterData, cb)
    local data = CRP.RPC:execute('CreateCharacter', characterData)

    if data and not data.status then
        local errorMessage = 'Ocorreu um erro ao criar a sua personagem, contacte um administrador, caso o problema continue.'

        if data.message then
            errorMessage = data.message
        end

        exports['crp-notifications']:SendAlert('error', errorMessage)

        cb({ status = false })
        return
    end

    cb(data)
end)

RegisterNUICallback('deleteCharacter', function(characterId, cb)
    local data = CRP.RPC:execute('DeleteCharacter', characterId)

    if not data.status then
        exports['crp-notifications']:SendAlert('error', 'Ocorreu um erro ao eliminar a sua personagem, contacte um administrado, caso o problema continue.')

        cb({ status = false })
        return
    end

    cb(data)
end)

RegisterNUICallback('selectCharacter', function(characterId, cb)
    local data = CRP.RPC:execute('SelectCharacter', characterId)

    if not data then
        exports['crp-notifications']:SendAlert('error', 'Ocorreu um erro ao carregar a sua personagem, contacte um administrador se isto continuar.')
        return
    end

    TriggerEvent('crp-base:spawnPlayer', data)

    Citizen.Wait(4000)

    closeMenu()

    cb(true)
end)