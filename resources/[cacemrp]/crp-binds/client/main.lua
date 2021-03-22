local keybinds = {}

function RegisterKeybind(name, description, key, func)
	RegisterCommand(name, function(source, args)
        func()
    end, false)

    RegisterKeyMapping(name, description, 'keyboard', key)
	TriggerEvent('chat:removeSuggestion', '/' .. name)
end

exports('RegisterKeybind', RegisterKeybind)

function RegisterHoldKeybind(name, description, key, func, delay)
	RegisterCommand('+' .. name, function(source, args)
		if not keybinds[name] then
			func(true)
		end
    end, false)

	RegisterCommand('-' .. name, function(source, args)
        keybinds[name] = true

		func(false)

		Citizen.Wait(delay)

		keybinds[name] = false
    end, false)

	RegisterKeyMapping('+' .. name, description, 'keyboard', key)
	TriggerEvent('chat:removeSuggestion', '/+' .. name)
	TriggerEvent('chat:removeSuggestion', '/-' .. name)
end

exports('RegisterHoldKeybind', RegisterHoldKeybind)