local isAppOpen, events = false, {}

function openApp(appName, data)
	isAppOpen = true

	SetNuiFocus(true, true)
	-- SetNuiFocusKeepInput(true)

	Citizen.CreateThread(function()
        while isAppOpen do
			Citizen.Wait(0)

			DisableAllControlActions(0)
		end
	end)

	SendNUIMessage({
		app = appName, event = 'setData', status = true, eventData = data
	})
end

function closeApp(appName)
	isAppOpen = false

	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)

	SendNUIMessage({
		app = appName, status = false
	})
end

function setAppData(appName, data)
	SendNUIMessage({
		app = appName, event = 'setAppData', eventData = data
	})
end

RegisterNUICallback('closeMenu', function(data, cb)
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)

	TriggerEvent('crp-ui:closedMenu', data.appName, data)

	Citizen.Wait(300)

	isAppOpen = false

    cb(true)
end)

function RegisterUIEvent(name)
	if not events[name] then
		events[name] = true

		RegisterNUICallback(name, function(...)
			TriggerEvent(('crp-ui:%s'):format(name), ...)
		end)
	end
end

Citizen.CreateThread(function()
	TriggerEvent('crp-ui:isReady')
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end

	isAppOpen = false

	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
end)

exports('openApp', openApp)
exports('closeApp', closeApp)
exports('setAppData', setAppData)

exports('RegisterUIEvent', RegisterUIEvent)
exports('SendUIMessage', SendNUIMessage)