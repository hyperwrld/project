local vehiclesKeys, hotwiredVehicles = {}, {}

RegisterNetEvent('crp-base:characterLoaded', function(source, character)
	local characterId = character.getCharacterId()

	TriggerEvent('crp-vehicles:setKeys', source, vehiclesKeys[characterId], hotwiredVehicles[characterId])
end)

function setVehicleKey(source, vehiclePlate, status)
	local characterId = exports['crp-base']:getCharacter(source).getCharacterId()

	if not vehiclesKeys[characterId] then
		vehiclesKeys[characterId] = {}
	end

	if not vehiclePlate or status == nil then
		return false
	end

	vehiclesKeys[characterId][vehiclePlate] = status

	return true
end

function setHotwiredVehicle(source, vehiclePlate, status)
	local characterId = exports['crp-base']:getCharacter(source).getCharacterId()

	if not hotwiredVehicles[characterId] then
		hotwiredVehicles[characterId] = {}
	end

	if not vehiclePlate or status == nil then
		return false
	end

	hotwiredVehicles[characterId][vehiclePlate] = status

	return true
end

RPC:register('setVehicleKey', function(source, vehiclePlate, status) return setVehicleKey(source, vehiclePlate, status) end)
RPC:register('setHotwiredVehicle', function(source, vehiclePlate, status) return setHotwiredVehicle(source, vehiclePlate, status) end)