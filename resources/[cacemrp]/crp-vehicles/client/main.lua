local canShuffle = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()

        if not canShuffle then
            if not GetPedConfigFlag(playerPed, 184, 1) then
                SetPedConfigFlag(playerPed, 184, true)
			end

            if IsPedInAnyVehicle(playerPed, false) then
				local vehicle = GetVehiclePedIsIn(playerPed, 0)

				if GetIsTaskActive(playerPed, 165) then
					if GetSeatPedIsTryingToEnter(playerPed) == -1 and GetPedConfigFlag(playerPed, 184, 1) then
                        SetPedIntoVehicle(playerPed, vehicle, 0)
                        SetVehicleCloseDoorDeferedAction(vehicle, 0)
					end
				end
            end
        else
            if GetPedConfigFlag(playerPed, 184, 1) then
                SetPedConfigFlag(playerPed, 184, false)
            end
        end
    end
end)

RegisterNetEvent('crp-vehicles:changeSeat')
AddEventHandler('crp-vehicles:changeSeat', function(seatNumber)
	local playerPed = PlayerPedId()

	if not IsPedInAnyVehicle(playerPed, 0) then
		exports['crp-ui']:setAlert('Não estás em nenhum veículo.', 'error')
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, 0)
	local vehicleSeatsNumber = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))

	if seatNumber < - 1 or seatNumber > vehicleSeatsNumber - 2 then
		exports['crp-ui']:setAlert('Inseriste um número de assento inválido.', 'error')
		return
	end

	if not IsVehicleSeatFree(vehicle, seatNumber) then
		exports['crp-ui']:setAlert('O assento que inseriste já está ocupado.', 'error')
		return
	end

	SetPedIntoVehicle(playerPed, vehicle, seatNumber)
end)

function GetPedCurrentSeat(playerPed, vehicle)
    local numberSeats = GetVehicleModelNumberOfSeats(vehicle)

	for i = -1, numberSeats do
        local targetPed = GetPedInVehicleSeat(vehicle, i)

        if targetPed == playerPed then
            return i
        end
    end

	return false
end