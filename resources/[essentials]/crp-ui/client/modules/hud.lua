function setCharacterData(data)
	SendNUIMessage({
		app = 'hud', event = 'setCharacterData', eventData = data
	})
end

function updateMinimap(x, y)
	SendNUIMessage({
		app = 'hud', event = 'setMinimap', eventData = { x = x, y = y }
	})
end

function setCompassDirection(direction)
	SendNUIMessage({
		app = 'hud', event = 'setCompassDirection', eventData = direction
	})
end

function setVehicleStatus(status)
	SendNUIMessage({
		app = 'hud', event = 'setVehicleStatus', eventData = status
	})
end

function setVehicleData(location, speed, fuel, time)
	SendNUIMessage({
		app = 'hud', event = 'setVehicleData', eventData = { location = location, speed = speed, fuel = fuel, time = time }
	})
end

function showInteraction(message)
	SendNUIMessage({
		app = 'hud', event = 'setInteractionData', eventData = { status = true, message = message }
	})
end

function hideInteraction()
	SendNUIMessage({
		app = 'hud', event = 'setInteractionData', eventData = { status = false }
	})
end

exports('updateMinimap', updateMinimap)
exports('setCharacterData', setCharacterData)

exports('setCompassDirection', setCompassDirection)
exports('setVehicleStatus', setVehicleStatus)
exports('setVehicleData', setVehicleData)

exports('showInteraction', showInteraction)
exports('hideInteraction', hideInteraction)