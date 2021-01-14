local isAppOpen, events = false, {}

function openApp(appName, data, hasFocus, hasCursor, canDisable)
	isAppOpen = true

	if hasFocus == nil then
		hasFocus = true
	end

	if hasCursor == nil then
		hasCursor = true
	end

	SetNuiFocus(hasFocus, hasCursor)

	if canDisable then
		Citizen.CreateThread(function()
			while isAppOpen do
				Citizen.Wait(0)

				DisableAllControlActions(0)
			end
		end)
	end

	SendNUIMessage({
		app = appName, event = 'setData', state = true, data = data
	})
end

exports('openApp', openApp)

function closeApp(appName)
	isAppOpen = false

	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)

	SendNUIMessage({
		app = appName, state = false
	})
end

exports('closeApp', closeApp)

function setAppData(appName, data)
	SendNUIMessage({
		app = appName, event = 'setData', data = data
	})
end

exports('setAppData', setAppData)

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

exports('SendUIMessage', SendNUIMessage)
exports('RegisterUIEvent', RegisterUIEvent)

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