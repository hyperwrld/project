function createCircleZones(points, zoneName, resourceName)
	local zones = {}

	for i = 1, #points do
		name = 'circle-' .. tostring(i)

		zones[#zones + 1] = CircleZone:Create(points[i].coords, 0.6, { name = name, useZ = true, data = points[i].data })
	end

	local zone = ComboZone:Create(zones, { name = zoneName })

	zone:onPlayerInOut(function(isPointInside, point, zone)
		if zone then
			TriggerEvent(resourceName ..'onPlayerInOut', isInsideZone, point)
		end
	end)
end

exports('createCircleZones', createCircleZones)