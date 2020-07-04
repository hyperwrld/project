Inventories, DropInventories = {}, {}

-- inventory type: 1 (drop) / 2 (...)

function GetInventories(source, data, callback)
    local user = exports['crp-base']:GetCharacter(source)
    local inventoryName = 'character-' .. user.getCharacterID()

    if isInventoryLoaded(inventoryName) and isInventoryLoaded(data.name, data) then
        local items, maxWeight, maxSlots = {}, 1000, 40

        if Inventories[data.name] then
            items, maxWeight, maxSlots = Inventories[data.name].items, Inventories[data.name].maxWeight, Inventories[data.name].maxSlots
        end

        callback:resolve({ playerInventory = {
            name = Inventories[inventoryName].name, items = Inventories[inventoryName].items
        }, secondaryInventory = {
            name = data.name, items = items,
            maxWeight = maxWeight, maxSlots = maxSlots, type = data.type, coords = data.coords
        }})
    end
end

function MoveItem(source, data, callback)
    if Inventories[data.currentInventory] == nil then
        callback:resolve({ status = false })
        return
    end

    if data.type == 1 and string.find(data.futureInventory, 'drop') then
        CheckIfDropExists(data.futureInventory, data.coords)
    elseif Inventories[data.futureInventory] == nil then
        callback:resolve({ status = false })
        return
    end

    local status, item = false, Inventories[data.currentInventory].getItem(data.currentIndex)

    if item and item.count >= data.itemCount then
        local itemFuture = Inventories[data.futureInventory].getItem(data.futureIndex)

        if data.itemCount == 0 then
            data.itemCount = item.count
        end

        if itemFuture then
            if item.name == itemFuture.name and itemsList[item.name].canStack then
                if (item.count - data.itemCount) > 0 then
                    if CanMove(data.currentInventory, data.futureInventory, item.name, data.itemCount) then
                        print('qqqqqqq????')
                        Inventories[data.currentInventory].updateItem(item.name, data.currentIndex, (item.count - data.itemCount))
                        Inventories[data.futureInventory].updateItem(item.name, data.futureIndex, (itemFuture.count + data.itemCount))

                        status = true
                    end
                elseif CanMove(data.currentInventory, data.futureInventory, item.name, item.count) then
                    print('111111111')
                    Inventories[data.currentInventory].removeItem(item.name, data.currentIndex, true)
                    Inventories[data.futureInventory].updateItem(item.name, data.futureIndex, (itemFuture.count + item.count))

                    if Inventories[data.currentInventory].checkIfEmpty() then
                        DeleteDropInventory(data.currentInventory)
                    end

                    status = true
                end
            elseif CanMove(data.currentInventory, data.futureInventory, item.name, item.count, itemFuture.slot) and CanMove(data.futureInventory, data.currentInventory, itemFuture.name, itemFuture.count, item.slot) then
                Inventories[data.currentInventory].swapItem(itemFuture, data.futureInventory, data.currentIndex)
                Inventories[data.futureInventory].swapItem(item, data.currentInventory, data.futureIndex)

                status = true
            end
        else
            if (item.count - data.itemCount) > 0 then
                if CanMove(data.currentInventory, data.futureInventory, item.name, data.itemCount) then
                    print(item.count, data.itemCount)
                    Inventories[data.currentInventory].updateItem(item.name, data.currentIndex, (item.count - data.itemCount))
                    Inventories[data.futureInventory].addItem(item, data.futureIndex, data.itemCount)

                    status = true
                end
            elseif CanMove(data.currentInventory, data.futureInventory, item.name, item.count) then
                Inventories[data.currentInventory].removeItem(item.name, item.slot, false)
                Inventories[data.futureInventory].swapItem(item, data.currentInventory, data.futureIndex)

                if Inventories[data.currentInventory].checkIfEmpty() then
                    DeleteDropInventory(data.currentInventory)
                end

                status = true
            end
        end
    end

    if status then
        callback:resolve({
            status = true, currentSlot = Inventories[data.currentInventory] and Inventories[data.currentInventory].getItem(data.currentIndex) or {},
            futureSlot = Inventories[data.futureInventory] and Inventories[data.futureInventory].getItem(data.futureIndex) or {}
        })
    else
        callback:resolve({ status = false })
    end
end

function isInventoryLoaded(name, data)
    if Inventories[name] ~= nil then
        return true
    end

    local maxWeight, maxSlots = 325, 40

    if data then
        if data.type == 1 then
            return true
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
                slot = result[i].slot, meta = json.decode(result[i].meta)
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
        if DropInventories[i].name == inventoryName or vector3(DropInventories[i].coords) == vector3(inventoryCoords) then
            hasFound = true

            break
        end
    end

    print(hasFound)

    if not hasFound then
        print('alo alo', inventoryName)
        LoadInventory({ name = inventoryName, maxWeight = 1000, maxSlots = 40 })

        table.insert(DropInventories, { name = inventoryName, coords = inventoryCoords })

        TriggerClientEvent('crp-inventory:updateDropInventories', -1, DropInventories)
    end
end

function DeleteDropInventory(inventoryName)
    for i = 1, #DropInventories, 1 do
        print(DropInventories[i].name, inventoryName)
        if DropInventories[i].name == inventoryName then
            table.remove(DropInventories, i)

            Inventories[inventoryName] = nil

            TriggerClientEvent('crp-inventory:updateDropInventories', -1, DropInventories)
            break
        end
    end
end

CRP.RPC:register('GetInventories', function(source, data)
    local inventoryPromise = promise:new()

    GetInventories(source, data, inventoryPromise)

    return Citizen.Await(inventoryPromise)
end)

CRP.RPC:register('moveItem', function(source, data)
    local inventoryPromise = promise:new()

    MoveItem(source, data, inventoryPromise)

    return Citizen.Await(inventoryPromise)
end)