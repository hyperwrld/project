local isInventoryOpen, isShowing, isDoingAnimation, isWeaponEquiped, isUsingItem, currentWeapon, weaponSlot = false, false, false, false, false, nil, nil

local function sendMessage(data)
	SendNUIMessage(data)
end

local function closeInventory()
    isInventoryOpen = false

	EnableAllControlActions(0)
    SetNuiFocus(false, false)
end

local function showInventory(type, data)
	if isInventoryOpen then
		closeInventory()
		return
	end

	-- * type: 1 (drop), 2 (store), 3 (customInventory)

	local player = exports['crp-base']:getModule('LocalPlayer')
	local events, id = exports['crp-base']:getModule('Events'), player:getCurrentCharacter()

	if type == 1 then
		local inventory, inventoryCoords, alreadyExists = GetClosestInventory()

        if not alreadyExists then
            events:Trigger('crp-inventory:getInventories', inventory, function(data)
				sendMessage({
					event = 'open',
					playerData = { id = id, items = data.player },
					secondaryData = { id = inventory, coords = inventoryCoords, type = type, items = data.secondary },
				})
			end)
		else
			events:Trigger('crp-inventory:getInventories', inventory, function(data)
				sendMessage({
					event = 'open',
					playerData = { id = id, items = data.player },
					secondaryData = { id = inventory, coords = inventoryCoords, type = type, items = data.secondary },
				})
			end)
		end
    elseif type == 2 then
		events:Trigger('crp-inventory:getStoreItems', data.shopType, function(_data)
			sendMessage({
				event = 'open',
				playerData = { id = id, items = _data.player },
				secondaryData = { id = data.name, type = type, items = _data.secondary, shopType = data.shopType },
			})
        end)
    elseif type == 3 then
        events:Trigger('crp-inventory:getInventories', data.name, function(_data)
			sendMessage({
				event = 'open',
				playerData = { id = id, items = _data.player },
				secondaryData = { id = data.name, slots = data.slots, weight = data.weight, type = type, items = _data.secondary },
			})
		end)
	end

	isInventoryOpen = true

	SetNuiFocus(true, true)

	Citizen.CreateThread(function()
		while isInventoryOpen do
			Citizen.Wait(0)

			DisableAllControlActions(0)
		end
	end)
end

local function nuiCallBack(data, cb)
	local events = exports['crp-base']:getModule('Events')

	if data.close then closeInventory() end

    if data.moveitem then
        local item = data.itemdata

        if (tonumber(item.id) == tonumber(currentWeapon) and tonumber(item.lastSlot) == tonumber(weaponSlot)) then
            cb({ status = false })
        else
            events:Trigger('crp-inventory:moveItem', data.itemdata, function(data)
                cb(data)
            end)
        end
	end

    if data.swapitem then
        local items = data.itemsdata

        if (tonumber(items.item) == tonumber(currentWeapon) and tonumber(items.lastSlot) == tonumber(weaponSlot)) or (tonumber(items._item) == tonumber(currentWeapon) and tonumber(items.currentSlot) == tonumber(weaponSlot)) then
            cb({ status = false })
        else
            events:Trigger('crp-inventory:swapItems', items, function(data)
                cb(data)
            end)
        end
	end

	if data.buyitem then
		events:Trigger('crp-inventory:buyItem', { itemdata = data.itemdata, shoptype = data.shoptype }, function(data)
			cb(data)
		end)
    end

    if data.useitem then
        local events = exports['crp-base']:getModule('Events')

        events:Trigger('crp-inventory:getItem', data.itemdata.slot, function(_data)
            if _data[1] == nil then
                cb(false)
            end

            UseRegularItem(_data[1].item, data.itemdata.slot)
        end)
    end

	if data.success then
		if data.text then exports['crp-notifications']:SendAlert('success', data.text) end

		PlaySoundFrontend(-1, 'ERROR', 'HUD_LIQUOR_STORE_SOUNDSET', false)
	end

	if data.error then
		if data.text then exports['crp-notifications']:SendAlert('error', data.text) end

		PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
	end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)

        if not isShowing and (IsDisabledControlJustPressed(0, 37)) then
            local events = exports['crp-base']:getModule('Events')

            isShowing = true

            events:Trigger('crp-inventory:showActionBar', nil, function(data)
                sendMessage({ event = 'show', items = data })
            end)
        end

        if isShowing and (IsDisabledControlReleased(0, 37)) then
            sendMessage({ event = 'hide' })

            isShowing = false
        end

        if IsDisabledControlJustPressed(0, 157) and not isUsingItem then
            if not isWeaponEquiped or (isWeaponEquiped and weaponSlot ~= 1) then
                UseItem(1)
            elseif isWeaponEquiped then
                Holster()
            end
        end

        if IsDisabledControlJustPressed(0, 158) and not isUsingItem then
            if not isWeaponEquiped or (isWeaponEquiped and weaponSlot ~= 2) then
                UseItem(2)
            elseif isWeaponEquiped then
                Holster()
            end
        end

        if IsDisabledControlJustPressed(0, 160) and not isUsingItem then
            if not isWeaponEquiped or (isWeaponEquiped and weaponSlot ~= 3) then
                UseItem(3)
            elseif isWeaponEquiped then
                Holster()
            end
        end

        if IsDisabledControlJustPressed(0, 164) and not isUsingItem then
            if not isWeaponEquiped or (isWeaponEquiped and weaponSlot ~= 4) then
                UseItem(4)
            elseif isWeaponEquiped then
                Holster()
            end
        end

        if IsControlJustReleased(0, 289) and IsInputDisabled(0) and not isUsingItem then
            showInventory(1)
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        DisableControlAction(0, 14, true)
        DisableControlAction(0, 15, true)
        DisableControlAction(0, 16, true)
        DisableControlAction(0, 17, true)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 99, true)
        DisableControlAction(0, 100, true)
        DisableControlAction(0, 115, true)
        DisableControlAction(0, 116, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(150)

        local playerPed = GetPlayerPed(-1)

        if IsPedShooting(playerPed) then
            UpdateWeaponAmmo()
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords, letSleep = GetEntityCoords(PlayerPedId()), true

		for k, v in pairs(inventories) do
			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)

			if distance < 20.0 then
				DrawMarker(20, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 0.4, 255, 255, 255, 100, false, true, 2, false, false, false, false)

				letSleep = false
			end
		end

		if letSleep then
			Citizen.Wait(1500)
		end
	end
end)

RegisterNetEvent('crp-inventory:openCustom')
AddEventHandler('crp-inventory:openCustom', function(data)
	showInventory(data.type, data)
end)

RegisterNetEvent('crp-inventory:updateInventories')
AddEventHandler('crp-inventory:updateInventories', function(newInventories)
	inventories = newInventories
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and isInventoryOpen then
        closeInventory()
    end
end)

RegisterCommand('tp', function(source, args)
    local x = tonumber(args[1])
	local y = tonumber(args[2])
	local z = tonumber(args[3])

	if x and y and z then
		x = x + 0.0
		y = y + 0.0
		z = z + 0.0

		RequestCollisionAtCoord(x, y, z)

		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			RequestCollisionAtCoord(x, y, z)
			Citizen.Wait(1)
		end

		SetEntityCoords(PlayerPedId(), x, y, z)
	end
end, false)