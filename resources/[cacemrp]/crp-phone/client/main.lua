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
		eventName = 'phone/setData', eventData = data
	})
end)

RegisterNetEvent('crp-phone:receiveMessage')
AddEventHandler('crp-phone:receiveMessage', function(data)
	SendUiMessage({
		eventName = 'phone/receiveMessage', eventData = data
	})
end)

RegisterNetEvent('crp-phone:receiveTweet')
AddEventHandler('crp-phone:receiveTweet', function(data)
	SendUiMessage({
		eventName = 'phone/receiveTweet', eventData = data
	})
end)