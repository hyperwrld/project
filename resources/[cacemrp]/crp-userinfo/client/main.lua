local job, inService, isHandcuffed, isPrimeTime, isNightTime = 'unemployed', false, false, false, false

function isPed(type)
    local data = false

    if type == 'job' then
        data = job
    end

    if type == 'service' then
        data = inService
    end

    if type == 'handcuffed' then
        data = isHandcuffed
    end

    if type == 'primetime' then
        data = isPrimeTime
    end

    if type == 'nighttime' then
        data = isNightTime
    end

    return data
end

AddEventHandler('crp-userinfo:isPolice', function(callback)
    if job == 'police' and inService then
        callback(true)
    else
        callback(false)
    end
end)

AddEventHandler('crp-userinfo:isMedic', function(callback)
    if job == 'medic' and inService then
        callback(true)
    else
        callback(false)
    end
end)

AddEventHandler('crp-userinfo:updateJob', function(_job)
    job = _job
end)

AddEventHandler('crp-userinfo:updateCuffs', function(state)
    isHandcuffed = state
end)

AddEventHandler('crp-userinfo:setPrimeTime', function(state)
    isPrimeTime = state
end)

AddEventHandler('crp-userinfo:setCurrentTime', function(state)
    isNightTime = state
end)

RegisterNetEvent('crp-userinfo:updateService')
AddEventHandler('crp-userinfo:updateService', function(jobName, status)
    inService = status
end)