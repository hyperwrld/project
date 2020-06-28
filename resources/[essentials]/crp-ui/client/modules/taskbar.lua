local isDoingAction, wasCancelled = false, false

RegisterNetEvent('crp-ui:setTaskbar')
AddEventHandler('crp-ui:setTaskbar', function(action, callback)
    if not isDoingAction then
        isDoingAction, wasCancelled = true, false

        SendNUIMessage({ eventName = 'setTaskbar', text = action.text, time = action.time })

        Citizen.CreateThread(function()
            while isDoingAction do
                Citizen.Wait(0)

                if IsControlJustPressed(0, 200) and action.cancel then
                    isDoingAction, wasCancelled = false, true

                    SendNUIMessage({ eventName = 'stopTaskbar' })
                end
            end

            if wasCancelled then
                callback(false)
            else callback(true) end
        end)
    else
        callback(false)

        TriggerEvent('crp-ui:setAlert', { text = 'Não é possível fazer duas ações ao mesmo tempo.', type = 'error' })
    end
end)

RegisterNUICallback('finishedTask', function(cb)
    isDoingAction, wasCancelled = false, false

    cb(true)
end)