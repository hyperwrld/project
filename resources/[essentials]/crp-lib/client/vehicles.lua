local isInVehicle, isEnteringVehicle, currentVehicle, currentSeat = false, false, 0, 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()

		if not isInVehicle and not IsPlayerDead(PlayerId()) then
			local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

			if DoesEntityExist(vehicle) and not isEnteringVehicle then
				local seat, entityNetId = GetSeatPedIsTryingToEnter(playerPed), VehToNet(vehicle)

				isEnteringVehicle = true

				TriggerEvent('crp-lib:enteringVehicle', vehicle, seat, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), entityNetId)
			elseif not DoesEntityExist(vehicle) and not IsPedInAnyVehicle(playerPed, true) and isEnteringVehicle then
				TriggerEvent('crp-lib:enteringAborted')

				isEnteringVehicle = false
			elseif IsPedInAnyVehicle(playerPed, false) then
				isEnteringVehicle, isInVehicle, currentVehicle, currentSeat = false, true, GetVehiclePedIsUsing(playerPed), GetPedVehicleSeat(playerPed)

				local vehicleModel, entityNetId = GetEntityModel(currentVehicle), VehToNet(currentVehicle)

				TriggerEvent('crp-lib:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(vehicleModel), entityNetId)
			end
		elseif isInVehicle then
			if not IsPedInAnyVehicle(playerPed, false) or IsPlayerDead(PlayerId()) then
				local vehicleModel, entityNetId = GetEntityModel(currentVehicle), VehToNet(currentVehicle)

				TriggerEvent('crp-lib:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(vehicleModel), entityNetId)

				isInVehicle, currentVehicle, currentSeat = false, 0, 0
			end
		end

		Citizen.Wait(50)
	end
end)

function GetPedVehicleSeat(playerPed)
	local vehicle = GetVehiclePedIsIn(playerPed, false)

    for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
		if GetPedInVehicleSeat(vehicle, i) == playerPed then
			return i
		end
	end

    return -2
end