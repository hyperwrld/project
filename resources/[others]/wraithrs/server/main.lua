local hotVehicles = {}

RegisterNetEvent('wraithrs:addVehicle')
AddEventHandler('wraithrs:addVehicle', function(vehiclePlate, reason)
    hotVehicles[string.lower(vehiclePlate)] = reason

    TriggerClientEvent('wraithrs:addVehicle', -1, hotVehicles)
end)

RegisterNetEvent('wraithrs:notification')
AddEventHandler('wraithrs:notification', function(vehiclePlate)
    TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 255}, templateId = 'red', args = { 'POLÍCIA', 'Uso inválido do comando.' }})
end)