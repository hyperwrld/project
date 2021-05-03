local isDoingAction, wasCancelled, canCancelTask, percentage = false, false, false, 0

function setTaskbar(message, time, canCancel, disableShoot)
	if isDoingAction then
		setAlert('Não é possível fazer duas ações ao mesmo tempo.', 'error')

		return false
	end

	isDoingAction, wasCancelled, canCancelTask = true, false, canCancel

	SendNUIMessage({
		app = 'taskbar', event = 'setTaskbar', data = { message = message, time = time }
	})

	while isDoingAction and (disableShoot) do
		Citizen.Wait(0)

		if disableShoot then
			DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing

			DisableControlAction(0, 24, true) -- Disable attack
			DisableControlAction(0, 25, true) -- Disable aim
			DisableControlAction(1, 37, true) -- Disable weapon select
			DisableControlAction(0, 47, true) -- Disable weapon
			DisableControlAction(0, 58, true) -- Disable weapon

			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 263, true) -- Disable melee
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
		end
	end

	if wasCancelled then
		return false, percentage
	end

	return true
end

exports('setTaskbar', setTaskbar)

RegisterNUICallback('finishedTask', function(data, cb)
    isDoingAction, wasCancelled = false, false

    cb(true)
end)

RegisterNUICallback('canceledTask', function(data, cb)
    isDoingAction, wasCancelled, percentage = false, true, data

    cb(true)
end)

function cancelTask()
	if canCancelTask then
		SendNUIMessage({
			app = 'taskbar', event = 'stopTaskbar'
		})
	end
end

exports['crp-binds']:RegisterKeybind('taskbar', '[Taskbar] Cancelar ação', 'ESC', cancelTask)