local isInsideZone, storePed, isRobbing = false, 0, false

exports['crp-lib']:createBoxZones({
	{ coords = vector4(-161.76, -302.12, 39.73, 341), length = 3.8, width = 3.2, minZ = 38.73, maxZ = 40.73, data = { name = 'normal' } }
}, 'robberyZone', GetCurrentResourceName() .. ':robbery')

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

		SetPedCombatAttributes(storePed, 46, true)
		SetPedFleeAttributes(storePed, 0, false)
		SetBlockingOfNonTemporaryEvents(storePed, true)
	end

	Citizen.CreateThread(function()
		while isInsideZone do
			Citizen.Wait(50)

			local isAiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

			if isAiming and entity == storePed then
				initializeStoreRobbery()
				break
			end
		end
	end)
end

function initializeStoreRobbery()
	if IsPedDeadOrDying(storePed) then
		return
	end

	isRobbing = true

	NetworkRequestControlOfEntity(storePed)

	TaskPlayAnimation(storePed, 'missheist_agency2ahands_up', 'handsup_anxious', 1.0, -1.0, 1.0, 11, 0)

	Citizen.Wait(2000)

	if IsPedDeadOrDying(storePed) then
		return
	end

	local cashRegister = GetClosestObjectOfType(GetEntityCoords(storePed), 2.5, 303280717, false)

	if not DoesEntityExist(cashRegister) then
		return
    end

    ClearPedTasksImmediately(PlayerPedId())

	LoadDictionary('mp_am_hold_up')

    NetworkRequestControlOfEntity(cashRegister)

	local sceneCoords, sceneRotation = GetEntityCoords(cashRegister) - vector3(0.0, 0.0, 0.1), GetEntityRotation(cashRegister) + vector3(0.0, 0.0, -180.0)
	local scene = NetworkCreateSynchronisedScene(sceneCoords, sceneRotation, 2, false, true, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(storePed, scene, 'mp_am_hold_up', 'holdup_victim_20s', 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(cashRegister, scene, 'mp_am_hold_up', 'holdup_victim_20s_till', 4.0, -8.0, 1)

	NetworkStartSynchronisedScene(scene)

	-- Give Money

	print(cashRegister)
end