local isDoingAction, wasCancelled = false, false

-- * How to use the progress bar

--  exports['crp-progressbar']:StartProgressBar({ duration = 2000, label = 'A colocar o cartão' }, function(finished)
--     if finished then
--         print('crl')
--     end
-- end)

function StartProgressBar(action, callback)
    if not isDoingAction then
        isDoingAction, wasCancelled = true, false

        SendNUIMessage({ action = 'start', duration = action.duration, label = action.label })

        Citizen.CreateThread(function()
            while isDoingAction do
                Citizen.Wait(1)

                if IsControlJustPressed(0, 200) then
                    CancelAction()
                end
            end

            if wasCancelled then
                callback(false)
            else callback(true) end
        end)
    else
        callback(false)

        exports['crp-notifications']:SendAlert('error', 'Não é possível fazer duas ações ao mesmo tempo.', 2000)
    end
end

RegisterNUICallback('finish', function(data, cb)
	isDoingAction, wasCancelled = false, false
end)

function CancelAction()
    isDoingAction, wasCancelled = false, true

    SendNUIMessage({ action = 'cancel' })
end