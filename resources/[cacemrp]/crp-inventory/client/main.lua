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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for i = 1, #dropInventories, 1 do
            local distance = #(vector3(dropInventories[i].coords.x, dropInventories[i].coords.y, dropInventories[i].coords.z) - coords)

            if distance < 20.0 then
				DrawMarker(20, dropInventories[i].coords.x, dropInventories[i].coords.y, dropInventories[i].coords.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 255, 255, 100, false, true, 2, false, false, false, false)

				letSleep = false
			end
        end

        if letSleep then
			Citizen.Wait(1500)
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

			TriggerEvent('crp-inventory:openInventory', 4, 'container (' .. math.floor(container.x + 0.5) .. ' | ' .. math.floor(container.y + 0.5) .. ')')
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

						Citizen.Wait(1000)

						Debug('[Main] Checking vehicle trunk.')

						TriggerEvent('crp-inventory:openInventory', 2, 'trunk-' .. GetVehicleNumberPlateText(vehicle))
					else
						Debug('[Main] The vehicle trunk is closed.')

						exports['crp-ui']:setAlert('O veículo está trancado', 'inform')
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

function useItem(slot)
	if isUsingItem then
		return
	end

	local success, data = RPC:execute('getItem', slot)

	print(success, data)

	if not data then
		return
	end

	local itemData = getItemData(data.item)

	if IsWeaponValid(itemData.hash) then
		if isWeaponEquiped then
			holsterWeapon(itemData.identifier)
			return
		end

		Citizen.Wait(200)

		isWeaponEquiped, weaponSlot = true, slot

		equipWeapon(itemData, data.meta.ammo)
	else
		TriggerEvent('crp-inventory:useItem', data.item)
	end
end

function toggleAction()
	local data = {}

	isShowingAction = not isShowingAction

	if isShowingAction then
        data = RPC:execute('getActionBarItems')
	end

	exports['crp-ui']:toggleAction(isShowingAction, data)
end

RegisterUICallback('moveItem', function(data, cb)
	local success, current, future = RPC:execute('moveItem', data.current, data.future, data.currentIndex, data.futureIndex, data.count, data.data)

    cb({ status = success, current = current, future = future })
end)

RegisterUICallback('buyItem', function(data, cb)
	local success, current, future = RPC:execute('buyItem', data.current, data.future, data.currentIndex, data.futureIndex, data.count, data.data)

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
		if type == 2 or type == 4 then
			TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
		else
			LoadDictionary('pickup_object')

			TaskPlayAnim(PlayerPedId(), 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
		end

		exports['crp-ui']:openApp('inventory', data)
	end
end)

AddEventHandler('crp-inventory:openShop', function(type)
	local success, data = RPC:execute('openShop', type)

	if success then
		exports['crp-ui']:openApp('inventory', data)
	end
end)

AddEventHandler('crp-ui:closedMenu', function(name, data)
	if name ~= 'inventory' then
		return
	end

	Debug('[Main] Inventory closed.')

	TriggerServerEvent('crp-inventory:closedInventory', data.first, data.second)

	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('crp-inventory:addDropInventory')
AddEventHandler('crp-inventory:addDropInventory', function(name, coords)
	dropInventories[#dropInventories + 1] = { name = name, coords = coords }
end)

RegisterNetEvent('crp-inventory:removeDropInventory')
AddEventHandler('crp-inventory:removeDropInventory', function(name)
	for i = 1, #dropInventories, 1 do
		if dropInventories[i].name == name then
			table.remove(dropInventories, i)
			break
		end
	end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end

	Debug('[Main] Updated items list on the crp-ui.')

	exports['crp-ui']:setAppData('inventory', itemsList)
end)

RegisterCommand('+openInventory', openInventory, false)
RegisterKeyMapping('+openInventory', 'Abrir o inventário', 'keyboard', 'i')

RegisterCommand('+showAction', toggleAction, false)
RegisterCommand('-showAction', toggleAction, false)
RegisterKeyMapping('+showAction', 'Mostrar a actionbar', 'keyboard', 'Tab')