local bedCoords = {
    { ['x'] = 324.244, ['y'] = -582.822, ['z'] = 44.204 },
    { ['x'] = 322.631, ['y'] = -586.968, ['z'] = 44.204 },
    { ['x'] = 317.734, ['y'] = -585.263, ['z'] = 44.204 },
    { ['x'] = 319.472, ['y'] = -580.983, ['z'] = 44.204 },
    { ['x'] = 314.49,  ['y'] = -584.069, ['z'] = 44.204 },
    { ['x'] = 313.82,  ['y'] = -578.99,  ['z'] = 44.204 },
    { ['x'] = 310.979, ['y'] = -582.906, ['z'] = 44.204 },
    { ['x'] = 307.742, ['y'] = -581.687, ['z'] = 44.204 },
    { ['x'] = 309.386, ['y'] = -577.331, ['z'] = 44.204 }
}

function CheckInHospital()
    local playerPed, bed, _bedCoords = GetPlayerPed(-1), nil, 0

    for i, values in ipairs(bedCoords) do
        bed = GetClosestObjectOfType(values['x'], values['y'], values['z'], 2.0, 'V_Med_bed1', false, false, false)
        _bedCoords = GetEntityCoords(bed)

        if CheckHospitalBed(_bedCoords) then
            break
        else
            bed, _bedCoords = nil, 0
        end
    end

    if bed ~= nil and DoesEntityExist(bed) then
        isOnBed = true

        DoScreenFadeOut(1000)

        Citizen.Wait(1000)

        SetEntityCoords(playerPed, _bedCoords)

        -- ! Pagar por ser tratado e avisar quanto é que pagou

        exports['crp-notifications']:SendPersistantAlert('start', 'bed', 'inform', '[E] para sair da cama')

        LoadAnimation('missfinale_c1@')

        ClearPedTasksImmediately(playerPed)

        TaskPlayAnim(playerPed, 'missfinale_c1@', 'lying_dead_player0', 8.0, 1.0, -1, 1, 0, 0, 0, 0)

        DoScreenFadeIn(3000)

        while isOnBed do
            Citizen.Wait(0)

            AttachEntityToEntity(playerPed, bed, 1, -0.2, -0.2, 1.4, 0.0, 0.0, 180.0, true, true, true, true, 1, true)

            if IsControlJustReleased(0, 38) then
                isOnBed = false

                DetachEntity(GetPlayerPed(-1), 1, true)
            end
        end

        SetEntityHeading(GetEntityHeading(playerPed) - 90)

        exports['crp-notifications']:SendPersistantAlert('end', 'bed')

        DetachEntity(playerPed, 1, true)
    end
end

RegisterCommand('teste', function(source, args)
    local bedCoords = GetEntityCoords(GetPlayerPed(-1))
    print(bedCoords.x, bedCoords.y, bedCoords.z)
    local obj = GetClosestObjectOfType(bedCoords.x, bedCoords.y, bedCoords.z, 4.0, 'gabz_pillbox_doubledoor_l', false, false, false)

    local objCoords = GetEntityCoords(obj)

    SetEntityCoords(GetPlayerPed(-1), objCoords)
    print(obj, objCoords)
end, false)

function CheckHospitalBed(coords)
    local players, playerPed = GetPlayers(), GetPlayerPed(-1)

    for k, v in ipairs(players) do
        local target = GetPlayerPed(v)

		if target ~= playerPed then
			local _coords = GetEntityCoords(target, 0)
            local distance = #(coords - _coords)

            if distance <= 2.5 then
                return false
            end
		end
    end
    return true
end

function FastTravel(coords)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(500)
    end

    if DoesEntityExist(playerPed) then
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(playerPed) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityHeading(playerPed, coords.h)

        DoScreenFadeIn(800)
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

function LoadAnimation(dictionary)
    while (not HasAnimDictLoaded(dictionary)) do
        RequestAnimDict(dictionary)

        Citizen.Wait(5)
    end
end