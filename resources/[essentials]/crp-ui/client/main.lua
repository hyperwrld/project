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
			TaskSetBlockingOfNonTemporaryEvents(GetPlayerPed(-1), true)
		end
    end)
end)

AddEventHandler('crp-ui:closeMenu', function()
    closeMenu()
end)

function closeMenu()
    isMenuOpen = false

    SendNUIMessage({ eventName = 'toggleMenu', status = false })

	EnableAllControlActions(0)
	TaskSetBlockingOfNonTemporaryEvents(GetPlayerPed(-1), false)
	SetNuiFocus(false, false)
end

RegisterNUICallback('closeMenu', function(moveData, cb)
    closeMenu()

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