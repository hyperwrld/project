local function isEmpty(string)
	return string == nil or string == ''
end

TriggerEvent('crp-base:addCommand', 'reparar', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' or userJob == 'medic' then
        TriggerClientEvent('crp-' .. userJob .. ':repairVehicle', source)
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

local vehicles = {
    ['police'] = {
        ['chgr'] = { wheel = 17, tint = 4, suspension = 3, color = 0 } -- extra 1 2 3 4 5  6 7 8 11
    },
    ['medic'] = {

    }
}

TriggerEvent('crp-base:addCommand', 'carro', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if args[1] == nil then
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Uso inválido do comando.' }})
		return
    end

    args[1] = args[1]:lower()

    if userJob == 'police' or userJob == 'medic' then
        if vehicles[userJob][args[1]] then
            TriggerClientEvent('crp-' .. userJob .. ':spawnVehicle', source, args[1], vehicles[userJob][args[1]])
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

                TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Passaste uma multa ao jogador (' .. args[1] .. ') de ' .. args[2] .. '€' }})
                TriggerClientEvent('chat:addMessage', args[1], { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Recebeste uma multa de ' .. args[2] .. '€' }})
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
        TriggerClientEvent('crp-police:impoundVehicle', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para apreender um veículo.' })

TriggerEvent('crp-base:addCommand', 'escoltar', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' or userJob == 'medic' then
        TriggerClientEvent('crp-police:dragPlayer', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para escoltar um jogador.' })

TriggerEvent('crp-base:addCommand', 'algemar', function(source, args, user)
    if tonumber(args[1]) then
        if GetPlayerName(tonumber(args[1])) then
            local user = exports['crp-base']:GetCharacter(source)
            local userJob = user.getJob().name

            if userJob == 'police' then
                TriggerClientEvent('crp-police:cuffed', tonumber(args[1]), false)
            else
                TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
            end
        else
            TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'O jogador não está online.' }})
        end
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Uso inválido do comando.' }})
    end
end, { help = 'Utilize este comando para algemar um jogador.', params = {{ name = 'id do jogador' }} })

TriggerEvent('crp-base:addCommand', 'desalgemar', function(source, args, user)
    if tonumber(args[1]) then
        if GetPlayerName(tonumber(args[1])) then
            local user = exports['crp-base']:GetCharacter(source)
            local userJob = user.getJob().name

            if userJob == 'police' then
                TriggerClientEvent('crp-police:uncuff', tonumber(args[1]))
            else
                TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
            end
        else
            TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'O jogador não está online.' }})
        end
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Uso inválido do comando.' }})
    end
end, { help = 'Utilize este comando para desalgemar um jogador.', params = {{ name = 'id do jogador' }} })

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
            TriggerEvent('wraithrs:addVehicle', vehiclePlate, table.concat(args, ' '))
        else
            TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
        end
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Uso inválido do comando.' }})
    end
end, { help = 'Utilize este comando para colocar um veículo nos procurados.', params = {{ name = 'matricula' }, { name = 'razão' }} })