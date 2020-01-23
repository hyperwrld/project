local storeItems = {
	{ name = 129942349, count = 50, slot = 1, price = 3      }, { name = 196068078,   count = 50, slot = 2, price = 50   },
	{ name = 130895348, count = 50, slot = 3, price = 50     }, { name = 156805094,   count = 50, slot = 4, price = 50   },
    { name = -2084633992, count = 50, slot = 5, price = 5000 }, { name = -1074790547, count = 50, slot = 6, price = 10   },
	{ name = 1649403952,  count = 50, slot = 7, price = 300  },
}

local weaponStoreItems = {
	{ name = 911657153,   count = 50, slot = 1, price = 1000  },
	{ name = 453432689,   count = 50, slot = 2, price = 5000  },
	{ name = -1076751822, count = 50, slot = 3, price = 10000 },
}

local armoryItems = {
    { name = 156805094,   count = 50, slot = 1, price = 3 },
    { name = -2084633992, count = 50, slot = 2, price = 50, meta = { serial = true, ammo = 30 } },
    { name = 1737195953,  count = 50, slot = 3, price = 50, meta = { serial = true } },
    { name = 911657153,   count = 50, slot = 4, price = 50, meta = { serial = true, ammo = 1 } },
    { name = 1593441988,  count = 50, slot = 5, price = 50, meta = { serial = true, ammo = 30 } },
}

AddEventHandler('crp-inventory:getStoreItems', function(source, type, callback)
    local user, inventory = exports['crp-base']:GetCharacter(source), {}
    local inventoryName = user.GetCharacterInventory()

    if type == 1 then
        inventory = storeItems
    end

    if type == 2 then
        inventory = weaponStoreItems
    end

    if type == 3 then
        inventory = armoryItems
    end

    if isInventoryLoaded(inventoryName) then
        callback({ player = inventories[inventoryName].items, secondary = inventory })
    end
end)

AddEventHandler('crp-inventory:buyItem', function(source, data, callback)
    local user, inventory = exports['crp-base']:GetCharacter(source), {}
    local inventoryName = user.GetCharacterInventory()

    if data.shoptype == 1 then
        inventory = storeItems
    end

    if data.shoptype == 2 then
        inventory = weaponStoreItems
    end

    if data.shoptype == 3 then
        if user.GetJob().name ~= 'police' then
            return callback({ status = false, text = 'Só membros da polícia é que conseguem comprar este item.' })
        end

        inventory = armoryItems
    end

    local found, item = false, nil

    for i = 1, #inventory do
        if inventory[i].name == data.itemdata.item then
            found, item = true, inventory[i]
            break
        end
    end

    if not found then
        return callback({ status = false })
    end

    local characterMoney, itemPrice = user.GetMoney(), (data.itemdata.quantity * tonumber(item.price))

    if characterMoney >= itemPrice then
        local userInventory = inventories[inventoryName]

        user.RemoveMoney(itemPrice)

        if data.itemdata.canStack then
            local _item = userInventory.getItem(data.itemdata.item, data.itemdata.slot)

            if _item then
                userInventory.updateItem(data.itemdata.item, data.itemdata.slot, (data.itemdata.quantity + _item.count))

                callback({ status = true, stack = true, price = itemPrice })
            end
        else
            local meta = {}

            if item.meta then
                if item.meta.serial then
                    meta.serial = GetRandomString() .. '-'.. user.GetCharacterID()
                end

                if item.meta.ammo then
                    meta.ammo = item.meta.ammo
                end
            end

            userInventory.addItem(data.itemdata.item, data.itemdata.slot, data.itemdata.quantity, meta)

            callback({ status = true, stack = false, price = itemPrice })
        end
    else
        callback({ status = false, text = 'Não tens dinheiro suficiente.' })
    end
end)

function GetRandomString()
    local characterSet, output = 'abcdefghijklmnopqrstuvwxyz0123456789', ''

    for i = 1, 5 do
        local random = math.random(#characterSet)

        output = output .. string.sub(characterSet, random, random)
    end

    return output
end