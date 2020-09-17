local isDoingAction, wasCancelled, percentage = false, false, 0

function setTaskbar(text, type, time, canCancel)
	if isDoingAction then
		setAlert('Não é possível fazer duas ações ao mesmo tempo.', 'error')

		return false
	end

	isDoingAction, wasCancelled = true, false

	SendNUIMessage({
		app = 'taskbar', event = 'setTaskbar', eventData = { text = text, type = type, time = time }
	})

	while isDoingAction do
		Citizen.Wait(0)

		if IsControlJustPressed(0, 200) and canCancel then
			SendNUIMessage({
				app = 'taskbar', event = 'stopTaskbar'
			})
		end
	end

	if wasCancelled then
		return false, percentage
	end

	return true
end

RegisterNUICallback('finishedTask', function(data, cb)
    isDoingAction, wasCancelled = false, false

    cb(true)
end)

RegisterNUICallback('canceledTask', function(data, cb)
    isDoingAction, wasCancelled, percentage = false, true, data

    cb(true)
end)

exports('setTaskbar', setTaskbar)