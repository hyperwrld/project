local spawnedPeds = {}

local storeLocations = {
    [1]  = { ['x'] = 372.533,   ['y'] = 326.424,   ['z'] = 103.566, ['h'] = 256.291, ['name'] = 'Loja 1',  ['recent'] = false, ['city'] = true,  ['safe'] = true, ['safecoords'] = vector3(378.193, 333.434, 103.566)   },
    [2]  = { ['x'] = 1960.13,   ['y'] = 3739.999,  ['z'] = 32.344,  ['h'] = 296.691, ['name'] = 'Loja 2',  ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(1959.293, 3748.901, 32.344)  },
    [3]  = { ['x'] = -3038.879, ['y'] = 584.544,   ['z'] = 7.909,   ['h'] = 20.945,  ['name'] = 'Loja 3',  ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(-3047.905, 585.615, 7.909)   },
	[4]  = { ['x'] = 549.038,   ['y'] = 2671.361,  ['z'] = 42.157,  ['h'] = 93.516,  ['name'] = 'Loja 4',  ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(546.421, 2662.748, 42.157)   },
	[5]  = { ['x'] = 2557.272,  ['y'] = 380.839,   ['z'] = 108.623, ['h'] = 356.327, ['name'] = 'Loja 5',  ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(2549.198, 384.932, 108.623)  },
	[6]  = { ['x'] = -1820.218, ['y'] = 794.249,   ['z'] = 138.09,  ['h'] = 134.107, ['name'] = 'Loja 6',  ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(-1829.251, 798.748, 138.192) },
	[7]  = { ['x'] = -1221.972, ['y'] = -908.278,  ['z'] = 12.326,  ['h'] = 35.444,  ['name'] = 'Loja 7',  ['recent'] = false, ['city'] = true,  ['safe'] = true, ['safecoords'] = vector3(-1220.803, -915.976, 11.326) },
	[8]  = { ['x'] = -706.136,  ['y'] = -913.546,  ['z'] = 19.216,  ['h'] = 89.738,  ['name'] = 'Loja 8',  ['recent'] = false, ['city'] = true,  ['safe'] = true, ['safecoords'] = vector3(-709.769, -904.118, 19.216)  },
	[9]  = { ['x'] = 24.503,    ['y'] = -1347.338, ['z'] = 29.497,  ['h'] = 267.649, ['name'] = 'Loja 9',  ['recent'] = false, ['city'] = true,  ['safe'] = true, ['safecoords'] = vector3(28.249, -1339.141, 29.497)   },
	[10] = { ['x'] = -46.713,   ['y'] = -1757.825, ['z'] = 29.421,  ['h'] = 47.782,  ['name'] = 'Loja 10', ['recent'] = false, ['city'] = true,  ['safe'] = true, ['safecoords'] = vector3(-43.416, -1748.34, 29.421)   },
	[11] = { ['x'] = 1164.648,  ['y'] = -322.63,   ['z'] = 69.205,  ['h'] = 98.09,   ['name'] = 'Loja 11', ['recent'] = false, ['city'] = true,  ['safe'] = true, ['safecoords'] = vector3(1159.444, -313.993, 69.205)  },
	[12] = { ['x'] = 2678.095,  ['y'] = 3279.362,  ['z'] = 55.241,  ['h'] = 330.998, ['name'] = 'Loja 12', ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(2672.719, 3286.645, 55.241)  },
	[13] = { ['x'] = 1698.207,  ['y'] = 4922.863,  ['z'] = 42.064,  ['h'] = 325.593, ['name'] = 'Loja 13', ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(1707.951, 4920.456, 42.064)  },
	[14] = { ['x'] = 1727.814,  ['y'] = 6415.151,  ['z'] = 35.037,  ['h'] = 242.035, ['name'] = 'Loja 14', ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(1734.872, 6420.879, 35.037)  },
	[15] = { ['x'] = -2966.44,  ['y'] = 390.913,   ['z'] = 15.043,  ['h'] = 85.269,  ['name'] = 'Loja 15', ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(-2959.673, 387.059, 14.043)  },
    [16] = { ['x'] = -1486.222, ['y'] = -377.958,  ['z'] = 40.163,  ['h'] = 133.803, ['name'] = 'Loja 16', ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(-1478.904, -375.462, 39.163) },
    [17] = { ['x'] = 1165.896,  ['y'] = 2710.8,    ['z'] = 38.158,  ['h'] = 173.467, ['name'] = 'Loja 17', ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(1169.253, 2717.831, 37.158)  },
    [18] = { ['x'] = -3242.206, ['y'] = 1000.002,  ['z'] = 12.831,  ['h'] = 353.949, ['name'] = 'Loja 18', ['recent'] = false, ['city'] = false, ['safe'] = true, ['safecoords'] = vector3(-3250.01, 1004.462, 12.831)  },
    [19] = { ['x'] = 1392.707,  ['y'] = 3606.341,  ['z'] = 34.981,  ['h'] = 201.291, ['name'] = 'Loja 19', ['recent'] = false, ['city'] = false, ['safe'] = false },
}

