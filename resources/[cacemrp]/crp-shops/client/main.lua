local shopLocations = {
	[1]  = { ['x'] = 374.016,   ['y'] = 325.752,   ['z'] = 102.600, ['type'] = 'normalshop' },
	[2]  = { ['x'] = 1961.656,  ['y'] = 3740.457,  ['z'] = 31.373,  ['type'] = 'normalshop' },
	[3]  = { ['x'] = 1392.031,  ['y'] = 3604.588,  ['z'] = 34.050,  ['type'] = 'normalshop' },
	[4]  = { ['x'] = 547.482,   ['y'] = 2671.089,  ['z'] = 41.207,  ['type'] = 'normalshop' },
	[5]  = { ['x'] = 2557.637,  ['y'] = 382.383,   ['z'] = 107.673, ['type'] = 'normalshop' },
	[6]  = { ['x'] = -1820.613, ['y'] = 792.315,   ['z'] = 137.17,  ['type'] = 'normalshop' },
	[7]  = { ['x'] = -1222.978, ['y'] = -906.819,  ['z'] = 11.376,  ['type'] = 'normalshop' },
	[8]  = { ['x'] = -707.749,  ['y'] = -914.615,  ['z'] = 18.266,  ['type'] = 'normalshop' },
	[9]  = { ['x'] = 26.057,    ['y'] = -1347.581, ['z'] = 28.547,  ['type'] = 'normalshop' },
	[10] = { ['x'] = -48.689,   ['y'] = -1757.749, ['z'] = 28.471,  ['type'] = 'normalshop' },
	[11] = { ['x'] = 1163.307,  ['y'] = -324.086,  ['z'] = 68.255,  ['type'] = 'normalshop' },
	[12] = { ['x'] = 2679.075,  ['y'] = 3280.623,  ['z'] = 54.291,  ['type'] = 'normalshop' },
	[13] = { ['x'] = 1698.17,   ['y'] = 4924.784,  ['z'] = 41.114,  ['type'] = 'normalshop' },
	[14] = { ['x'] = 1729.135,  ['y'] = 6414.242,  ['z'] = 34.087,  ['type'] = 'normalshop' },
	[15] = { ['x'] = -2968.207, ['y'] = 390.342,   ['z'] = 14.093,  ['type'] = 'normalshop' },
	[16] = { ['x'] = -1487.078, ['y'] = -379.677,  ['z'] = 39.213,  ['type'] = 'normalshop' },
	[17] = { ['x'] = 22.269,    ['y'] = -1106.985, ['z'] = 28.847,  ['type'] = 'weaponshop' },
	[18] = { ['x'] = -662.017,  ['y'] = -935.074,  ['z'] = 20.879,  ['type'] = 'weaponshop' },
	[19] = { ['x'] = -1305.603, ['y'] = -394.556,  ['z'] = 35.746,  ['type'] = 'weaponshop' },
	[20] = { ['x'] = 252.367,   ['y'] = -50.223,   ['z'] = 68.991,  ['type'] = 'weaponshop' },
	[20] = { ['x'] = 809.956,   ['y'] = -2157.509, ['z'] = 28.669,  ['type'] = 'weaponshop' },
	[21] = { ['x'] = 842.094,   ['y'] = -1033.815, ['z'] = 27.245,  ['type'] = 'weaponshop' },
	[22] = { ['x'] = -1117.759, ['y'] = 2698.803,  ['z'] = 17.604,  ['type'] = 'weaponshop' },
	[23] = { ['x'] = -3172.099, ['y'] = 1088.034,  ['z'] = 19.889,  ['type'] = 'weaponshop' },
	[24] = { ['x'] = 1693.51,   ['y'] = 3760.129,  ['z'] = 33.755,  ['type'] = 'weaponshop' },
	[25] = { ['x'] = -330.373,  ['y'] = 6084.121,  ['z'] = 30.505,  ['type'] = 'weaponshop' }
}

local storeItems = {
	{ item = 129942349,   count = 50, slot = 1, price = 3    },
	{ item = 196068078,   count = 50, slot = 2, price = 50   },
	{ item = 130895348,   count = 50, slot = 3, price = 50   },
	{ item = 156805094,   count = 50, slot = 4, price = 50   },

	{ item = -2084633992, count = 50, slot = 5, price = 5000 },
	{ item = -1074790547, count = 50, slot = 6, price = 10   },
	{ item = 1649403952,  count = 50, slot = 7, price = 300  },
}

local weaponStoreItems = {
	{ item = 911657153,   count = 50, slot = 1, price = 1000  },
	{ item = 453432689,   count = 50, slot = 2, price = 5000  },
	{ item = -1076751822, count = 50, slot = 3, price = 10000 },
}

local hasAlreadyEnteredMarker, shopType

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep = false, false
    
        for k, v in pairs(shopLocations) do
            local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)

            if distance < 10.0 then
                DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 130, 201, 100, false, false, 2, false, nil, nil, false)
               
                letSleep = false

                if distance < 1.0 then
					isInMarker = true
					shopType   = v.type
                end
            end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = true
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
		end

		if letSleep then
			Citizen.Wait(500)
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if hasAlreadyEnteredMarker then
			local currentName, currentItems = 'loja de conveniência', {}

			if (shopType == 'weaponshop') then
				currentName, currentItems = 'loja de armas', weaponStoreItems

				DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abrir a ~g~loja de armas~s~.')
			else
				currentItems = storeItems

				DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abrir a ~g~loja~s~.')
			end

			if IsControlJustReleased(0, 38) then
                TriggerEvent('crp-inventory:openStore', currentName, currentItems)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function DisplayHelpText(string)
    SetTextComponentFormat('STRING')
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end