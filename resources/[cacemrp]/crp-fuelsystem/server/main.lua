RegisterServerEvent('crp-fuelsystem:checkFuelValue')
AddEventHandler('crp-fuelsystem:checkFuelValue', function(currentFuel, vehicle)
    local character = exports['crp-base']:GetCharacter(source)
    local fuelCost = (100 - currentFuel) * 1.5

    if character.getMoney() >= fuelCost then
        local refuelTime = (100 - currentFuel) / 3

        character.removeMoney(fuelCost)

        TriggerClientEvent('crp-fuelsystem:refuelVehicle', source, refuelTime, vehicle)
    else
        TriggerServerEvent('crp-ui:setAlert', { text = 'Não tens dinheiro suficiente para abastecer o veículo.', type = 'inform' })
    end
end)