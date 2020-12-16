function createZones(type, points, zoneName, eventName, canLog) -- type: 1 (PolyZones) / 2 (CircleZones)
	local zones = {}

	for i = 1, #points do
		name = 'zone-' .. tostring(i)

		if type == 1 then
			zones[#zones + 1] = PolyZone:Create(points[i].coords, 0.6, { name = name, debugPoly=true, useZ = true, data = points[i].data })
		elseif type == 2 then
			zones[#zones + 1] = CircleZone:Create(points[i].coords, 0.6, { name = name, debugPoly=true, useZ = true, data = points[i].data })
		end
	end

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