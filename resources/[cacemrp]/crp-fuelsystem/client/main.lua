local pumpModels = {
    [-2007231801] = true, [1339433404] = true, [1694452750] = true, [1933174915] = true, [-462817101] = true, [-469694731] = true, [-164877493] = true
}

local blacklistedVehicles = {
    ['BMX'] = true, ['CRUISER'] = true, ['FIXTER'] = true, ['SCORCHER'] = true, ['TRIBIKE'] = true, ['TRIBIKE2'] = true, ['TRIBIKE3'] = true, ['DINGHY'] = true, ['DINGHY2'] = true,
    ['DINGHY4'] = true, ['JETMAX'] = true, ['MARQUIS'] = true, ['SEASHARK'] = true, ['SEASHARK3'] = true, ['SPEEDER'] = true, ['SQUALO'] = true, ['SUBMERSIBLE'] = true, ['SUBMERSIBLE2'] = true,
    ['SUNTRAP'] = true, ['TORO'] = true, ['TORO2'] = true, ['TROPIC'] = true, ['TROPIC2'] = true, ['TUG'] = true
}

local playerPed, isNearPump, isFueling, currentFuel, lastUpdate, lastVehicle = PlayerPedId(), false, false, 0.0, 0, 0

DecorRegister('currentFuel', 3)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if IsPedInAnyVehicle(playerPed) then
            local vehicle, isBlacklisted = GetVehiclePedIsIn(playerPed, false), false

            if blacklistedVehicles[GetEntityModel(vehicle)] then
                isBlacklisted = true
            end

            if not isBlacklisted and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                if lastVehicle ~= vehicle then
                    if not DecorExistOn(vehicle, 'currentFuel') then
                        currentFuel = math.random(20, 60)

                        DecorSetInt(vehicle, 'currentFuel', math.floor(currentFuel + 0.5))
                    else
                        currentFuel = DecorGetInt(vehicle, 'currentFuel')
                    end

                    lastVehicle, lastUpdate = vehicle, 0
                end

                if lastUpdate > 150 then
                    DecorSetInt(vehicle, 'currentFuel', math.floor(currentFuel + 0.5))

                    lastUpdate = 0
                end

                lastUpdate = lastUpdate + 1

                if currentFuel > 0 and IsVehicleEngineOn(vehicle) then
                    currentFuel = currentFuel - (math.floor(GetVehicleCurrentRpm(vehicle) * 10 + 0.5) / 10) / 80
                end

                if currentFuel < 1 then
                    if currentFuel ~= 0 then
                        currentFuel = 0

                        DecorSetInt(vehicle, 'currentFuel', 0)
                    end

                    if IsVehicleEngineOn(vehicle) then
                        SetVehicleEngineOn(vehicle, false, false, true)
                        SetVehicleUndriveable(vehicle, true)
                    end
                else
                    if currentFuel < 15 then
                        -- TODO: trigger low fuel alarm
                    end

                    if currentFuel < 6 then
                        local chance = math.random(0, 100)

                        if chance > 85 then
                            SetVehicleEngineOn(vehicle, false, false, true)
                            SetVehicleUndriveable(vehicle, true)

                            Citizen.Wait(250)

                            SetVehicleEngineOn(vehicle, true, false, true)
                            SetVehicleUndriveable(vehicle, true)
                        end
                    end
                end
            end
        elseif lastVehicle ~= 0 then
            DecorSetInt(lastVehicle, 'currentFuel', math.floor(currentFuel + 0.5))

            lastVehicle = 0

            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        playerPed = PlayerPedId()

        if not isFueling and (isNearPump and GetEntityHealth(isNearPump) > 0) and not IsPedInAnyVehicle(playerPed) then
            local vehicle = GetPlayersLastVehicle()
            local vehicleCoords = GetEntityCoords(vehicle)

            if DoesEntityExist(vehicle) and #(GetEntityCoords(playerPed) - vehicleCoords) < 2.5 then
                local entityCoords, vehicleFuel = GetEntityCoords(isNearPump), DecorGetInt(vehicle, 'currentFuel')

                DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abastecer o ~g~veículo~s~.')
                DrawMarker(20, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 150, 0, 0, 150, 0, 1, 0, 0)

                if IsControlJustReleased(0, 38) then
                    if vehicleFuel < 100 then
                        TriggerServerEvent('crp-fuelsystem:checkFuelValue', vehicleFuel, vehicle)
                    else
                        TriggerEvent('crp-ui:setAlert', { text = 'O depósito do veículo já está cheio.', type = 'inform' })
                    end
                end
            else
                Citizen.Wait(250)
            end
        else
            Citizen.Wait(250)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)

        local pumpObject, pumpDistance = FindNearestFuelPump()

        if pumpDistance < 5.0 then
			isNearPump = pumpObject
		else
			isNearPump = false

			Citizen.Wait(math.ceil(pumpDistance * 20))
		end
    end
end)

RegisterNetEvent('crp-fuelsystem:refuelVehicle')
AddEventHandler('crp-fuelsystem:refuelVehicle', function(time, vehicle)
    ClearPedSecondaryTask(playerPed)
    TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)

    if not HasAnimDictLoaded('weapon@w_sp_jerrycan') then
		RequestAnimDict('weapon@w_sp_jerrycan')

		while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do
			Citizen.Wait(0)
		end
    end

    TaskPlayAnim(playerPed, 'weapon@w_sp_jerrycan', 'fire', 8.0, 1.0, -1, 1, 0, 0, 0, 0)

    TriggerEvent('crp-ui:setTaskbar', { text = 'Abastecer', time = time }, function(data)
        if data.status then
            DecorSetInt(vehicle, 'currentFuel', 100)
        else
            local fuel = DecorGetInt(vehicle, 'currentFuel')

            DecorSetInt(vehicle, 'currentFuel', math.ceil((100 - fuel) * (data.percentage / 100) + fuel))
        end

        ClearPedTasks(playerPed)
        RemoveAnimDict('weapon@w_sp_jerrycan')
    end)
end)

function FindNearestFuelPump()
	local coords, fuelPumps = GetEntityCoords(playerPed), {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if pumpModels[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end

		success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

    local pumpObject, pumpDistance = 0, 1000

    for i = 1, #fuelPumps do
        local distance = #(coords - GetEntityCoords(fuelPumps[i]))

		if distance < pumpDistance then
			pumpDistance, pumpObject = distance, fuelPumps[i]
		end
    end

	return pumpObject, pumpDistance
end

function DisplayHelpText(string)
    SetTextComponentFormat('STRING')
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end