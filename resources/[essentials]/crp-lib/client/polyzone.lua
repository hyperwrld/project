function createZones(type, points, zoneName, eventName) -- type: 1 (PolyZones) / 2 (CircleZones)
	local zones = {}

	for i = 1, #points do
		name = 'zone-' .. tostring(i)

		if type == 1 then
			zones[#zones + 1] = PolyZone:Create(points[i].coords, 0.6, { name = name, useZ = true, data = points[i].data })
		elseif type == 2 then
			zones[#zones + 1] = CircleZone:Create(points[i].coords, 0.6, { name = name, useZ = true, data = points[i].data })
		end
	end

	local zone = ComboZone:Create(zones, { name = zoneName })

	zone:onPlayerInOut(function(isPointInside, point, zone)
		if zone then
			TriggerEvent(eventName .. ':onPlayerInOut', isInsideZone, point)
		end
	end)
end

exports('createZones', createZones)