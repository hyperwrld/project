local canScan, isLookingAt, canSelect, zones, playerPed = false, false, false, {}, PlayerPedId()

function scanTarget()
	canScan = not canScan

	if not canScan then
		isLookingAt, canSelect = false, false
	end

	exports['crp-ui']:toggleTarget(canScan, isLookingAt)

	if not canScan then
		return
	end

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

			local direction = RotationToDirection(cameraRotation)
			local destination = {
				x = cameraPosition.x + direction.x * 2.5, y = cameraPosition.y + direction.y * 2.5, z = cameraPosition.z + direction.z * 2.5
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

					exports['crp-ui']:toggleTarget(canScan, isLookingAt)
				else
					if eventData and not isLookingAt and canScan then
						isLookingAt, data = true, {{
							type = eventData.type, label = eventData.label
						}}

						exports['crp-ui']:toggleTarget(canScan, isLookingAt, data)

						TriggerEvent('crp-target:listenForKey')
					end
				end
			else
				if isLookingAt then
					isLookingAt = false

					exports['crp-ui']:toggleTarget(canScan, isLookingAt)
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