local isSpawning, isRobbing, isOpeningSafe = false, false, false

local recentVictims = {}

RegisterNetEvent('crp-robbery:robPed')
AddEventHandler('crp-robbery:robPed', function(entity, vehicle)
    local playerPed = GetPlayerPed(-1)

    isRobbing = true

    ClearPedTasks(entity)
    ClearPedSecondaryTask(entity)
    TaskTurnPedToFaceEntity(entity, playerPed, 3.0)
    TaskSetBlockingOfNonTemporaryEvents(entity, true)
    SetPedFleeAttributes(entity, 0, 0)
    SetPedCombatAttributes(entity, 17, 1)
    SetPedSeeingRange(entity, 0.0)
    SetPedHearingRange(entity, 0.0)
    SetPedAlertness(entity, 0)
    SetPedKeepTask(entity, true)

    Citizen.Wait(1500)

    RequestAnimDict('missfbi5ig_22')

    while not HasAnimDictLoaded('missfbi5ig_22') do
        Citizen.Wait(0)
    end

    local isStorePed, store = CheckIfShopKeeper(entity)
    local isAlerted = false

    while isRobbing do
        Citizen.Wait(0)

        if not IsEntityPlayingAnim(entity, 'missfbi5ig_22', 'hands_up_anxious_scientist', 3) then
            TaskPlayAnim(entity, 'missfbi5ig_22', 'hands_up_anxious_scientist', 5.0, 1.0, -1, 1, 0, 0, 0, 0)
            
			Citizen.Wait(1000)
        end
        
        local coords, _coords = GetEntityCoords(playerPed), GetEntityCoords(entity)

        if #(coords - _coords) > 25.0 then
            isRobbing = false
        end

        if GetRandomNumber(1000) < 35 and #(coords - _coords) < 6.0 then
            local isPrimeTime = false

            if isStorePed then
                TriggerEvent('crp-hud:changestress', true, 50)

                Citizen.Wait(10000)

                if GetRandomNumber(100) < 60 and not isAlerted then
                    -- alert police!

                    isAlerted = true
                end

                isPrimeTime = exports['crp-userinfo']:isPed('primetime')
            else
                TriggerEvent('crp-hud:changestress', true, 35)
            end

            if vehicle ~= 0 then
                exports['crp-notifications']:SendAlert('inform', 'Recebeste as chaves do veículo.')

                local vehiclePlate = GetVehicleNumberPlateText(vehicle, false)

                -- ! Give player keys and add vehicle to the hot vehicles table (wraithrs)
            end

            if isStorePed then
                TriggerServerEvent('crp-robbery:robbedShop', isPrimeTime, store)
            else
                TriggerServerEvent('crp-robbery:robbedPerson')
            end

            RequestAnimDict('mp_common')

            while not HasAnimDictLoaded('mp_common') do
		        Citizen.Wait(0)
            end		

            TaskPlayAnim(entity, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 1, 0, 0, 0, 0)

            if not isStorePed then
                isRobbing = false
            else
                if isPrimeTime and GetRandomNumber(100) > 40 then
                    isRobbing = false
                elseif not isPrimeTime and GetRandomNumber(100) > 25 then
                    isRobbing = false
                end
            end

            Citizen.Wait(1500)
        end
    end

    Citizen.Wait(1000)

    ClearPedTasks(entity)

    if isStorePed then
        if DoesEntityExist(entity) and #(GetEntityCoords(entity) - GetEntityCoords(playerPed)) < 6.0 then
            if GetRandomNumber(100) > 10 or storeLocations[store]['recent'] or not storeLocations[store]['safe'] then
                exports['crp-notifications']:SendAlert('inform', 'O empregado da loja diz que não existe mais dinheiro na loja.')
            else
                RobSafe(store)

                exports['crp-notifications']:SendAlert('inform', 'O empregado da loja diz o código para abrir o cofre (' .. GetRandomNumber(1000, 9999) .. ').')
            end
        end

        TriggerServerEvent('crp-robbery:endedRobbery', store)
    else
        TriggerEvent('crp-hud:changestress', true, 35)

        Citizen.Wait(1000)

        SetAllPedAtributes(entity, false)

        TaskSmartFleePed(entity, playerPed, 500, -1, false, false)
    end
end)

