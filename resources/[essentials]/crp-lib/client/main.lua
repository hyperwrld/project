local registeredEvents = {}

function SendUIMessage(data)
	exports['crp-ui']:SendUIMessage(data)
end

function RegisterUICallback(name, cb)
	AddEventHandler(('crp-ui:%s'):format(name), cb)

	registeredEvents[#registeredEvents + 1] = name
end

AddEventHandler('crp-ui:isReady', function()
	for k, name in ipairs(registeredEvents) do
		exports['crp-ui']:RegisterUIEvent(name)
	end
end)