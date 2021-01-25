Citizen.CreateThread(function()
	Debug('Updated jobs list on the crp-ui.')

	exports['crp-ui']:setJobList(jobsList)
end)