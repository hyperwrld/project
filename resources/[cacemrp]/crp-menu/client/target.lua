local canScan, isLookingAt, canSelect, hasWait, zones, playerPed = false, false, false, false, {}, PlayerPedId()

local scanRange = {
    2.7, 3.0, 3.5, 0.0, 2.3  -- [0] Third Person Close / [1] Third Person Mid / [2] Third Person Far / [4] First Person
}

function toggleScan()
	if hasWait then
		return
	end

	if canScan then
		hasWait = true

		exports['crp-ui']:closeApp('target')
		return
	end

	canScan = not canScan

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

AddEventHandler('crp-ui:closedMenu', function(name, data)
	if name ~= 'target' and not canScan then
		return
	end

	canScan, isLookingAt, canSelect = false, false, false

	Debug('Target scan closed.')

	Citizen.Wait(100)

	hasWait = false
end)

AddEventHandler('crp-target:selectOption', function()
	canSelect, hasWait = true, true

	SetCursorLocation(0.5, 0.5)

	exports['crp-ui']:setNuiFocus(true, true, true)

	Citizen.Wait(50)

	hasWait = false
end)

function createTarget(zoneName, coords, length, width, minZ, maxZ, data)
	zones[#zones + 1] = BoxZone:Create(coords.xyz, length, width, { name = zoneName, heading = coords.w, minZ = minZ, maxZ = maxZ, data = data })

	Debug('Created target zone (' .. zoneName .. ') successfully.')
end

createTarget('mrpd_service', vector4(441.8, -981.9, 30.69, 0), 0.6, 0.4, 30.69, 30.89, nil)

exports('createTarget', createTarget)

function RotationToDirection(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation.x, y = (math.pi / 180) * rotation.y, z = (math.pi / 180) * rotation.z
	}

	return {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), z = math.sin(adjustedRotation.x)
	}
end

function isPointInsideZone(point)
	for k, v in ipairs(zones) do
		if v:isPointInside(point) then
			return true, v.name
		end
	end

	return false
end

RegisterCommand('+toggleScan', toggleScan, false)
RegisterCommand('-toggleScan', toggleScan, false)
RegisterKeyMapping('+toggleScan', 'Ativar/Desativar o target scan', 'keyboard', 'LMENU')