local serviceLocations = {{ x = 442.24, y = -976.78, z = 30.69 }, { x = -449.121, y = 6011.788, z = 31.716 }}

local armoriesLocations = {{ x = 452.245, y = -980.076, z = 29.74 }, { x = -437.933, y = 5988.451, z = 30.746 }}

local warehouseLocations = {{ x = 459.04, y = -983.05, z = 30.78 }, { x = -442.171, y = 5987.419, z = 31.716 }}

local policePoints = {{ x = 422.469, y = -1011.87, z = 29.072 }, { x = 1855.819, y = 3682.377, z = 34.268 }, { x = -453.184, y = 6029.408, z = 31.341 }}

local currentActionData = {}
local hasAlreadyEnteredMarker, isPolice, playerInService, isBeingDragged, isEscorting, draggerId, isCuffing = false, false, false, false, false, 0, false
local lastStation, lastPart, currentAction

RegisterNetEvent('crp-police:repairvehicle')
AddEventHandler('crp-police:repairvehicle', function()
    local playerPed = PlayerPedId()

    if not playerInService then
        exports['crp-notifications']:SendAlert('error', 'Precisas de estar de serviço para poder usar este comando.')
        return
    end

    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if DoesEntityExist(vehicle) then
            local boolean, coords = false, GetEntityCoords(playerPed, 0)
            
		    for i, v in ipairs(policePoints) do
                if GetDistanceBetweenCoords(coords, policePoints[i].x, policePoints[i].y, policePoints[i].z) < 50 then
                    boolean = true
                    break
			    end
            end
            
            if boolean then 
                exports['crp-progressbar']:StartProgressBar({ duration = 10000, label = 'Reparar o veículo', cancel = true, vehicle = true }, function(finished)
                    if finished then
                        SetVehicleFixed(vehicle)
                        SetVehicleDeformationFixed(vehicle)

                        exports['crp-notifications']:SendAlert('success', 'Veículo reparado com sucesso.')
                    else
                        exports['crp-notifications']:SendAlert('error', 'Oops! Não foi possível repar o veículo.')
                    end
                end)
            else
                exports['crp-notifications']:SendAlert('error', 'Não estás perto de nenhum ponto de reparo.')
            end
        else
            exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum veículo.')
        end
    else
        exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum veículo.')
    end
end)

RegisterNetEvent('crp-police:search')
AddEventHandler('crp-police:search', function()
    if not playerInService then
        exports['crp-notifications']:SendAlert('error', 'Precisas de estar de serviço para poder usar este comando.')
        return
    end

    local closestPlayer, distance = GetClosestPlayer()

    if distance < 5.0 then
        TriggerServerEvent('crp-police:search', closestPlayer)
    else
        exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum player perto de ti.')
    end
end)

