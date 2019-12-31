function GetVehicleInDirection(coordsA, coordsB)
    local offset, rayHandle, vehicle = 0

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordsA.x, coordsA.y, coordsA.z, coordsB.x, coordsB.y, coordsB.z + offset, 10, GetPlayerPed(-1), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordsA, GetEntityCoords(vehicle))
	
	if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function GetClosestPlayer()
    local players, closestDistance, closestPlayer, playerPed = GetPlayers(), -1, -1, GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    if not IsPedInAnyVehicle(playerPed, false) then
        for i = 1, #players, 1 do
            local targetPed = GetPlayerPed(players[i])
            
            if targetPed ~= playerPed then
                local _coords = GetEntityCoords(targetPed)
                local distance = #(coords - _coords)

                if closestDistance == -1 or closestDistance > distance then
                    closestPlayer = players[i]
                    closestDistance = distance
                end
            end
        end

        return GetPlayerServerId(closestPlayer), closestDistance
    else
        exports['crp-notifications']:SendAlert('error', 'Não é possível fazer essa ação, porque estás num veículo.')
    end
end

function GetPlayers()
    local players = {}

	for k, player in ipairs(GetActivePlayers()) do
		local playerPed = GetPlayerPed(player)

		if DoesEntityExist(playerPed) then
			table.insert(players, player)
		end
	end

	return players
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
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

function DisplayHelpText(string)
    SetTextComponentFormat('STRING')
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end