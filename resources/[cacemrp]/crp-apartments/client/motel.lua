local apartments = {
	[1]  = { ['x'] = 312.96, ['y'] = -218.27, ['z'] = 54.22 }, [2]  = { ['x'] = 311.27, ['y'] = -217.74, ['z'] = 54.22 },
	[3]  = { ['x'] = 307.63, ['y'] = -216.43, ['z'] = 54.22 }, [4]  = { ['x'] = 307.71, ['y'] = -213.40, ['z'] = 54.22 },
	[5]  = { ['x'] = 309.95, ['y'] = -208.48, ['z'] = 54.22 }, [6]  = { ['x'] = 311.78, ['y'] = -203.50, ['z'] = 54.22 },
	[7]  = { ['x'] = 313.72, ['y'] = -198.61, ['z'] = 54.22 }, [8]  = { ['x'] = 315.53, ['y'] = -195.24, ['z'] = 54.22 },
	[9]  = { ['x'] = 319.23, ['y'] = -196.43, ['z'] = 54.22 }, [10] = { ['x'] = 321.08, ['y'] = -197.23, ['z'] = 54.22 },
	[11] = { ['x'] = 312.98, ['y'] = -218.36, ['z'] = 58.01 }, [12] = { ['x'] = 311.10, ['y'] = -217.64, ['z'] = 58.01 },
	[13] = { ['x'] = 307.37, ['y'] = -216.34, ['z'] = 58.01 }, [14] = { ['x'] = 307.76, ['y'] = -213.59, ['z'] = 58.01 },
	[15] = { ['x'] = 309.76, ['y'] = -208.25, ['z'] = 58.01 }, [16] = { ['x'] = 311.48, ['y'] = -203.75, ['z'] = 58.01 },
	[17] = { ['x'] = 313.65, ['y'] = -198.22, ['z'] = 58.01 }, [18] = { ['x'] = 315.47, ['y'] = -195.19, ['z'] = 58.01 },
	[19] = { ['x'] = 319.39, ['y'] = -196.58, ['z'] = 58.01 }, [20] = { ['x'] = 321.19, ['y'] = -197.31, ['z'] = 58.01 },
	[21] = { ['x'] = 329.49, ['y'] = -224.92, ['z'] = 54.22 }, [22] = { ['x'] = 331.33, ['y'] = -225.56, ['z'] = 54.22 },
	[23] = { ['x'] = 335.18, ['y'] = -227.14, ['z'] = 54.22 }, [24] = { ['x'] = 336.71, ['y'] = -224.66, ['z'] = 54.22 },
	[25] = { ['x'] = 338.79, ['y'] = -219.11, ['z'] = 54.22 }, [26] = { ['x'] = 340.43, ['y'] = -214.78, ['z'] = 54.22 },
	[27] = { ['x'] = 342.28, ['y'] = -209.32, ['z'] = 54.22 }, [28] = { ['x'] = 344.39, ['y'] = -204.45, ['z'] = 54.22 },
	[29] = { ['x'] = 346.75, ['y'] = -197.52, ['z'] = 54.23 }, [30] = { ['x'] = 329.70, ['y'] = -224.65, ['z'] = 58.01 },
	[31] = { ['x'] = 331.52, ['y'] = -225.52, ['z'] = 58.01 }, [32] = { ['x'] = 335.16, ['y'] = -227.07, ['z'] = 58.01 },
	[33] = { ['x'] = 336.35, ['y'] = -224.58, ['z'] = 58.01 }, [34] = { ['x'] = 338.56, ['y'] = -219.34, ['z'] = 58.01 },
	[35] = { ['x'] = 340.50, ['y'] = -214.33, ['z'] = 58.01 }, [36] = { ['x'] = 342.41, ['y'] = -209.25, ['z'] = 58.01 },
	[37] = { ['x'] = 344.03, ['y'] = -204.98, ['z'] = 58.01 }, [38] = { ['x'] = 346.08, ['y'] = -199.59, ['z'] = 58.01 },
}

isInside, currentRoomNumber = false, 0
currentRoomCoords = { x = 175.09 , y = -904.79, z = -98.99 }

