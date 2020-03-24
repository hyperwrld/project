local hasAlreadyEnteredMarker, isMedic, playerInService = false, false, false
local currentActionData, teleportInfo, lastPart, currentAction = {}, {}

isOnBed = false

local locations = {
    { ['x'] = 306.912, ['y'] = -595.098, ['z'] = 43.284, ['type'] = 'heal', ['text'] = '[H] para dar check-in no hospital' },
    { ['x'] = 327.138, ['y'] = -603.849, ['z'] = 43.284, ['type'] = 'teleport', ['text'] = '[E] para ir para o heliponto', ['_x'] = 338.64,  ['_y'] = -583.985, ['_z'] = 74.166, ['_h'] = 252.0 },
    { ['x'] = 338.64,  ['y'] = -583.985, ['z'] = 74.166, ['type'] = 'teleport', ['text'] = '[E] para ir para o hospital', ['_x'] = 327.138, ['_y'] = -603.849, ['_z'] = 43.284, ['_h'] = 338.0 },
}

local medicLocations = {
    { ['x'] = 310.668, ['y'] = -596.022, ['z'] = 43.284, ['type'] = 'service', ['text'] = '[E] Entrar de Serviço | [G] Sair de Serviço' },
    { ['x'] = 306.719, ['y'] = -601.554, ['z'] = 43.284, ['type'] = 'warehouse', ['text'] = '[E] para abrir o armazém' },
    { ['x'] = 333.031, ['y'] = -568.992, ['z'] = 43.284, ['type'] = 'teleport', ['text'] = '[E] para ir para o estacionamento', ['_x'] = 319.68,  ['_y'] = -560.083, ['_z'] = 28.743, ['_h'] = 31.0 },
    { ['x'] = 319.68,  ['y'] = -560.083, ['z'] = 28.743, ['type'] = 'teleport', ['text'] = '[E] para ir para o hospital', ['_x'] = 333.031, ['_y'] = -568.992, ['_z'] = 43.284, ['_h'] = 171.0 }
}

local medicPoints = {
    { ['x'] = 365.223,  ['y'] = -590.933,  ['z'] = 28.693 },
    { ['x'] = 298.586,  ['y'] = -1441.491, ['z'] = 29.794 },
    { ['x'] = 1840.431, ['y'] = 3668.819,  ['z'] = 33.68  },
    { ['x'] = -240.131, ['y'] = 6333.193,  ['z'] = 32.426 },
    { ['x'] = 292.651,  ['y'] = -603.111,  ['z'] = 43.309 }
}

RegisterNetEvent('crp-medic:repairVehicle')
AddEventHandler('crp-medic:repairVehicle', function()
    local isInService = exports['crp-userinfo']:isPed('inService')

    if not isInService then
        return
    end

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if DoesEntityExist(vehicle) then
            local boolean, coords = false, GetEntityCoords(playerPed, 0)

		    for i, v in ipairs(medicPoints) do
                if GetDistanceBetweenCoords(coords, medicPoints[i]['x'], medicPoints[i]['y'], medicPoints[i]['z']) < 50 then
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
        end
    end
end)

RegisterNetEvent('crp-medic:spawnvVehicle')
AddEventHandler('crp-medic:spawnVehicle', function(vehicleModel, data)
    local isInService = exports['crp-userinfo']:isPed('inService')

    if not isInService then
        return
    end

    local boolean, coords = false, GetEntityCoords(PlayerPedId(), 0)

    for i, v in ipairs(medicPoints) do
        if GetDistanceBetweenCoords(coords, medicPoints[i]['x'], medicPoints[i]['y'], medicPoints[i]['z']) < 50 then
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
            local coords, heading = GetOffsetFromEntityInWorldCoords(playerPed, 1.5, 5.0, 0.0), GetEntityHeading(playerPed)

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

            TriggerServerEvent('crp-keys:addKey', vehicle, vehiclePlate)

            SetVehicleDirtLevel(vehicle, 0)

            exports['crp-notifications']:SendAlert('success', 'Veículo spawnado com sucesso.')
        end)
    else
        exports['crp-notifications']:SendAlert('error', 'Não estás perto de nenhum ponto de spawn.')
    end
