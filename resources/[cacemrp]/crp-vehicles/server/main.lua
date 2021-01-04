local vehiclesKeys, hotwiredVehicles = {}, {}

AddEventHandler('crp-base:characterLoaded', function(source, character)
	local characterId = character.getCharacterId()

	if (vehiclesKeys[characterId] and not #vehiclesKeys[characterId]) and (not hotwiredVehicles[characterId] and not #hotwiredVehicles[characterId]) then
		return
	end

	TriggerClientEvent('crp-vehicles:setKeys', source, vehiclesKeys[characterId], hotwiredVehicles[characterId])
end)

function setKey(source, vehiclePlate, status, updateOnClient)
	local characterId = exports['crp-base']:getCharacter(source).getCharacterId()

	if not vehiclesKeys[characterId] then
		vehiclesKeys[characterId] = {}
	end

	if not vehiclePlate or status == nil then
		return false
	end

	vehiclesKeys[characterId][vehiclePlate] = status

	if updateOnClient then
		TriggerEvent('crp-vehicles:addKey', source, vehiclePlate, status)
	end

	return true
end

RPC:register('setKey', function(source, vehiclePlate, status)
	return setKey(source, vehiclePlate, status)
end)

function setHotwire(source, vehiclePlate, status)
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

RPC:register('setHotwire', function(source, vehiclePlate, status)
	return setHotwire(source, vehiclePlate, status)
end)

function giveKey(source, targetPlayer, vehiclePlate)
	local characterId = exports['crp-base']:getCharacter(source).getCharacterId()

	if not vehiclesKeys[characterId] or not vehiclesKeys[characterId][vehiclePlate] then
		return false
	end

	local success = setKey(targetPlayer, vehiclePlate, true, true)

	if not success then
		return false
	end

	return true
end

RPC:register('giveKey', function(source, targetPlayer, vehiclePlate)
	return giveKey(source, targetPlayer, vehiclePlate)
end)