RegisterNetEvent('crp-police:spawnvehicle')
AddEventHandler('crp-police:spawnvehicle', function(vehicleModel, data)
    -- if not playerInService then
    --     exports['crp-notifications']:SendAlert('error', 'Precisas de estar de serviço para poder usar este comando.')
    --     return
    -- end

    local boolean, coords = false, GetEntityCoords(PlayerPedId(), 0)

    for i, v in ipairs(policePoints) do
        if GetDistanceBetweenCoords(coords, policePoints[i].x, policePoints[i].y, policePoints[i].z) < 50 then
            boolean = true
            break
		end
    end

    if boolean then
        Citizen.CreateThread(function()
            local vehicleHash = GetHashKey(vehicleModel)

            if not IsModelAVehicle(vehicleHash) or not IsModelInCdimage(vehicleHash) or not IsModelValid(vehicleHash) then 
                exports['crp-notifications']:SendAlert('error', 'Oops! Ocorreu um erro ao spawnar o veículo.')
                return 
            end
            
            RequestModel(vehicleHash)

            while not HasModelLoaded(vehicleHash) do
                Citizen.Wait(0)
            end

            local playerPed = GetPlayerPed(-1)
            local coords, heading = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.5, 5.0, 0.0), GetEntityHeading(playerPed)

            local vehicle = CreateVehicle(vehicleHash, coords, heading, true, false)

            SetModelAsNoLongerNeeded(vehicleHash)

            SetVehicleModKit(vehicle, 0)

            SetVehicleMod(vehicle, 11, 3, false)
            SetVehicleMod(vehicle, 12, 2, false)
            SetVehicleMod(vehicle, 13, 2, false)
            SetVehicleMod(vehicle, 15, data.suspension, false)
            SetVehicleMod(vehicle, 16, 1, false)
            SetVehicleMod(vehicle, 14, 1, false)

            SetVehicleWheelType(vehicle, 1)
            SetVehicleWindowTint(vehicle, 3)
            SetVehicleMod(vehicle, 23, 15, false)
            SetVehicleLivery(vehicle, 0)

            SetVehicleColours(vehicle, data.color, data.color)
            SetVehicleExtraColours(vehicle, 0, 0)

            ToggleVehicleMod(vehicle, 22, true)

            SetVehicleDirtLevel(vehicle, 0)

            local vehiclePlate = GetVehicleNumberPlateText(vehicle)

            -- ! Adicionar as chaves ao jogador
            
            SetVehicleDirtLevel(vehicle, 0)

            exports['crp-notifications']:SendAlert('success', 'Veículo spawnado com sucesso.')
        end)
    else
        exports['crp-notifications']:SendAlert('error', 'Não estás perto de nenhum ponto de spawn.')
    end
end)

RegisterNetEvent('crp-police:impoundvehicle')
AddEventHandler('crp-police:impoundvehicle', function()
    if not playerInService then
        exports['crp-notifications']:SendAlert('error', 'Precisas de estar de serviço para poder usar este comando.')
        return
    end

    local playerPed = GetPlayerPed(-1)
    local coordsA, coordsB = GetEntityCoords(playerPed, 1), GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 100.0, 0.0)
    local vehicle = GetVehicleInDirection(coordsA, coordsB)

    if vehicle == 0 then
        exports['crp-notifications']:SendAlert('error', 'Oops! Ocorreu um erro ao tentar encontrar o veículo.')
        return
    end

    exports['crp-progressbar']:StartProgressBar({ duration = 5000, label = 'Apreender o veículo', cancel = true }, function(finished)
        if finished then
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))

            if DoesEntityExist(vehicle) then
                SetEntityCoords(vehicle, 0.0, 0.0, -30.0)
                SetEntityAsNoLongerNeeded(vehicle)
                DeleteVehicle(vehicle)

                Citizen.Wait(250)

                if DoesEntityExist(vehicle) then
                    exports['crp-notifications']:SendAlert('error', 'Oops! Ocorreu um erro ao tentar apreender o veículo.')
                else
                    local vehiclePlate = GetVehicleNumberPlateText(vehicle)

                    -- ! Impound vehicle on the database

                    exports['crp-notifications']:SendAlert('success', 'Veículo apreendido com sucesso.')
                end
            else
                local vehiclePlate = GetVehicleNumberPlateText(vehicle)

                -- ! Impound vehicle on the database
                
                exports['crp-notifications']:SendAlert('success', 'Veículo apreendido com sucesso.')
            end
        else
            exports['crp-notifications']:SendAlert('error', 'Oops! Ocorreu um erro ao tentar apreender o veículo.')
        end
    end)
end)

RegisterNetEvent('crp-police:cuffplayer')
AddEventHandler('crp-police:cuffplayer', function(state)
    -- if not playerInService then
    --     exports['crp-notifications']:SendAlert('error', 'Precisas de estar de serviço para poder usar este comando.')
    --     return
    -- end

    --local isHandcuffed = exports['crp-userinfo']:isPed('handcuffed')

    -- if isCuffing or isHandcuffed or not IsPedRagdoll(GetPlayerPed(-1)) and not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    --     return
    -- end

    isCuffing = true

    local user, distance = GetClosestPlayer()

    if distance ~= nil and distance ~= -1 and distance < 1.0 and GetEntitySpeed(GetPlayerPed(GetPlayerFromServerId(user))) < 1.0 then 
        if state then
            exports['crp-notifications']:SendAlert('inform', 'Colocaste as algemas apertadas no jogador.')
        else
            exports['crp-notifications']:SendAlert('inform', 'Colocaste as algemas largas no jogador.')
        end

        TriggerServerEvent('crp-police:cuffplayer', user, state)
    end
end)

