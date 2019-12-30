local isDoingAction, wasCancelled = false, false

-- * How to use the progress bar

--  exports['crp-progressbar']:StartProgressBar({ duration = 2000, label = 'A colocar o cartão' }, function(finished)
--     if finished then
--         print('crl')
--     end
-- end)

function StartProgressBar(action, callback)
    if not isDoingAction then
        if action.cancel == nil then action.cancel = false end
        if action.move == nil then action.move = false end
        if action.combat == nil then action.combat = false end
        if action.vehicle == nil then action.vehicle = false end

        isDoingAction, wasCancelled = true, false

        SendNUIMessage({ action = 'start', duration = action.duration, label = action.label })

        Citizen.CreateThread(function()
            while isDoingAction do
                Citizen.Wait(1)

                if IsControlJustPressed(0, 200) and action.cancel then
                    CancelAction()
                end

                if action.move then         
                    DisableControlAction(0, 30, true)
                    DisableControlAction(0, 31, true)
                    DisableControlAction(0, 36, true)
                    DisableControlAction(0, 21, true)
                end

                if action.combat then
                    DisablePlayerFiring(PlayerId(), true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(1, 37, true)
                    DisableControlAction(0, 47, true)
                    DisableControlAction(0, 58, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 143, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 264, true)
                    DisableControlAction(0, 257, true)
                end

                if action.vehicle then
                    DisablePlayerFiring(PlayerId(), true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(1, 37, true)
                    DisableControlAction(0, 47, true)
                    DisableControlAction(0, 58, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 143, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 264, true)
                    DisableControlAction(0, 257, true)
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