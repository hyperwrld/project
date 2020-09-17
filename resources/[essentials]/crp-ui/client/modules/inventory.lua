function addQueue(identifier, quantity, state)
	SendNUIMessage({
		app = 'inventory', event = 'addQueue', eventData = { itemId = identifier, quantity = quantity, state = state }
	})
end

function toggleAction(status, items)
	SendNUIMessage({
		app = 'inventory', event = 'setActionData', eventData = { status = status, items = items }
	})
end

exports('addQueue', addQueue)
exports('toggleAction', toggleAction)