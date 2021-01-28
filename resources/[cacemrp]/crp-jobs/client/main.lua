Citizen.CreateThread(function()
	local data = RPC:execute('fetchJobs')

	exports['crp-ui']:setJobList(data)

	Debug('Updated jobs list on the crp-ui.')
end)

RegisterUICallback('createGroup', function(data, cb)
	local success, data = RPC:execute('createGroup', data)

    cb({ state = success, group = data })
end)

RegisterUICallback('joinGroup', function(data, cb)
	local success, data = RPC:execute('joinGroup', data.code)

    cb({ state = success, group = data })
end)

RegisterUICallback('leaveGroup', function(data, cb)
	local success = RPC:execute('leaveGroup', data.code)

    cb({ state = success })
end)

RegisterNetEvent('crp-jobs:updateGroup')
AddEventHandler('crp-jobs:updateGroup', function(data)
	exports['crp-ui']:setGroupData(data)
end)