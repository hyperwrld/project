Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

		if IsControlJustReleased(0, 170) then
			TriggerEvent('crp-ui:openMenu', 'phone')
        end
    end
end)

function RegisterUICallback(name, func)
    TriggerEvent('crp-ui:registerNuiCallback', name, func)
end

function SendUIMessage(data)
    TriggerEvent('crp-ui:sendNuiMessage', data)
end

RegisterNetEvent('crp-phone:updatePhone')
AddEventHandler('crp-phone:updatePhone', function(data)
	SendUIMessage({
		eventName = 'phone/setData', eventData = data
	})
end)

RegisterNetEvent('crp-phone:receiveMessage')
AddEventHandler('crp-phone:receiveMessage', function(data)
	SendUIMessage({
		eventName = 'phone/receiveMessage', eventData = data
	})
end)

RegisterNetEvent('crp-phone:receiveTweet')
AddEventHandler('crp-phone:receiveTweet', function(data)
	SendUIMessage({
		app = 'phone', event = 'receiveTweet', eventData = data
	})
end)