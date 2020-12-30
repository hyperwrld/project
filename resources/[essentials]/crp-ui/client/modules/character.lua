function updateData(data)
	SendNUIMessage({
		app = 'skincreator', event = 'updateData', eventData = data
	})
end

exports('updateData', updateData)