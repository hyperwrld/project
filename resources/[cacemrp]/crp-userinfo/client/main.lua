local job, inService, isHandcuffed = 'unemployed', false, false

AddEventHandler('crp-userinfo:updateJob', function(_job)
    job = _job
end)

AddEventHandler('crp-userinfo:updateCuffs', function(state)
    isHandcuffed = state
end)

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

    return data
end