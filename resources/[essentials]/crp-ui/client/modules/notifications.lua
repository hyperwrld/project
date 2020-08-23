RegisterNetEvent('crp-ui:setAlert')
AddEventHandler('crp-ui:setAlert', function(data)
    SendNUIMessage({ eventName = 'notifications/setAlert', eventData = { text = data.text, type = data.type, time = data.time }})
end)

RegisterNetEvent('crp-ui:setCustomAlert')
AddEventHandler('crp-ui:setCustomAlert', function(data)
    SendNUIMessage({ eventName = 'notifications/setCustomAlert', eventData = { action = data.action , id = data.id, text = data.text, type = data.type }})
end)