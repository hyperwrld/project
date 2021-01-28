jobsList, inService = {}, {}

function getJobList()
	local result = Citizen.Await(DB:Execute([[SELECT * FROM jobs;]]))

	for i = 1, #result do
		local data = result[i]

		jobsList[#jobsList + 1] = {
			identifier = data.name, label = data.label, maxGrade = data.maxgrade, salary = data.salary
		}

		if data.service then
			inService[data.name] = {}
		end
	end
end

Citizen.CreateThread(function()
	getJobList()
end)

function fetchJobs()
	return jobsList
end

RPC:register('fetchJobs', fetchJobs)

function getJobIndex(identifier)
	for i = 1, #jobsList, 1 do
		if jobsList[i].identifier == identifier then
			return i
		end
	end

	return false
end