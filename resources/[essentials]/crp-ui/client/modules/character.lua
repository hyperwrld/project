function updateData(data)
	SendNUIMessage({
		app = 'skincreator', event = 'updateData', data = data
	})
end

exports('updateData', updateData)