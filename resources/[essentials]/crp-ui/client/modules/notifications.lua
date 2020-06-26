RegisterNetEvent('crp-ui:setAlert')
AddEventHandler('crp-ui:setAlert', function(data)
    SendNUIMessage({ eventName = 'setAlert', alertData = { text = data.text, type = data.type }})
end)

RegisterNetEvent('crp-ui:setCustomAlert')
AddEventHandler('crp-ui:setCustomAlert', function(data)
    SendNUIMessage({ eventName = 'setCustomAlert', alertData = { action = data.action , id = data.id, text = data.text, type = data.type }})
end)