RegisterServerEvent('crp-lib:playSound')
AddEventHandler('crp-lib:playSound', function(target, soundName, volume)
	if target == nil then
		target = source
	end

    TriggerClientEvent('crp-lib:playSound', target, soundName, volume)
end)

RegisterServerEvent('crp-lib:playOnCoords')
AddEventHandler('crp-lib:playOnCoords', function(maxDistance, soundName, volume)
	local soundCoords = GetEntityCoords(GetPlayerPed(source))

	for k, playerId in ipairs(GetPlayers()) do
		local coords = GetEntityCoords(GetPlayerPed(playerId))

		if #(soundCoords - coords) < maxDistance then
			TriggerClientEvent('crp-lib:playSound', playerId, soundName, volume)
		end
	end
end)