RegisterNetEvent('crp-robbery:setRobbed')
AddEventHandler('crp-robbery:setRobbed', function(store, state)
    storeLocations[store]['recent'] = state
end)

function RobSafe(storeId)
    local isRunning, playerPed = true, GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    while isRunning do
        local currentCoords, safeCoords = GetEntityCoords(playerPed), storeLocations[storeId]['safecoords']
        local distance = #(safeCoords - currentCoords)

        if distance < 2.0 then
            DrawText3D(safeCoords.x, safeCoords.y, safeCoords.z - 0.5, '[E] abrir o cofre')

            if distance < 1.0 then
                if IsControlJustPressed(0, 38) and not isOpeningSafe then
                    local firstTimer, secondTimer = 85000, 100000

                    if storeLocations[storeId]['city'] then
                        firstTimer, secondTimer = 55000, 65000
                    end

                    isOpeningSafe = true

                    exports['crp-progressbar']:StartProgressBar({ duration = GetRandomNumber(firstTimer, secondTimer), label = 'Abrir o cofre' }, function(finished)
                        if finished and #(safeCoords - GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
                            local isPrimeTime = exports['crp-userinfo']:isPed('primetime')

                            TriggerServerEvent('crp-robbery:robbedSafe', isPrimeTime, storeId)

                            isRunning = false
                        else
                            exports['crp-notifications']:SendAlert('inform', 'Não conseguiste roubar o cofre porque não estavas perto.')
                        end

                        isOpeningSafe = false
                    end)
                end
            end
        end

        if distance > 10.0 then
            if isOpeningSafe then
                exports['crp-progressbar']:CancelAction()
            end

            isRunning, isOpeningSafe = false, false
        end

        Citizen.Wait(0)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local isAiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

        if isAiming then
            local playerPed = GetPlayerPed(-1)
            local coords, _coords = GetEntityCoords(playerPed), GetEntityCoords(entity)

            if #(coords - _coords) < 5.0 and not recentVictims[entity] and not IsPedAPlayer(entity) and not IsEntityDead(entity) and not IsPedDeadOrDying(entity, 1) then
                if IsPedArmed(playerPed, 6) and not IsPedArmed(entity, 7) and not IsEntityPlayingAnim(entity, 'missfbi5ig_22', 'hands_up_anxious_scientist', 3) then
                    if IsPedInAnyVehicle(entity, false) and GetEntitySpeed(GetVehiclePedIsIn(entity, false)) < 2.0 then
                        local vehicle = GetVehiclePedIsIn(entity, false)
                        
                        ClearPedTasks(entity)

                        TaskLeaveVehicle(entity, vehicle, 0)

                        SetAllPedAtributes(entity, true)

                        Citizen.Wait(1000)

                        ResetPedLastVehicle(entity)

                        TriggerEvent('crp-robbery:robPed', entity, vehicle)
                    else
                        TriggerEvent('crp-robbery:robPed', entity, 0)
                    end

                    recentVictims[entity] = true
                    Citizen.Wait(1000)
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local minDistance, scanId = 1000.0, 0

        for i = 1, #storeLocations do
            local distance = #(GetEntityCoords(GetPlayerPed(-1)) - vector3(storeLocations[i]['x'], storeLocations[i]['y'], storeLocations[i]['z']))

            if distance < minDistance then
                minDistance, scanId = distance, i
            end
        end

        if minDistance > 30.0 then
            scanId = 0

            Citizen.Wait(math.ceil(minDistance * 5))

            if #spawnedPeds > 0 then
                for i = 1, #spawnedPeds do
                    SetEntityAsNoLongerNeeded(spawnedPeds[i], true)
                end
            end

            spawnedPeds = {}
        else
            local playerPed = GetPlayerPed(-1)
            local isInVehicle = IsPedInAnyVehicle(playerPed, true)

            if not haveSpawned and not isInVehicle then
                SpawnShopkeeper(scanId)
            end

            Citizen.Wait(0)
        end
    end
