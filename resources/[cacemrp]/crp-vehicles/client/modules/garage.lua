function GetClosestVehicle(coords, maxDistance)
	local closestVehicle, smallestDistance, vehicles = -1, maxDistance, GetAllVehicles()

	for k, vehicle in pairs(vehicles) do
		if DoesEntityExist(entity) then
			local distance = #(coords - GetEntityCoords(entity))

			if distance <= smallestDistance then
				closestVehicle, smallestDistance = entity, distance
			end
		end
	end

	return closestVehicle, smallestDistance
end

exports('GetClosestVehicle', GetClosestVehicle)