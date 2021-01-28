function setMessage(data)
	SendNUIMessage({
		app = 'messages', event = 'setMessage', data = data
	})
end

function setJobList(data)
	SendNUIMessage({
		app = 'jobs', event = 'setData', data = data
	})
end

function setGroupData(data)
	SendNUIMessage({
		app = 'jobs', event = 'setGroupData', data = data
	})
end

exports('setMessage', setMessage)
exports('setJobList', setJobList)
exports('setGroupData', setGroupData)