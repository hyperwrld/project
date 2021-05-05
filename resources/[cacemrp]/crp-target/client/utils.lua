zones, eventList = {}, {}

function createTarget(zoneName, coords, length, width, minZ, maxZ, data)
	zones[#zones + 1] = BoxZone:Create(coords.xyz, length, width, { name = zoneName, heading = coords.w, minZ = minZ, maxZ = maxZ, data = data, debugPoly = true })

	Debug('Created target zone (' .. zoneName .. ') successfully.')
end

exports('createTarget', createTarget)

function RotationToDirection(rotation)
	local adjustedRotation = vector3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y, (math.pi / 180) * rotation.z)

	return vector3(-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.sin(adjustedRotation.x))
end

function isPointInsideZone(point)
	for zoneId, zone in ipairs(zones) do
		if zone:isPointInside(point) then
			return true, zone.name
		end
	end

	return false
end