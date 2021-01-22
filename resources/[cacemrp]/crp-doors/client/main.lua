local doors, isInsideZone, currentDoorId = {}, false, nil

exports['crp-lib']:createBoxZones({
	{ coords = vector4(441.12, -977.61, 30.69, 0),    length = 1.8,  width = 1.55, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 2
	{ coords = vector4(441.1, -986.19, 30.69, 0),     length = 1.8,  width = 1.55, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 3
	{ coords = vector4(445.39, -983.6, 30.69, 0),     length = 1.55, width = 1.8,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 4
	{ coords = vector4(438.23, -995.715, 30.69, 0),   length = 1.2,  width = 1.55, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 5 (1)
	{ coords = vector4(438.23, -994.51, 30.69, 0),    length = 1.2,  width = 1.55, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 5 (2)
	{ coords = vector4(442.48, -998.74, 30.69, 0),    length = 1.6,  width = 1.15, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 6 (1)
	{ coords = vector4(441.32, -998.74, 30.69, 0),    length = 1.6,  width = 1.15, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 6 (2)
	{ coords = vector4(452.68, -995.95, 30.69, 315),  length = 1.8,  width = 1.55, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 7
	{ coords = vector4(457.68, -995.95, 30.69, 45),   length = 1.8,  width = 1.55, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 8
	{ coords = vector4(458.67, -990.07, 30.69, 0),    length = 1.55, width = 1.8,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 9
	{ coords = vector4(458.65, -977.49, 30.69, 0),    length = 1.55, width = 1.8,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 10
	{ coords = vector4(456.47, -972.2, 30.69, 0),     length = 1.6,  width = 1.15, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 11 (1)
	{ coords = vector4(457.62, -972.2, 30.69, 0),     length = 1.6,  width = 1.15, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 11 (2)
	{ coords = vector4(469.43, -985.63, 30.69, 0),    length = 1.2,  width = 1.6,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 12 (1)
	{ coords = vector4(469.43, -986.84, 30.69, 0),    length = 1.2,  width = 1.6,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 12 (2)
	{ coords = vector4(473.58, -984.36, 30.69, 0),    length = 1.6,  width = 1.2,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 13 (1)
	{ coords = vector4(474.78, -984.36, 30.69, 0),    length = 1.6,  width = 1.2,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 13 (2)
	{ coords = vector4(479.75, -986.765, 30.69, 0),   length = 1.3,  width = 1.6,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 14 (1)
	{ coords = vector4(479.75, -988.07, 30.69, 0),    length = 1.3,  width = 1.6,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 14 (2)
	{ coords = vector4(474.835, -989.84, 30.69, 0),   length = 1.6,  width = 1.3,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 15 (1)
	{ coords = vector4(473.53, -989.84, 30.69, 0),    length = 1.6,  width = 1.3,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 15 (2)
	{ coords = vector4(479.77, -999.02, 30.69, 0),    length = 1.55, width = 1.8,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 16
	{ coords = vector4(476.73, -999.03, 30.69, 0),    length = 1.55, width = 1.8,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 17
	{ coords = vector4(486.83, -1000.2, 30.69, 0),    length = 1.8,  width = 1.55, minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 18
	{ coords = vector4(487.47, -1002.88, 30.69, 0),   length = 1.6,  width = 1.3,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 19 (1)
	{ coords = vector4(486.16, -1002.88, 30.69, 0),   length = 1.6,  width = 1.3,  minZ = 29.49, maxZ = 32.09, data = 1 }, -- Door 19 (2)

	{ coords = vector4(452.29, -1001.86, 26.26, 0),  length = 12.0,  width = 4.0,  minZ = 24.70, maxZ = 27.35, data = 1 }, -- Door 20
	{ coords = vector4(431.42, -1001.86, 28.72, 0),  length = 12.0,  width = 4.0,  minZ = 24.70, maxZ = 27.35, data = 1 }, -- Door 21
	{ coords = vector4(464.16, -975.28, 26.27, 0),   length = 1.55,  width = 1.8,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 22
	{ coords = vector4(464.14, -996.9, 26.27, 0),    length = 1.55,  width = 1.8,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 23
	{ coords = vector4(471.39, -985.55, 26.27, 0),   length = 1.35,  width = 1.6,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 24 (1)
	{ coords = vector4(471.39, -986.91, 26.27, 0),   length = 1.35,  width = 1.6,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 24 (2)
	{ coords = vector4(469.41, -1000.55, 26.27, 0),  length = 1.6,   width = 1.35, minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 25 (1)
	{ coords = vector4(468.05, -1000.55, 26.27, 0),  length = 1.6,   width = 1.35, minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 25 (2)
	{ coords = vector4(471.35, -1008.31, 26.27, 0),  length = 1.35,  width = 1.6,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 26 (1)
	{ coords = vector4(471.35, -1009.67, 26.27, 0),  length = 1.35,  width = 1.6,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 26 (2)
	{ coords = vector4(469.25, -1014.47, 26.27, 0),  length = 1.6,   width = 1.35, minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 27 (1)
	{ coords = vector4(467.89, -1014.48, 26.43, 0),  length = 1.6,   width = 1.35, minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 27 (2)
	{ coords = vector4(475.4, -990.07, 26.27, 315),  length = 1.8,   width = 1.55, minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 28
	{ coords = vector4(479.12, -985.54, 26.27, 0),   length = 1.35,  width = 1.6,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 29 (1)
	{ coords = vector4(479.12, -986.89, 26.27, 0),   length = 1.35,  width = 1.6,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 29 (1)
	{ coords = vector4(482.65, -984.6, 26.27, 0),    length = 1.55,  width = 1.8,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 30
	{ coords = vector4(482.66, -988.18, 26.27, 0),   length = 1.55,  width = 1.8,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 31
	{ coords = vector4(482.68, -992.9, 26.27, 0),    length = 1.55,  width = 1.8,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 32
	{ coords = vector4(482.66, -996.34, 26.27, 0),   length = 1.55,  width = 1.8,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 33
	{ coords = vector4(481.55, -997.92, 26.27, 0),   length = 1.6,   width = 1.35, minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 34 (1)
	{ coords = vector4(480.19, -997.92, 26.27, 0),   length = 1.6,   width = 1.35, minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 34 (2)
	{ coords = vector4(477.69, -997.96, 26.27, 0),   length = 1.8,   width = 1.55, minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 35
	{ coords = vector4(479.04, -1002.56, 26.27, 0),  length = 1.55,  width = 1.8,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 36
	{ coords = vector4(481.61, -1004.11, 26.27, 0),  length = 1.8,   width = 1.2,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 37
	{ coords = vector4(484.78, -1007.69, 26.27, 0),  length = 1.8,   width = 1.2,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 38
	{ coords = vector4(486.31, -1012.19, 26.27, 0),  length = 1.8,   width = 1.2,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 39
	{ coords = vector4(483.34, -1012.19, 26.27, 0),  length = 1.8,   width = 1.2,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 40
	{ coords = vector4(480.34, -1012.19, 26.27, 0),  length = 1.8,   width = 1.2,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 41
	{ coords = vector4(477.29, -1012.18, 26.27, 0),  length = 1.8,   width = 1.2,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 42
	{ coords = vector4(476.6, -1008.29, 26.27, 0),   length = 1.2,   width = 1.8,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 43
	{ coords = vector4(475.35, -1006.96, 26.27, 0),  length = 1.4,   width = 1.5,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 44
	{ coords = vector4(475.35, -1010.86, 26.27, 0),  length = 1.8,   width = 1.5,  minZ = 25.25, maxZ = 27.70, data = 1 }, -- Door 45

	{ coords = vector4(464.32, -983.92, 43.69, 0),   length = 1.45,  width = 1.8,  minZ = 42.70, maxZ = 45.05, data = 1 }, -- Door 46
	{ coords = vector4(459.35, -981.11, 34.97, 0),   length = 1.8,   width = 1.55, minZ = 33.90, maxZ = 36.30, data = 1 }, -- Door 47
	{ coords = vector4(459.36, -990.77, 34.97, 0),   length = 1.8,   width = 1.55, minZ = 33.90, maxZ = 36.30, data = 1 }, -- Door 48
	{ coords = vector4(449.44, -982.0, 34.97, 315),  length = 1.8,   width = 1.55, minZ = 33.90, maxZ = 36.30, data = 1 }, -- Door 49
	{ coords = vector4(449.41, -989.75, 34.97, 45),  length = 1.8,   width = 1.55, minZ = 33.90, maxZ = 36.30, data = 1 }, -- Door 50
	{ coords = vector4(449.43, -995.92, 34.97, 315), length = 1.8,   width = 1.55, minZ = 33.90, maxZ = 36.30, data = 1 }, -- Door 51
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