function toggleAction(status, items)
	SendNUIMessage({
		app = 'inventory', event = 'setActionData', eventData = { status = status, items = items }
	})
end

exports('toggleAction', toggleAction)