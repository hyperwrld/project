local currentJob, isInService = 'unemployed', false

local jobsRelationshipGroups = {
	['police'] = 'COP', ['medic'] = 'MEDIC'
}

RegisterNetEvent('crp-jobs:updateJob')
AddEventHandler('crp-jobs:updateJob', function(job, jobLabel)
	local playerPed, alertText = PlayerPedId(), 'Foste contratado, para o seguinte trabalho: ' .. jobLabel

	if job == 'unemployed' then
		alertText = 'Foste despedido e agora estás desempregado'
	end

	exports['crp-ui']:setAlert(alertText, 'inform')

	if jobsRelationshipGroups[job] then
		SetPedRelationshipGroupDefaultHash(playerPed, GetHashKey(jobsRelationshipGroups[job]))
	else
		SetPedRelationshipGroupDefaultHash(playerPed, GetHashKey('PLAYER'))
	end
end)

RegisterNetEvent('crp-jobs:updateJobService')
AddEventHandler('crp-jobs:updateJobService', function(status)
	isInService = status
end)

function getJob()
	return currentJob
end

function isInService(job)
	if currentJob ~= job or not isInService then
		return false
	end

	return true
end

exports('getJob', getJob)
exports('isInService', isInService)