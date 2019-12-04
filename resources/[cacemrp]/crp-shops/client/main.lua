local Shops = {
    [1]  = { ['x'] = 373.875, ['y'] = 325.896, ['z'] = 102.566 },
}

local storeItems = {
	{ item = 129942349,   count = 50, slot = 1, price = 50   },
	{ item = 196068078,   count = 50, slot = 2, price = 50   },
	{ item = 130895348,   count = 50, slot = 3, price = 50   },
	{ item = 156805094,   count = 50, slot = 4, price = 50   },

	{ item = -2084633992, count = 50, slot = 5, price = 5000 },
	{ item = -1074790547, count = 50, slot = 6, price = 10   },
	{ item = 1649403952,  count = 50, slot = 7, price = 300  }
}

local hasAlreadyEnteredMarker

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep = false, false
    
        for k, v in pairs(Shops) do
            local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)

            if distance < 10.0 then
                DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 44, 130, 201, 100, false, false, 2, false, nil, nil, false)
               
                letSleep = false

                if distance < 1.5 then
                    isInMarker  = true
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
            DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abrir a ~g~loja~s~.')

			if IsControlJustReleased(0, 38) then
                TriggerEvent('crp-inventory:openStore', 'loja de conveniência', storeItems)
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