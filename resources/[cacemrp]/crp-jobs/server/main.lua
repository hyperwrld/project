jobs, inService = {}, {}

AddEventHandler('crp-base:playerDisconnected', function(character)
	if not inService[character.getJob()] then
		character.setJob('unemployed', 0)
	end
end)

function getJobList()
	local result = Citizen.Await(DB:Execute([[SELECT * FROM jobs;]]))

	for i = 1, #result do
		local data = result[i]

		jobs[#jobs + 1] = {
			name = data.name, label = data.label, maxGrade = data.maxgrade, salary = data.salary
		}

		if data.service ~= 0 then
			inService[data.name] = {}
		end
	end
end

function deliverPaychecks()
	local characters = exports['crp-base']:getAllCharacters()

	for i = 1, #characters do
		local character, currentJob = characters[i], characters[i].getJob()

		if inService[currentJob] and not inService[currentJob][character.source] then
			-- pay less
		end

		local jobIndex = getJobIndex(jobs, currentJob)

		if jobIndex then
			local salary = jobs[jobIndex].salary + (jobs[jobIndex].salary * (tonumber(character.getGrade()) / 10))

			character.addBank(RoundNumber(salary))
		end
	end

	SetTimeout(30 * 60000, deliverPaychecks)
end

Citizen.CreateThread(function()
	getJobList()
	deliverPaychecks()
end)

function getJobIndex(table, name)
	for i = 1, #table, 1 do
		if table[i].name == name then
			return i
		end
	end

	return false
end