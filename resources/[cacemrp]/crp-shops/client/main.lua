local isInsideZone = false

exports['crp-lib']:createCircleZones({
	{ coords = vector3(-48.55, -1757.73, 29.42),  data = 'normal' },
	{ coords = vector3(25.99, -1347.76, 29.5),    data = 'normal' },
	{ coords = vector3(1136.1, -982.85, 46.42),   data = 'normal' },
	{ coords = vector3(-707.64, -914.59, 19.22),  data = 'normal' },
	{ coords = vector3(-1222.42, -906.44, 12.33), data = 'normal' },
	{ coords = vector3(-1488.01, -378.85, 40.16), data = 'normal' },
	{ coords = vector3(1163.39, -323.95, 69.21),  data = 'normal' },
	{ coords = vector3(373.93, 325.72, 103.57),   data = 'normal' },
	{ coords = vector3(2557.69, 382.3, 108.62),   data = 'normal' },
	{ coords = vector3(-2968.18, 391.66, 15.04),  data = 'normal' },
	{ coords = vector3(-3038.98, 586.11, 7.91),   data = 'normal' },
	{ coords = vector3(-1820.6, 792.41, 138.17),  data = 'normal' },
	{ coords = vector3(-3241.65, 1001.47, 12.83), data = 'normal' },
	{ coords = vector3(547.51, 2671.59, 42.16),   data = 'normal' },
	{ coords = vector3(1165.4, 2708.99, 38.16),   data = 'normal' },
	{ coords = vector3(2679.12, 3280.53, 55.24),  data = 'normal' },
	{ coords = vector3(1961.59, 3740.43, 32.34),  data = 'normal' },
	{ coords = vector3(1393.79, 3605.06, 34.98),  data = 'normal' },
	{ coords = vector3(1698.14, 4924.74, 42.06),  data = 'normal' },
	{ coords = vector3(1729.04, 6414.23, 35.04),  data = 'normal' },
}, 'shopsZone', GetCurrentResourceName())

AddEventHandler('crp-shops:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		ListenForKeys(zone.data)

		exports['crp-ui']:showInteraction('[E] para abrir a loja.')
	else
		exports['crp-ui']:hideInteraction()
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