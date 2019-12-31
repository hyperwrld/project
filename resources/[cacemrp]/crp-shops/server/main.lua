-- local storeItems = { 
--     [129942349] = { price = 3 }, [196068078] = { price = 200 }, [130895348] = { price = 150 }, [156805094] = { price = 20 }, 
--     [-2084633992] = { price = 5000 }, [-1074790547] = { price = 10 }, [1649403952] = { price = 300 }
-- }

local storeItems = {
	{ item = 129942349, count = 50, slot = 1, price = 3      }, { item = 196068078,   count = 50, slot = 2, price = 50   },
	{ item = 130895348, count = 50, slot = 3, price = 50     }, { item = 156805094,   count = 50, slot = 4, price = 50   },
    { item = -2084633992, count = 50, slot = 5, price = 5000 }, { item = -1074790547, count = 50, slot = 6, price = 10   },
	{ item = 1649403952,  count = 50, slot = 7, price = 300  },
}

local weaponStoreItems = {
	{ item = 911657153,   count = 50, slot = 1, price = 1000  },
	{ item = 453432689,   count = 50, slot = 2, price = 5000  },
	{ item = -1076751822, count = 50, slot = 3, price = 10000 },
}

local armoryItems = {
    { item = 156805094,  count = 50, slot = 1, price = 3    }, { item = -2084633992, count = 50, slot = 2, price = 50 }, 
    { item = 1737195953, count = 50, slot = 3, price = 50   }, { item = 911657153,   count = 50, slot = 4, price = 50 }, 
    { item = 1593441988, count = 50, slot = 5, price = 5000 }, 
}

AddEventHandler('crp-shops:getStoreItems', function(source, data, callback)
    local character = exports['crp-base']:GetCharacter(source)

    if character.getCharacterID() == data.id then
        local inventory = {}

        if data.type == 1 then 
            inventory = storeItems 
        elseif data.type == 2 then 
            inventory = weaponStoreItems 
        elseif data.type == 3 then
            inventory = armoryItems 
        end

        exports.ghmattimysql:execute('SELECT * FROM inventory WHERE name = @name;', {
            ['@name'] = 'character-' .. data.id
        }, function(result)
            callback({ player = result, secondary = inventory })
        end)
    else
        print('player tried to acess another player inventory')
    end
end)

AddEventHandler('crp-shops:buyItem', function(source, data, callback)
    local character, inventory = exports['crp-base']:GetCharacter(source), {}

    if data.shoptype == 1 then 
        inventory = storeItems 
    elseif data.shoptype == 2 then 
        inventory = weaponStoreItems 
    elseif data.shoptype == 3 then
        inventory = armoryItems
   
        if character.getJob().name == 'police' then 
            return callback({ status = false, text = 'Só membros da polícia é que conseguem comprar este item.' }) 
        end
    end

    local found, item = GetItem(inventory, data.itemdata.item)

    if not found then return callback({ status = false }) end

    local characterMoney, itemPrice = character.getMoney(), (data.itemdata.quantity * tonumber(item.price))

    if characterMoney >= itemPrice then
        character.removeMoney(itemPrice)

        if data.itemdata.canStack then
            exports.ghmattimysql:scalar('SELECT count FROM inventory WHERE name = @name AND item = @item AND slot = @slot;', {
                ['@name'] = data.itemdata.inventory, ['@item'] = data.itemdata.item, ['@slot'] = data.itemdata.slot
            }, function(result)
                if result then
                    exports.ghmattimysql:execute('UPDATE inventory SET count = count + @quantity WHERE name = @name AND item = @item AND slot = @slot;', 
                    { ['@quantity'] = data.itemdata.quantity, ['@name'] = data.itemdata.inventory, ['@item'] = data.itemdata.item, ['@slot'] = data.itemdata.slot })

                    callback({ status = true, stack = true, price = itemPrice })
                end
            end)
        else
            if data.itemdata.isWeapon then
                exports.ghmattimysql:execute('INSERT INTO inventory (count, item, slot, name, information) VALUES (@quantity, @item, @slot, @name, @info);', 
                { ['@quantity'] = data.itemdata.quantity, ['@name'] = data.itemdata.inventory, ['@item'] = data.itemdata.item, ['@slot'] = data.itemdata.slot, ['@info'] = json.encode({ serial = character.getCharacterID(), ammo = 60 }) })
            else
                exports.ghmattimysql:execute('INSERT INTO inventory (count, item, slot, name) VALUES (@quantity, @item, @slot, @name);', 
                { ['@quantity'] = data.itemdata.quantity, ['@name'] = data.itemdata.inventory, ['@item'] = data.itemdata.item, ['@slot'] = data.itemdata.slot })
            end

            callback({ status = true, stack = false, price = itemPrice })
        end
    else
        callback({ status = false, text = 'Não tens dinheiro suficiente.' })
    end
end)

function GetItem(inventory, item)
    local found, data = false, nil

    for i = 1, #inventory do
        if inventory[i].item == item then
            found, data = true, inventory[i]
        end
    end

    return found, data
end