Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

		if IsControlJustReleased(0, 170) then
			TriggerEvent('crp-ui:openMenu', 'phone')
        end
    end
end)

function RegisterUiCallback(name, func)
    TriggerEvent('crp-ui:registerNuiCallback', name, func)
end

function SendUiMessage(data)
    TriggerEvent('crp-ui:sendNuiMessage', data)
end

RegisterNetEvent('crp-phone:updatePhone')
AddEventHandler('crp-phone:updatePhone', function(data)
	SendUiMessage({
		eventName = 'updatePhone',
		phoneData = data
	})
end)

RegisterNetEvent('crp-phone:receiveMessage')
AddEventHandler('crp-phone:receiveMessage', function(number, message)
	SendUiMessage({
		eventName = 'receiveMessage',
		number = number,
		message = message
	})
end)