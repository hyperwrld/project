local function isEmpty(string)
	return string == nil or string == ''
end

TriggerEvent('crp-base:addCommand', 'reparar', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' or userJob == 'medic' then
        TriggerClientEvent('crp-police:repairvehicle', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para reparar o seu veículo.' })

TriggerEvent('crp-base:addCommand', 'revistar', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-police:search', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para revistar um jogador.' })

local vehicles = { ['chgr'] = { wheel = 17, tint = 4, suspension = 3, color = 0 } } -- extra 1 2 3 4 5  6 7 8 11

TriggerEvent('crp-base:addCommand', 'carro', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if args[1] == nil then
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Uso inválido do comando.' }})
		return
    end

    args[1] = args[1]:lower()

    if userJob == 'police' then
        if vehicles[args[1]] then
            TriggerClientEvent('crp-police:spawnvehicle', source, args[1], vehicles[args[1]])
        else 
            TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Não foi encontrado nenhum veículo com esse nome.' }})
        end
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para spawnar um veículo.', params = {{ name = 'nome do veículo' }} })

TriggerEvent('crp-base:addCommand', 'pregos', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-policespikes:drop', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para meter o tapete de pregos no chão.' })

TriggerEvent('crp-base:addCommand', 'retirarpregos', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-policespikes:pickup', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para retirar o tapete de pregos do chão.' })

TriggerEvent('crp-base:addCommand', 'multar', function(source, args, user)
    if tonumber(args[1]) and tonumber(args[2]) then
        local user = exports['crp-base']:GetCharacter(source)
        local userJob = user.getJob().name

        if userJob == 'police' then
            args[1] = tonumber(args[1])
            args[2] = tonumber(args[2])

            local target = exports['crp-base']:GetCharacter(args[1])

            if target then
                target.removeBank(args[2])

                TriggerClientEvent('crp-notifications:SendAlert', source, { type = 'inform', text = 'Passaste uma multa ao jogador (' .. args[1] .. ') de ' .. args[2] .. '€', length = 5000 })
                
                TriggerClientEvent('crp-notifications:SendAlert', args[1], { type = 'inform', text = 'Recebeste uma multa de ' .. args[2] .. '€', length = 5000 })
            else
                TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'O jogador que colocou não está online.' }})
            end
        else
            TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
        end
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Uso inválido do comando.' }})
    end
end, { help = 'Utilize este comando para passar uma multa a um jogador.', params = {{ name = 'id do jogador' }, { name = 'quantia' }} })

TriggerEvent('crp-base:addCommand', 'apreender', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-police:impoundvehicle', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para apreender um veículo.' })

TriggerEvent('crp-base:addCommand', 'escoltar', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-police:dragplayer', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para escoltar um jogador.' })

TriggerEvent('crp-base:addCommand', 'algemar', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-police:cuffplayer', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para algemar um jogador.' })

TriggerEvent('crp-base:addCommand', 'radar', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('wraithrs:toggleradar', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para ligar/desligar o radar.' })

TriggerEvent('crp-base:addCommand', 'radarlimite', function(source, args, user)
    if tonumber(args[1]) then
        local user = exports['crp-base']:GetCharacter(source)
        local userJob = user.getJob().name

        if userJob == 'police' then
            TriggerClientEvent('wraithrs:updateradarlimit', source, args[1])
        else
            TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
        end
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Uso inválido do comando.' }})
    end
end, { help = 'Utilize este comando para definir o limite do radar.', params = {{ name = 'limite em kmh' }} })

TriggerEvent('crp-base:addCommand', 'alerta', function(source, args, user)
    if args[1] and args[2] then
        local user = exports['crp-base']:GetCharacter(source)
        local userJob = user.getJob().name

        local vehiclePlate = args[1]

        table.remove(args, 1)

        if userJob == 'police' then
            print('olaa')
            TriggerEvent('wraithrs:addVehicle', vehiclePlate, table.concat(args, ' '))
        else
            TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
        end
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Uso inválido do comando.' }})
    end
end, { help = 'Utilize este comando para colocar um veículo nos procurados.', params = {{ name = 'matricula' }, { name = 'razão' }} })

RegisterServerEvent('crp-police:dragplayer')
AddEventHandler('crp-police:dragplayer', function(target)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-police:drag', target, source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
	end
end)

RegisterServerEvent('crp-police:updatedragger')
AddEventHandler('crp-police:updatedragger', function(target, status)
    TriggerClientEvent('crp-police:updatedragger', target, status)
end)

RegisterNetEvent('crp-police:search')
AddEventHandler('crp-police:search', function(target)
    local user = exports['crp-base']:GetCharacter(source)
    local character, userJob = exports['crp-base']:GetCharacter(target), user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-inventory:openCustom', source, { type = 3, weight = 325, slots = 40, name = 'character-' .. character.getCharacterID() })
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end)