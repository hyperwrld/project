AddEventHandler('crp-base:playerDisconnected', function(character)
	if not inService[character.getJob()] then
		character.setJob('unemployed', 0)
	end
end)

function deliverPaychecks()
	local characters = exports['crp-base']:getAllCharacters()

	for i = 1, #characters do
		local character, currentJob = characters[i], characters[i].getJob()

		if inService[currentJob] and not inService[currentJob][character.source] then
			-- pay less
		end

		local jobIndex = getJobIndex(currentJob)

		if jobIndex then
			local salary = jobsList[jobIndex].salary + (jobsList[jobIndex].salary * (tonumber(character.getGrade()) / 10))

			character.addBank(RoundNumber(salary))
		end
	end

	SetTimeout(30 * 60000, deliverPaychecks)
end

Citizen.CreateThread(function()
	deliverPaychecks()
end)