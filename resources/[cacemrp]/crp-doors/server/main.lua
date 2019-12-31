local doorInfo = {}

RegisterServerEvent('crp-doors:updateState')
AddEventHandler('crp-doors:updateState', function(door, state)
	if type(door) ~= 'number' or type(state) ~= 'boolean' then
		return
	end

	doorInfo[door] = state

	TriggerClientEvent('crp-doors:setState', -1, door, state)
end)

AddEventHandler('crp-doors:getDoorsInfo', function(source, data, callback)
	callback(doorInfo)
end)