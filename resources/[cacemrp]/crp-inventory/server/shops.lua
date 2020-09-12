local shopItems = {
	[1] = {
		{ item = 129942349,   count = 50, slot = 1, price = 3    }, { item = 196068078,   count = 50, slot = 2, price = 50 },
		{ item = 130895348,   count = 50, slot = 3, price = 50   }, { item = 156805094,   count = 50, slot = 4, price = 50 },
		{ item = -2084633992, count = 50, slot = 5, price = 5000 }, { item = -1074790547, count = 50, slot = 6, price = 10 },
		{ item = 1649403952,  count = 50, slot = 7, price = 300  },
	}
}

RPC:register('openShop', function(source, type, name)
    return openShop(source, type, name)
end)

function openShop(source, type, name, shopType)
	local character = exports['crp-base']:GetCharacter(source)
	local firstInventory, shopInventory = loadInventory('character-' .. character.getCharacterID(), 40, 100), loadShop(name, type)

	if not firstInventory or not shopInventory then
		return false
	end

	return true, { player = firstInventory, secondary = shopInventory }
end

function loadShop(name, type)
	if not shopItems[type] then
		return false
	end

	local data = {
		name = name, maxSlots = 40,
		maxWeight = 10000, items = shopItems[type]
	}

	return data
end