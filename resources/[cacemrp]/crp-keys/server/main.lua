local keys = {}

AddEventHandler('crp:playerloaded', function(source, user)
    local characterId = user.getCharacterID()

    if keys[characterId] == nil then
        keys[characterId] = {}
    else
        TriggerClientEvent('crp-keys:updateKeys', source, keys[characterId])
    end
end)

RegisterServerEvent('crp-keys:addKey')
AddEventHandler('crp-keys:addKey', function(vehicle, vehiclePlate)
    if vehicle == nil then
        return
    end

    local user = exports['crp-base']:GetCharacter(source)
    local characterId = user.getCharacterID()

        if keys[characterId] == nil then
        keys[characterId] = {}
        end

    table.insert(keys[characterId], vehiclePlate)

    TriggerClientEvent('crp-keys:updateKey', source, vehicle, vehiclePlate, true)
end)

RegisterServerEvent('crp-keys:removeKey')
AddEventHandler('crp-keys:removeKey', function(vehicle, vehiclePlate)
    if vehicle == nil then
        return
    end

    local user = exports['crp-base']:GetCharacter(source)
    local characterId = user.getCharacterID()

    table.remove(keys[characterId], FindTableIndex(keys[characterId], vehiclePlate))

    TriggerClientEvent('crp-keys:updateKey', source, vehicle, vehiclePlate, false)
end)

RegisterServerEvent('crp-keys:giveKey')
AddEventHandler('crp-keys:giveKey', function(target, vehiclePlate)
    local user = exports['crp-base']:GetCharacter(target)
    local characterId = user.getCharacterID()

    table.insert(keys[characterId], vehiclePlate)

    TriggerClientEvent('crp-keys:updateKey', source, vehicle, vehiclePlate, false)
    TriggerClientEvent('crp-notifications:SendAlert', target, 'inform', 'Acabaste de receber as chaves de um veículo.')
end)

TriggerEvent('crp-base:addCommand', 'darchave', function(source, args, user)
    TriggerClientEvent('crp-keys:giveKey', source)
end, { help = 'Serve para dar a chave do veículo a um jogador.' })

function FindTableIndex(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end