end)

function SpawnShopkeeper(i)
    isSpawning = true

    local pedType = GetHashKey('mp_m_shopkeep_01')
    local coords, heading = vector3(storeLocations[i]['x'], storeLocations[i]['y'], storeLocations[i]['z']), storeLocations[i]['h']

    RequestModel(pedType)

    while not HasModelLoaded(pedType) do
        Citizen.Wait(0)
    end

    local hasBeenFound, foundPed = DoesPedExistInCoords(coords.x, coords.y, coords.z)

    if not hasBeenFound then
        if GetPedType(pedType) ~= nil then
            local shopPed = CreatePed(GetPedType(pedType), pedType, coords.x, coords.y, coords.z, heading, 1, 1)
            
			spawnedPeds[#spawnedPeds + 1] = shopPed

			SetPedKeepTask(shopPed, true)
			SetPedDropsWeaponsWhenDead(shopPed, false)
	        SetPedFleeAttributes(shopPed, 0, 0)
	        SetPedCombatAttributes(shopPed, 17, 1)
	        SetPedSeeingRange(shopPed, 0.0)
	        SetPedHearingRange(shopPed, 0.0)
	        SetPedAlertness(shopPed, 0.0)
        end
    else
        spawnedPeds[#spawnedPeds + 1] = foundPed
    end

    Citizen.Wait(10000)

	isSpawning = false
end

function DoesPedExistInCoords(x, y, z)
    local handle, ped = FindFirstPed()
    local isFound, foundPed, success = false, 0

    repeat
        local position = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(x, y, z, position, true)

        if distance < 5.0 then
            isFound, foundPed = true, ped
        end

        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)

    return isFound, foundPed
end

function CheckIfShopKeeper(entity)
    local minDistance = 1000.0
    
	for i = 1, #storeLocations do
        local distance = #(GetEntityCoords(GetPlayerPed(-1)) - vector3(storeLocations[i]['x'], storeLocations[i]['y'], storeLocations[i]['z']))
        
		if distance < minDistance then
			minDistance, scanId = distance, i
		end
    end
    
    if minDistance < 8.0 then
        for k, v in ipairs(spawnedPeds) do
            if (entity == v) then
                return true, scanId
            end
        end
    end

    return false, 0
end

function SetAllPedAtributes(foundPed, boolean)
	if boolean then
		SetBlockingOfNonTemporaryEvents(foundPed, true)

		SetPedFleeAttributes(foundPed, 0, 0)

		SetPedCombatAttributes(foundPed, 17, true)
		SetPedCombatAttributes(foundPed, 46, true)
	else
		SetBlockingOfNonTemporaryEvents(foundPed, false)

		SetPedFleeAttributes(foundPed, 0, 1)

		SetPedCombatAttributes(foundPed, 17, false)
		SetPedCombatAttributes(foundPed, 46, false)
	end
end

function GetRandomNumber(firstNumber, secondNumber)
    math.randomseed(GetGameTimer())

    if secondNumber then
        return math.random(firstNumber, secondNumber)
    else
        return math.random(firstNumber)
    end
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