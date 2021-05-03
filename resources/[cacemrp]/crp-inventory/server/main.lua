inventories, dropInventories, openInventories = {}, {}, {}

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end

	Debug('Resource started | Cleaning drop/container inventories | Cleaning old items.')

	DB:Execute([[DELETE FROM inventory WHERE name LIKE 'drop%' OR name LIKE 'container%';]])
end)

RPC:register('openInventory', function(source, type, name, data)
    return openInventory(source, type, name, data)
end)

RPC:register('moveItem', function(source, current, future, currentSlot, futureSlot, count, data)
	return moveProcess(source, current, future, currentSlot, futureSlot, count, data)
end)

RPC:register('getActionBarItems', function(source)
	return getActionBarItems(source)
end)

RPC:register('getItem', function(source, slot)
	return getItem(source, slot)
end)

function openInventory(source, type, name, data)
	local success, data = loadInventories(source, type, name, data)

	if not success or type == 5 then
		Debug('Couldnt load the inventories.')

		return false
	end

	Debug(('Inventories (character & %s) loaded.'):format(data.secondName))

	return true, data
end

-- List of types:
-- 1 (drop) - 2 (trunk) - 3 (glove) - 4 (container) - 5(shop) - 6(locker)

function loadInventories(source, type, name, data)
	local maxSlots, maxWeight = 1000, 40

	Debug('Loading inventories...')

	local character = exports['crp-base']:getCharacter(source)
	local characterName = 'character-' .. character.getCharacterId()
	local first = loadInventory(characterName, 40, 100)

	if type == 2 then
		maxWeight = 100

		if vehicleWeights[data.vehicleName] then
			maxWeight = vehicleWeights[data.vehicleName]
		end
	elseif type == 6 then
		name = 'locker-' .. character.getCharacterId()
	else
		maxSlots, maxWeight = inventoryTypes[type].slots, inventoryTypes[type].weight
	end

	local second = loadInventory(name, maxSlots, maxWeight, type, data)

	if not first or not second then
		return false
	end

	if not canOpenInventories(source, characterName, name) then
		return
	end

	return true, {
		firstName = first.name, firstItems = first.items, secondItems = second.items,
		secondName = second.name, secondMaxWeight = second.maxWeight,
		maxSlots = second.maxSlots, type = second.type, coords = second.coords
	}
end

function canOpenInventories(source, firstName, secondName)
	local first, second = openInventories[firstName], openInventories[secondName]

	if (first ~= nil and first.state and first.source ~= source) then
		return false
	end

	if (second ~= nil and second.state and second.source ~= source) then
		return false
	end

	openInventories[firstName] = { state = true, source = source }

	if second then
		openInventories[secondName] = { state = true, source = source }
	end

	return true
end

RegisterNetEvent('crp-inventory:closedInventory')
AddEventHandler('crp-inventory:closedInventory', function(firstName, secondName)
	local _source, first, second = source, openInventories[firstName], openInventories[secondName]

	if (not first or not first.state) or (not second or not second.state) then
		return
	end

	if first.source ~= source or second.source ~= source then
		return
	end

	local data = { state = false, source = nil }

	if inventories[secondName].isEmpty() then
		removeDropInventory(secondName)
	end

	openInventories[firstName], openInventories[secondName] = data, data
end)

AddEventHandler('playerDropped', function(reason)
	for key, value in pairs(openInventories) do
		if value.source == source then
			openInventories[key] = { state = false, source = nil }

			Debug('Closed the inventory ' .. key)
		end
	end
end)

function loadInventory(name, slots, weight, _type, data)
	if not name or type(name) ~= 'string' then return false end

	if inventories[name] then
		return inventories[name]
	end

	local query = [[SELECT item, count, slot, meta, creation_time FROM inventory WHERE name = ?;]]
	local result = Citizen.Await(DB:Execute(query, name))

	inventories[name] = createInventory(name, slots, weight, _type, result, data)

	return inventories[name]:returnData()
end

function moveProcess(source, current, future, currentSlot, futureSlot, count, data)
	if not inventories[current] or (not inventories[future] and data.type ~= 1) then
		return false
	end

	if not inventories[future] and data.type == 1 then
		loadInventory(future, 40, 1000, 1, data)
	end

	if inventories[current].type == 5 or inventories[future].type == 5 then
		return false
	end

	local data = inventories[current].getItemData(currentSlot)

	if data and data.count >= count then
		local _data = inventories[future].getItemData(futureSlot)

		if count <= 0 then
			count = data.count
		end

		if _data then
			return swapItems(data, _data, current, future, currentSlot, futureSlot, count)
		end

		return moveItem(data, current, future, currentSlot, futureSlot, count)
	end

	return false
