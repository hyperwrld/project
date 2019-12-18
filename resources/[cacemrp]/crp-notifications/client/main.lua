RegisterNetEvent('crp-notifications:SendAlert')
AddEventHandler('crp-notifications:SendAlert', function(data)
	SendAlert(data.type, data.text, data.length)
end)

RegisterNetEvent('crp-notifications:SendCustomAlert')
AddEventHandler('crp-notifications:SendCustomAlert', function(data)
	SendCustomAlert(data.id, data.type, data.text, data.length)
end)

RegisterNetEvent('crp-notifications:SendPersistantAlert')
AddEventHandler('crp-notifications:SendPersistantAlert', function(data)
	SendPersistantAlert(data.action, data.id, data.type, data.text)
end)

function SendAlert(type, text, length)
	SendNUIMessage({ event = 'alert', type = type, text = text, length = length })
end

function SendCustomAlert(id, type, text, length)
	SendNUIMessage({ event = 'customAlert', id = id, type = type, text = text })
end

function SendPersistantAlert(action, id, type, text)
    SendNUIMessage({ event = 'persistantAlert', action = action, id = id, type = type, text = text })
end