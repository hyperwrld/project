local isInsideZone = false

Citizen.CreateThread(function()
	for k, shop in pairs(shops) do
		if shop.isPublic then
			exports['crp-base']:createBlip('shop' .. k, shop.coords, 52, 2, 0.75, 'Loja')
		end
	end

	exports['crp-lib']:createCircleZones(shops, 0.6, true, 'shopsZone', GetCurrentResourceName())
end)

AddEventHandler('crp-shops:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		ListenForKeys(zone.data)

		exports['crp-ui']:toggleInteraction(true, '[E] abrir a loja')
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