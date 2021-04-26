local isInsideZone, banks = false, {}

exports['crp-lib']:createBoxZones({
	{ coords = vector4(149.23, -1040.42, 29.37, 340),  length = 0.7,  width = 2.8, minZ = 25.57,  maxZ = 29.57,  data = 1 },
	{ coords = vector4(313.57, -278.88, 54.16, 340),   length = 0.7,  width = 2.8, minZ = 50.36,  maxZ = 54.36,  data = 2 },
	{ coords = vector4(-351.57, -49.64, 49.04, 340),   length = 0.7,  width = 2.8, minZ = 45.24,  maxZ = 49.24,  data = 3 },
	{ coords = vector4(-1213.28, -331.08, 37.79, 297), length = 2.8,  width = 0.7, minZ = 33.99,  maxZ = 37.99,  data = 4 },
	{ coords = vector4(247.48, 223.16, 106.29, 340),   length = 0.65, width = 3.2, minZ = 102.29, maxZ = 106.29, data = 5 },
	{ coords = vector4(-2962.59, 482.29, 15.7, 358),   length = 2.8,  width = 0.7, minZ = 11.9,   maxZ = 15.9,   data = 6 },
	{ coords = vector4(1175.77, 2706.79, 38.09, 0),    length = 0.7,  width = 2.8, minZ = 34.29,  maxZ = 38.29,  data = 7 },
	{ coords = vector4(-112.05, 6469.08, 31.63, 315),  length = 0.65, width = 4.4, minZ = 27.83,  maxZ = 31.83,  data = 8 },
}, 'bankZones', GetCurrentResourceName(), false)

AddEventHandler('crp-banking:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		if not banks[zone.data] then
			ListenForInput()
		end

		exports['crp-ui']:toggleInteraction(true, ('%s'):format(not banks[zone.data] and '[E] para usar o banco' or 'Este banco está fechado'))
	else
		exports['crp-ui']:toggleInteraction(false)
	end

	isInsideZone = isPointInside
end)

AddEventHandler('crp-banking:openBank', function(type)
	local success, characterId, accounts, transactions = RPC:execute('fetchBank')

	if success then
		exports['crp-ui']:openApp('banking', {
			type = type, characterId = characterId,
			accounts = accounts, transactions = transactions
		})
	end
end)

function ListenForInput(bankId)
	Citizen.CreateThread(function()
		while isInsideZone do
			Citizen.Wait(0)

			if IsControlJustReleased(0, 38) then
				TriggerEvent('crp-banking:openBank', 1)
			end
		end
	end)
end