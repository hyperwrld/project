CRP.JobManager, CRP.JobsList, CRP.JobService = {}, {}, {}

function CRP.JobManager:GetJobsList()
	local result = DB:Execute([[SELECT * FROM jobs;]])

	for i = 1, #result do
		local jobData = result[i]

		CRP.JobsList[jobData.name] = { label = jobData.label, maxgrade = jobData.maxgrade, salary = jobData.salary }

		if jobData.service then
			CRP.JobService[jobData.name] = {}
		end
	end
end

function CRP.JobManager:DeliverPayChecks()
	local characters = CRP.Characters or {}

	for i = 1, #characters do
		local character, currentJob = characters[i], characters.getJob()

		if CRP.JobService and not CRP.JobService[currentJob.name][character.source] then
			return
		end

		local salary = math.floor((CRP.JobsList[currentJob.name].salary) + (CRP.JobsList[currentJob.name].salary * (tonumber(currentJob.grade) / 10)))

		character.addBank(salary)
	end

	SetTimeout(5 * 60000, CRP.JobManager.DeliverPayChecks)
end

CRP.JobManager:GetJobsList()
CRP.JobManager:DeliverPayChecks()

RegisterServerEvent('crp-base:updateServiceStatus')
AddEventHandler('crp-base:updateServiceStatus', function(jobName, status)
	if not CRP.JobService[jobName] then
		return
	end

	CRP.JobService[name][source] = status

	Citizen.Wait(1000)

    TriggerClientEvent('crp-base:updateJobService', source, name, status)
end)

AddEventHandler('crp-base:playerDropped', function(source, character)
	local characterJob = character.getJob()

	if not CRP.JobService[characterJob] then
		return
	end

	CRP.JobService[characterJob][source] = false
end)

function isJobValid(jobName, grade)
	local jobData = CRP.JobsList[jobName]

	if not jobData then
		return false
	end

	if grade >= 0 and grade <= jobData.maxgrade then
		return true
	end

	return false
end

function canPromote(jobName, grade)
	local jobData = CRP.JobsList[jobName]

	if not jobData or jobData.maxgrade ~= 0 then
		return false
	end

	if jobData.maxgrade == grade then
		return true
	end

	return false
end