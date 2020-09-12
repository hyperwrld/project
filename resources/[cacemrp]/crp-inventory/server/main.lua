inventories, dropInventories = {}, {}

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end

	Debug('[Main] Resource started | Cleaning drop inventories | Cleaning old items.')

	DB:Execute([[DELETE FROM inventory WHERE name LIKE 'drop-%';]])
end)

RPC:register('openInventory', function(source, type, name, data)
    return openInventory(source, type, name, data)
end)

RPC:register('moveItem', function(source, current, future, currentSlot, futureSlot, count)
	return moveProcess(source, current, future, currentSlot, futureSlot, count)
end)

RPC:register('getActionBarItems', function(source)
	return getActionBarItems(source)
end)

RPC:register('getItem', function(source, slot)
	return getItem(source, slot)
end)

function openInventory(source, type, name, data)
	local success, firstInventory, secondInventory = loadInventories(source, type, name, data)

	if not success or type == 5 then
		Debug('[Main] Couldnt load the inventories.')

		return false
	end

	Debug('[Main] Inventories (character & ' .. name ..') loaded.')

	return true, { player = firstInventory, secondary = secondInventory }
end

-- List of types:
-- 1 (drop) - 2 (trunk) - 3 (glove) - 4 (container) - 5(shop) - 6(...)

function loadInventories(source, type, name, data)
	local maxSlots, maxWeight = 1000, 40

	Debug('[Main] Loading inventories...')

	local character = exports['crp-base']:GetCharacter(source)
	local firstInventory = loadInventory('character-' .. character.getCharacterID(), 40, 100)

	if type == 2 then
		maxWeight = vehicleWeights[data.vehicleName]
	else
		maxSlots, maxWeight = inventoryTypes[type].slots, inventoryTypes[type].weight
	end

	local secondInventory = loadInventory(name, maxSlots, maxWeight, type, data)

	if not firstInventory or not secondInventory then
		return false
	end

	return true, firstInventory, secondInventory
end

function loadInventory(name, slots, weight, _type, data)
	if not name or type(name) ~= 'string' then return false end

	if inventories[name] then
		return inventories[name]
	end

	local query = [[SELECT item, count, slot, meta, creation_time FROM inventory WHERE name = ?;]]
	local result = Citizen.Await(DB:Execute(query, name))

	inventories[name] = createInventory(name, slots, weight, _type, result)

	if _type == 1 then
		addDropInventory(name, data)
	end

	return inventories[name]:returnData()
end

function moveProcess(source, current, future, currentSlot, futureSlot, count)
	if not inventories[current] or not inventories[future] then
		return false
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
	if data.item == _data.item and itemsList[data.item].canStack then
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

			if inventories[current].isEmpty() then
				removeDropInventory(current)
			end
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

		if inventories[current].isEmpty() then
			removeDropInventory(current)
		end
	end

	return true, inventories[current].getItemData(currentSlot), inventories[future].getItemData(futureSlot)
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
	local character = exports['crp-base']:GetCharacter(source)
	local name = 'character-' .. character.getCharacterID()

	if not inventories[name] then
		loadInventory(name, 40, 100)
	end

	return inventories[name].getActionBarItems()
end

function getItem(source, slot)
	local character = exports['crp-base']:GetCharacter(source)
	local name = 'character-' .. character.getCharacterID()

	if not inventories[name] then
		loadInventory(name, 40, 100)
	end

	local data = inventories[name].getItemData(slot)

	if not data then
		return false
	end

	local currentTime, percentagem = os.time(os.date("!*t")), 100

	if itemsList[data.item].decayRate ~= 0.0 then
		percentagem = 100 - math.ceil(((currentTime - data.creation_time) / (2419200000 * itemsList[data.item].decayRate)) * 100)
	end

	print(percentagem)

	if percentagem <= 0 then
		return false, 'Este item já não pode ser usado.'
	end

	return true, data
end