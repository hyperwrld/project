local shopsData = {
	[1] = {
		name = 'Loja',
		permission = nil,
		items = {
			{
				item = 'CRP_CACETETE',
				count = 50,
				slot = 1,
				price = 3
			},
			{
				item = 'CRP_PISTOLA',
				count = 50,
				slot = 2,
				price = 50
			},
			{
				item = 'CRP_TASER',
				count = 50,
				slot = 3,
				price = 50
			},
			{
				item = 'CRP_BATATAS',
				count = 50,
				slot = 4,
				price = 30
			},
			{
				item = 'CRP_GAZUA',
				count = 50,
				slot = 5,
				price = 1
			}
		}
	},
	[2] = {
		name = 'Armamento',
		permission = 'police',
		items = {
			{
				item = 'CRP_CACETETE',
				count = 50,
				slot = 1,
				price = 500
			}
		}
	}
}

RPC:register('openShop', function(source, type)
    return openShop(source, type)
end)

RPC:register('buyItem', function(source, current, future, currentSlot, futureSlot, count, data)
	return buyItem(source, current, future, currentSlot, futureSlot, count, data)
end)

function openShop(source, type)
	local character = exports['crp-base']:getCharacter(source)
	local characterName = 'character-' .. character.getCharacterId()
	local first, shop = loadInventory(characterName, 40, 100), loadShop(source, type)

	if not first or not shop then
		return false
	end

	if not canOpenInventories(source, characterName) then
		return false
	end

	return true, {
		firstName = first.name, firstItems = first.items,
		secondItems = shop.items, secondName = shop.name, secondMaxWeight = shop.maxWeight,
		maxSlots = shop.maxSlots, type = shop.type, shopType = shop.shopType
	}
end

function loadShop(source, type)
	if not shopsData[type] or not hasPermission(source, type) then
		return false
	end

	local data = {
		name = shopsData[type].name, maxSlots = 40, maxWeight = 10000,
		items = shopsData[type].items, type = 5, shopType = type
	}

	return data
end

function buyItem(source, current, future, currentSlot, futureSlot, count, data)
	if not data.type == 5 or not inventories[future] then
		return false
	end

	if not openInventories[future] or openInventories[future].source ~= source then
		return false
	end

	if not shopsData[data.shopType] or not hasPermission(source, data.shopType) then
		return false
	end

	local shopItems = shopsData[data.shopType].items
	local found, itemData = shopHasItem(data.shopType, currentSlot)

	if not found then
		return false
	end

	if count <= 0 then
		count = itemData.count
	end

	if (itemData.count - count) < 0 then
		count = itemData.count
	end

	local itemPrice = (itemData.price * count)
	local character = exports['crp-base']:getCharacter(source)

	if not inventories[future].canCarry((current == future), itemData.item, count) then
		return false
	end

	local _data = inventories[future].getItemData(futureSlot)
	local currentSlotData, itemMeta = itemData, {}

	if itemData.count > count then
		currentSlotData.count = (itemData.count - count)
	end

	if _data then
		if itemData.item ~= _data.item or not getItemData(itemData.item).canStack or not inventories[future].useItem('CRP_DINHEIRO', itemPrice) then
			return false
		end

		inventories[future].updateItem(itemData.item, futureSlot, (_data.count + count))
	else
		if (not getItemData(itemData.item).canStack and count > 1) or not inventories[future].useItem('CRP_DINHEIRO', itemPrice) then
			return false
		end

		inventories[future].addItem(itemData.item, futureSlot, count, itemMeta, os.time(os.date("!*t")))
	end

	return true, currentSlotData, inventories[future].items
end

function hasPermission(source, shopType)
	if shopsData[shopType].permission == nil then
		return true
	end

	local character = exports['crp-base']:getCharacter(source)

	if character.getJob() == shopsData[shopType].permission then
		return true
	end

	return false
end

function shopHasItem(type, slot)
	for i = 1, #shopsData[type].items, 1 do
		if shopsData[type].items[i].slot == slot then
			return true, shopsData[type].items[i]
		end
	end

	return false
end