local playerPed, currentTarget, isInVehicle = PlayerPedId(), nil, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5500)

		playerPed = PlayerPedId()
	end
end)

Citizen.CreateThread(function()
	while true do
		local entity, entityType, coords = GetEntityPlayerIsLookingAt(3.0, 0.2, 286)

		if entity and entityType ~= 0 then
			if (entity ~= currentTarget) then
				currentTarget = entity

				TriggerEvent('crp-interact:changedEntity', currentTarget, entityType, coords)
			end
		elseif currentTarget then
			currentTarget = nil

			TriggerEvent('crp-interact:changedEntity', currentTarget)
		end

		Citizen.Wait(250)
	end
end)

function GetEntityPlayerIsLookingAt(distance, radius, flag)
	local boneCoords = GetPedBoneCoords(playerPed, 31086)
	local forwardVector = GetForwardVector(GetGameplayCamRot(2))

	if not forwardVector then
		return
	end

	local forwardCoords = boneCoords + (forwardVector * (isInVehicle and distance + 1.5 or distance))
	local _, hit, endCoords, surfaceNormal, entityHit = StartShapeTest(boneCoords, forwardCoords, flag or 286, playerPed, radius or 0.2)

	if not hit and entityHit == 0 then
		return
	end

	local entityType = GetEntityType(entityHit)

    return entityHit, entityType, endCoords
end

function StartShapeTest(origin, target, flag, ignoreEntity, radius)
    local handle = StartShapeTestSweptSphere(origin.x, origin.y, origin.z, target.x, target.y, target.z, radius, flag, ignoreEntity, 0)

    return GetShapeTestResult(handle)
end

function GetForwardVector(rotation)
    local rot = (math.pi / 180.0) * rotation

    return vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)), math.sin(rot.x))
end