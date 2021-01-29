local currentJob = 'unemployed'

Citizen.CreateThread(function()
	exports['crp-ui']:setJobList(jobs)

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

RegisterUICallback('kickMember', function(data, cb)
	local success, data = RPC:execute('kickMember', data.code, data.member)

    cb({ state = success, group = data })
end)

RegisterUICallback('leaveGroup', function(data, cb)
	local success = RPC:execute('leaveGroup', data.code)

    cb({ state = success })
end)

function getJob()
	return currentJob
end

exports('getJob', getJob)

RegisterNetEvent('crp-jobs:updateJob')
AddEventHandler('crp-jobs:updateJob', function(jobName)
	currentJob = jobName
end)

RegisterNetEvent('crp-jobs:updateGroup')
AddEventHandler('crp-jobs:updateGroup', function(data)
	exports['crp-ui']:setGroupData(data)
end)