RegisterNetEvent('crp-police:uncuffplayer')
AddEventHandler('crp-police:uncuffplayer', function(state)
    local user, distance = GetClosestPlayer()

    if distance ~= nil and distance ~= -1 and distance < 2.0 then 
        exports['crp-notifications']:SendAlert('inform', 'Desalgemaste um jogador.')

        TriggerServerEvent('crp-police:uncuffplayer', user)
        TriggerServerEvent('interact-sound:playWithinDistance', 2.5, 'uncuff', 0.1)
    end
end)

RegisterNetEvent('crp-police:uncuff')
AddEventHandler('crp-police:uncuff', function()
    isHandcuffed, handcuffType = false, false

    Citizen.Wait(100)

    ClearPedTasksImmediately(GetPlayerPed(-1))

    TriggerEvent('crp-userinfo:updateCuffs', false)
end)

RegisterNetEvent('crp-police:getcuffed')
AddEventHandler('crp-police:getcuffed', function(cuffer, state)
    local playerPed = GetPlayerPed(-1)

    ClearPedTasksImmediately(playerPed)

    isHandcuffed, handcuffType = true, state

    LoadAnimation('mp_arrest_paired')

    local cuffer = GetPlayerPed(GetPlayerFromServerId(tonumber(cuffer)))
    local direction = GetEntityHeading(cuffer)

    SetEntityCoords(playerPed, GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
    
    Citizen.Wait(100)

    SetEntityHeading(playerPed, direction)
    
    TaskPlayAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, -1, 32, 0, 0, 0, 0)
    
    Citizen.Wait(2500)

    Citizen.CreateThread(function()
        repeat
            Citizen.Wait(0)

            local playerPed, number = GetPlayerPed(-1), 49

            if handcuffType then
                number = 16
            end

            if (not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3)) or (IsPedRagdoll(playerPed)) then
                LoadAnimation('mp_arresting')

                TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, number, 0, 0, 0, 0)
            end

            DisableControlAction(1, 23, true)
            DisableControlAction(1, 106, true)
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisablePlayerFiring(playerPed, true)
        until isHandcuffed == false
    end)

    TriggerEvent('crp-userinfo:updateCuffs', true)

    TriggerServerEvent('interact-sound:playWithinDistance', 2.5, 'cuff', 0.1)
end)

RegisterNetEvent('crp-police:cuffed')
AddEventHandler('crp-police:cuffed', function(state)
    ClearPedTasksImmediately(GetPlayerPed(-1))

    isHandcuffed, handcuffType = true, state

    Citizen.Wait(100)

    Citizen.CreateThread(function()
        repeat
            Citizen.Wait(0)

            local playerPed, number = GetPlayerPed(-1), 49

            if handcuffType then
                number = 16
            end

            if (not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3)) or (IsPedRagdoll(playerPed)) then
                LoadAnimation('mp_arresting')

                TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, number, 0, 0, 0, 0)
            end

            DisableControlAction(1, 23, true)
            DisableControlAction(1, 106, true)
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisablePlayerFiring(playerPed, true)
        until isHandcuffed == false
    end)

    TriggerEvent('crp-userinfo:updateCuffs', true)

    TriggerServerEvent('interact-sound:playWithinDistance', 2.5, 'cuff', 0.1)
end)

RegisterNetEvent('crp-police:cuff')
AddEventHandler('crp-police:cuff', function(cuffer, state)
    local playerPed = GetPlayerPed(-1)

    LoadAnimation('mp_arrest_paired')
    
    Citizen.Wait(100)
    
    TaskPlayAnim(playerPed, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, -1, 48, 0, 0, 0, 0)
    
    Citizen.Wait(3500)
    
    ClearPedTasksImmediately(playerPed)
    
    isCuffing = false
end)

