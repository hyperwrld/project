local vehicleTable = { 
    [1] = { ['model'] = 'flatbed', ['price'] = 200 },  [2] = { ['model'] = 'cruiser',  ['price'] = 600 }, 
    [3] = { ['model'] = 'fixter',   ['price'] = 300 }, [4] = { ['model'] = 'scorcher', ['price'] = 700 },
    [5] = { ['model'] = 'tribike',  ['price'] = 400 }, [6] = { ['model'] = 'tribike2', ['price'] = 800 },
    [7] = { ['model'] = 'tribike3', ['price'] = 500 },
}

local vehicles = { { model = 'elegy', price = 200 }, { model = 'scorcher', price = 200 }, { model = 'cruiser', price = 200 }}

RegisterNetEvent('crp-vehicleshop:updateVehicleTable')
AddEventHandler('crp-vehicleshop:updateVehicleTable', function(_vehicleTable)
    vehicleTable = _vehicleTable

    TriggerClientEvent('crp-vehicleshop:updateVehicleTable', -1, vehicleTable, true)
end)

RegisterNetEvent('crp-vehicleshop:requestVehicles')
AddEventHandler('crp-vehicleshop:requestVehicles', function()
    TriggerClientEvent('crp-vehicleshop:updateVehicleTable', source, vehicleTable, false)
end)

AddEventHandler('crp-vehicleshop:attemptBuyVehicle', function(source, vehicle, callback)
    local user = exports['crp-base']:GetCharacter(source)
    local found, foundVehicle = false, nil

    for i = 1, #vehicles, 1 do
        if GetHashKey(vehicles[i].model) == vehicle.model then
			found, foundVehicle = true, vehicles[i]
            break
        end
    end

    if found and user.getMoney() >= foundVehicle.price then
        user.removeMoney(foundVehicle.price)

        callback({ status = true, vehicle = vehicle })
    else
        callback({ status = false })
    end
end)

AddEventHandler('crp-vehicleshop:isPlateTaken', function(source, plate, callback)
    exports.ghmattimysql:execute('SELECT 1 FROM vehicles WHERE plate = @plate;', {
	    ['@plate'] = plate
    }, function(result)
        callback(result[1] ~= nil)
	end)
end)