local isInsideZone = false

AddEventHandler('crp-jobs:startedJob', function(job, isLeader)
	if not job == 'garbageman' then
		return
	end

	local coords = vector3(-349.75, -1569.79, 25.23)

	exports['crp-base']:createBlip('trashHQ', coords, 318, 47, 0.75, 'Centro de Reciclagem')

	if isLeader then
		exports['crp-lib']:createCircleZone('trashHQ', coords, 0.65, 'crp-trashHQ')
		exports['crp-ui']:setAlert('Vá até o centro de reciclagem para pegar no seu camião do lixo.', 'inform', 10000)
	end
end)

AddEventHandler('crp-trashHQ:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		ListenForKeys()

		exports['crp-ui']:toggleInteraction(true, '[E] spawnar o camião')
	else
		exports['crp-ui']:toggleInteraction(false)
	end

	isInsideZone = isPointInside
end)

function ListenForKeys(doorId)
	Citizen.CreateThread(function()
		while isInsideZone do
			Citizen.Wait(0)


		end
	end)
end
