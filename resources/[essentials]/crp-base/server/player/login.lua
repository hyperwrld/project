users = {}

-- Loads the character when called, only ever needs to get called once

function LoadCharacter(source, identifier, charId)
    local _source, data = source, {}

    TriggerEvent('crp-base:retrieveCharacter', { identifier = identifier, charId = charId }, function(_data)
        data = _data
    end)

    while next(data) == nil do
		Citizen.Wait(0)
    end

    if data.identifier then
        users[_source] = CreateCharacter(_source, data)
        users[_source].displayMoney(users[_source].getMoney())

        -- Tells other resources that a player has loaded

        TriggerEvent('crp:playerloaded', _source, users[_source])

        -- Sends the command suggestions to the client, this creates a neat autocomplete

        for k, v in pairs(commandSuggestions) do
            TriggerClientEvent('chat:addSuggestion', _source, '/' .. k, v.help, v.params)
        end

        return users[_source]
    else
        local identifier

        for k, v in ipairs(GetPlayerIdentifiers(_source)) do
            if string.sub(v, 1, string.len('steam:')) == 'steam:' then
                identifier = v
                break
            end
        end

        if identifier then
            TriggerEvent('crp-db:updatecharacter', data.identifier, data.id, identifier, function(done)
                if done then
                    return false
                end
            end)
        else
            return false
        end
    end
end