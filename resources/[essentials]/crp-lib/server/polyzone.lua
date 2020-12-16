local zones = {}

function onPlayerInOut(source, zoneName, isPointInside)
	if not zones[zoneName] then
		zones[zoneName] = {}
	end

	if isPointInside then
		zones[zoneName][source] = true
	else
		zones[zoneName][source] = nil
	end
end

function isZoneEmpty(zoneName)
	if not zones[zoneName] or #zones[zoneName] == 0 then
		return true
	end

	return false
end

RPC:register('onPlayerInOut', function(source, zoneName, isPointInside)
    return onPlayerInOut(source, zoneName, isPointInside)
end)

RPC:register('isZoneEmpty', function(source, zoneName)
    return isZoneEmpty(zoneName)
end)