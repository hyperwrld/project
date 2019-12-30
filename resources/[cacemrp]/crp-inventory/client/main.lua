local isInventoryOpen, Inventories = false, {}

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
			events:Trigger('crp-inventory:getInventory', id, function(data)
				sendMessage({ 
					event = 'open', 
					playerData = { id = id, items = data }, 
					secondaryData = { id = inventory, coords = inventoryCoords, type = type, items = nil },
				})
			end)
		else
			events:Trigger('crp-inventory:getInventories', { id = id, inventory = inventory }, function(data)
				sendMessage({ 
					event = 'open', 
					playerData = { id = id, items = data.player }, 
					secondaryData = { id = inventory, coords = inventoryCoords, type = type, items = data.secondary },
				})
			end)
		end
    elseif type == 2 then
		events:Trigger('crp-shops:getStoreItems', { id = id, type = data.shopType }, function(_data)
			sendMessage({ 
				event = 'open', 
				playerData = { id = id, items = _data.player }, 
				secondaryData = { id = data.name, type = type, items = _data.secondary, shopType = data.shopType },
			})
        end)
    elseif type == 3 then
        events:Trigger('crp-inventory:getInventories', { id = id, inventory = data.name }, function(_data)
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
		events:Trigger('crp-inventory:moveItem', data.itemdata, function(data)
			cb(data)
		end)
	end

	if data.swapitem then
		events:Trigger('crp-inventory:swapItems', data.itemsdata, function(data)
			cb(data)
		end)
	end

	if data.buyitem then
		events:Trigger('crp-shops:buyItem', { itemdata = data.itemdata, shoptype = data.shoptype }, function(data)
			cb(data)
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

		if IsControlJustReleased(0, 289) and IsInputDisabled(0) then
			showInventory(1)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords, letSleep = GetEntityCoords(PlayerPedId()), true

		for k, v in pairs(Inventories) do
			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)

			if distance < 20.0 then
				DrawMarker(20, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 0.4, 255, 255, 255, 100, false, true, 2, false, false, false, false)
				
				letSleep = false
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function GetClosestInventory() 
	local coords = GetEntityCoords(PlayerPedId())
	local inventory, inventoryDistance, inventoryCoords

	for k, v in pairs(Inventories) do
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

		while CheckIfInventoryExists(Inventories, inventory) == true do
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

RegisterNetEvent('crp-inventory:openCustom')
AddEventHandler('crp-inventory:openCustom', function(data)
	showInventory(data.type, data)
end)

RegisterNetEvent('crp-inventory:updateInventories')
AddEventHandler('crp-inventory:updateInventories', function(newInventories)
	Inventories = newInventories
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and isInventoryOpen then
        closeInventory()
    end
end)