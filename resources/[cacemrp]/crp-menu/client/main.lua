local isMenuOpen = false

local function closeMenu()
    isMenuOpen = false

	EnableAllControlActions(0)
    SetNuiFocus(false, false)
end

local function showMenu()
    if isMenuOpen then
        closeMenu()
        return
    end

    SendNUIMessage({
        eventName = 'open',
        isPedInAnyVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
    })

    SetNuiFocus(true, true)

    Citizen.CreateThread(function()
		while isMenuOpen do
			Citizen.Wait(0)

			DisableAllControlActions(0)
		end
	end)
end

local function nuiCallBack(data, cb)
	local events = exports['crp-base']:getModule('Events')

	if data.close then closeMenu() end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, 19) and IsInputDisabled(0) then
            showMenu()
        end
	end
end)

RegisterCommand('nui', function(source, args)
    if tostring(args[1]) == tostring(false) then
        print('ola?')
        SetNuiFocus(false, false)
    else
        print('12333 ')
        SetNuiFocus(true, true)
    end
end, false)