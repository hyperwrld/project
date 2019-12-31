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