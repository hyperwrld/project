local lastVehicle, isDoingAction = 0, false
local vehiclesKeys, hotwiredVehicles = {}, {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsUsing(playerPed)

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				-- print(lastVehicle, vehicle)
				-- print(hasVehicleKey(vehicle), hasHotwiredVehicle(vehicle))
				if (not hasVehicleKey(vehicle) or not hasHotwiredVehicle(vehicle)) and lastVehicle ~= vehicle then
					print('aaaaaaa?')
					SetVehicleNeedsToBeHotwired(vehicle, false)
					SetVehicleEngineOn(vehicle, false, true, true)

					exports['crp-ui']:showInteraction('[G] Procurar / [H] Ligação direta')
				end

				if not isDoingAction then
					if IsControlJustPressed(0, 47) then
						searchVehicle(vehicle)
					end

					if IsControlJustPressed(0, 74) then
                        hotwireVehicle(vehicle)
					end
				end

				lastVehicle = vehicle
			end
		end
	end
end)

function searchVehicle(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

    if not vehiclesKeys[vehiclePlate] then
        return
    end

    isDoingAction = true

	local playerPed = PlayerPedId()
    local success, percentage = exports['crp-ui']:setTaskbar('Procurar a chave', 5000, true)

	if not IsPedInAnyVehicle(playerPed) or not success then
		isDoingAction = false
		return
	end

	local randomNumber = GetRandomNumber(100)

	if randomNumber > 90 then
        SetVehicleEngineOn(vehicle, true, false, false)

        vehiclesKeys[vehiclePlate] = true

        exports['crp-ui']:setAlert('Encontraste a chave no veículo.', 'inform')
		return
	end

	local success, percentage = exports['crp-ui']:setTaskbar('Procurar a chave na parte de trás', 5000, true)

	if not IsPedInAnyVehicle(playerPed) or not success then
		isDoingAction = false
		return
	end

	local randomNumber = GetRandomNumber(100)

	if randomNumber > 95 then
        SetVehicleEngineOn(vehicle, true, false, false)

        vehiclesKeys[vehiclePlate] = true

		exports['crp-ui']:setAlert('Encontraste a chave no veículo.', 'inform')
	else
        vehiclesKeys[vehiclePlate] = false

		exports['crp-ui']:setAlert('Não conseguiste achar a chave.', 'inform')
	end

	isDoingAction = false
end

function hotwireVehicle(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

    if not hotwiredVehicles[vehiclePlate] then
        return
    end

	local playerPed = PlayerPedId()

	LoadDictionary('veh@break_in@0h@p_m_one@')

	TaskPlayAnim(playerPed, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 1.0, 1.0, -1, 1, 0.0, false, false, false)

    local success, percentage = exports['crp-ui']:setTaskbar('Ligação direta', 12500, true)

	if not IsPedInAnyVehicle(playerPed) or not success then
		isDoingAction = false
		return
	end

	local randomNumber = GetRandomNumber(100)

	if randomNumber > 65 then
		exports['crp-ui']:setAlert('Ligação direta feita com sucesso.', 'inform')

        SetVehicleEngineOn(vehicle, true, false, false)

        hotwiredVehicles[vehiclePlate] = true
    else
        exports['crp-ui']:setAlert('Não conseguiste fazer ligação direta.', 'inform')

        hotwiredVehicles[vehiclePlate] = false
	end

	isDoingAction = false
end

function hasVehicleKey(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

    if not vehiclesKeys[vehiclePlate] then
        return false
    end

    return true
end

function hasHotwiredVehicle(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

    if not hotwiredVehicles[vehiclePlate] then
        return false
    end

    return true
end

function shutDownVehicle(vehicle)

end