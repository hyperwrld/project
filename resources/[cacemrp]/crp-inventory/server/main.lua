local dropInventories = {}

inventories, itemList = {}, {}

itemList['1737195953']  = { weight = 10, canStack = true }
itemList['911657153']   = { weight = 10, canStack = true }
itemList['453432689']   = { weight = 15, canStack = true }
itemList['-1076751822'] = { weight = 15, canStack = true }
itemList['137902532']   = { weight = 15, canStack = true }
itemList['-771403250']  = { weight = 20, canStack = true }
itemList['1593441988']  = { weight = 15, canStack = true }
itemList['-619010992']  = { weight = 30, canStack = true }
itemList['-1121678507'] = { weight = 30, canStack = true }
itemList['324215364']   = { weight = 30, canStack = true }
itemList['736523883']   = { weight = 35, canStack = true }
itemList['1649403952']  = { weight = 45, canStack = true }
itemList['-1074790547'] = { weight = 55, canStack = true }
itemList['-2084633992'] = { weight = 55, canStack = true }

AddEventHandler('crp-inventory:moveItem', function(source, data, callback)
    local lastInventory = GetInventory(data.lastInventory)
    local item = lastInventory.getItem(data.item, data.lastSlot)

    if item and item.count >= data.quantity then
        if data.inventoryType == 1 and string.find(data.currentInventory, 'drop') then
            CheckIfInventoryExists(data.currentInventory, data.coords)
        end

        local currentInventory = GetInventory(data.currentInventory)

        if (item.count - data.quantity) > 0 then
            lastInventory.updateItem(data.item, data.lastSlot, (item.count - data.quantity))
            currentInventory.addItem(data.item, data.currentSlot, data.quantity, nil)

            callback({ status = true, splitItem = true })
        else
            lastInventory.removeItem(item.name, item.slot, false)
            currentInventory.swapItem(item.name, data.currentSlot, item.count, item.meta, data.lastInventory, data.lastSlot)

            if data.inventoryType == 1 and lastInventory.checkIfEmpty() then
                for i = 1, #dropInventories, 1 do
                    if dropInventories[i].name == data.lastInventory then
                        table.remove(dropInventories, i)

                        TriggerClientEvent('crp-inventory:updateInventories', -1, dropInventories)
                    end
                end
            end

            callback({ status = true, splitItem = false })
        end
    else
        callback({ status = false })
    end
end)

AddEventHandler('crp-inventory:swapItems', function(source, data, callback)
    local lastInventory = GetInventory(data.lastInventory)
    local item = lastInventory.getItem(data.item, data.lastSlot)

    if item and item.count >= data.quantity then
        local currentInventory = GetInventory(data.currentInventory)
        local _item = currentInventory.getItem(data._item, data.currentSlot)

        if _item then
            if data.canStack and (item.count - data.quantity) > 0 then
                lastInventory.updateItem(data.item, data.lastSlot, (item.count - data.quantity))
                currentInventory.updateItem(data.item, data.currentSlot, (_item.count + data.quantity))

                callback({ status = true, stackItems = true, delete = false })
            else
                local status = { status = false }

                if data.canStack then
                    lastInventory.removeItem(data.item, data.lastSlot, true)
                    currentInventory.updateItem(data.item, data.currentSlot, (_item.count + data.quantity))

                    status = { status = true, stackItems = true, delete = true }
                elseif (item.count - data.quantity) == 0 then
                    lastInventory.removeItem(item.name, item.slot, false)
                    currentInventory.removeItem(_item.name, _item.slot, false)

                    lastInventory.swapItem(_item.name, data.lastSlot, _item.count, _item.meta, data.currentInventory, data.currentSlot)
                    currentInventory.swapItem(item.name, data.currentSlot, item.count, item.meta, data.lastInventory, data.lastSlot)

                    status = { status = true, swapItems = true }
                end

                callback(status)
            end
        else
            callback({ status = false })
        end
    else
        callback({ status = false })
    end
end)

AddEventHandler('crp-inventory:getInventories', function(source, inventory, callback)
    local user = exports['crp-base']:getCharacter(source)
    local inventoryName = user.getCharacterInventory()

    if isInventoryLoaded(inventoryName) and isInventoryLoaded(inventory) then
        callback({ player = inventories[inventoryName].items, secondary = inventories[inventory].items or nil })
    end
end)

AddEventHandler('crp-inventory:showActionBar', function(source, data, callback)
    local user = exports['crp-base']:getCharacter(source)
    local inventoryName = user.getCharacterInventory()

    if isInventoryLoaded(inventoryName) then
        callback(inventories[inventoryName].getActionBarItems())
    end
end)

AddEventHandler('crp-inventory:getItem', function(source, slot, callback)
    local user = exports['crp-base']:getCharacter(source)
    local inventoryName = user.getCharacterInventory()

    if isInventoryLoaded(inventoryName) then
        callback(inventories[inventoryName].getActionBarItem(slot))
    end
end)

RegisterServerEvent('crp-inventory:useItem')
AddEventHandler('crp-inventory:useItem', function(item, slot)
    local user = exports['crp-base']:getCharacter(source)
    local inventoryName = user.getCharacterInventory()

    if isInventoryLoaded(inventoryName) then
        local inventory = inventories[inventoryName]
        local item = inventory.getItem(item, slot)

        if item and (item.count - 1) > 0 then
            inventory.updateItem(item.name, slot, (item.count - 1))
        else
            inventory.removeItem(item.name, slot, true)
        end
    end
end)

function isInventoryLoaded(name)
    if inventories[name] ~= nil then
        return true
    end

    local maxWeight = 325

    if string.find(name, 'drop-') then
        local found = false

        for i = 1, #dropInventories, 1 do
            if dropInventories[i].name == name then
                found = true
                break
            end
        end

        if found then
            return true
        end

        maxWeight = 1000
    elseif string.find(name, 'character-') then
        maxWeight = 325
    end

    local isLoading = true

    exports.ghmattimysql:execute('SELECT * FROM inventory WHERE name = @name;', { ['@name'] = name }, function(result)
        local inventoriesItems = {}

        for k, v in ipairs(result) do
            if v.name == name then
                table.insert(inventoriesItems, { name = v.item, slot = v.slot, count = v.count, meta = json.decode(v.meta) })
            end
        end

        inventories[name], isLoading = CreateInventory(name, inventoriesItems, maxWeight), false
    end)

    while isLoading do
        Citizen.Wait(0)
    end

    return true
end

function CheckIfInventoryExists(inventory, coords)
    local found = false

    for i = 1, #dropInventories, 1 do
        if CompareCoords(dropInventories[i].coords, coords) or dropInventories[i].name == inventory then
            found = true
            return
        end
    end

    if not found then
        table.insert(dropInventories, { name = inventory, coords = coords })

        TriggerClientEvent('crp-inventory:updateInventories', -1, dropInventories)
    end
end

function CompareCoords(coords, _coords)
    if (coords.x == _coords.x and coords.y == _coords.y and coords.z == _coords.z) then
        return true
    end

    return false
end

function GetInventory(name)
    return inventories[name]
end