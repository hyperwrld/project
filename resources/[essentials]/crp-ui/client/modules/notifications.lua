function setAlert(text, type, time)
	SendNUIMessage({
		app = 'notifications', event = 'setAlert', eventData = { text = text, type = type, time = time }
	})
end

function setCustomAlert(action, id, text, type)
	SendNUIMessage({
		app = 'notifications', event = 'setCustomAlert', eventData = { action = action, id = id, text = text, type = type }
	})
end

exports('setAlert', setAlert)
exports('setCustomAlert', setCustomAlert)