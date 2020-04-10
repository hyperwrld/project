local apartments = {
    [1]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [2]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [3]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [4]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [5]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [6]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [7]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [8]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [9]  = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [10] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [11] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [12] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [13] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [14] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [15] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [16] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [17] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [18] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [19] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [20] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [21] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [22] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [23] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [24] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [25] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [26] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [27] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [28] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [29] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [30] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [31] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [32] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [33] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [34] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [35] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [36] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
    [37] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 }, [38] = { ['owner'] = nil, ['state'] = true, ['type'] = 1 },
}

RegisterNetEvent('crp-apartments:spawnSelection')
AddEventHandler('crp-apartments:spawnSelection', function()
	for k, v in pairs(apartments) do
        if apartments[k]['owner'] == nil then
			apartments[k]['owner'], apartments[k]['state'] = source, true

			TriggerClientEvent('crp-apartments:spawnSelection', source, k, apartments[k]['type'])
            return
        end
    end
end)

RegisterNetEvent('crp-apartments:updateMotelLock')
AddEventHandler('crp-apartments:updateMotelLock', function(number)
    if apartments[number]['owner'] == source then
        apartments[number]['state'] = not apartments[number]['state']

        if apartments[number]['state'] then
            TriggerClientEvent('crp-notifications:SendAlert', source, { type = 'inform', text = 'Apartamento trancado.', length = 5 })
        else
            TriggerClientEvent('crp-notifications:SendAlert', source, { type = 'inform', text = 'Apartamento destrancado.', length = 5 })
        end
    else
        TriggerClientEvent('crp-notifications:SendAlert', source, { type = 'error', text = 'Ocorreu um erro, tente novamente.', length = 5 })
    end
end)

RegisterNetEvent('crp-apartments:checkInteriorState')
AddEventHandler('crp-apartments:checkInteriorState', function(number, type)
    if type == 1 then
        if apartments[number] then
            if not apartments[number]['state'] or apartments[number]['owner'] == source then
                TriggerClientEvent('crp-apartments:buildHotelInterior', source, number, type)
            else
                TriggerClientEvent('crp-notifications:SendAlert', source, { type = 'inform', text = 'O apartamento/casa está trancado.', length = 5 })
            end
        end
    else

    end
end)

RegisterNetEvent('crp-apartments:openMotelInventory')
AddEventHandler('crp-apartments:openMotelInventory', function(number)
    if apartments[number] and apartments[number]['owner'] then
        local motelOwnerId = exports['crp-base']:GetCharacter(apartments[number]['owner']).getCharacterID()

        TriggerClientEvent('crp-inventory:openCustom', source, { type = 3, name = 'motel-' .. motelOwnerId, slots = 50, weight = 750 })
    end
end)

TriggerEvent('crp-base:addCommand', 'entrar', function(source, args, user)
    TriggerClientEvent('crp-apartments:enterInterior', source)
end, { help = 'Utilize este comando para entrar em alguma casa/apartamento.' })