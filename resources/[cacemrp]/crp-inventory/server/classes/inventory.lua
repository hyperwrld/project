function createInventory(name, slots, weight, type, items)
	local self = {}

	self.name, self.maxSlots = name, slots
	self.maxWeight, self.type = weight, type
	self.items = items or {}

	self.returnData = function()
		return {
			name = self.name,
			maxSlots = self.maxSlots,
			maxWeight = self.maxWeight,
			items = self.items
		}
	end

	self.calculateWeight = function()
        local weight = 0

        for i = 1, #self.items, 1 do
			if self.items[i].slot ~= itemSlot then
				local item = itemsList[self.items[i].name]

				if (item) then
					weight = weight + (item.weight * self.items[i].count)
				end
            end
        end

        return weight
	end

	self.currentWeight = self.calculateWeight()

	self.getSlotData = function(slot)
		for i = 1, #self.items, 1 do
			if self.items[i].slot == slot then
                return self.items[i], i
            end
		end

		return false
	end

	self.getItemData = function(slot)
		for i = 1, #self.items, 1 do
			if self.items[i].slot == slot then
                return self.items[i]
            end
		end

		return false
	end

	self.addItem = function(name, slot, count, meta, creationTime)
        table.insert(self.items, { item = name, count = count, slot = slot, meta = meta, creation_time = creationTime })

		self.currentWeight = self.currentWeight + (itemsList[name].weight * count)

		local query = [[INSERT INTO inventory (name, item, count, slot, meta, creation_time) VALUES (?, ?, ?, ?, ?, ?);]]

		DB:Execute(query, self.name, name, count, slot, meta and json.encode(meta) or json.encode({}), creationTime)
	end

	self.removeItem = function(name, slot, state)
        local data, index = self.getSlotData(slot)

        if data then
            self.currentWeight = self.currentWeight - (itemsList[data.item].weight * data.count)

            table.remove(self.items, index)

			if state then
				local query = [[DELETE FROM inventory WHERE name = ? AND item = ? AND slot = ?;]]

				DB:Execute(query, self.name, name, slot)
            end
		end
	end

	self.updateItem = function(name, slot, count)
		local data, index = self.getSlotData(slot)

		if data then
			self.currentWeight = (self.currentWeight - (itemsList[data.item].weight * data.count)) + (itemsList[name].weight * count)

			self.items[index].count = count

			local query = [[UPDATE inventory set count = ? WHERE name = ? AND item = ? AND slot = ?;]]

			DB:Execute(query, count, self.name, name, slot)
		end
	end

	self.swapItem = function(item, current, slot)
		local data, index = self.getSlotData(slot)
		local weight = 0

		if data then
			weight = itemsList[data.item].weight * data.count

			self.items[index] = { item = item.item, slot = slot, count = item.count, meta = item.meta, creation_time = item.creation_time }
		else
			table.insert(self.items, { item = item.item, slot = slot, count = item.count, meta = item.meta, creation_time = item.creation_time })
		end

		self.currentWeight = (self.currentWeight - weight) + (itemsList[item.item].weight * item.count)

		local query = [[UPDATE inventory SET name = ?, slot = ? WHERE name = ? AND item = ? AND slot = ?;]]

		DB:Execute(query, self.name, slot, current, item.item, item.slot)
	end

	self.canCarry = function(isSameInventory, name, count, slot)
		if isSameInventory then
			return true
		end

		if slot then
			local data, index = self.getSlotData(slot)

            return (self.currentWeight - (itemsList[data.item].weight * data.count) + (itemsList[name].weight * count)) <= self.maxWeight
		else
            return (self.currentWeight + (itemsList[name].weight * count)) <= self.maxWeight
        end
	end

	self.isEmpty = function()
		if self.type == 1 and #self.items <= 0 then
			return true
		end

        return false
	end

	self.getActionBarItems = function()
		local items = {}

        for i = 1, #self.items, 1 do
            if self.items[i].slot >= 1 and self.items[i].slot <= 4 then
                items[self.items[i].slot] = { name = self.items[i].item, count = self.items[i].count, durability = self.items[i].durability }
            end
        end

        return items
	end

	return self
end