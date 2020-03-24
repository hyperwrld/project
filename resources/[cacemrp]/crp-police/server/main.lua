TriggerEvent('crp-jobmanager:activateService', 'police')

RegisterServerEvent('crp-police:cuffPlayer')
AddEventHandler('crp-police:cuffPlayer', function(target, state)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-police:getCuffed', target, source, state)
        TriggerClientEvent('crp-police:cuff', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
	end
end)

RegisterServerEvent('crp-police:uncuffPlayer')
AddEventHandler('crp-police:uncuffPlayer', function(target)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-police:uncuff', target)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
	end
end)

RegisterServerEvent('crp-police:dragPlayer')
AddEventHandler('crp-police:dragPlayer', function(target)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-police:drag', target, source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
	end
end)

RegisterServerEvent('crp-police:updateDragger')
AddEventHandler('crp-police:updateDragger', function(target, status)
    TriggerClientEvent('crp-police:updateDragger', target, status)
end)

RegisterServerEvent('crp-police:putInVehicle')
AddEventHandler('crp-police:putInVehicle', function(target, vehicle)
    TriggerClientEvent('crp-police:enterVehicle', target, vehicle)
end)

RegisterServerEvent('crp-police:removeFromVehilce')
AddEventHandler('crp-police:removeFromVehilce', function(target, coords)
    TriggerClientEvent('crp-police:removeFromVehilce', target, coords)
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