local isScanning, zones = false, {}

function scanTarget()
	isScanning = not isScanning

	if isScanning then
		Citizen.CreateThread(function()
			while isScanning do
				local playerPed, found, data = PlayerPedId(), false, {}
				local coords, cameraRotation, cameraPosition = GetEntityCoords(playerPed), GetGameplayCamRot(), GetGameplayCamCoord()

				local direction = RotationToDirection(cameraRotation)
				local destination = {
					x = cameraPosition.x + direction.x * 2.5, y = cameraPosition.y + direction.y * 2.5, z = cameraPosition.z + direction.z * 2.5
				}

				local rayHandle = StartShapeTestRay(cameraPosition.x, cameraPosition.y, cameraPosition.z, destination.x, destination.y, destination.z, -1, playerPed, 7)
				local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

				DisablePlayerFiring(playerPed, true)

				if hit == 1 then
					local entityModel = GetEntityModel(entityHit)

					-- print(entityModel)

					if objectList[entityModel] then
						local objectData = objectList[entityModel]

						found, data = true, {{ type = objectData.type, label = objectData.label }}

						if IsDisabledControlJustPressed(0, 69) then
							exports['crp-ui']:setNuiFocus(true, true)
						end

						--TriggerEvent(objectList[entityModel].eventName, table.unpack(objectList[entityModel].data))
						print('sssss', json.encode(objectList[entityModel]))
					end

					-- DrawLine(coords.x, coords.y, coords.z, endCoords.x, endCoords.y, endCoords.z, 255, 0, 0, 255)
					-- DrawMarker(28, endCoords.x, endCoords.y, endCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.2, 0.2, 0.2, 255, 128, 0, 50, false, true, 2, nil, nil, false)
				end

				exports['crp-ui']:toggleTarget(isScanning, found, data)

				Citizen.Wait(0)
			end
		end)
	else
		exports['crp-ui']:setNuiFocus(false, false)

		exports['crp-ui']:toggleTarget(false, false)
	end
end

function createTarget(zoneName, coords, length, width, minZ, maxZ, data)
	zones[#zones + 1] = BoxZone:Create(coords.xyz, length, width, { name = zoneName, heading = coords.w, minZ = minZ, maxZ = maxZ, data = data, debugPoly = true })

	Debug('Created target zone (' .. zoneName .. ') successfully.')
end

createTarget('mrpd_service', vector4(441.8, -981.9, 30.69, 0), 0.6, 0.4, 30.69, 30.89, nil)

exports('createTarget', createTarget)

function isPointInsideZone(point)
	for k, v in ipairs(zones) do
		print(point)
		if v:isPointInside(point) then
			return true, v.name, v.data
		end
	end

	return false
end

RegisterCommand('+scanTarget', scanTarget, false)
RegisterCommand('-scanTarget', scanTarget, false)
RegisterKeyMapping('+scanTarget', 'Abrir o menu', 'keyboard', 'LMENU')