end

function swapItems(data, _data, current, future, currentSlot, futureSlot, count)
	if data.item == _data.item and getItemData(data.item).canStack then
		local itemCount = count

		if data.count - count <= 0 then
			itemCount = data.count
		end

		if not inventories[future].canCarry((current == future), data.item, itemCount) then
			return false
		end

		if (data.count - count > 0) then
			inventories[current].updateItem(data.item, currentSlot, (data.count - count))
			inventories[future].updateItem(data.item, futureSlot, (_data.count + count))
		else
			inventories[current].removeItem(data.item, currentSlot, true)
			inventories[future].updateItem(data.item, futureSlot, _data.count + data.count)
		end
	else
		if not (inventories[future].canCarry((current == future), data.item, data.count, _data.slot) and inventories[current].canCarry((current == future), _data.item, _data.count, data.slot)) then
			return false
		end

		inventories[current].swapItem(_data, future, currentSlot)
		inventories[future].swapItem(data, current, futureSlot)
	end

	return true, inventories[current].getItemData(currentSlot), inventories[future].getItemData(futureSlot)
end

function moveItem(data, current, future, currentSlot, futureSlot, count)
	local itemCount = count

	if (data.count - itemCount) < 0 then
		itemCount = data.count
	end

	if not inventories[future].canCarry((current == future), data.item, itemCount) then
		return false
	end

	if data.count > itemCount then
		inventories[current].updateItem(data.item, currentSlot, (data.count - itemCount))
		inventories[future].addItem(data.item, futureSlot, itemCount, data.meta, data.creation_time)
	else
		inventories[current].removeItem(data.item, data.slot, false)
		inventories[future].swapItem(data, current, futureSlot)
	end

	local currentSlotData = false

	if inventories[current] then
		currentSlotData = inventories[current].getItemData(currentSlot)
	end

	if inventories[future].type == 1 then
		addDropInventory(future, inventories[future].coords)
	end

	return true, currentSlotData, inventories[future].getItemData(futureSlot)
end

function addDropInventory(name, coords)
	table.insert(dropInventories, { name = name, coords = coords })

	TriggerClientEvent('crp-inventory:addDropInventory', -1, name, coords)
end

function removeDropInventory(name)
	for i = 1, #dropInventories, 1 do
		if dropInventories[i].name == name then
			table.remove(dropInventories, i)

			inventories[name] = nil

			TriggerClientEvent('crp-inventory:removeDropInventory', -1, name)
			break
		end
	end
end

function getActionBarItems(source)
	local character = exports['crp-base']:getCharacter(source)
	local name = 'character-' .. character.getCharacterId()

	if not inventories[name] then
		loadInventory(name, 40, 100)
	end

	return inventories[name].getActionBarItems()
end

function getItem(source, slot)
	local character = exports['crp-base']:getCharacter(source)
	local name = 'character-' .. character.getCharacterId()

	if not inventories[name] then
		loadInventory(name, 40, 100)
	end

	local data = inventories[name].getItemData(slot)

	if not data then
		return false
	end

	local currentTime, percentagem = os.time(os.date("!*t")), 100
	local item = getItemData(data.item)

	if item and item.decayRate ~= 0.0 then
		percentagem = 100 - math.ceil(((((currentTime * 1000) - (data.creation_time * 1000)) / (2419200000 * item.decayRate)) * 100))
	end

	if percentagem <= 0 then
		return false, 'Este item já não pode ser usado.'
	end

	return true, data
end

function hasItem(source, name, quantity)
	local character = exports['crp-base']:getCharacter(source)
	local characterName = 'character-' .. character.getCharacterId()

	if not inventories[characterName] then
		if not loadInventory(characterName, 40, 100) then
			return false
		end
	end

	return inventories[characterName].getQuantity(name) >= quantity
end

RPC:register('hasItem', hasItem)

function useItem(source, name, quantity)
	local character = exports['crp-base']:getCharacter(source)
	local characterName = 'character-' .. character.getCharacterId()

	if not inventories[characterName] then
		if not loadInventory(characterName, 40, 100) then
			return false
		end
	end

	return inventories[characterName].useItem(name, quantity)
end

exports('useItem', useItem)
RPC:register('useItem', useItem)