RegisterNetEvent('crp-apartments:buildHotelInterior')
AddEventHandler('crp-apartments:buildHotelInterior', function(number, roomType)
    local playerPed = GetPlayerPed(-1)

    isInside, currentRoomNumber = true, number

    TriggerEvent('crp-weather:weatherDesync', true)

    SetEntityCoords(playerPed, 151.38, -1007.73, -99.0, false, false, false, true)

    Citizen.Wait(3000)

    local generator = { x = 152.98, y = -1004.04, z = -78.65 }

    generator.x = (175.09) + ((number * 12.0))

    currentRoomCoords = generator

    SetEntityCoords(playerPed, generator.x - 1.6, generator.y - 4.0, generator.z, false, false, false, true)
    SetEntityHeading(playerPed, 1.0)

    local building = CreateObject(GetHashKey('v_49_motelmp_shell'), generator.x, generator.y, generator.z, false, false, false)

    FreezeEntityPosition(building, true)

    Citizen.Wait(100)

    FloatTilSafe(type, building)

    CreateObject(GetHashKey('v_49_motelmp_stuff'), generator.x, generator.y, generator.z + 0.05, false, false, false)
    CreateObject(GetHashKey('v_49_motelmp_bed'), generator.x + 1.4, generator.y - 0.55, generator.z + 0.049, false, false, false)
    CreateObject(GetHashKey('v_49_motelmp_clothes'), generator.x - 2.04, generator.y + 2.03, generator.z + 0.193, false, false, false)
	CreateObject(GetHashKey('v_49_motelmp_winframe'), generator.x + 0.745, generator.y - 4.26, generator.z + 1.122, false, false, false)
    CreateObject(GetHashKey('v_49_motelmp_glass'), generator.x + 0.74, generator.y - 4.26, generator.z + 1.15, false, false,false)
    CreateObject(GetHashKey('v_49_motelmp_curtains'), generator.x + 0.74, generator.y - 4.16, generator.z + 0.95, false, false, false)
    CreateObject(GetHashKey('v_49_motelmp_screen'), generator.x - 2.21, generator.y - 0.6, generator.z + 0.85, false, false, false)
    CreateObject(GetHashKey('v_res_binder'), generator.x - 2.2, generator.y + 1.3, generator.z + 0.91, false, false, false)

	local firstTenis = CreateObject(GetHashKey('v_res_fa_trainer02r'), generator.x - 2.1, generator.y + 2.98, generator.z + 0.407, false, false, false)
    local secondTenis = CreateObject(GetHashKey('v_res_fa_trainer02l'), generator.x - 2.1, generator.y + 2.79, generator.z + 0.407, false, false, false)
    local sink = CreateObject(GetHashKey('prop_sink_06'), generator.x + 1.1, generator.y + 4.0, generator.z + 0.05, false, false, false)

    SetEntityHeading(firstTenis, GetEntityHeading(firstTenis) - 60)
    SetEntityHeading(secondTenis, GetEntityHeading(secondTenis) - 60)

    FreezeEntityPosition(sink, true)

    local firstChair = CreateObject(GetHashKey('prop_chair_04a'), generator.x + 2.1, generator.y - 2.4, generator.z + 0.04, false, false, false)
    local secondChair = CreateObject(GetHashKey('prop_chair_04a'), generator.x + 0.7, generator.y - 3.5, generator.z + 0.04, false, false, false)

    SetEntityHeading(firstChair, GetEntityHeading(firstChair) + 270)
    SetEntityHeading(secondChair, GetEntityHeading(secondChair) + 180)

    FreezeEntityPosition(firstChair, true)
    FreezeEntityPosition(secondChair, true)

    local kettle = CreateObject(GetHashKey('prop_kettle'), generator.x - 2.3, generator.y + 0.6, generator.z + 0.9, false, false, false)
    local tvCabinet = CreateObject(GetHashKey('prop_tv_cabinet_03'), generator.x - 2.3, generator.y - 0.6, generator.z + 0.05, false, false, false)
    local tv = CreateObject(GetHashKey('prop_tv_06'), generator.x - 2.3, generator.y - 0.6, generator.z + 0.762, false, false, false)

    SetEntityHeading(kettle, GetEntityHeading(kettle) + 90)
    SetEntityHeading(tvCabinet, GetEntityHeading(tvCabinet) + 90)
    SetEntityHeading(tv, GetEntityHeading(tv) + 90)

    FreezeEntityPosition(tvCabinet, true)
    FreezeEntityPosition(tv, true)

	local toilet = CreateObject(GetHashKey('prop_ld_toilet_01'), generator.x + 2.1, generator.y + 2.9, generator.z + 0.05, false, false, false)
	local clock = CreateObject(GetHashKey('prop_game_clock_02'), generator.x - 2.57, generator.y - 0.6, generator.z + 2.0, false, false, false)
	local phone = CreateObject(GetHashKey('v_res_j_phone'), generator.x + 2.4, generator.y - 1.8, generator.z + 0.695, false, false, false)
	local ironBoard = CreateObject(GetHashKey('v_ret_fh_ironbrd'), generator.x - 1.75, generator.y + 3.5, generator.z + 0.045, false, false, false)
	local iron = CreateObject(GetHashKey('prop_iron_01'), generator.x - 1.9, generator.y + 2.85, generator.z + 0.675, false, false, false)
	local firstMug = CreateObject(GetHashKey('v_ret_ta_mug'), generator.x - 2.3, generator.y + 0.95, generator.z + 0.915, false, false, false)
	local secondMug = CreateObject(GetHashKey('v_ret_ta_mug'), generator.x - 2.2, generator.y + 0.9, generator.z + 0.915, false, false, false)

	SetEntityHeading(toilet, GetEntityHeading(toilet) + 270)
	SetEntityHeading(clock, GetEntityHeading(clock) + 90)
	SetEntityHeading(phone, GetEntityHeading(phone) + 220)
    SetEntityHeading(ironBoard, GetEntityHeading(ironBoard) + 90)
	SetEntityHeading(iron, GetEntityHeading(iron) + 230)
	SetEntityHeading(firstMug, GetEntityHeading(firstMug) + 20)
    SetEntityHeading(secondMug, GetEntityHeading(secondMug) + 230)

    DoScreenFadeIn(100)
end)

