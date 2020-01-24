inventories, isWeaponEquiped, isDoingAnimation, isUsingItem, isInventoryOpen, currentWeapon, weaponSlot = {}, false, false, false, false, nil, nil

function UseItem(slot)
    local events = exports['crp-base']:getModule('Events')

    events:Trigger('crp-inventory:getItem', slot, function(data)
        if data == nil then
            return
        end

        if IsWeaponValid(tonumber(data.name)) then
            if isWeaponEquiped then
                Holster()

                isWeaponEquiped, weaponSlot = true, slot

                unHolster(data)
            else
                isWeaponEquiped, weaponSlot = true, slot

                unHolster(data)
            end
        else
            UseRegularItem(data.name, slot)
        end
    end)
end

function UseRegularItem(item, slot)
    local isDead = exports['crp-userinfo']:isPed('dead')

    if isDead then
        return
    end

    isUsingItem = true

    if isInventoryOpen then
        sendMessage({ event = 'close' })
    end

    if item == '196068078' then
        local playerPed = GetPlayerPed(-1)

        ClearPedSecondaryTask(playerPed)

        LoadAnimation('friends@frl@ig_1')

        TaskPlayAnim(playerPed, 'friends@frl@ig_1', 'drink_lamar', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

        exports['crp-progressbar']:StartProgressBar({ duration = 6000, label = 'Beber', combat = true, cancel = true }, function(finished)
            if finished then
                TriggerEvent('crp-hud:changemeta', { thirst = true })

                TriggerServerEvent('crp-inventory:useItem', item, slot)
            end
            isUsingItem = false
            ClearPedSecondaryTask(playerPed)
        end)
    end

    if item == '129942349' then
        local playerPed = GetPlayerPed(-1)

        ClearPedSecondaryTask(playerPed)

        LoadAnimation('mp_player_inteat@burger')

        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

        exports['crp-progressbar']:StartProgressBar({ duration = 6000, label = 'Comer', combat = true, cancel = true }, function(finished)
            if finished then
                TriggerEvent('crp-hud:changemeta', { hunger = true })

                TriggerServerEvent('crp-inventory:useItem', item, slot)
            end
            isUsingItem = false
            ClearPedSecondaryTask(playerPed)
        end)
    end

    if item == '156805094' then
        local playerPed = GetPlayerPed(-1)

        ClearPedSecondaryTask(playerPed)

        exports['crp-progressbar']:StartProgressBar({ duration = 5000, label = 'Colocar o colete', combat = true, cancel = true }, function(finished)
            if finished then
                SetPedArmour(playerPed, 100)

                TriggerServerEvent('crp-inventory:useItem', item, slot)
            end
            isUsingItem = false
        end)
    end
end

function Holster()
    isDoingAnimation = true

    local dictionary, animation = 'reaction@intimidation@1h', 'outro'
    local job = exports['crp-userinfo']:isPed('job')

    if job == 'police' then
        copHolster()

        Citizen.Wait(600)

        isDoingAnimation, isWeaponEquiped, currentWeapon, weaponSlot = false, false, nil, nil
        return
    end

    local playerPed, animationLength = GetPlayerPed(-1), GetAnimDuration(dictionary, animation) * 1000

    LoadAnimation(dictionary)

    WaitAnimation()

    TaskPlayAnim(playerPed, dictionary, animation, 1.0, 1.0, -1, 50, 0, 0, 0, 0)

    UpdateWeaponAmmo()

    Citizen.Wait(animationLength - 2200)

    SetCurrentPedWeapon(playerPed, GetHashKey('weapon_unarmed'), 1)

    Citizen.Wait(300)

    RemoveAllPedWeapons(playerPed)
    ClearPedTasks(playerPed)

    Citizen.Wait(800)

    isDoingAnimation, isWeaponEquiped, currentWeapon, weaponSlot = false, false, nil, nil
end

function copHolster()
    local dictionary, animation = 'reaction@intimidation@cop@unarmed', 'intro'
    local playerPed = GetPlayerPed(-1)

    LoadAnimation(dictionary)

    WaitAnimation()

    TaskPlayAnim(playerPed, dictionary, animation, 10.0, 2.3, -1, 49, 1, 0, 0, 0)

    UpdateWeaponAmmo()

    Citizen.Wait(600)

    SetCurrentPedWeapon(playerPed, GetHashKey('weapon_unarmed'), 1)

    RemoveAllPedWeapons(playerPed)

	ClearPedTasks(playerPed)
end

function unHolster(weaponInfo)
    isDoingAnimation = true

    local dictionary, animation = 'reaction@intimidation@1h', 'intro'
    local job = exports['crp-userinfo']:isPed('job')

    if job == 'police' then
        copUnHolster(weaponInfo)

        Citizen.Wait(450)

        isDoingAnimation = false
        return
    end

    local playerPed, animationLength = GetPlayerPed(-1), GetAnimDuration(dictionary, animation) * 1000

    RemoveAllPedWeapons(playerPed)

    LoadAnimation(dictionary)

    WaitAnimation()

    TaskPlayAnim(playerPed, dictionary, animation, 1.0, 1.0, -1, 50, 0, 0, 0, 0)

    Citizen.Wait(900)

    GiveWeaponToPed(playerPed, tonumber(weaponInfo.name), tonumber(weaponInfo.meta.ammo), 0, 1)

    SetCurrentPedWeapon(playerPed, tonumber(weaponInfo.name), 1)

    currentWeapon = tonumber(weaponInfo.name)

    Citizen.Wait(500)

    ClearPedTasks(playerPed)

    Citizen.Wait(1000)

    isDoingAnimation = false
end

function copUnHolster(weaponInfo)
    local dictionary, animation = 'reaction@intimidation@cop@unarmed', 'intro'
    local playerPed = GetPlayerPed(-1)

    LoadAnimation(dictionary)

	RemoveAllPedWeapons(playerPed)

	TaskPlayAnim(playerPed, dictionary, animation, 10.0, 2.3, -1, 49, 1, 0, 0, 0)

	Citizen.Wait(600)

    GiveWeaponToPed(playerPed, tonumber(weaponInfo.name), tonumber(weaponInfo.meta.ammo), 0, 1)

    SetCurrentPedWeapon(playerPed, tonumber(weaponInfo.name), 1)

    currentWeapon = tonumber(weaponInfo.name)

    if currentWeapon == GetHashKey('weapon_combatpistol') then
        GiveWeaponComponentToPed(playerPed, currentWeapon, GetHashKey('COMPONENT_AT_PI_FLSH'))
    elseif currentWeapon == GetHashKey('weapon_carbinerifle') then
        GiveWeaponComponentToPed(playerPed, currentWeapon, GetHashKey('COMPONENT_AT_AR_FLSH'))
	    GiveWeaponComponentToPed(playerPed, currentWeapon, GetHashKey('COMPONENT_AT_AR_AFGRIP'))
	    GiveWeaponComponentToPed(playerPed, currentWeapon, GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'))
    end

	ClearPedTasks(playerPed)
end

function WaitAnimation()
    Citizen.CreateThread(function()
        repeat
            Citizen.Wait(0)

            DisablePlayerFiring(GetPlayerPed(-1), true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 142, true)
        until isDoingAnimation == false
    end)
end

function UpdateWeaponAmmo()
    local weaponAmmo = GetAmmoInPedWeapon(GetPlayerPed(-1), currentWeapon)

    TriggerServerEvent('crp-inventory:setWeaponAmmo', currentWeapon, weaponSlot, weaponAmmo)
end

function GetClosestInventory()
	local coords = GetEntityCoords(PlayerPedId())
	local inventory, inventoryDistance, inventoryCoords

	for k, v in pairs(inventories) do
		local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)

		if distance <= 2.0 then
			if inventory == nil then
				inventory = v.name
				inventoryDistance = distance
				inventoryCoords = { x = coords.x, y = coords.y, z = coords.z }
			end

			if inventoryDistance < distance then
				inventory = v.name
				inventoryDistance = distance
				inventoryCoords = { x = coords.x, y = coords.y, z = coords.z }
			end
		end
	end

	if inventory == nil then
		inventory = 'drop-' .. math.random(0, 100000)

		while CheckIfInventoryExists(inventories, inventory) == true do
			inventory = 'drop-' .. math.random(0, 100000)
		end

		inventoryCoords = { x = coords.x, y = coords.y, z = coords.z }

		return inventory, inventoryCoords, false
	end

	return inventory, inventoryCoords, true
end

function CheckIfInventoryExists(table, value)
    for k, v in pairs(table) do
        if v.name == value then
            return true
        end
    end

    return false
end

function LoadAnimation(dictionary)
    while (not HasAnimDictLoaded(dictionary)) do
        RequestAnimDict(dictionary)

        Citizen.Wait(5)
    end
end