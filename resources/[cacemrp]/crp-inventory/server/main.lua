Inventories, DropInventories = {}, {}

-- inventory type: 1 (drop) / 2 (trunk) / 3 (glovebox) / 4 (...)

function GetInventories(source, data)
    local user = exports['crp-base']:GetCharacter(source)
    local inventoryName = 'character-' .. user.getCharacterID()

	if isInventoryLoaded(inventoryName) then
		local items, maxWeight, maxSlots = {}, 1000, 40

		if data.type == 5 then
			items = getShopItems(data.shopType)
		else
			if not isInventoryLoaded(data.name, data) then
				return
			end

			if Inventories[data.name] then
				items, maxWeight, maxSlots = Inventories[data.name].items, Inventories[data.name].maxWeight, Inventories[data.name].maxSlots
			end
		end

		return { playerInventory = {
            name = Inventories[inventoryName].name, items = Inventories[inventoryName].items
        }, secondaryInventory = {
            name = data.name, items = items,
            maxWeight = maxWeight, maxSlots = maxSlots, type = data.type, coords = data.coords
        }}
	end

    -- if isInventoryLoaded(inventoryName) and isInventoryLoaded(data.name, data) then
    --     local items, maxWeight, maxSlots = {}, 1000, 40

    --     if Inventories[data.name] then
    --         items, maxWeight, maxSlots = Inventories[data.name].items, Inventories[data.name].maxWeight, Inventories[data.name].maxSlots
    --     end

    --     return { playerInventory = {
    --         name = Inventories[inventoryName].name, items = Inventories[inventoryName].items
    --     }, secondaryInventory = {
    --         name = data.name, items = items,
    --         maxWeight = maxWeight, maxSlots = maxSlots, type = data.type, coords = data.coords
    --     }}
    -- end
end

function MoveProcess(source, data)
    if Inventories[data.currentInventory] == nil then
        return { status = false }
    end

    if data.type == 1 and string.find(data.futureInventory, 'drop') then
        CheckIfDropExists(data.futureInventory, data.coords)
    elseif Inventories[data.futureInventory] == nil then
        return { status = false }
    end

    local item, index = Inventories[data.currentInventory].getInventoryItem(data.currentIndex)
    local status = false

    if item and item.count >= data.itemCount then
        local itemFuture, futureIndex = Inventories[data.futureInventory].getInventoryItem(data.futureIndex)

        if data.itemCount == 0 then
            data.itemCount = item.count
        end

        if itemFuture then
            return SwapItem(item, itemFuture, data)
        else
            return MoveItem(item, data)
        end
    end

    return { status = false }
end

function SwapItem(item, itemFuture, data)
    local status = false

    if item.name == itemFuture.name and itemsList[item.name].canStack then
        if (item.count - data.itemCount) > 0 then
            if Inventories[data.futureInventory].canCarryItem((data.currentInventory == data.futureInventory), item.name, data.itemCount) then
                Inventories[data.currentInventory].updateInventoryItem(item.name, data.currentIndex, (item.count - data.itemCount))
                Inventories[data.futureInventory].updateInventoryItem(item.name, data.futureIndex, (itemFuture.count + data.itemCount))

                status = true
            end
        elseif Inventories[data.futureInventory].canCarryItem((data.currentInventory == data.futureInventory), item.name, item.count) then
            Inventories[data.currentInventory].removeInventoryItem(item.name, data.currentIndex, true)
            Inventories[data.futureInventory].updateInventoryItem(item.name, data.futureIndex, (itemFuture.count + item.count))

            if Inventories[data.currentInventory].isEmpty() then
                DeleteDropInventory(data.currentInventory)
            end

            status = true
        end
    elseif Inventories[data.futureInventory].canCarryItem((data.currentInventory == data.futureInventory), item.name, item.count, itemFuture.slot) and
           Inventories[data.currentInventory].canCarryItem((data.currentInventory == data.futureInventory), itemFuture.name, itemFuture.count, item.slot) then

        Inventories[data.currentInventory].swapInventoryItem(itemFuture, data.futureInventory, data.currentIndex)
        Inventories[data.futureInventory].swapInventoryItem(item, data.currentInventory, data.futureIndex)

        status = true
    end

    if status then
        local currentSlot, futureSlot = {}, {}

        if Inventories[data.currentInventory] and Inventories[data.currentInventory].getInventoryItem(data.currentIndex) then
            currentSlot, index = Inventories[data.currentInventory].getInventoryItem(data.currentIndex)
        end

        if Inventories[data.futureInventory] and Inventories[data.futureInventory].getInventoryItem(data.futureIndex) then
            futureSlot, index = Inventories[data.futureInventory].getInventoryItem(data.futureIndex)
        end

        return { status = true, currentSlot = currentSlot, futureSlot = futureSlot }
    end

    return { status = false }
end

