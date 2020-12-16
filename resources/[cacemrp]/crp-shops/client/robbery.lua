local isInsideZone, storePed = false, 0

exports['crp-lib']:createZones(2, {
	{ coords = vector3(26.43, -1345.34, 29.5),  data = vector4(24.31, -1347.32, 29.49054, 263.16) }
}, 'robberyZone', GetCurrentResourceName() .. ':robbery', true)

AddEventHandler('crp-shops:robbery:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		initializeStore(zone.data)
	else
		local isZoneEmpty = RPC:execute('isZoneEmpty', 'robberyZone')

		if isZoneEmpty then
			DeleteEntity(storePed)
		end
	end

	isInsideZone = isPointInside
end)

function initializeStore(coords)
	local success, foundPed = DoesPedExistInCoords(vector3(coords.x, coords.y, coords.z), 1.0)

	if not success or (IsPedAPlayer(foundPed)) then
		storePed = CreateEntity(1, `mp_m_shopkeep_01`, coords, true, true, 0)

		-- SetPedKeepTask(storePed, true)
		-- SetPedDropsWeaponsWhenDead(storePed, false)
		-- SetPedFleeAttributes(storePed, 0, 0)
		-- SetPedCombatAttributes(storePed, 17, 1)
		-- SetPedSeeingRange(storePed, 0.0)
		-- SetPedHearingRange(storePed, 0.0)
		-- SetPedAlertness(storePed, 0.0)

		SetPedCombatAttributes(storePed, 46, true)
		SetPedFleeAttributes(storePed, 0, 0)
		SetBlockingOfNonTemporaryEvents(storePed, true)
	end

	Citizen.CreateThread(function()
		while isInsideZone do
			Citizen.Wait(50)

			local isAiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

			-- print(isAiming, entity, storePed)
		end
	end)
end