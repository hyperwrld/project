local isDoingAction, wasCancelled, percentage = false, false, 0

RegisterNetEvent('crp-ui:setTaskbar')
AddEventHandler('crp-ui:setTaskbar', function(data, callback)
    if not isDoingAction then
        isDoingAction, wasCancelled = true, false

        SendNUIMessage({ eventName = 'setTaskbar', taskbarData = { text = data.text, time = data.time }})

        Citizen.CreateThread(function()
            while isDoingAction do
                Citizen.Wait(0)

                if IsControlJustPressed(0, 200) and not data.cancel then
                    SendNUIMessage({ eventName = 'stopTaskbar' })
                end
            end

            if wasCancelled then
                callback({ status = false, percentage = percentage })
            else callback({ status = true }) end
        end)
    else
        callback({ status = false })

        TriggerEvent('crp-ui:setAlert', { text = 'Não é possível fazer duas ações ao mesmo tempo.', type = 'error' })
    end
end)

RegisterNUICallback('finishedTask', function(data, cb)
    isDoingAction, wasCancelled = false, false

    cb(true)
end)

RegisterNUICallback('canceledTask', function(data, cb)
    isDoingAction, wasCancelled, percentage = false, true, data

    cb(true)
end)