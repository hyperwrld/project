local serviceLocations = {{ x = 442.24, y = -976.78, z = 30.69 }, { x = -449.121, y = 6011.788, z = 31.716 }}

local armoriesLocations = {{ x = 452.245, y = -980.076, z = 29.74 }, { x = -437.933, y = 5988.451, z = 30.746 }}

local warehouseLocations = {{ x = 459.04, y = -983.05, z = 30.78 }, { x = -442.171, y = 5987.419, z = 31.716 }}

local repairPoints = {{ x = 422.469, y = -1011.87, z = 29.072 }, { x = 1855.819, y = 3682.377, z = 34.268 }, { x = -453.184, y = 6029.408, z = 31.341 }}

local currentActionData = {}
local hasAlreadyEnteredMarker, isCop, playerInService = false, false, false
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
            
		    for i, v in ipairs(repairPoints) do
                if GetDistanceBetweenCoords(coords, repairPoints[i].x, repairPoints[i].y, repairPoints[i].z) < 50 then
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
    if not playerInService then
        exports['crp-notifications']:SendAlert('error', 'Precisas de estar de serviço para poder usar este comando.')
        return
    end

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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local isInMarker, hasExited, letSleep, coords = false, false, true, GetEntityCoords(playerPed)
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
                elseif IsControlJustReleased(0, 47) then
                    playerInService, currentAction = false, nil
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