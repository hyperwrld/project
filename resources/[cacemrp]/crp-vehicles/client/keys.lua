local vehiclesKeys, hotwiredVehicles = {}, {}

function searchVehicle(vehicle)
	local vehiclePlate = GetVehicleNumberPlateText(vehicle)

	if vehiclesKeys[vehiclePlate] == false then
		exports['crp-ui']:setAlert('Já procuraste este veículo e não encontraste nada.', 'inform')
        return
    end

	isDoingAction = true

    local success, percentage = exports['crp-ui']:setTaskbar('Procurar a chave', 10, true)

	if not isDoingAction or not success then
		return
	end

	local randomNumber = GetRandomNumber(100)

	if randomNumber > 95 then
		setKey(vehiclePlate, true)

		exports['crp-ui']:setAlert('Encontraste a chave no veículo.', 'inform')

		isDoingAction, isShowingAction = false, false
		return
	end

	local success, percentage = exports['crp-ui']:setTaskbar('Procurar a chave na parte de trás', 15, true)

	if not isDoingAction or not success then
		return
	end

	local randomNumber = GetRandomNumber(100)

	if randomNumber > 98 then
		setKey(vehiclePlate, true)

		exports['crp-ui']:setAlert('Encontraste a chave no veículo.', 'inform')

		isShowingAction = false
	else
		setKey(vehiclePlate, false)

		exports['crp-ui']:setAlert('Não conseguiste achar a chave.', 'inform')
	end

	isDoingAction = false
end

function hotwireVehicle(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

	if hotwiredVehicles[vehiclePlate] == false then
		exports['crp-ui']:setAlert('Já tentaste fazer direção direta e não conseguiste.', 'inform')
        return
	end

	isDoingAction = true

	TaskPlayAnim(playerPed, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 1.0, 1.0, -1, 1, 0.0)

	local success, percentage = exports['crp-ui']:setTaskbar('Ligação direta', 12.5, true)

	if not isDoingAction or not success then
		return
	end

	local randomNumber = GetRandomNumber(100)

	if randomNumber > 85 then
        setHotwire(vehiclePlate, true)

		exports['crp-ui']:setAlert('Ligação direta feita com sucesso.', 'inform')

		isShowingAction = false
	else
		setHotwire(vehiclePlate, false)

        exports['crp-ui']:setAlert('Não conseguiste fazer ligação direta.', 'inform')
	end

	isDoingAction = false
end

function setKey(vehiclePlate, status)
	local success = RPC:execute('setKey', vehiclePlate, status)

	if success then
		vehiclesKeys[vehiclePlate] = status
	end
end

function hasVehicleKey(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

    if not vehiclesKeys[vehiclePlate] then
        return false
    end

    return true
end

function setHotwire(vehiclePlate, status)
	local success = RPC:execute('setHotwire', vehiclePlate, status)

	if success then
		hotwiredVehicles[vehiclePlate] = status
	end
end

function hasHotwiredVehicle(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

    if not hotwiredVehicles[vehiclePlate] then
        return false
    end

    return true
end

function toggleVehicleEngine()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle, state = GetVehiclePedIsIn(playerPed, false), true

		if hasVehicleKey(vehicle) or hasHotwiredVehicle(vehicle) then
			if GetIsVehicleEngineRunning(vehicle) then
				state = false
			end

			SetVehicleEngineOn(vehicle, state, false, false)

			TriggerEvent('crp-vehicles:toggledEngine', state, vehicle)
		end
	end
end

RegisterNetEvent('crp-vehicles:setKeys')
AddEventHandler('crp-vehicles:setKeys', function(vehicleKeys, hotwireVehicles)
	vehiclesKeys, hotwiredVehicles = vehicleKeys or {}, hotwireVehicles or {}
end)

RegisterNetEvent('crp-vehicles:changeSeat')
AddEventHandler('crp-vehicles:changeSeat', function(seatNumber)
	if not IsPedInAnyVehicle(playerPed, 0) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local vehicleMaxSeats = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))

	if (seatNumber < -1) or (seatNumber > vehicleMaxSeats - 2) or (not IsVehicleSeatFree(vehicle, seatNumber)) then
		return
	end

	SetPedIntoVehicle(playerPed, vehicle, seatNumber)
end)

function getPedVehicleSeat()
	for i = -2, GetVehicleMaxNumberOfPassengers(currentSeat) do
		if GetPedInVehicleSeat(currentSeat, i) == playerPed then
			return i
		end
	end

	return -2
end