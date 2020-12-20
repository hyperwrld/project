function createCircleZones(points, radius, useZ, zoneName, eventName, canLog)
	local zones = {}

	for i = 1, #points do
		name = 'circleZone-' .. tostring(i)

		zones[#zones + 1] = CircleZone:Create(points[i].coords, radius, { name = name, useZ = useZ, data = points[i].data, debugPoly = true })
	end

	createZones(zones, zoneName, eventName, canLog)
end

exports('createCircleZones', createCircleZones)

function createBoxZones(points, zoneName, eventName, canLog)
	local zones = {}

	for i = 1, #points do
		name = 'boxZone-' .. tostring(i)

		zones[#zones + 1] = BoxZone:Create(points[i].coords, points[i].length, points[i].width, {
			name = name, heading = points[i].heading, minZ = points[i].minZ, maxZ = points[i].maxZ, data = points[i].data, debugPoly = true
		})
	end

	createZones(zones, zoneName, eventName, canLog)
end

exports('createBoxZones', createBoxZones)

function createZones(zones, zoneName, eventName, canLog)
	local comboZone = ComboZone:Create(zones, { name = zoneName })

	comboZone:onPlayerInOut(function(isPointInside, point, zone)
		if zone then
			if canLog then
				RPC:execute('onPlayerInOut', zoneName, isPointInside)
			end

			TriggerEvent(eventName .. ':onPlayerInOut', isPointInside, zone)
		end
	end)
end

exports('createZones', createZones)