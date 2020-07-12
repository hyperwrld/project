local isMenuOpen, isReady = false, false

AddEventHandler('crp-ui:openMenu', function(menuType, data)
    isMenuOpen = true

    SendNUIMessage({ eventName = 'toggleMenu', status = true, component = menuType, menuData = data })

    SetNuiFocus(true, true)

    Citizen.CreateThread(function()
        while isMenuOpen do
			Citizen.Wait(0)

			HideHudAndRadarThisFrame()
			DisableAllControlActions(0)
		end
    end)
end)

AddEventHandler('crp-ui:closeMenu', function()
    closeMenu(true)
end)

function closeMenu(state)
    isMenuOpen = false

    if state then
        SendNUIMessage({ eventName = 'toggleMenu', status = false })
    end

	EnableAllControlActions(0)
	SetNuiFocus(false, false)
end

RegisterNUICallback('closeMenu', function(moveData, cb)
    closeMenu(false)

    cb(true)
end)

exports('isNuiCallbackReady', function()
    return isReady
end)

function RegisterNuiCallback()
    AddEventHandler('crp-ui:registerNuiCallback', function(name, func)
        RegisterNUICallback(name, func)
    end)

    isReady = true
end

RegisterNuiCallback()

AddEventHandler('crp-ui:sendNuiMessage', function(data)
    SendNUIMessage(data)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == 'crp-ui' then
        SetNuiFocus(false, false)
    end
end)