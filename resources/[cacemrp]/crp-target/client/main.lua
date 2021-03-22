local canScan, isLookingAt, canSelect, playerPed = false, false, false, PlayerPedId()

local scanRange = {
    2.7, 3.0, 3.5, 0.0, 2.3  -- [0] Third Person Close / [1] Third Person Mid / [2] Third Person Far / [4] First Person
}

function toggleScan(state)
	if not state then
		exports['crp-ui']:closeApp('target')
		return
	end

	canScan = state

	Citizen.CreateThread(function()
		while canScan and not canSelect do
			Citizen.Wait(5000)

			playerPed = PlayerPedId()
		end
	end)

	Citizen.CreateThread(function()
		while canScan and not canSelect do
			Citizen.Wait(250)

			local coords, cameraRotation, cameraPosition = GetEntityCoords(playerPed), GetGameplayCamRot(), GetGameplayCamCoord()

			local direction, range = RotationToDirection(cameraRotation), scanRange[GetFollowPedCamViewMode() + 1]
			local destination = {
				x = cameraPosition.x + direction.x * range, y = cameraPosition.y + direction.y * range, z = cameraPosition.z + direction.z * range
			}

			local rayHandle = StartShapeTestRay(cameraPosition.x, cameraPosition.y, cameraPosition.z, destination.x, destination.y, destination.z, -1, playerPed, 7)
			local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

			if hit == 1 then
				local isInsideZone, eventName = isPointInsideZone(endCoords)

				if not isInsideZone and GetEntityType(entityHit) ~= 0 then
					eventName = GetEntityModel(entityHit)
				end

				local eventData = eventList[eventName]

				if eventData and not isLookingAt and canScan then
					local data = {}

					isLookingAt = true

					if eventData then
						data = {{
							id = eventName, type = eventData.type, label = eventData.label
						}}
					else

					end

					exports['crp-ui']:setAppData('target', { hideState = canScan, activeState = isLookingAt, options = data })

					Citizen.CreateThread(function()
						while canScan and isLookingAt do
							Citizen.Wait(0)

							if not canSelect then
								DisablePlayerFiring(playerPed, true)

								if IsDisabledControlJustReleased(0, 24) then
									TriggerEvent('crp-target:selectOption')
								end
							else
								DisableAllControlActions(0)
							end
						end
					end)
				end
			elseif isLookingAt then
				isLookingAt = false

				exports['crp-ui']:setAppData('target', { hideState = canScan, activeState = isLookingAt })
			end
		end
	end)

	exports['crp-ui']:openApp('target', { hideState = canScan, activeState = isLookingAt }, false, false, true)
end

AddEventHandler('crp-target:selectOption', function()
	canSelect = true

	SetCursorLocation(0.5, 0.5)

	exports['crp-ui']:setNuiFocus(true, true, true)
end)

RegisterUICallback('startEvent', function(data, cb)
	exports['crp-ui']:closeApp('target')

	if eventList[data] then
		TriggerEvent(eventList[data].eventName, table.unpack(eventList[data].data))
	end

	cb({ state = true })
end)

AddEventHandler('crp-ui:closedMenu', function(name, data)
	if name ~= 'target' and not canScan then
		return
	end

	isLookingAt, canSelect = false, false

	Debug('Target scan closed.')
end)

exports['crp-binds']:RegisterHoldKeybind('toggleScan', 'Ativar/Desativar o target scan', 'LMENU', toggleScan, 0)