RegisterNetEvent('crp-police:dragplayer')
AddEventHandler('crp-police:dragplayer', function()
    -- if not playerInService then
    --     exports['crp-notifications']:SendAlert('error', 'Precisas de estar de serviço para poder usar este comando.')
    --     return
    -- end

    local isHandcuffed = exports['crp-userinfo']:isPed('handcuffed')

    if isHandcuffed then
        exports['crp-notifications']:SendAlert('error', 'Não podes fazer isso porque estás algemado.')
        return
    end

    local user, distance = GetClosestPlayer()

    if distance ~= nil and distance ~= -1 and distance < 1.0 then 
        if not isBeingDragged then
            TriggerServerEvent('crp-police:dragplayer', user)
        end
    end
end)

RegisterNetEvent('crp-police:drag')
AddEventHandler('crp-police:drag', function(player)
    draggerId = tonumber(player)

    isBeingDragged = not isBeingDragged

    if isBeingDragged then
        SetEntityCoords(GetPlayerPed(-1), GetEntityCoords(GetPlayerPed(dragger)))

        Citizen.CreateThread(function()
            repeat
                local playerPed = GetPlayerPed(-1)

                if GetEntitySpeed(playerPed) > 0.2 then
                    local coords = GetEntityCoords(playerPed,  true)

                    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)	
                end

                Citizen.Wait(10000)
            until isBeingDragged == false
        end)

        if draggerId ~= -1 then
            TriggerServerEvent('crp-police:updatedragger', draggerId, true)
        end
    else
        local playerPed = GetPlayerPed(-1)

        ClearPedTasks(playerPed)

        DetachEntity(playerPed, true, false)

        if draggerId ~= -1 then
            TriggerServerEvent('crp-police:updatedragger', draggerId, false)
        end
    end
end)

RegisterNetEvent('crp-police:updatedragger')
AddEventHandler('crp-police:updatedragger', function(status)
    isEscorting = status

    if isEscorting then
        Citizen.CreateThread(function()
            repeat
                Citizen.Wait(0)

                local playerPed = GetPlayerPed(-1)

                if IsPedRunning(playerPed) or IsPedSprinting(playerPed) then
				    SetPlayerControl(PlayerId(), 0, 0)
				    Citizen.Wait(1000)
				    SetPlayerControl(PlayerId(), 1, 1)
			    end
            until isEscorting == false
        end)
    end
end)

RegisterNetEvent('crp-police:putInVehicle')
AddEventHandler('crp-police:putInVehicle', function()
    local user, distance, userId = GetClosestPedIgnoreCar()

    if distance ~= -1 and distance < 3.0 then
        local isInVehicle = IsPedInAnyVehicle(user)

        if not isInVehicle then
            local playerPed = GetPlayerPed(-1)
            local coords, _coords = GetEntityCoords(playerPed, 0), GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 100.0, 0.0)
            local vehicle = GetVehicleInDirection(coords, _coords)

            if vehicle == 0 or not IsEntityAVehicle(vehicle) then
                exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum veículo.')
                return
            end

            local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)

            TriggerServerEvent('crp-police:putInVehicle', GetPlayerServerId(userId), vehicleNetId)

            isEscorting = false
        else
            local user, distance = GetClosestPlayerIgnoreCar()

            if distance ~= -1 and distance < 10.0 then
                local playerPed = GetPlayerPed(-1)
                local coords = GetEntityCoords(playerPed, 0)

                TriggerServerEvent('crp-police:removeFromVehilce', GetPlayerServerId(user), coords)

                Citizen.Wait(1000)

                TriggerServerEvent('crp-police:dragplayer', GetPlayerServerId(user))
            else
                exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum jogador próximo.')
            end
        end
    else
        exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum jogador próximo.')
    end
end)

