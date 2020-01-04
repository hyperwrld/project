function GetVehicleInDirection(coordFrom, coordTo)
    local offset, rayHandle, vehicle = 0

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, GetPlayerPed(-1), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
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

        closestPlayer = GetPlayerServerId(closestPlayer)

        if closestPlayer == 0 then
            exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum jogador próximo.')
        else
            return closestPlayer, closestDistance
        end
    else
        exports['crp-notifications']:SendAlert('error', 'Não é possível fazer essa ação, porque estás num veículo.')
    end
end

function GetClosestPedIgnoreCar()
    local players, closestDistance, closestPlayer, closestPlayerId, playerPed = GetPlayers(), -1, -1, -1, GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed, 0)

    for k, v in ipairs(players) do
        local target = GetPlayerPed(v)

        if target ~= playerPed then
            local _coords = GetEntityCoords(GetPlayerPed(v), 0)
            local distance = #(coords - _coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer, closestPlayerId, closestDistance = target, v, distance
            end
        end
    end
    
	return closestPlayer, closestDistance, closestPlayerId
end

function GetClosestPlayerIgnoreCar()
	local players, closestDistance, closestPlayer, playerPed = GetPlayers(), -1, -1, GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed, 0)

	for k, v in ipairs(players) do
        local target = GetPlayerPed(v)
        
		if target ~= playerPed then
			local _coords = GetEntityCoords(GetPlayerPed(v), 0)
            local distance = #(coords - _coords)
            
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer, closestDistance = v, distance
            end
		end
	end
	
	return closestPlayer, closestDistance
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

function LoadAnimation(dictionary)
    while (not HasAnimDictLoaded(dictionary)) do
        RequestAnimDict(dictionary)

        Citizen.Wait(5)
    end
end