function MoveItem(item, data)
    local status = false

    if (item.count - data.itemCount) > 0 then
        if Inventories[data.futureInventory].canCarryItem((data.currentInventory == data.futureInventory), item.name, data.itemCount) then
            Inventories[data.currentInventory].updateInventoryItem(item.name, data.currentIndex, (item.count - data.itemCount))
            Inventories[data.futureInventory].addInventoryItem(item.name, data.futureIndex, data.itemCount, item.meta)

            status = true
        end
    elseif Inventories[data.futureInventory].canCarryItem((data.currentInventory == data.futureInventory), item.name, item.count) then
        Inventories[data.currentInventory].removeInventoryItem(item.name, item.slot, false)
        Inventories[data.futureInventory].swapInventoryItem(item, data.currentInventory, data.futureIndex)

        if Inventories[data.currentInventory].isEmpty() then
            DeleteDropInventory(data.currentInventory)
        end

        status = true
    end

    if status then
        local currentSlot, futureSlot = {}, {}

        if Inventories[data.currentInventory] and Inventories[data.currentInventory].getInventoryItem(data.currentIndex) then
            currentSlot, index = Inventories[data.currentInventory].getInventoryItem(data.currentIndex)
        end

        if Inventories[data.futureInventory] and Inventories[data.futureInventory].getInventoryItem(data.futureIndex) then
            futureSlot, index = Inventories[data.futureInventory].getInventoryItem(data.futureIndex)
        end

        return { status = true, currentSlot = currentSlot, futureSlot = futureSlot }
    end

    return { status = false }
end

function GetActionBarData(source)
    local user = exports['crp-base']:GetCharacter(source)
    local inventoryName = 'character-' .. user.getCharacterID()

    if isInventoryLoaded(inventoryName) then
        return Inventories[inventoryName].getActionBarData()
    end
end

function GetItem(source, slot)
    local user = exports['crp-base']:GetCharacter(source)
    local inventoryName = 'character-' .. user.getCharacterID()

    if isInventoryLoaded(inventoryName) then
        return Inventories[inventoryName].getInventoryItem(slot)
    end
end

function isInventoryLoaded(name, data)
    if Inventories[name] ~= nil then
        return true
    end

	local maxWeight, maxSlots = 100, 40

	-- Type: 1 (drop) - 2 (trunk) - 3 (glove) - 4 (...) - 5(shop)

    if data then
        if data.type == 1 then
            return true
        elseif data.type == 3 then
			maxWeight, maxSlots = 40, 3
		elseif data.type == 5 then
			maxWeight = 1000

			return CreateInventory(data, getShopItems(data.shopType))
        end
    end

    return LoadInventory({ name = name, maxWeight = maxWeight, maxSlots = maxSlots })
end

function LoadInventory(data)
    if not data.name or type(data.name) ~= 'string' then return false end

    local query, isLoading = [[SELECT item, count, slot, meta FROM inventory WHERE name = @name;]], true

    exports.ghmattimysql:execute(query, { ['@name'] = data.name }, function(result)
        local inventoryItems = {}

        for i = 1, #result, 1 do
            table.insert(inventoryItems, {
                name = result[i].item, count = result[i].count,
                slot = result[i].slot, meta = result[i].meta and json.decode(result[i].meta) or {}
            })
        end

        Inventories[data.name], isLoading = CreateInventory(data, inventoryItems), false
    end)

    while isLoading do
        Citizen.Wait(0)
    end

    return true
end

function CanMove(currentInventory, futureInventory, itemName, itemQuantity, itemSlot)
    if currentInventory == futureInventory then
        return true
    end

    local inventory = Inventories[futureInventory]

    if (itemsList[itemName].weight * itemQuantity) + inventory.getInventoryWeight(itemSlot) > inventory.maxWeight then
        return false
    end

    return true
end

function CheckIfDropExists(inventoryName, inventoryCoords)
    local hasFound = false

    for i = 1, #DropInventories, 1 do
        local inventory = DropInventories[i]

        if inventory.name == inventoryName or vector3(inventory.coords.x, inventory.coords.y, inventory.coords.z) == vector3(inventoryCoords.x, inventoryCoords.y, inventoryCoords.z) then
            hasFound = true

            break
        end
    end

    if not hasFound then
        LoadInventory({ name = inventoryName, maxWeight = 1000, maxSlots = 40 })

        table.insert(DropInventories, { name = inventoryName, coords = inventoryCoords })

        TriggerClientEvent('crp-inventory:updateDropInventories', -1, DropInventories)
    end
end

function DeleteDropInventory(inventoryName)
    for i = 1, #DropInventories, 1 do
        if DropInventories[i].name == inventoryName then
            table.remove(DropInventories, i)

            Inventories[inventoryName] = nil

            TriggerClientEvent('crp-inventory:updateDropInventories', -1, DropInventories)
            break
        end
    end
end

CRP.RPC:register('GetInventories', function(source, data)
    return GetInventories(source, data)
end)

CRP.RPC:register('MoveItem', function(source, data)
    return MoveProcess(source, data)
end)

CRP.RPC:register('GetActionBarData', function(source)
    return GetActionBarData(source)
end)

CRP.RPC:register('GetItem', function(source, slot)
    return GetItem(source, slot)
end)