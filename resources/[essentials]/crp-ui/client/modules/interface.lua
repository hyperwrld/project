function updateMinimap(x, y)
	SendNUIMessage({
		app = 'hud', event = 'setMinimapData', eventData = { x = x, y = y }
	})
end

function setHudHideState(state)
	SendNUIMessage({
		app = 'hud', event = 'setHudHideState', eventData = state
	})
end

function setCharacterData(data)
	SendNUIMessage({
		app = 'hud', event = 'setCharacterData', eventData = data
	})
end

function setHudData(name, value)
	SendNUIMessage({
		app = 'hud', event = 'setHudData', eventData = { name = name, value = value }
	})
end

function setVehicleHudData(location, speed, fuel, time)
	SendNUIMessage({
		app = 'hud', event = 'setVehicleHudData', eventData = { location = location, speed = speed, fuel = fuel, time = time }
	})
end

function toggleInteraction(status, firstMessage, secondMessage)
	SendNUIMessage({
		app = 'interactions', event = 'setInteractionsData', eventData = { status = status, firstMessage = firstMessage, secondMessage = secondMessage }
	})
end

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

exports('updateMinimap', updateMinimap)
exports('setHudHideState', setHudHideState)
exports('setCharacterData', setCharacterData)

exports('setHudData', setHudData)
exports('setVehicleHudData', setVehicleHudData)

exports('toggleInteraction', toggleInteraction)
exports('setAlert', setAlert)
exports('setCustomAlert', setCustomAlert)