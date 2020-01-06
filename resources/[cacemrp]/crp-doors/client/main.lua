local doorList = {
    -- ! Los Santos Station

    [1] = { name = 'v_ilev_ph_gendoor004', coords = vector3(449.6, -986.4, 30.6),  authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [2] = { name = 'v_ilev_ph_gendoor002', coords = vector3(447.2, -980.6, 30.6),  authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [3] = { name = 'v_ilev_arm_secdoor',   coords = vector3(452.6, -982.7, 30.6),  authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [4] = { name = 'v_ilev_arm_secdoor',   coords = vector3(461.2, -985.3, 30.8),  authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [5] = { name = 'v_ilev_gtdoor02',      coords = vector3(464.3, -984.6, 43.8),  authorizedJob = 'police', locked = true, x =  1.2, y = 0.0, z =  0.1 },
    [6] = { name = 'v_ilev_ph_gendoor005', coords = vector3(443.9, -989.0, 30.6),  authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [7] = { name = 'v_ilev_ph_gendoor005', coords = vector3(445.3, -988.7, 30.6),  authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },

    -- ! Paleto Bay Station

    [8]  = { name = 'v_ilev_bk_door2',      coords = vector3(-442.8, 6010.9, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [9]  = { name = 'v_ilev_bk_door2',      coords = vector3(-440.9, 6012.7, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [10] = { name = 'v_ilev_cf_officedoor', coords = vector3(-437.6, 6008.3, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [11] = { name = 'v_ilev_cf_officedoor', coords = vector3(-441.0, 6004.9, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [12] = { name = 'v_ilev_rc_door2',      coords = vector3(-449.7, 6015.4, 31.8), authorizedJob = 'police', locked = true, x =  1.2, y = 0.0, z =  0.1 },
    [13] = { name = 'v_ilev_cd_entrydoor',  coords = vector3(-454.5, 6011.2, 31.8), authorizedJob = 'police', locked = true, x =  1.2, y = 0.0, z =  0.1 },
    [14] = { name = 'v_ilev_ss_door8',      coords = vector3(-447.7, 6006.7, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [15] = { name = 'v_ilev_ss_door7',      coords = vector3(-449.5, 6008.5, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [16] = { name = 'v_ilev_gc_door01',     coords = vector3(-450.9, 6006.0, 31.9), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [17] = { name = 'v_ilev_gc_door01',     coords = vector3(-447.2, 6002.3, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [18] = { name = 'v_ilev_ph_cellgate',   coords = vector3(-432.1, 5992.1, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [19] = { name = 'v_ilev_ph_cellgate',   coords = vector3(-428.0, 5996.6, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [20] = { name = 'v_ilev_ph_cellgate',   coords = vector3(-431.1, 5999.7, 31.8), authorizedJob = 'police', locked = true, x = -1.2, y = 0.0, z = -0.1 },
    [21] = { name = 'v_ilev_fingate',       coords = vector3(-437.6, 5992.8, 31.9), authorizedJob = 'police', locked = true, x =  1.2, y = 0.0, z =  0.1 },
}

local isActive, userJob = false, 'unemployed'

Citizen.CreateThread(function()
    local events = exports['crp-base']:getModule('Events')

    events:Trigger('crp-doors:getDoorsInfo', nil, function(doorInfo)
        for door, state in pairs(doorInfo) do
			doorList[door].locked = state
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
        for _, door in ipairs(doorList) do
            door.object = GetClosestObjectOfType(door.coords, 1.0, GetHashKey(door.name), false, false, false)
		end

		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local closestDoor, closestDistance, closestTimer = 0, 1000, 500000

		for k, door in ipairs(doorList) do
            local distance = #(playerCoords - door.coords)

            if distance < closestTimer then
                closestTimer = math.floor(distance)
            end

            if distance < closestDistance and distance < 50 then
                closestTimer = 0

                local maxDistance, displayText = 1.55, 'Destrancada'

                if door.distance then
                    maxDistance = door.distance
                end

                FreezeEntityPosition(door.object, door.locked)

                if distance < maxDistance then
                    closestDoor, closestDistance = door, distance

                    local isAuthorized = IsAuthorized(door)

                    if door.locked then
                        displayText = 'Trancada'
                    end

                    if isAuthorized then
                        displayText = '[E] ' .. displayText
                    end

                    if (door.textcoords and not door.locked) or (not door.textcoords) then
                        door.textcoords = GetOffsetFromEntityInWorldCoords(door.object, door.x, door.y, door.z)
                    end

                    DrawText3D(door.textcoords.x, door.textcoords.y, door.textcoords.z, displayText)

                    if isAuthorized and IsControlJustReleased(0, 38) then
                        TriggerAnimation()

                        TriggerServerEvent('interact-sound:playWithinDistance', 2.5, 'doors', 0.1)

                        if door.locked then
                            local keepRunning, count = true, 0

                            while keepRunning do
                                Citizen.Wait(0)

                                DrawText3D(door.textcoords.x, door.textcoords.y, door.textcoords.z, 'Destrancando')

                                count = count + 1

                                if count > 100 then
                                    keepRunning = false
                                end
                            end
                        else
                            local keepRunning, count, swing = true, 0, 0

                            while keepRunning do
                                Citizen.Wait(0)

                                local locked, heading = GetStateOfClosestDoorOfType(GetHashKey(door.name), door.coords.x, door.coords.y, door.coords.z)

                                heading = math.ceil(heading * 100)

                                local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), door.coords.x, door.coords.y, door.coords.z, true)

                                door.textcoords = GetOffsetFromEntityInWorldCoords(door.object, door.x, door.y, door.z)

                                DrawText3D(door.textcoords.x, door.textcoords.y, door.textcoords.z, 'Trancando')

                                count = count + 1

                                if heading < 1.5 and heading > -1.5 then
                                    swing = swing + 1
                                end

                                if distance > 150.0 or swing > 100 or count > 500 then
                                    keepRunning = false
                                end
                            end
                        end

                        door.locked = not door.locked
                        TriggerServerEvent('crp-doors:updateState', k, door.locked)
                    end
                end
            end
        end

        if closestTimer > 50 and closestTimer ~= 500000 then
            Citizen.Wait(math.ceil(closestTimer * 25))
        end
	end
end)

RegisterNetEvent('crp-doors:setState')
AddEventHandler('crp-doors:setState', function(door, state)
	doorList[door].locked = state
end)

AddEventHandler('crp-userinfo:updateJob', function(_job)
    userJob = _job
end)

function IsAuthorized(door)
    if door.authorizedJob == userJob then
        return true
    end

	return false
end

function TriggerAnimation()
    local playerPed, dictionary = GetPlayerPed(-1), 'anim@heists@keycard@'

    ClearPedSecondaryTask(playerPed)

    while (not HasAnimDictLoaded(dictionary)) do
        RequestAnimDict(dictionary)

        Citizen.Wait(5)
    end

    TaskPlayAnim(playerPed, dictionary, 'exit', 8.0, 1.0, -1, 16, 0, 0, 0, 0)

    Citizen.Wait(850)

    ClearPedTasks(playerPed)
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