local playerPed, canScan, isLookingAt, canSelect = PlayerPedId(), false, false, false

local scanRange = {
    2.7, 3.0, 3.5, 0.0, 2.3  -- [0] Third Person Close / [1] Third Person Mid / [2] Third Person Far / [4] First Person
}

function toggleScan(state)
	canScan = state

	if not state and not canSelect then
		exports['crp-ui']:closeApp('target')
		return
	end

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
			local destination = vector3((cameraPosition.x + direction.x * range), (cameraPosition.y + direction.y * range), (cameraPosition.z + direction.z * range))
			local rayHandle = StartShapeTestRay(cameraPosition, destination, -1, playerPed, 7)
			local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

			if hit == 1 then
				local isInsideZone, eventName = isPointInsideZone(endCoords)

				if not isInsideZone and GetEntityType(entityHit) ~= 0 then
					eventName = GetEntityModel(entityHit)
				end

				local eventData = eventList[eventName]

				if eventData and not isLookingAt and canScan then
					isLookingAt = true

					exports['crp-ui']:setAppData('target', { hideState = canScan, activeState = isLookingAt, options = { id = eventName, type = eventData.type, label = eventData.label } })

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

	exports['crp-ui']:openApp('target', { hideState = canScan, activeState = isLookingAt }, false, false)
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

exports['crp-binds']:RegisterHoldKeybind('toggleScan', '[Target] Mostrar/Ocultar', '', toggleScan, 200) -- ALT Key has problems (probably FiveM related)