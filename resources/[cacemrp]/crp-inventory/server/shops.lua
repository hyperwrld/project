local storeItems = {
	{ name = 129942349,   count = 50, slot = 1, price = 3    }, { name = 196068078,   count = 50, slot = 2, price = 50 },
	{ name = 130895348,   count = 50, slot = 3, price = 50   }, { name = 156805094,   count = 50, slot = 4, price = 50 },
    { name = -2084633992, count = 50, slot = 5, price = 5000 }, { name = -1074790547, count = 50, slot = 6, price = 10 },
	{ name = 1649403952,  count = 50, slot = 7, price = 300  },
}

function getShopItems(shopType)
	if shopType == 1 then
		return storeItems
	end
end