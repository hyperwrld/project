local zones = {}

function createCircleZone(zoneName, coords, radius, eventName)
	if zones[zoneName] and not zones[zoneName].destroyed then
		return
	end

	zones[zoneName] = CircleZone:Create(coords, radius, { name = zoneName, useZ = true, debugPoly = false })

	zones[zoneName]:onPlayerInOut(function(isPointInside, point, zone)
		TriggerEvent(eventName .. ':onPlayerInOut', isPointInside, zone)
	end)
end

exports('createCircleZone', createCircleZone)

function destroyZone(zoneName)
	if not zones[zoneName] or zones[zoneName].destroyed then
		return false
	end

	zones[zoneName]:destroy()

	return true
end

exports('destroyZone', destroyZone)

function createCircleZones(points, radius, useZ, zoneName, eventName, canLog)
	local zones = {}

	Debug('Trying to create zone (' .. zoneName .. ' - type: circle).')

	for i = 1, #points do
		name = 'circleZone-' .. tostring(i)

		zones[#zones + 1] = CircleZone:Create(points[i].coords, radius, { name = name, useZ = useZ, data = points[i].data, debugPoly = false })
	end

	createZones(zones, zoneName, eventName, canLog)
end

exports('createCircleZones', createCircleZones)

function createBoxZone(zoneName, coords, length, width, minZ, maxZ, data, eventName)
	local boxZone = BoxZone:Create(coords.xyz, length, width, { name = zoneName, heading = coords.w, minZ = minZ, maxZ = maxZ, data = data, debugPoly = false })

	boxZone:onPlayerInOut(function(isPointInside, point, zone)
		TriggerEvent(eventName .. ':onPlayerInOut', isPointInside, zone)
	end)

	Debug('Created zone (' .. zoneName .. ') successfully.')

	return boxZone
end

exports('createBoxZone', createBoxZone)

function createBoxZones(points, zoneName, eventName, canLog)
	local zones = {}

	Debug('Trying to create zone (' .. zoneName .. ' - type: box).')

	for i = 1, #points do
		name = 'boxZone-' .. tostring(i)

		zones[#zones + 1] = BoxZone:Create(points[i].coords.xyz, points[i].length, points[i].width, {
			name = name, heading = points[i].coords.w, minZ = points[i].minZ, maxZ = points[i].maxZ, data = points[i].data, debugPoly = false
		})
	end

	createZones(zones, zoneName, eventName, canLog)
end

exports('createBoxZones', createBoxZones)

function createPolyZone(points, minZ, maxZ, zoneName, eventName)
	Debug('Trying to create zone (' .. zoneName .. ' - type: poly).')

	local polyZone = PolyZone:Create(points, { name = zoneName, minZ = minZ, maxZ = maxZ, debugGrid = true })

	polyZone:onPlayerInOut(function(isPointInside, point, zone)
		TriggerEvent(eventName .. ':onPlayerInOut', isPointInside, zone)
	end)

	Debug('Created zone (' .. zoneName .. ') successfully.')
end

exports('createPolyZone', createPolyZone)

function createZones(zones, zoneName, eventName, canLog)
	local comboZone = ComboZone:Create(zones, { name = zoneName })

	Debug('Created zone (' .. zoneName .. ') successfully.')

	comboZone:onPlayerInOut(function(isPointInside, point, zone)
		if zone then
			if canLog then
				RPC:execute('onPlayerInOut', zoneName, isPointInside)
			end

			TriggerEvent(eventName .. ':onPlayerInOut', isPointInside, zone)
		end
	end)
end