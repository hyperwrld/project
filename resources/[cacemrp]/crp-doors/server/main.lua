RegisterServerEvent('crp-doors:changeDoorState')
AddEventHandler('crp-doors:changeDoorState', function(doorId, state)
	local character = exports['crp-base']:getCharacter(source)

	if isAuthorized(doorId, character.getJob()) then
		doorList[doorId].state = state

		TriggerClientEvent('crp-doors:changeDoorState', -1, doorId, state)
	end
end)

RPC:register('fetchDoorsData', function(source)
	return doorList
end)

function isAuthorized(doorId, currentJob)
	for k, jobName in ipairs(doorList[doorId].authorizedJobs) do
		if currentJob == jobName then
			return true
		end
	end

	return false
end