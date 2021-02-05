local garages = {
	{ coords = vector3(468.9, -974.83, 26.27), radius = 0.50, isPublic = false, spawns = {} },
	{ coords = vector3(275.637, -344.797, 45.173), radius = 0.50, isPublic = true, spawns = {} },
}

Citizen.CreateThread(function()
	for k, garage in pairs(garages) do
		if garage.isPublic then
			exports['crp-base']:createBlip('garage' .. k, garage.coords, 357, 3, 0.75, 'Garagem')
		end
	end

	exports['crp-lib']:createCircleZones(garages, 0.6, true, 'garageZone', GetCurrentResourceName())
end)

AddEventHandler('crp-garage:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		ListenForKeys(zone.data)

		exports['crp-ui']:toggleInteraction(true, '[E] abrir a garagem')
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
				exports['crp-ui']:openApp('garage')
			end
		end
	end)
end