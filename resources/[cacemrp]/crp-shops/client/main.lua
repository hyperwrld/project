local isInsideZone = false

Citizen.CreateThread(function()
	exports['crp-lib']:createCircleZones(shops, 0.6, true, 'shopsZone', GetCurrentResourceName())
end)

AddEventHandler('crp-shops:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		ListenForKeys(zone.data)

		exports['crp-ui']:toggleInteraction(true, '[E] para abrir a loja')
	else
		exports['crp-ui']:toggleInteraction(false)
	end

	isInsideZone = isPointInside
end)

function ListenForKeys(type)
	Citizen.CreateThread(function()
		while isInsideZone do
			Citizen.Wait(0)

			if IsControlJustReleased(0, 38) then
				TriggerEvent('crp-inventory:openShop', type)
			end
		end
	end)
end