local isLoggedIn, isInVehicle, isEnteringVehicle, isCheckingTask, isShowingAction, currentVehicle, currentSeat = false, false, false, false, false, 0, 0

playerPed, playerId, isDoingAction = PlayerPedId(), PlayerId(), false

AddEventHandler('crp-base:characterSpawned', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5000)

			playerPed, playerId = PlayerPedId(), PlayerId()
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(50)

			if not isInVehicle then
				local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

				if DoesEntityExist(vehicle) and not isEnteringVehicle then
					isEnteringVehicle = true

					TriggerEvent('crp-vehicles:enteringVehicle', vehicle, GetSeatPedIsTryingToEnter(playerPed), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), VehToNet(vehicle))
				elseif not DoesEntityExist(vehicle) and not IsPedInAnyVehicle(playerPed, true) and isEnteringVehicle then
					isEnteringVehicle = false

					TriggerEvent('crp-vehicles:enteringAborted')
				elseif IsPedInAnyVehicle(playerPed, false) then
					isEnteringVehicle, isInVehicle, currentVehicle = false, true, GetVehiclePedIsUsing(playerPed)

					TriggerEvent('crp-vehicles:enteredVehicle', currentVehicle, getPedVehicleSeat(), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), VehToNet(currentVehicle))
				end
			elseif isInVehicle and not IsPedInAnyVehicle(playerPed, false) then
				TriggerEvent('crp-vehicles:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), VehToNet(currentVehicle))

				isInVehicle, currentVehicle, currentSeat = false, 0, 0
			end
		end
	end)
end)

AddEventHandler('crp-vehicles:enteringVehicle', function(vehicle)
	SetVehicleNeedsToBeHotwired(vehicle, false)
end)

AddEventHandler('crp-vehicles:enteredVehicle', function(vehicle, currentSeat, vehicleModel, vehicleNetId)
	isCheckingTask = true

	print('Started checkingTask.')

	SetVehicleEngineOn(vehicle, false, true, true)

	Citizen.CreateThread(function()
		while isCheckingTask do
			Citizen.Wait(0)

			if GetIsTaskActive(playerPed, 165) then
				if GetSeatPedIsTryingToEnter(playerPed) == -1 and GetPedConfigFlag(playerPed, 184, 1) then
					SetPedIntoVehicle(playerPed, vehicle, 0)
				end
			end
		end
	end)

	Citizen.Wait(2000)

	if isCheckingTask then
		print('Stopped checkingTask.')

		isCheckingTask = false
	end

	if not hasVehicleKey(vehicle) and not hasHotwiredVehicle(vehicle) then
		isShowingAction = true

		exports['crp-ui']:toggleInteraction(true, '[G] Procurar', '[H] Ligação direta')

		Citizen.CreateThread(function()
			while isShowingAction do
				Citizen.Wait(0)

				if not isDoingAction then
					if IsControlJustPressed(0, 47) then
						searchVehicle(vehicle)
					end

					if IsControlJustPressed(0, 74) then
						hotwireVehicle(vehicle)
					end
				end
			end
		end)
	end
end)

AddEventHandler('crp-vehicles:leftVehicle', function()
	if isCheckingTask then
		isCheckingTask = false

		print('Stopped checkingTask.')
	end

	if isShowingAction then
		isShowingAction = false

		exports['crp-ui']:toggleInteraction(false)
	end

	if isDoingAction then
		isDoingAction = false
	end
end)

RegisterCommand('+toggleVehicleEngine', toggleVehicleEngine, false)
RegisterKeyMapping('+toggleVehicleEngine', 'Ligar/Desligar o motor', 'keyboard', 'M')