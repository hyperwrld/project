local currentJob, isInService, isHandcuffed, isPrimeTime, isNightTime = 'unemployed', false, false, false, false

exports('GetPedData', function(type)
    local data = false

    if type == 'currentJob' then
        data = currentJob
    end

    if type == 'isInService' then
        data = isInService
    end

    if type == 'isHandcuffed' then
        data = isHandcuffed
    end

    if type == 'isPrimeTime' then
        data = isPrimeTime
    end

    if type == 'isNightTime' then
        data = isNightTime
    end

    if type == 'isPolice' then
        if job == 'police' and IsInService then
            data = true
        else
            data = false
        end
    end

    if type == 'isWhitelisted' then
        if (job == 'police' or job == 'medic') and IsInService then
            data = true
        else
            data = false
        end
    end
end)

RegisterNetEvent('crp-base:updateJobService')
AddEventHandler('crp-base:updateJobService', function(jobName, status)
    isInService = status
end)

AddEventHandler('crp-base:updateCurrentJob', function(newJob)
    currentJob = newJob
end)

AddEventHandler('crp-base:setTimeData', function(type, state)
    if type == 'primeTime' then
        isPrimeTime = state
    elseif type == 'nightTime' then
        isNightTime = state
    end
end)

AddEventHandler('crp-base:isPolice', function(callback)
    if job == 'police' and isInService then
        callback(true)
    else
        callback(false)
    end
end)

AddEventHandler('crp-base:isMedic', function(callback)
    if job == 'medic' and isInService then
        callback(true)
    else
        callback(false)
    end
end)