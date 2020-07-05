local isMenuOpen = false

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

AddEventHandler('crp-ui:registerNuiCallback', function(name, func)
    RegisterNUICallback(name, func)
end)