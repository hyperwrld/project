CRP.Jobs, CRP.JobsList, CRP.InService = {}, {}, {}

function CRP.Jobs:GetJobsList()
    exports.ghmattimysql:execute('SELECT * FROM jobs;', {}, function(result)
        for i = 1, #result do
            CRP.JobsList[result[i].name] = { label = result[i].label, minGrade = result[i].min_grade, maxGrade = result[i].max_grade, salary = result[i].salary }

            if result[i].has_service then
                CRP.InService[result[i].name] = {}
            end
        end
    end)
end

CRP.Jobs:GetJobsList()

function CRP.Jobs:DeliverPaychecks()
    local characters = CRP.Characters or {}

    for i = 1, #characters, 1 do
        local character = characters[i]
        local characterJob = character.getJob()

        local salary = math.floor((CRP.JobsList[characterJob.name].salary) + (CRP.JobsList[characterJob.name].salary * (tonumber(characterJob.grade) / 10)))

        character.addBank(salary)

        TriggerClientEvent('crp-ui:setAlert', character.source, { type = 'inform', text = 'Acabaste de receber o teu salario de ' .. salary .. '€.' })
    end

    SetTimeout(5 * 60000, CRP.Jobs.DeliverPaychecks)
end

CRP.Jobs:DeliverPaychecks()

function CheckIfHigherRank(name, grade)
    if not job or type(job) ~= 'string' then return false end
    if not grade or type(grade) ~= 'number' then return false end

    if CRP.JobsList[name] and grade == CRP.JobsList[name].maxGrade then
        return true
    end

    return false
end

function DoesJobExist(job, grade)
    if not job or type(job) ~= 'string' then return false end
    if not grade or type(grade) ~= 'number' then return false end

    if CRP.JobsList[job] and grade >= CRP.JobsList[job].minGrade and grade <= CRP.JobsList[job].maxGrade then
        return true
    end

    return false
end

AddEventHandler('crp-base:playerDropped', function(source, character)
    if CRP.InService[character.getJob()] then
        CRP.InService[character.getJob()][source] = false
    end
end)

RegisterServerEvent('crp-base:leaveJobService')
AddEventHandler('crp-base:leaveJobService', function(name)
    if CRP.InService[name] then
        CRP.InService[name][source] = false
    end

    Citizen.Wait(1000)

    TriggerClientEvent('crp-base:updateJobService', source, name, false)
end)

RegisterServerEvent('crp-base:joinJobService')
AddEventHandler('crp-base:joinJobService', function(name)
    if CRP.InService[name] then
        CRP.InService[name][source] = true
    end

    Citizen.Wait(1000)

    TriggerClientEvent('crp-base:updateJobService', source, name, true)
end)