JobsList, JobService = {}, {}

function getJobsList()
	local result = DB:Execute([[SELECT * FROM jobs;]])

	for i = 1, #result do
		local jobData = result[i]

		JobsList[jobData.name] = { label = jobData.label, maxgrade = jobData.maxgrade, salary = jobData.salary }

		if jobData.service then
			JobService[jobData.name] = {}
		end
	end
end

function deliverPayChecks()
	local characters = exports['crp-base']:getAllCharacters()

	for i = 1, #characters do
		local character, currentJob = characters[i], characters.getJob()

		if JobService and not JobService[currentJob.name][character.source] then
			return
		end

		local salary = math.floor((JobsList[currentJob.name].salary) + (JobsList[currentJob.name].salary * (tonumber(currentJob.grade) / 10)))

		character.addBank(salary)
	end

	SetTimeout(5 * 60000, deliverPayChecks)
end

getJobsList()
deliverPayChecks()

RegisterServerEvent('crp-jobs:updateService')
AddEventHandler('crp-jobs:updateService', function(jobName, status)
	if not JobService[jobName] then
		return
	end

	if Characters[source].job ~= jobName then
		return
	end

	JobService[name][source] = status

	Citizen.Wait(1000)

    TriggerClientEvent('crp-jobs:updateJobService', source, status)
end)

AddEventHandler('crp-base:playerDropped', function(source, character)
	local characterJob = character.getJob()

	if not JobService[characterJob] then
		return
	end

	JobService[characterJob][source] = false
end)

function isJobValid(jobName, grade)
	local jobData = JobsList[jobName]

	if not jobData then
		return false
	end

	if grade >= 0 and grade <= jobData.maxgrade then
		return true
	end

	return false
end

function canPromote(jobName, grade)
	local jobData = JobsList[jobName]

	if not jobData or jobData.maxgrade ~= 0 then
		return false
	end

	if jobData.maxgrade == grade then
		return true
	end

	return false
end