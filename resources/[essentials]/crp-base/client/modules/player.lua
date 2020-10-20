local currentJob, isInService = 'unemployed', false

local jobsRelationshipGroups = {
	['police'] = 'COP', ['medic'] = 'MEDIC'
}

RegisterNetEvent('crp-base:updateJob')
AddEventHandler('crp-base:updateJob', function(job, jobLabel)
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

RegisterNetEvent('crp-base:updateJobService')
AddEventHandler('crp-base:updateJobService', function(status)
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