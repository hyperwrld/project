local job, inService = 'unemployed', false

AddEventHandler('crp-userinfo:updateJob', function(_job)
    job = _job
end)

function isPed(type)
    local data = false

    if type == 'job' then
        data = job
    end

    if type == 'service' then
        data = inService
    end

    return data
end