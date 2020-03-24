function CreateInventory(name, items, maxWeight)
	local self = {}

    self.name      = name
    self.maxWeight = maxWeight or 325
    self.items     = items or {}

    self.addItem = function(name, slot, count, meta)
        table.insert(self.items, { name = name, slot = slot, count = count, meta = meta or nil })

        exports.ghmattimysql:execute('INSERT INTO inventory (name, item, slot, count, meta) VALUES (@name, @item, @slot, @count, @meta);',
        { ['@name'] = self.name, ['@item'] = name, ['@slot'] = slot, ['@count'] = count, ['@meta'] = json.encode(meta) or nil })
    end

    self.updateItem = function(name, slot, count)
        local item = self.getItem(name, slot)

        item.count = count

        exports.ghmattimysql:execute('UPDATE inventory SET count = @count WHERE name = @name AND item = @item AND slot = @slot;',
        { ['@count'] = count, ['@name'] = self.name, ['@item'] = name, ['@slot'] = slot })
    end

    self.swapItem = function(name, slot, count, meta, _name, _slot)
        table.insert(self.items, { name = name, slot = slot, count = count, meta = meta or nil })

        exports.ghmattimysql:execute('UPDATE inventory SET name = @name, slot = @slot WHERE name = @_name AND item = @item AND slot = @_slot;',
        { ['@name'] = self.name, ['@slot'] = slot, ['@_name'] = _name, ['@item'] = name, ['@_slot'] = _slot })
    end

    self.removeItem = function(name, slot, state)
        for i = 1, #self.items, 1 do
            if self.items[i].name == name and tonumber(self.items[i].slot) == tonumber(slot) then
                table.remove(self.items, i)
                break
			end
        end

        if state then
            exports.ghmattimysql:execute('DELETE from inventory WHERE name = @name AND item = @item AND slot = @slot;',
            { ['@name'] = self.name, ['@item'] = name, ['@slot'] = slot })
        end
	end

    self.getItem = function(name, slot)
        for i = 1, #self.items, 1 do
            if tonumber(self.items[i].name) == tonumber(name) and tonumber(self.items[i].slot) == tonumber(slot) then
				return self.items[i]
			end
        end

        return false
    end

    self.checkIfEmpty = function()
        if string.find(self.name, 'drop') and #self.items <= 0 then
            return true
        end

        return false
    end

    self.getActionBarItems = function()
        local items = {}

        for i = 1, #self.items, 1 do
            if tonumber(self.items[i].slot) == 1 or tonumber(self.items[i].slot) == 2 or tonumber(self.items[i].slot) == 3 or tonumber(self.items[i].slot) == 4 then
                items[self.items[i].slot] = { name = self.items[i].name }
			end
        end

        return items
    end

    self.getActionBarItem = function(slot)
        for i = 1, #self.items, 1 do
            if tonumber(self.items[i].slot) == tonumber(slot) then
				return self.items[i]
			end
        end

        return nil
    end

    self.canMoveItem = function(item, count, slot)
        local item, inventoryWeight = self.getItem(name, slot), self.getInventoryWeight()

        if (inventoryWeight + (itemList[item.name].weight * count)) then
            return true
        end

        return false
    end

    self.getInventoryWeight = function()
        local weight = 0

        for i = 1, #self.items, 1 do
            local item = itemList[self.items[i].name]

            weight = weight + item.weight
        end

        return weight
    end

    self.updateAmmo = function(name, slot, ammo)
        local item = self.getItem(name, slot)

        if item then
            item.meta.ammo = ammo

            exports.ghmattimysql:execute('UPDATE inventory SET meta = @meta WHERE name = @name AND item = @item AND slot = @slot;',
            { ['@name'] = self.name, ['@slot'] = slot, ['@item'] = name, ['@meta'] = json.encode(item.meta) or nil })
        end
    end

	return self
end