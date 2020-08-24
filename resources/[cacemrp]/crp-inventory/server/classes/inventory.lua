function CreateInventory(data, items)
    local self = {}

    self.name      = data.name
    self.maxWeight = data.maxWeight or 325
    self.maxSlots  = data.maxSlots or 40
    self.items     = items or {}

    self.calculateWeight = function()
        local weight = 0

        for i = 1, #self.items, 1 do
            if self.items[i].slot ~= itemSlot then
                local item = itemsList[self.items[i].name]

                weight = weight + (item.weight * self.items[i].count)
            end
        end

        return weight
    end

    self.weight    = self.calculateWeight()

    self.getInventoryItem = function(slot)
        for i = 1, #self.items, 1 do
            if self.items[i].slot == slot then
                return self.items[i], i
            end
        end

		return false
    end

    self.addInventoryItem = function(name, slot, count, meta, creationTime)
        table.insert(self.items, { name = name, count = count, slot = slot, meta = meta, creationTime = creationTime})

        self.weight = self.weight + (itemsList[name].weight * count)

        exports.ghmattimysql:execute('INSERT INTO inventory (name, item, count, slot, meta, creation_time) VALUES (@name, @item, @count, @slot, @meta, @creationTime)', {
			['@name'] = self.name, ['@item'] = name, ['@count'] = count, ['@slot'] = slot, ['@meta'] = meta and json.encode(meta) or json.encode({}), ['@creationTime'] = creationTime
		})
    end

    self.removeInventoryItem = function(name, slot, state)
        local item, index = self.getInventoryItem(slot)

        if item then
            self.weight = self.weight - (itemsList[item.name].weight * item.count)

            table.remove(self.items, index)

            if state then
                exports.ghmattimysql:execute('DELETE from inventory WHERE name = @name AND item = @item AND slot = @slot;',
                { ['@name'] = self.name, ['@item'] = name, ['@slot'] = slot })
            end
		end
    end

    self.updateInventoryItem = function(name, slot, count)
        local item, index = self.getInventoryItem(slot)

        if item then
            self.weight = (self.weight - (itemsList[item.name].weight * item.count)) + (itemsList[name].weight * count)

            self.items[index].count = count

            exports.ghmattimysql:execute('UPDATE inventory SET count = @count WHERE name = @name AND item = @item AND slot = @slot;',
            { ['@count'] = count, ['@name'] = self.name, ['@item'] = name, ['@slot'] = slot })
        end
    end

    self.swapInventoryItem = function(itemData, currentInventory, currentSlot)
        local item, index = self.getInventoryItem(currentSlot)

        local weight = 0

        if item then
            weight = itemsList[item.name].weight * item.count
        end

        self.weight = (self.weight - weight) + (itemsList[itemData.name].weight * itemData.count)

        if item then
            self.items[index] = { name = itemData.name, slot = currentSlot, count = itemData.count, meta = itemData.meta, creationTime = itemData.creationTime }
        else
            table.insert(self.items, { name = itemData.name, slot = currentSlot, count = itemData.count, meta = itemData.meta, creationTime = itemData.creationTime })
        end

        exports.ghmattimysql:execute('UPDATE inventory SET name = @inventory, slot = @slot WHERE name = @currentInventory AND item = @name AND slot = @currentSlot;', {
			['@inventory'] = self.name, ['@slot'] = currentSlot, ['@currentInventory'] = currentInventory, ['@name'] = itemData.name, ['@currentSlot'] = itemData.slot
		})
    end

    self.canCarryItem = function(sameInventory, name, count, slot)
        if sameInventory then
            return true
        end

        if slot then
            local item, index = self.getInventoryItem(slot)

            return (self.weight - (itemsList[item.name].weight * item.count) + (itemsList[name].weight * count)) <= self.maxWeight
        else
            return (self.weight + (itemsList[name].weight * count)) <= self.maxWeight
        end
    end

    self.isEmpty = function()
        if string.find(self.name, 'drop') and #self.items <= 0 then
            return true
        end

        return false
    end

    self.getActionBarData = function()
        local items = {}

        for i = 1, #self.items, 1 do
            if self.items[i].slot >= 1 and self.items[i].slot <= 4 then
                items[self.items[i].slot] = { name = self.items[i].name, count = self.items[i].count, durability = self.items[i].durability }
            end
        end

        return items
    end

    return self
end