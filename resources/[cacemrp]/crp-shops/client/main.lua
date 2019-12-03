local Shops = {
    { x = 373.875,   y = 325.896,  z = 102.566 },
    { x = 2557.458,  y = 382.282,  z = 107.622 },
    { x = -3038.939, y = 585.954,  z = 6.908   },
    { x = -3241.927, y = 1001.462, z = 11.830  },
    { x = 547.431,   y = 2671.710, z = 41.156  },
    { x = 1961.464,  y = 3740.672, z = 31.343  },
    { x = 2678.916,  y = 3280.671, z = 54.241  },
    { x = 1729.216,  y = 6414.131, z = 34.037  }
}

local hasAlreadyEnteredMarker = false

Citizen.CreateThread(function()
    print('olaaaa')
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep, currentZone = false, false
    
        for k, v in pairs(Shops) do
            local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)

            if distance < 10.0 then
                DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 44, 130, 201, 100, false, false, 2, false, nil, nil, false)
               
                letSleep = false

                if distance < 1.0 then
                    isInMarker  = true
                end
            end
        end

		if isInMarker and not hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = true
            print('ola')
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
            print('TEXTE')
            DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abrir a ~g~loja~s~.')

			if IsControlJustReleased(0, 38) then
				
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