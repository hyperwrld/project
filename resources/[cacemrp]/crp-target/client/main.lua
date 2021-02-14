local canScan, isLookingAt, canSelect, hasWait, zones, playerPed = false, false, false, false, {}, PlayerPedId()

local scanRange = {
    2.7, 3.0, 3.5, 0.0, 2.3  -- [0] Third Person Close / [1] Third Person Mid / [2] Third Person Far / [4] First Person
}

function scanTarget()
	if hasWait then
		return
	end

	canScan = not canScan

	if not canScan then
		isLookingAt, canSelect = false, false
	end

	if not canScan then
		exports['crp-ui']:closeApp('target')
		return
	end

	exports['crp-ui']:openApp('target', { hideState = canScan, activeState = isLookingAt }, false, false)

	Citizen.CreateThread(function()
		while canScan do
			Citizen.Wait(5000)

			playerPed = PlayerPedId()
		end
	end)

	Citizen.CreateThread(function()
		while canScan do
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

				if not eventData and isLookingAt then
					isLookingAt = false

					exports['crp-ui']:setAppData('target', { hideState = canScan, activeState = isLookingAt })
				else
					if not isLookingAt and canScan then
						if eventData then
							local data = {}

							isLookingAt = true

							if eventData then
								data = {{
									id = eventName, type = eventData.type, label = eventData.label
								}}
							else

							end

							exports['crp-ui']:setAppData('target', { hideState = canScan, activeState = isLookingAt, options = data })

							TriggerEvent('crp-target:listenForKey')
						end
					end
				end
			else
				if isLookingAt then
					isLookingAt = false

					exports['crp-ui']:setAppData('target', { hideState = canScan, activeState = isLookingAt })
				end
			end
		end
	end)
end

AddEventHandler('crp-target:listenForKey', function()
	Citizen.CreateThread(function()
		while isLookingAt do
			Citizen.Wait(0)

			if canSelect then
				DisableAllControlActions(0)
			else
				DisableControlAction(0, 24, true)

				if IsDisabledControlJustReleased(0, 24) then
					canSelect = true

					exports['crp-ui']:setNuiFocus(true, true, true)
				end
			end
		end
	end)
end)

RegisterUICallback('startEvent', function(data, cb)
	canScan, isLookingAt, canSelect, hasWait = false, false, false, true

	if eventList[data] then
		TriggerEvent(eventList[data].eventName, table.unpack(eventList[data].data))
	end

	Citizen.Wait(2000)

	hasWait = false

	cb({ state = true })
end)

function createTarget(zoneName, coords, length, width, minZ, maxZ, data)
	zones[#zones + 1] = BoxZone:Create(coords.xyz, length, width, { name = zoneName, heading = coords.w, minZ = minZ, maxZ = maxZ, data = data })

	Debug('Created target zone (' .. zoneName .. ') successfully.')
end

createTarget('mrpd_service', vector4(441.8, -981.9, 30.69, 0), 0.6, 0.4, 30.69, 30.89, nil)

exports('createTarget', createTarget)

function isPointInsideZone(point)
	for k, v in ipairs(zones) do
		if v:isPointInside(point) then
			return true, v.name
		end
	end

	return false
end

RegisterCommand('+scanTarget', scanTarget, false)
RegisterCommand('-scanTarget', scanTarget, false)
RegisterKeyMapping('+scanTarget', 'Abrir o menu', 'keyboard', 'LMENU')