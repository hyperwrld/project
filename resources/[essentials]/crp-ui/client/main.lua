local isMenuOpen = false

AddEventHandler('crp-ui:openMenu', function(menuType)
    isMenuOpen = true

    SendNUIMessage({ eventName = 'toggleMenu', status = true, component = menuType })
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

    SendNUIMessage({ eventName = 'closeMenu' })

	EnableAllControlActions(0)
	TaskSetBlockingOfNonTemporaryEvents(GetPlayerPed(-1), false)
	SetNuiFocus(false, false)
end