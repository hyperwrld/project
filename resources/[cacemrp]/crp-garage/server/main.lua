RPC.register('StoreVehicle', function(source, vehicleInfo)
    local vehiclePromise = promise:new()

    StoreVehicle(source, vehicleInfo, vehiclePromise)

    return Citizen.Await(vehiclePromise)
end)

RPC.register('GetPlayerVehicles', function(source, garageNumber)
    local vehiclesPromise = promise:new()

    GetPlayerVehicles(source, garageNumber, vehiclesPromise)

    return Citizen.Await(vehiclesPromise)
end)

RPC.register('SpawnVehicle', function(source, vehicleInfo)
    local vehiclePromise = promise:new()

    SpawnVehicle(source, vehicleInfo, vehiclePromise)

    return Citizen.Await(vehiclePromise)
end)

function StoreVehicle(source, vehicleInfo, vehiclePromise)
    exports.ghmattimysql:execute('UPDATE vehicles SET location = @location, status = 1 WHERE plate = @plate;', { ['@location'] = vehicleInfo.garage, ['@plate'] = vehicleInfo.plate }, function(result)
        if result.affectedRows > 0 then
            vehiclePromise:resolve(true)
        else
            vehiclePromise:resolve(false)
        end
    end)
end

function GetPlayerVehicles(source, garageNumber, vehiclesPromise)
    local user = exports['crp-base']:GetCharacter(source)

    exports.ghmattimysql:execute('SELECT * FROM vehicles WHERE owner = @owner AND (location = @location OR status = 0 OR status = 3);', { ['@owner'] = user.getCharacterID(), ['@location'] = garageNumber }, function(result)
        vehiclesPromise:resolve(result)
    end)
end

function SpawnVehicle(source, vehicleInfo, vehiclePromise)
    local user = exports['crp-base']:GetCharacter(source)

    exports.ghmattimysql:execute('SELECT plate, vehicle, mods FROM vehicles WHERE owner = @owner AND plate = @plate AND location = @location AND status = 1;', { ['owner'] = user.getCharacterID(), ['@plate'] = vehicleInfo.plate, ['@location'] = vehicleInfo.garage }, function(result)
        if #result > 0 then
            exports.ghmattimysql:execute('UPDATE vehicles SET status = 0 WHERE plate = @plate;', { ['@plate'] = vehicleInfo.plate }, function(_result)
                if _result.affectedRows > 0 then
                    vehiclePromise:resolve({ status = true, data = result[1] })
                else
                    vehiclePromise:resolve({ status = false })
                end
            end)
        else
            vehiclePromise:resolve({ status = false })
        end
    end)
end