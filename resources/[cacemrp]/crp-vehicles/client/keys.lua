local lastVehicle, isShowingAction, isDoingAction = 0, false, false
local vehiclesKeys, hotwiredVehicles = {}, {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsUsing(playerPed)

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				if not hasVehicleKey(vehicle) or not hasHotwiredVehicle(vehicle) and lastVehicle ~= vehicle then
					isShowingAction = true

					SetVehicleNeedsToBeHotwired(vehicle, false)
					SetVehicleEngineOn(vehicle, false, true, true)

					exports['crp-ui']:toggleInteraction(true, '[G] Procurar / [H] Ligação direta')
				elseif isShowingAction then
					isShowingAction = false

					exports['crp-ui']:toggleInteraction(false)
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

	if vehiclesKeys[vehiclePlate] == false then
		exports['crp-ui']:setAlert('Já procuraste neste veículo e não encontraste nada.', 'inform')
		return
	end

	local randomNumber = GetRandomNumber(100)

	if randomNumber > 90 then
        SetVehicleEngineOn(vehicle, true, false, false)

        setKey(vehiclePlate, true)

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

		setKey(vehiclePlate, true)

		exports['crp-ui']:setAlert('Encontraste a chave no veículo.', 'inform')
	else
		setKey(vehiclePlate, false)

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

	if hotwiredVehicles[vehiclePlate] == false then
		exports['crp-ui']:setAlert('Já tentaste fazer direção direta e não conseguiste.', 'inform')
		return
	end

	local randomNumber = GetRandomNumber(100)

	if randomNumber > 65 then
		SetVehicleEngineOn(vehicle, true, false, false)

		exports['crp-ui']:setAlert('Ligação direta feita com sucesso.', 'inform')

        setHotwire(vehiclePlate, true)
    else
        exports['crp-ui']:setAlert('Não conseguiste fazer ligação direta.', 'inform')

        setHotwire(vehiclePlate, false)
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

function setKey(vehiclePlate, status)
	local success = RPC.execute('setKey', vehiclePlate, status)

	if success then
		vehiclesKeys[vehiclePlate] = status
	end
end

function hasHotwiredVehicle(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

    if not hotwiredVehicles[vehiclePlate] then
        return false
    end

    return true
end

function setHotwire(vehiclePlate, status)
	local success = RPC.execute('setHotwire', vehiclePlate, status)

	if success then
		hotwiredVehicles[vehiclePlate] = status
	end
end

function toggleVehicleEngine()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)

	if vehicle ~= 0 then
		if GetIsVehicleEngineRunning(vehicle) then
			SetVehicleEngineOn(vehicle, true, false, false)
		else
			SetVehicleEngineOn(vehicle, false, false, false)
		end
	end
end

RegisterNetEvent('crp-vehicles:setKeys')
AddEventHandler('crp-vehicles:setKeys', function(vehicleKeys, hotwireVehicles)
	vehiclesKeys, hotwiredVehicles = vehicleKeys or {}, hotwireVehicles or {}
end)

RegisterNetEvent('crp-vehicles:giveKeys')
AddEventHandler('crp-vehicles:giveKeys', function()
	local playerPed = PlayerPedId()
	local coords, vehicle = GetEntityCoords(playerPed), 0

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetVehicleInDirection(playerPed, coords, GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0))
	end

	if not DoesEntityExist(vehicle) then
		exports['crp-ui']:setAlert('Não foi encontrado nenhum veículo.', 'error')
		return
	end

	if not hasVehicleKey(vehicle) then
		exports['crp-ui']:setAlert('Não tens as chaves deste veículo.', 'error')
		return
	end

	local targetPed, distance = GetClosestPlayer()

	if targetPed == -1 or distance > 2.0 then
		exports['crp-ui']:setAlert('Nenhum jogador por perto.', 'error')
		return
	end

	local success = RPC.execute('giveKey', GetPlayerServerId(targetPed), GetVehicleNumberPlateText(vehicle))

	if success then
		exports['crp-ui']:setAlert('Deste a chave do veículo ao jogador.', 'success')
	end
end)

RegisterNetEvent('crp-vehicles:addKey')
AddEventHandler('crp-vehicles:addKey', setKey)

RegisterCommand('+toggleVehicleEngine', toggleVehicleEngine, false)
RegisterKeyMapping('+toggleVehicleEngine', 'Ligar o motor', 'keyboard', 'M')