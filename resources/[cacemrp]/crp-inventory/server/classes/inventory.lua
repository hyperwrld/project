function createInventory(name, slots, weight, type, items, coords)
	local self = {}

	self.name, self.maxSlots = name, slots
	self.maxWeight, self.type = weight, type
	self.items, self.coords = items or {}, coords

	self.returnData = function()
		return {
			name = self.name,
			maxSlots = self.maxSlots,
			maxWeight = self.maxWeight,
			items = self.items,
			type = self.type,
			coords = self.coords
		}
	end

	self.calculateWeight = function()
        local weight = 0

        for i = 1, #self.items, 1 do
			if self.items[i].slot ~= itemSlot then
				local item = getItemData(self.items[i].name)

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
		local item = getItemData(name)

        table.insert(self.items, { item = name, count = count, slot = slot, meta = meta, creation_time = creationTime })

		self.currentWeight = self.currentWeight + (item.weight * count)

		local query = [[INSERT INTO inventory (name, item, count, slot, meta, creation_time) VALUES (?, ?, ?, ?, ?, ?);]]

		DB:Execute(query, self.name, name, count, slot, meta and json.encode(meta) or json.encode({}), creationTime)
	end

	self.removeItem = function(name, slot, state)
        local data, index = self.getSlotData(slot)

		if data then
			local item = getItemData(data.item)

            self.currentWeight = self.currentWeight - (item.weight * data.count)

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
			local item = getItemData(name)

			self.currentWeight = (self.currentWeight - (item.weight * data.count)) + (item.weight * count)

			self.items[index].count = count

			local query = [[UPDATE inventory SET count = ? WHERE name = ? AND item = ? AND slot = ?;]]

			DB:Execute(query, count, self.name, name, slot)
		end
	end

	self.swapItem = function(item, current, slot)
		local data, index = self.getSlotData(slot)
		local weight = 0

		if data then
			local itemData = getItemData(data.item)

			weight = itemData.weight * data.count

			self.items[index] = { item = item.item, slot = slot, count = item.count, meta = item.meta, creation_time = item.creation_time }
		else
			table.insert(self.items, { item = item.item, slot = slot, count = item.count, meta = item.meta, creation_time = item.creation_time })
		end

		local itemData = getItemData(item.item)

		self.currentWeight = (self.currentWeight - weight) + (itemData.weight * item.count)

		local query = [[UPDATE inventory SET name = ?, slot = ? WHERE name = ? AND item = ? AND slot = ?;]]

		DB:Execute(query, self.name, slot, current, item.item, item.slot)
	end

	self.canCarry = function(isSameInventory, name, count, slot)
		if isSameInventory then
			return true
		end

		local item = getItemData(name)

		if slot then
			local data, index = self.getSlotData(slot)
			local itemData = getItemData(data.item)

            return (self.currentWeight - (itemData.weight * data.count) + (item.weight * count)) <= self.maxWeight
		else
            return (self.currentWeight + (item.weight * count)) <= self.maxWeight
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
                items[self.items[i].slot] = { name = self.items[i].item, count = self.items[i].count, creation_time = self.items[i].creation_time }
            end
        end

        return items
	end

	return self
end