RegisterNetEvent('crp-police:enterVehicle')
AddEventHandler('crp-police:enterVehicle', function(vehicle)
    local vehicleHandle = NetworkGetEntityFromNetworkId(vehicle)

    if vehicleHandle ~= nil then
        if IsEntityAVehicle(vehicleHandle) then
            for i = 1, GetVehicleMaxNumberOfPassengers(vehicleHandle) do
                if IsVehicleSeatFree(vehicleHandle, i) then
                    TriggerEvent('crp-police:drag', -1)
                     
                    Citizen.Wait(100)
                    
                    SetPedIntoVehicle(GetPlayerPed(-1), vehicleHandle, i)
                    return true
                end
            end

            if IsVehicleSeatFree(enterVehicle, 0) then
                TriggerEvent('crp-police:drag', -1)
                
                Citizen.Wait(100)
                
	            SetPedIntoVehicle(GetPlayerPed(-1), vehicleHandle, 0)
	        end
        end
    end
end)

RegisterNetEvent('crp-police:removeFromVehilce')
AddEventHandler('crp-police:removeFromVehilce', function(coords)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    ClearPedTasksImmediately(playerPed)

    TaskLeaveVehicle(playerPed, vehicle, 256)
    SetEntityCoords(playerPed, coords)
end)

AddEventHandler('crp-police:hasEnteredMarker', function(station, type)
    if type == 'service' then
        currentAction     = type
        currentActionData = {}
    elseif type == 'armory' then
        currentAction     = type
        currentActionData = { message = 'Pressiona ~INPUT_CONTEXT~ para abrir o ~g~armamento~s~.' }
    elseif type == 'warehouse' then
        currentAction     = type
        currentActionData = { station = station }
    end
end)

AddEventHandler('crp-police:hasExitedMarker', function()
	currentAction = nil
end)

