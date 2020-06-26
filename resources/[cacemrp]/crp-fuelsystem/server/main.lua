RegisterServerEvent('crp-fuelsystem:checkFuelValue')
AddEventHandler('crp-fuelsystem:checkFuelValue', function(currentFuel, pump)
    local character = exports['crp-base']:GetCharacter(source)
    local fuelCost = (100 - currentFuel) * 1.5

    if character.getMoney() > fuelCost then
        TriggerEvent('crp-fuelsystem:refuelVehicle')
    else
        TriggerServerEvent('crp-ui:setAlert', { text = 'Não tens dinheiro suficiente para abastecer o veículo.', type = 'inform' })
    end
end)