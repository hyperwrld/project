function updateMinimap(x, y)
	SendNUIMessage({
		app = 'hud', event = 'setMinimap', data = { x = x, y = y }
	})
end

function setHudHideState(state)
	SendNUIMessage({
		app = 'hud', event = 'setHudHideState', data = state
	})
end

function setData(data)
	SendNUIMessage({
		app = 'hud', event = 'setData', data = data
	})
end

function toggleInteraction(state, firstMessage, secondMessage)
	SendNUIMessage({
		app = 'interactions', event = 'setInteractionsData', data = { state = state, firstMessage = firstMessage, secondMessage = secondMessage }
	})
end

function setAlert(text, type, time)
	SendNUIMessage({
		app = 'notifications', event = 'setAlert', data = { text = text, type = type, time = time }
	})
end

function setCustomAlert(action, id, text, type)
	SendNUIMessage({
		app = 'notifications', event = 'setCustomAlert', data = { action = action, id = id, text = text, type = type }
	})
end

function triggerSound(soundName, volume)
	SendNUIMessage({
		app = 'sound', event = 'playSound', data = { soundName = soundName, volume = volume }
	})
end

exports('updateMinimap', updateMinimap)
exports('setHudHideState', setHudHideState)
exports('setData', setData)

exports('toggleInteraction', toggleInteraction)
exports('setAlert', setAlert)
exports('setCustomAlert', setCustomAlert)

exports('triggerSound', triggerSound)
exports('toggleTarget', toggleTarget)