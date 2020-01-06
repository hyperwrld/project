RegisterNetEvent('crp-jobmanager:updateJob')
AddEventHandler('crp-jobmanager:updateJob', function(job, name, notify)
    local user = exports['crp-base']:getModule('LocalPlayer')

    user.setVar('job', job)

    if notify then
        local text = 'Trabalho: ' .. name .. '.'

        if job == 'unemployed' then
            text = 'Estás desempregado.'
        end

        exports['crp-notifications']:SendAlert('inform', text, 3500)
    end

    if job == 'unemployed' then
        local playerPed = GetPlayerPed(-1)

		SetPedRelationshipGroupDefaultHash(playerPed, GetHashKey('PLAYER'))
        SetPoliceIgnorePlayer(playerPed, false)
    end

    TriggerEvent('crp-userinfo:updateJob', job)
end)