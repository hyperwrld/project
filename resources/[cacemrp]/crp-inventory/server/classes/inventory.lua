function CreateInventory(data, items)
    local self = {}

    self.name      = data.name
    self.maxWeight = data.maxWeight or 325
    self.maxSlots  = data.maxSlots or 40
    self.items     = items or {}

    self.addItem = function(itemData, slot, count)
        table.insert(self.items, { name = itemData.name, slot = slot, count = count, meta = itemData.meta })

        exports.ghmattimysql:execute('INSERT INTO inventory (name, item, count, slot, meta) VALUES (@name, @item, @count, @slot, @meta)',
        { ['@name'] = self.name, ['@item'] = itemData.name, ['@count'] = count, ['@slot'] = slot, ['@meta'] = json.encode(itemData.meta) })
    end

    self.updateItem = function(name, slot, count)
        local item = self.getItem(slot)

        item.count = count

        exports.ghmattimysql:execute('UPDATE inventory SET count = @count WHERE name = @name AND item = @item AND slot = @slot;',
        { ['@count'] = count, ['@name'] = self.name, ['@item'] = name, ['@slot'] = slot })
    end

    self.swapItem = function(itemData, currentInventory, futureSlot)
        for i = 1, #self.items, 1 do
            if tonumber(self.items[i].slot) == tonumber(futureSlot) then
                table.remove(self.items, i)
                break
			end
        end

        table.insert(self.items, { name = itemData.name, slot = futureSlot, count = itemData.count, meta = itemData.meta })

        exports.ghmattimysql:execute('UPDATE inventory SET name = @futureInventory, slot = @futureSlot WHERE name = @currentInventory AND item = @itemName AND slot = @currentSlot;',
        { ['@futureInventory'] = self.name, ['@futureSlot'] = futureSlot, ['@currentInventory'] = currentInventory, ['@itemName'] = itemData.name, ['@currentSlot'] = itemData.slot })

        return true
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

        return true
	end

    self.getItem = function(slot)
        for i = 1, #self.items, 1 do
            if tonumber(self.items[i].slot) == tonumber(slot) then
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

    self.getInventoryWeight = function(itemSlot)
        local weight = 0

        for i = 1, #self.items, 1 do
            if not self.items[i].slot == itemSlot then
                local item = itemsList[self.items[i].name]

                weight = weight + item.weight
            end
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