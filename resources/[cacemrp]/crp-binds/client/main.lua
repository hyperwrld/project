local canExecute = false

AddEventHandler('crp-binds:canExecute', function(state)
	canExecute = state
end)

function RegisterKeybind(name, category, description, key, downCommand, upCommand)
	if not name or not category or not description then
		return Debug("A parameter wasn't provied in the creating of this bind.")
	end

	local text = ('[%s] %s'):format(category, description)
	local stringDown = ('+cmd_%s'):format(downCommand)

	RegisterCommand(stringDown, function()
		if not canExecute then return end

		ExecuteCommand(downCommand)
	end)

	TriggerEvent('chat:removeSuggestion', stringDown)

	local stringUp = ('-cmd_%s'):format(upCommand)

	RegisterCommand(stringUp, function()
		if not canExecute then return end

		ExecuteCommand(upCommand)
	end)

	TriggerEvent('chat:removeSuggestion', stringUp)

	RegisterKeyMapping(stringDown, text, 'keyboard', key)
end

exports('RegisterKeybind', RegisterKeybind)