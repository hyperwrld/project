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

exports('setItems', setItems)
exports('updateData', updateData)