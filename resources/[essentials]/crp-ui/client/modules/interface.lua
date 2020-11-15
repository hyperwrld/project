function updateMinimap(x, y)
	SendNUIMessage({
		app = 'hud', event = 'setMinimapData', eventData = { x = x, y = y }
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

function setCurrencyHudStatus(data)
	SendNUIMessage({
		app = 'hud', event = 'setCurrencyHudStatus', eventData = data
	})
end

function setCurrentMoney(currentMoney)
	SendNUIMessage({
		app = 'hud', event = 'setCurrentMoney', eventData = currentMoney
	})
end

function addMoney(quantity)
	SendNUIMessage({
		app = 'hud', event = 'addMoney', eventData = quantity
	})
end

function removeMoney(quantity)
	SendNUIMessage({
		app = 'hud', event = 'removeMoney', eventData = quantity
	})
end

function toggleInteraction(status, message)
	SendNUIMessage({
		app = 'hud', event = 'setInteractionData', eventData = { status = status, message = message }
	})
end

exports('updateMinimap', updateMinimap)
exports('setCharacterData', setCharacterData)

exports('setHudData', setHudData)
exports('setVehicleHudData', setVehicleHudData)

RegisterNetEvent('crp-ui:setCurrencyHudStatus')
AddEventHandler('crp-ui:setCurrencyHudStatus', setCurrencyHudStatus)

RegisterNetEvent('crp-ui:setCurrentMoney')
AddEventHandler('crp-ui:setCurrentMoney', setCurrentMoney)

RegisterNetEvent('crp-ui:addMoney')
AddEventHandler('crp-ui:addMoney', addMoney)

RegisterNetEvent('crp-ui:removeMoney')
AddEventHandler('crp-ui:removeMoney', removeMoney)

exports('toggleInteraction', toggleInteraction)