end)

AddEventHandler('crp-medic:hasEnteredMarker', function(type)
    if type == 'heal' then
        currentAction     = type
        currentActionData = {}
    else
        currentAction     = type
        currentActionData = {}
    end
end)

AddEventHandler('crp-medic:hasExitedMarker', function()
	currentAction = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local letSleep = true
        local playerPed, currentPart = PlayerPedId()
        local isInMarker, hasExited, coords = false, false, GetEntityCoords(playerPed)

        for i = 1, #locations, 1 do
            local distance = #(coords - vector3(locations[i]['x'], locations[i]['y'], locations[i]['z']))

            if distance < 3.0 then
                DrawText3D(locations[i]['x'], locations[i]['y'], locations[i]['z'], locations[i]['text'])

                letSleep = false
            end

            if distance < 1.0 then
                isInMarker, currentPart = true, locations[i]['type']

                if currentPart == 'teleport' then
                    teleportInfo = { x = locations[i]['_x'], y = locations[i]['_y'], z = locations[i]['_z'], h = locations[i]['_h'] }
                end
            end
        end

        --if isMedic then
            for i = 1, #medicLocations, 1 do
                local distance = #(coords - vector3(medicLocations[i]['x'], medicLocations[i]['y'], medicLocations[i]['z']))

                if distance < 10.0 and not medicLocations[i]['text'] then
                    DrawMarker(27, medicLocations[i]['x'], medicLocations[i]['y'], medicLocations[i]['z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 130, 201, 100, false, false, 2, false, nil, nil, false)

                    letSleep = false
                elseif distance < 3.0 then
                    DrawText3D(medicLocations[i]['x'], medicLocations[i]['y'], medicLocations[i]['z'], medicLocations[i]['text'])

                    letSleep = false
                end

                if distance < 1.0 then
                    isInMarker, currentPart = true, medicLocations[i]['type']

                    if currentPart == 'teleport' then
                        teleportInfo = { x = medicLocations[i]['_x'], y = medicLocations[i]['_y'], z = medicLocations[i]['_z'], h = medicLocations[i]['_h'] }
                    end
                end
            end
        --end

        if isInMarker and not hasAlreadyEnteredMarker or (isInMarker and lastPart ~= currentPart) then
            if lastPart and lastPart ~= currentPart then
                hasExited = true

                TriggerEvent('crp-medic:hasExitedMarker')
            end

            hasAlreadyEnteredMarker = true
            lastPart                = currentPart

            TriggerEvent('crp-medic:hasEnteredMarker', currentPart)
        end

        if not hasExited and not isInMarker and hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = false

            TriggerEvent('crp-medic:hasExitedMarker')
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

            if currentAction == 'heal' then
                if IsControlJustReleased(0, 47) then
                    local playerPed = GetPlayerPed(-1)

                    LoadAnimation('anim@narcotics@trash')

                    TaskPlayAnim(playerPed,'anim@narcotics@trash', 'drop_front', 1.0, 1.0, -1, 1, 0, 0, 0, 0)

                    exports['crp-progressbar']:StartProgressBar({ duration = 2000, label = 'Fazendo Check-In', cancel = true }, function(finished)
                        if finished then
                            CheckInHospital()
                        end

                        ClearPedTasks(playerPed)
                    end)

                    currentAction = nil
                end
            elseif IsControlJustReleased(0, 38) then
                if currentAction == 'teleport' then
                    FastTravel({ x = teleportInfo.x, y = teleportInfo.y, z = teleportInfo.z, h = teleportInfo.h })
                elseif currentAction == 'warehouse' then
                    TriggerEvent('crp-inventory:openCustom', { type = 3, slots = 150, weight = 50000, name = 'warehouse-5' })
                end

                currentAction = nil
            end
        end
    end
end)