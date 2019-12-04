local storeItems = { 
    [129942349] = { price = 3 }, [196068078] = { price = 200 }, [130895348] = { price = 150 }, [156805094] = { price = 20 }, 
    [-2084633992] = { price = 5000 }, [-1074790547] = { price = 10 }, [1649403952] = { price = 300 }
}

AddEventHandler('crp-shops:buyItem', function(source, data, callback)
    local character = exports['crp-base']:GetCharacter(source)
    local characterMoney, itemPrice = character.getMoney(), (data.quantity * storeItems[data.item].price)

    if characterMoney >= itemPrice then
        character.removeMoney(itemPrice)

        if data.canStack then
            exports.ghmattimysql:scalar('SELECT count FROM inventory WHERE name = @name AND item = @item AND slot = @slot;', {
                ['@name'] = data.inventory, ['@item'] = data.item, ['@slot'] = data.slot
            }, function(result)
                if result then
                    exports.ghmattimysql:execute('UPDATE inventory SET count = count + @quantity WHERE name = @name AND item = @item AND slot = @slot;', 
                    { ['@quantity'] = data.quantity, ['@name'] = data.inventory, ['@item'] = data.item, ['@slot'] = data.slot })

                    print(' teste')
                    callback({ status = true, stack = true})
                end
            end)
        else
            exports.ghmattimysql:execute('INSERT INTO inventory (count, item, slot, name) VALUES (@quantity, @item, @slot, @name);', 
            { ['@quantity'] = data.quantity, ['@name'] = data.inventory, ['@item'] = data.item, ['@slot'] = data.slot })

            callback({ status = true, stack = false })
        end
    else
        print(' não tens guito caralho')
        callback({ status = false })
    end
end)