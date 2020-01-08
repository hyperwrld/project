RegisterServerEvent('crp-alerts:notification')
AddEventHandler('crp-alerts:notification', function(type, text)
    TriggerClientEvent('crp-alerts:notification', -1, source, type, text)
end)

TriggerEvent('crp-base:addCommand', 'limpar', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)
    local userJob = user.getJob().name

    if userJob == 'police' then
        TriggerClientEvent('crp-alerts:clean', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'orange', args = { 'SYSTEM', 'Permissões insuficientes.' }})
    end
end, { help = 'Utilize este comando para remover os blips do mapa.' })