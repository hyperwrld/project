local containers = {
	684586828, 218085040, 666561306, -58485588, -206690185, 1511880420, 682791951, 577432224, 364445978
}

function searchContainers(playerPed, coords)
	local rayHandle = StartShapeTestRay(coords, GetOffsetFromEntityInWorldCoords(playerPed, 0, 2.5, -0.4), 16, playerPed, 0)
	local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
	local entityModel = GetEntityModel(entityHit)

	if entityModel ~= 0 then
		for i = 1, #containers, 1 do
			if containers[i] == entityModel then
				return true, GetEntityCoords(entityHit)
			end
		end
	end

	return false
end

function GetVehicleInFront(playerPed, coords)
    local rayHandle = StartShapeTestRay(coords, GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, 0.0), 10, playerPed, 0)
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    return entityHit
end

function searchDropInventories(coords)
	local currentName, currentDistance, currentCoords

	for i = 1, #dropInventories, 1 do
		local distance = #(coords - dropInventories[i].coords)

		if distance <= 2.0 and (currentName == nil or currentDistance < distance) then
			currentName, currentDistance = dropInventories[i].name, distance
			currentCoords = dropInventories[i].coords
		end
	end

	if currentName == nil then
		currentName, currentCoords = 'drop-' .. GetRandomNumber(10000, 99999), coords

		while doesInventoryExist(currentName) do
			currentName = 'drop-' .. GetRandomNumber(10000, 99999)
		end
	end

	Debug('[Drop] Found/Created a drop inventory.')

	return currentName, currentCoords
end

function doesInventoryExist(name)
	for i = 1, #dropInventories, 1 do
        if dropInventories[i].name == name then
            return true
        end
    end

    return false
end

function holsterWeapon(weaponName)
	local playerPed = PlayerPedId()
	local dictionary, animation, inSpeed, outSpeed = 'reaction@intimidation@1h', 'outro', 1.0, 1.0
	-- local job = exports['crp-userinfo']:isPed('job')

	-- if job == 'police' then
	-- 	dictionary, animation = 'reaction@intimidation@cop@unarmed', 'outro'
	-- end

	PlayAnimation(dictionary, animation, inSpeed, outSpeed)

	Citizen.Wait((GetAnimDuration(dictionary, animation) * 1000) - 2200)

	SetCurrentPedWeapon(playerPed, GetHashKey('weapon_unarmed'), 1)

	exports['crp-ui']:addQueue(weaponName, 1, false)

    Citizen.Wait(300)

	RemoveAllPedWeapons(playerPed)
    ClearPedTasks(playerPed)

    isDoingAnimation, isWeaponEquiped = false, false
end

function equipWeapon(weaponData, weaponAmmo)
	local playerPed = PlayerPedId()
	local dictionary, animation = 'reaction@intimidation@1h', 'intro'
	-- local job = exports['crp-userinfo']:isPed('job')

	-- if job == 'police' then
	-- 	dictionary, animation = 'reaction@intimidation@cop@unarmed', 'intro'
	-- end

	RemoveAllPedWeapons(playerPed)
	PlayAnimation(dictionary, animation, 1.0, 1.0)

	Citizen.Wait(900)

	GiveWeaponToPed(playerPed, weaponData.hash, weaponAmmo, 0, 1)
	SetCurrentPedWeapon(playerPed, weaponData.hash, 1)

	if weaponData.hash == GetHashKey('WEAPON_CARBINERIFLE_MK2') then
		GiveWeaponComponentToPed(playerPed, weaponData.hash, GetHashKey('COMPONENT_AT_AR_AFGRIP_02'))
		GiveWeaponComponentToPed(playerPed, weaponData.hash, GetHashKey('COMPONENT_AT_AR_FLSH'))
		GiveWeaponComponentToPed(playerPed, weaponData.hash, GetHashKey('COMPONENT_AT_CR_BARREL_02'))
		GiveWeaponComponentToPed(playerPed, weaponData.hash, GetHashKey('COMPONENT_AT_MUZZLE_06'))
		GiveWeaponComponentToPed(playerPed, weaponData.hash, GetHashKey('COMPONENT_AT_SIGHTS'))
		GiveWeaponComponentToPed(playerPed, weaponData.hash, GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER'))
	end

	if weaponData.hash == GetHashKey('WEAPON_COMBATPISTOL') then
		GiveWeaponComponentToPed(playerPed, weaponData.hash, GetHashKey('COMPONENT_AT_PI_FLSH'))
	end

	exports['crp-ui']:addQueue(weaponData.identifier, 1, true)

    Citizen.Wait(300)

    ClearPedTasks(playerPed)

    isDoingAnimation = false
end

function PlayAnimation(dictionary, animation, inSpeed, outSpeed)
	local playerPed = PlayerPedId()

    while (not HasAnimDictLoaded(dictionary)) do
        RequestAnimDict(dictionary)

        Citizen.Wait(0)
	end

	isDoingAnimation = true

	Citizen.CreateThread(function()
		while isDoingAnimation do
			Citizen.Wait(0)

            DisablePlayerFiring(playerPed, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 142, true)
		end
	end)

	TaskPlayAnim(playerPed, dictionary, animation, inSpeed, outSpeed, -1, 50, 0, 0, 0, 0)
end