RegisterNetEvent('crp-apartments:enterInterior')
AddEventHandler('crp-apartments:enterInterior', function()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    for k, v in pairs(apartments) do
        if #(vector3(apartments[k]['x'], apartments[k]['y'], apartments[k]['z']) - coords) < 1.0 then
            TriggerServerEvent('crp-apartments:checkInteriorState', k, 1)
            break
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed, letSleep = GetPlayerPed(-1), true

        if not isInside then
            local hotelDistance = #(vector3(apartments[myRoomNumber]['x'], apartments[myRoomNumber]['y'], apartments[myRoomNumber]['z']) - GetEntityCoords(playerPed))

            if hotelDistance < 10.0 then
                letSleep = false

                DrawMarker(20, apartments[myRoomNumber]['x'], apartments[myRoomNumber]['y'], apartments[myRoomNumber]['z'], 0, 0, 0, 0, 0, 0, 0.7, 1.0, 0.3, 0, 155, 255, 200, 0, 0, 0, 0)

                if hotelDistance < 2.0 then
                    DrawText3D(apartments[myRoomNumber]['x'], apartments[myRoomNumber]['y'], apartments[myRoomNumber]['z'], '[~g~E~s~] para entrar / [~g~G~s~] para destrancar')

                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('interact-sound:playOnSource', 'dooropen', 0.1)

                        DoScreenFadeOut(100)

                        Citizen.Wait(100)

                        TriggerEvent('crp-apartments:buildHotelInterior', myRoomNumber, myRoomType)
                    end

                    if IsControlJustReleased(0, 47) then
                        TriggerServerEvent('interact-sound:playWithinDistance', 2.5, 'doors', 0.1)
                        TriggerServerEvent('crp-apartments:updateMotelLock', myRoomNumber)

                        Citizen.Wait(1000)
                    end
                end
            end
        else
            local doorDistance = #(vector3(currentRoomCoords.x - 1.6, currentRoomCoords.y - 4.0, currentRoomCoords.z + 1.2) - GetEntityCoords(playerPed))

            if doorDistance < 3.0 then
                letSleep = false

                DrawText3D(currentRoomCoords.x - 1.6, currentRoomCoords.y - 4.0, currentRoomCoords.z + 1.2, '[~g~E~s~] para sair')

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('interact-sound:playOnSource', 'doorclose', 0.1)

                    Wait(330)

                    CleanUpInterior()

                    SetEntityCoords(playerPed, apartments[currentRoomNumber]['x'], apartments[currentRoomNumber]['y'], apartments[currentRoomNumber]['z'])

                    isInside, currentRoomNumber = false, 0
				end
            end

            local stashDistance = #(vector3(currentRoomCoords.x - 1.9, currentRoomCoords.y + 0.9, currentRoomCoords.z + 1.0) - GetEntityCoords(playerPed))

            if stashDistance < 2.0 then
                letSleep = false

                DrawText3D(currentRoomCoords.x - 1.9, currentRoomCoords.y + 0.9, currentRoomCoords.z + 1.0, '[~g~E~s~] para abrir o armário')

                if IsControlJustReleased(0, 38) then
                    -- Trigger Sound

                    Wait(330)

                    TriggerServerEvent('crp-apartments:openMotelInventory', currentRoomNumber)
                end
            end
        end

        if letSleep then
            Citizen.Wait(1500)
        end
    end
end)