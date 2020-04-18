local robberyHouses = {
    [1] = { x = 1, y = 1, z = 1, name = '' }
}

local isOpen = false

RegisterNetEvent('crp-houserobbery:startLockpick')
AddEventHandler('crp-houserobbery:startLockpick', function()
    isOpen = true

    SendNUIMessage({ eventName = 'show' })

	SetNuiFocus(true, true)

	Citizen.CreateThread(function()
		while isOpen do
			Citizen.Wait(0)

			DisableAllControlActions(0)
		end
	end)
end)


local function nuiCallBack(data, cb)
	local events = exports['crp-base']:getModule('Events')

    isOpen = false

    EnableAllControlActions(0)
    SetNuiFocus(false, false)

    if data.open then

    end

    if data.remove then

    end

    -- remove item
end

RegisterNUICallback('nuiMessage', nuiCallBack)

RegisterCommand('testee', function(source, args)
    TriggerEvent('crp-houserobbery:startLockpick')
end, false)