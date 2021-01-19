local doors, isInsideZone, currentDoorId = {}, false, nil

exports['crp-lib']:createBoxZones({
	{ coords = vector4(441.12, -977.61, 30.69, 0), length = 1.8, width = 1.55, minZ = 29.49, maxZ = 32.09, data = 1 }
}, 'doorZone', GetCurrentResourceName(), false)

Citizen.CreateThread(function()
	doors = RPC:execute('fetchDoorsData')

	Debug('All the doors are being registered in the system.')

	for doorId, door in ipairs(doors) do
		if door and not IsDoorRegisteredWithSystem(doorId) then
			AddDoorToSystem(doorId, door.model, door.coords, false, false, false)
			DoorSystemSetDoorState(doorId, (door.state), false, true)
		end
	end
end)

AddEventHandler('crp-doors:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		local doorState = DoorSystemGetDoorState(zone.data) ~= 0 and true or false

		currentDoorId = zone.data

		ListenForKeys(zone.data)

		exports['crp-ui']:toggleInteraction(true, ('[E] %s'):format(doorState and 'Trancada' or 'Destrancada'))
	else
		exports['crp-ui']:toggleInteraction(false)
	end

	isInsideZone = isPointInside
end)

function ListenForKeys(doorId)
	Citizen.CreateThread(function()
		while isInsideZone do
			Citizen.Wait(0)

			if IsControlJustReleased(0, 38) then
				toggleDoorState(doorId)
			end
		end
	end)
end

RegisterNetEvent('crp-doors:changeDoorState')
AddEventHandler('crp-doors:changeDoorState', function(doorId, state)
	if doors and doors[doorId] then
		doors[doorId].state = state

		Debug(('Changed door (%s) to state: %s'):format(doorId, state))

		DoorSystemSetAutomaticRate(doorId, 1.0, false, false)
		DoorSystemSetDoorState(doorId, (state and 6 or 0), false, true)

		if isInsideZone and currentDoorId == doorId then
			exports['crp-ui']:toggleInteraction(true, ('[E] %s'):format(state and 'Trancada' or 'Destrancada'))
		end
	end
end)

function toggleDoorState(doorId)
	local doorState, playerPed = DoorSystemGetDoorState(doorId) ~= 0 and true or false, PlayerPedId()

	TriggerServerEvent('crp-doors:changeDoorState', doorId, not doorState)

	TriggerServerEvent('crp-lib:playOnCoords', 2.5, 'doors', 0.1)
	TaskPlayAnimation(playerPed, 'anim@heists@keycard@', 'exit', 8.0, 1.0, -1, 16, 0)

	Citizen.Wait(850)

	ClearPedTasks(playerPed)
end