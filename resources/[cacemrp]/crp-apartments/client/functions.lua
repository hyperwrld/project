function FloatTilSafe(roomType, building)
    local playerPed = GetPlayerPed(-1)

	SetEntityInvincible(playerPed, true)
    FreezeEntityPosition(playerPed, true)

    local coords = GetEntityCoords(playerPed)
    local status, counter = 3, 100

	while status == 3 do
        Citizen.Wait(100)

		if DoesEntityExist(building) then
			status = 2
        end

		if counter == 0 then
			status = 1
        end

		counter = counter - 1
	end

	if counter > 0 then
        SetEntityCoords(playerPed, coords)
		CleanUpPeds()
	elseif status == 1 then
		if roomType == 2 then
			SetEntityCoords(playerPed, 267.48, -638.81, 42.02)
		elseif roomType == 3 then
			SetEntityCoords(playerPed, 160.26, -641.96, 47.07)
		elseif roomType == 1 then
			SetEntityCoords(playerPed, 312.96, -218.27, 54.22)
		end
    end

    FreezeEntityPosition(playerPed, false)
end

function CleanUpInterior()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local handle, objectFound = FindFirstObject()
    local success

    repeat
        local position = GetEntityCoords(objectFound)
        local distance = #(coords - position)

        if distance < 50.0 and objectFound ~= playerPed then
            if IsEntityAPed(objectFound) then
        		if not IsPedAPlayer(objectFound) then
        			DeleteObject(objectFound)
        		end
        	elseif not IsEntityAVehicle(objectFound) and not IsEntityAttached(objectFound) then
	        	DeleteObject(objectFound)
        	end
        end

        success, objectFound = FindNextObject(handle)
    until not success

    EndFindObject(handle)

    TriggerEvent('crp-weather:weatherDesync', false)
end

function CleanUpPeds()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local handle, objectFound = FindFirstPed()
    local success

    repeat
        local position = GetEntityCoords(objectFound)
        local distance = #(coords - position)

        if distance < 50.0 and objectFound ~= playerPed then
    		if not IsPedAPlayer(objectFound) and not IsEntityAVehicle(objectFound) then
    			DeleteEntity(objectFound)
    		end
        end

        success, objectFound = FindNextPed(handle)
    until not success

    EndFindPed(handle)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)

    DrawText(_x, _y)

    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.005 + factor, 0.03, 41, 11, 41, 68)
end