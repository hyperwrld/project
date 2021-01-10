function updateData(data)
	SendNUIMessage({
		app = 'skincreator', event = 'updateData', data = data
	})
end

function setItems(data)
	SendNUIMessage({
		app = 'inventory', event = 'setItems', data = data
	})
end

function addQueue(identifier, quantity, state)
	SendNUIMessage({
		app = 'inventory', event = 'addQueue', data = { itemId = identifier, quantity = quantity, state = state }
	})
end

exports('setItems', setItems)
exports('updateData', updateData)
exports('addQueue', addQueue)