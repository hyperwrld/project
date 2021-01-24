function setMessage(data)
	SendNUIMessage({
		app = 'messages', event = 'setMessage', data = data
	})
end

exports('setMessage', setMessage)