AddEventHandler('crp-userinfo:updateJob', function(_job)
    if _job == 'police' then isPolice = true else isPolice = false end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isPolice and not IsPauseMenuActive() then
            local isInVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)

            if isInVehicle then             
                if IsControlJustReleased(2, 172) then
                    TriggerEvent('wraithrs:checkFrontRadar')
                    
					Citizen.Wait(500)
                end

                if IsControlJustReleased(2, 173) then
                    TriggerEvent('wraithrs:checkRearRadar')
                    
					Citizen.Wait(500)
                end

                if IsControlJustReleased(2, 174) then
                    TriggerEvent('wraithrs:resetRadar')
                    
					Citizen.Wait(500)
                end
                
                if IsControlJustReleased(2, 175) then
                    TriggerEvent('wraithrs:toggleradar')
                    
					Citizen.Wait(500)
                end
            else
				if IsControlJustReleased(2, 172) and not IsControlPressed(0, 19) then
                    TriggerEvent('crp-police:cuffplayer', false)
                    
					Citizen.Wait(500)
				end

				if IsControlJustReleased(2, 172) and IsControlPressed(0, 19) then
                    TriggerEvent('crp-police:cuffplayer', true)
                    
					Citizen.Wait(500)
                end
                
				if IsControlJustReleased(2, 173) then
                    TriggerEvent('crp-police:uncuffplayer')
                    
					Citizen.Wait(500)
                end
                
                if IsControlJustReleased(2, 174) then
                    TriggerEvent('crp-police:putInVehicle')
                    
					Citizen.Wait(500)
                end

                if IsControlJustReleased(2, 175) then
                    TriggerEvent('crp-police:dragplayer')
                    
					Citizen.Wait(500)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if isBeingDragged then
            local userPed, playerPed = GetPlayerPed(GetPlayerFromServerId(draggerId)), GetPlayerPed(-1)

            if isBeingDragged then
                AttachEntityToEntity(playerPed, userPed, 11816, 0.54, 0.44, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            end

            if IsEntityDead(userPed) then
                DetachEntity(playerPed, position)

                isBeingDragged = false

                local position = GetOffsetFromEntityInWorldCoords(userPed, 0.0, 0.8, 2.8)

                SetEntityCoords(playerPed, position)
            end

            DisableControlAction(1, 23, true)
            DisableControlAction(1, 106, true)
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 37, true)
            DisablePlayerFiring(playerPed, true)
            DisableControlAction(2, 32, true)
            DisableControlAction(1, 33, true)
            DisableControlAction(1, 34, true)
            DisableControlAction(1, 35, true)
            DisableControlAction(1, 37, true)
            DisableControlAction(0, 59, true)
            DisableControlAction(0, 60, true)
            DisableControlAction(2, 31, true) 
            SetCurrentPedWeapon(playerPed, GetHashKey('weapon_unarmed'), true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local letSleep = true
        
        if isPolice then
            local playerPed = PlayerPedId()
            local isInMarker, hasExited, coords = false, false, GetEntityCoords(playerPed)
            local currentStation, currentPart

            for i = 1, #serviceLocations, 1 do
                local distance = GetDistanceBetweenCoords(coords, serviceLocations[i].x, serviceLocations[i].y, serviceLocations[i].z, true)

                if distance < 3.0 then
                    DrawText3D(serviceLocations[i].x, serviceLocations[i].y, serviceLocations[i].z, '[E] Entrar de Serviço | [G] Sair de Serviço')

                    letSleep = false
                end

                if distance < 2.0 then
                    isInMarker, currentStation, currentPart = true, i, 'service'
                end
            end

            for i = 1, #armoriesLocations, 1 do
                local distance = GetDistanceBetweenCoords(coords, armoriesLocations[i].x, armoriesLocations[i].y, armoriesLocations[i].z, true)

                if distance < 10.0 then
                    DrawMarker(27, armoriesLocations[i].x, armoriesLocations[i].y, armoriesLocations[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 130, 201, 100, false, false, 2, false, nil, nil, false)
                
                    letSleep = false
                end

                if distance < 1.0 then
                    isInMarker, currentStation, currentPart = true, i, 'armory'
                end
            end

            for i = 1, #warehouseLocations, 1 do
                local distance = GetDistanceBetweenCoords(coords, warehouseLocations[i].x, warehouseLocations[i].y, warehouseLocations[i].z, true)

                if distance < 3.0 then
                    DrawText3D(warehouseLocations[i].x, warehouseLocations[i].y, warehouseLocations[i].z, '[E] para abrir o armazém')

                    letSleep = false
                end

                if distance < 2.0 then
                    isInMarker, currentStation, currentPart = true, i, 'warehouse'
                end
            end

            if isInMarker and not hasAlreadyEnteredMarker or (isInMarker and (lastStation ~= currentStation or lastPart ~= currentPart)) then
                if (lastStation and lastPart) and (lastStation ~= currentStation or lastPart ~= currentPart) then
                    hasExited = true

                    TriggerEvent('crp-police:hasExitedMarker')
                end

                hasAlreadyEnteredMarker = true
                lastStation             = currentStation
                lastPart                = currentPart

                TriggerEvent('crp-police:hasEnteredMarker', currentStation, currentPart)
            end

            if not hasExited and not isInMarker and hasAlreadyEnteredMarker then
                hasAlreadyEnteredMarker = false

                TriggerEvent('crp-police:hasExitedMarker')
            end
        end

        if letSleep then
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if currentAction then
            if currentActionData.message then DisplayHelpText(currentActionData.message) end

            if currentAction == 'service' then
                if IsControlJustReleased(0, 38) then
                    playerInService, currentAction = true, nil

                    TriggerServerEvent('crp-jobmanager:enableService', 'police')
                elseif IsControlJustReleased(0, 47) then
                    playerInService, currentAction = false, nil

                    TriggerServerEvent('crp-jobmanager:disableService', 'police')
                end
            elseif IsControlJustReleased(0, 38) then
                if currentAction == 'armory' then
                    TriggerEvent('crp-inventory:openCustom', { type = 2, name = 'armamento da polícia', shopType = 3 })
                elseif currentAction == 'warehouse' then
                    TriggerEvent('crp-inventory:openCustom', { type = 3, slots = 150, weight = 50000, name = 'warehouse-' .. currentActionData.station })
                end

                currentAction = nil
            end
        end
    end
end)