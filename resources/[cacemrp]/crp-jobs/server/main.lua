local inService, groups = {}, {}

function getJobList()
	local result = Citizen.Await(DB:Execute([[SELECT * FROM jobs;]]))

	for i = 1, #result do
		local data = result[i]
		local jobIndex = getJobIndex(data.name)

		if jobIndex then
			jobsList[jobIndex].maxGrade, jobsList[jobIndex].salary = data.maxgrade, data.salary

			if data.service then
				inService[data.name] = {}
			end
		end
	end
end

getJobList()

function deliverPaychecks()
	local characters = exports['crp-base']:getAllCharacters()

	for i = 1, #characters do
		local character, currentJob = characters[i], characters[i].getJob()

		if inService[currentJob] and not inService[currentJob][character.source] then
			-- pay less
		end

		local salary = jobsList[currentJob].salary + (jobsList[currentJob].salary * (tonumber(character.getGrade()) / 10))

		character.addBank(RoundNumber(salary))
	end

	SetTimeout(30 * 60000, deliverPaychecks)
end

deliverPaychecks()

function createGroup(source)
	local character, code = exports['crp-base']:getCharacter(source), getGroupCode()

	groups[code] = {
		[source] = {  }
	}

	return true
end

function getGroupCode()
	while true do
		local canContinue, code = true, GetRandomString(4)

		for i = 1, #groups do
			if groups[i].code == code then
				canContinue = false
			end
		end

		if canContinue then break end
	end

	return code
end