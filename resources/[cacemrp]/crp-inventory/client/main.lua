dropInventories = {}
isDoingAnimation, isUsingItem, isWeaponEquiped, weaponSlot = false, false, false, nil
isShowingAction = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

		DisableControlAction(0, 14, true)
		DisableControlAction(0, 15, true)
		DisableControlAction(0, 16, true)
		DisableControlAction(0, 17, true)
		DisableControlAction(0, 99, true)

		DisableControlAction(0, 100, true)
		DisableControlAction(0, 115, true)
		DisableControlAction(0, 116, true)

		if IsControlJustPressed(0, 157) or IsDisabledControlJustReleased(0, 157) then
			useItem(1)
        end

        if IsControlJustPressed(0, 158) or IsDisabledControlJustReleased(0, 158) then
            useItem(2)
        end

        if IsControlJustPressed(0, 160) or IsDisabledControlJustReleased(0, 160) then
            useItem(3)
        end

        if IsControlJustPressed(0, 164) or IsDisabledControlJustReleased(0, 164) then
            useItem(4)
        end
    end
end)

function openInventory()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if vehicle ~= 0 then
			Debug('[Main] Opened glovebox inventory.')

			TriggerEvent('crp-inventory:openInventory', 3, 'glovebox-' .. GetVehicleNumberPlateText(vehicle))
		end
	else
		local coords = GetEntityCoords(playerPed)
		local found, container = searchContainers(playerPed, coords)

		if found then
			Debug('[Main] Opened container inventory.')

			TriggerEvent('crp-inventory:openInventory', 4, 'container | ' .. container.x .. ' - ' .. container.y)
		else
			local vehicle = GetVehicleInFront(playerPed, coords)

			if vehicle ~= 0 and not IsThisModelABicycle(GetEntityModel(vehicle)) then
				local minimum, maximum = GetModelDimensions(vehicle)
				local position = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, minimum - 0.5, 0.0)

				if #(position - coords) < 3.5 then
					local vehicleStatus = GetVehicleDoorLockStatus(vehicle)

					if vehicleStatus == 0 or vehicleStatus == 1 then
						SetVehicleDoorOpen(vehicle, 5, 0, 0)
						TaskTurnPedToFaceEntity(playerPed, vehicle, 1.0)

						-- TODO: Trigger trunk animation.

						Citizen.Wait(1000)

						Debug('[Main] Checking vehicle trunk.')

						TriggerEvent('crp-inventory:openInventory', 2, 'trunk-' .. GetVehicleNumberPlateText(vehicle))
					else
						Debug('[Main] The vehicle trunk is closed.')

						-- TODO: Send alert (O veículo está trancado)
					end
				end
			else
				local name, coords = searchDropInventories(coords)

				Debug('[Main] Opened drop inventory.')

				TriggerEvent('crp-inventory:openInventory', 1, name, coords)
			end
		end
	end
end

function closeInventory()
	isOnTrunk = false


end

function useItem(slot)
	if isUsingItem then
		return
	end

	if isWeaponEquiped and weaponSlot == slot then
		holsterWeapon()
		return
	end

	local success, data = RPC:execute('getItem', slot)

	print(success, data)

	if not data then
		return
	end

	if IsWeaponValid(data.item) then
		if isWeaponEquiped then
			holsterWeapon()
		end

		Citizen.Wait(200)

		isWeaponEquiped, weaponSlot = true, slot

		equipWeapon(data)
	else
		TriggerEvent('crp-inventory:useItem', data)
	end
end

RegisterCommand('ola', function(source, args)
	local playerPed = PlayerPedId()
	local coords = vector3(120.3941, -1063.078, -34.75819) --  GetEntityCoords(playerPed)


	local coords2 = vector3(120.3941, -1063.078, 34.75819)

	print(coords.x - coords2.x, coords.y - coords2.y, coords.z - coords2.z)
	SetEntityCoords(playerPed, coords.x, coords.y, coords.z)

	building = CreateObjectNoOffset(GetHashKey('v_49_motelmp_shell'), coords.x, coords.y, coords.z, true, false, true)

	FreezeEntityPosition(building, true)

	-- 2.0509948730469	-2.073974609375	0.35182952880859

	stuff = CreateObjectNoOffset(GetHashKey('v_49_motelmp_stuff'), coords.x - 0.0013961791992188, coords.y - 0.0059814453125, coords.z - 0.10515975952148, false, false, false)
	clothes = CreateObjectNoOffset(GetHashKey('v_49_motelmp_clothes'), coords.x - 2.0509948730469, coords.y + 2.073974609375, coords.z - 0.35182952880859, false, false, false)
	-- reflect = CreateObjectNoOffset(GetHashKey('v_49_motelmp_reflect'), coords.x, coords.y, coords.z, false, false, false)
	print(GetEntityCoords(reflect))
end, false)

AddEventHandler('onResourceStop', function(resourceName)
	print('alo?')
	if resourceName == 'crp-inventory-new' then
		print('12333')
		DeleteEntity(building)
		DeleteEntity(stuff)
		DeleteEntity(bed)
		DeleteEntity(clothes)
		DeleteEntity(reflect)
    end
end)

function toggleAction()
	local data = {}

	isShowingAction = not isShowingAction

	if isShowingAction then
		data = RPC:execute('getActionBarItems')
	end

	exports['crp-ui']:toggleAction(isShowingAction, data)
end

RegisterUiCallback('moveItem', function(data, cb)
	local success, current, future = RPC:execute('moveItem', data.current, data.future, data.currentIndex, data.futureIndex, data.count)

    cb({ status = success, current = current, future = future })
end)

AddEventHandler('crp-inventory:useItem', function(data)
	if isUsingItem then
		return
	end

	isUsingItem = true

	Citizen.Wait(600)

	isUsingItem = false
end)

AddEventHandler('crp-inventory:openInventory', function(type, name, data)
	local success, data = RPC:execute('openInventory', type, name, data)

	if success then
		exports['crp-ui']:openApp('inventory', data)
	end
end)

AddEventHandler('crp-inventory:openShop', function(type, name)
	local success, data = RPC:execute('openShop', type, name)

	if success then
		exports['crp-ui']:openApp('inventory', data)
	end
end)

AddEventHandler('crp-ui:closedMenu', function(name)
	if name ~= 'inventory' then
		return
	end

	Debug('[Main] Inventory closed.')

	closeInventory()
end)

RegisterCommand('+openInventory', openInventory, false)
RegisterCommand('-openInventory', closeInventory, false)
RegisterKeyMapping('+openInventory', 'Abrir o inventário', 'keyboard', 'i')

RegisterCommand('+showAction', toggleAction, false)
RegisterCommand('-showAction', toggleAction, false)
RegisterKeyMapping('+showAction', 'Mostrar a actionbar', 'keyboard', 'tab')