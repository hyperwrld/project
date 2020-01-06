function round(num)
    return tonumber(string.format('%.0f', num))
end

function FormatSpeed(speed)
    return string.format('%03d', speed)
end

function GetVehicleInDirectionSphere(entFrom, coordFrom, coordTo)
    local rayHandle = StartShapeTestCapsule(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2.0, 10, entFrom, 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end

function IsEntityInMyHeading(myAng, tarAng, range)
    local rangeStartFront = myAng - (range / 2)
    local rangeEndFront = myAng + (range / 2)

    local opp = ((myAng + 180) % 360)

    local rangeStartBack = opp - (range / 2)
    local rangeEndBack = opp + (range / 2)

    if ((tarAng > rangeStartFront) and (tarAng < rangeEndFront)) then
        return true
    elseif ((tarAng > rangeStartBack) and (tarAng < rangeEndBack)) then
        return false
    else
        return nil
    end
end

local isisRadarEnabled, isisHidden, hotVehicles = false, false, {}

local radarInfo = {
    fwdPrevVeh = 0, fwdXmit = true, fwdMode = 'same', fwdSpeed = '000', fwdFast = '000', fwdFastLocked = false,
    fwdDir = nil, fwdFastSpeed = 0, fwdPlate = '########', fwdPlateLocked = false, bwdPrevVeh = 0, bwdXmit = true, bwdMode = 'opp', bwdSpeed = 'OFF', bwdFast = 'OFF',
    bwdFastLocked = false, bwdDir = nil, bwdFastSpeed = 0, bwdPlate = '########', bwdPlateLocked = false, fastResetLimit = 150, fastLimit = 60,
    angles = { ['same'] = { x = 0.0, y = 50.0, z = 0.0 }, ['opp'] = { x = -10.0, y = 50.0, z = 0.0 } }, lockBeep = true
}

function ResetFrontAntenna()
    if (radarInfo.fwdXmit) then
        radarInfo.fwdSpeed = '000'
        radarInfo.fwdFast = '000'
    else
        radarInfo.fwdSpeed = 'OFF'
        radarInfo.fwdFast = '   '
    end

    radarInfo.fwdPlate = '########'
    radarInfo.fwdDir = nil
    radarInfo.fwdFastSpeed = 0
    radarInfo.fwdFastLocked = false
    radarInfo.fwdPlateLocked = false
end

function ResetRearAntenna()
    if (radarInfo.bwdXmit) then
        radarInfo.bwdSpeed = '000'
        radarInfo.bwdFast = '000'
    else
        radarInfo.bwdSpeed = 'OFF'
        radarInfo.bwdFast = '   '
    end

    radarInfo.bwdPlate = '########'
    radarInfo.bwdDir = nil
    radarInfo.bwdFastSpeed = 0
    radarInfo.bwdFastLocked = false
    radarInfo.bwdPlateLocked = false
end

function ResetFrontFast()
    if (radarInfo.fwdXmit) then
        radarInfo.fwdFast = '000'
        radarInfo.fwdFastSpeed = 0
        radarInfo.fwdFastLocked = false
        radarInfo.fwdPlateLocked = false

        SendNUIMessage({ event = 'lockFwdFast', status = false })
    end
end

function ResetRearFast()
    if (radarInfo.bwdXmit) then
        radarInfo.bwdFast = '000'
        radarInfo.bwdFastSpeed = 0
        radarInfo.bwdFastLocked = false
        radarInfo.bwdPlateLocked = false

        SendNUIMessage({ event = 'lockBwdFast', status = false })
    end
end

function GetVehicleSpeed(vehicle)
    return GetEntitySpeed(vehicle) * 3.6
end

function ManageVehicleRadar()
    if (isRadarEnabled) then
        local playerPed = GetPlayerPed(-1)

        if (IsPedSittingInAnyVehicle(playerPed)) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if (GetPedInVehicleSeat(vehicle, -1) == playerPed and GetVehicleClass(vehicle) == 18) then
                local vehiclePos = GetEntityCoords(vehicle, true)
                local h = round(GetEntityHeading(vehicle), 0)

                if (radarInfo.fwdXmit) then
                    local forwardPosition = GetOffsetFromEntityInWorldCoords(vehicle, radarInfo.angles[radarInfo.fwdMode].x, radarInfo.angles[radarInfo.fwdMode].y, radarInfo.angles[radarInfo.fwdMode].z)
                    local fwdPos = { x = forwardPosition.x, y = forwardPosition.y, z = forwardPosition.z }
                    local _, fwdZ = GetGroundZFor_3dCoord(fwdPos.x, fwdPos.y, fwdPos.z + 500.0)

                    if (fwdPos.z < fwdZ and not (fwdZ > vehiclePos.z + 1.0)) then
                        fwdPos.z = fwdZ + 0.5
                    end

                    local packedFwdPos = vector3(fwdPos.x, fwdPos.y, fwdPos.z)
                    local fwdVeh = GetVehicleInDirectionSphere(vehicle, vehiclePos, packedFwdPos)

                    if (DoesEntityExist(fwdVeh) and IsEntityAVehicle(fwdVeh)) then
                        local fwdVehSpeed = round(GetVehicleSpeed(fwdVeh), 0)
                        local fwdPlate = tostring(GetVehicleNumberPlateText(fwdVeh)) or ''
                        local fwdVehHeading = round(GetEntityHeading(fwdVeh), 0)
                        local dir = IsEntityInMyHeading(h, fwdVehHeading, 100)

                        radarInfo.fwdSpeed = FormatSpeed(fwdVehSpeed)
                        radarInfo.fwdDir = dir

                        if isVehicleHot(fwdPlate) and not radarInfo.fwdFastLocked then
                            TriggerHotSound()

                            radarInfo.fwdPlate = fwdPlate
                            radarInfo.fwdFastSpeed = fwdVehSpeed
                            radarInfo.fwdFastLocked = true
                            radarInfo.fwdPlateLocked = true

                            TriggerEvent('chat:addMessage', { color = {255, 255, 255}, templateId = 'red', args = { 'POLÍCIA', 'Veículo procurado por: ' .. hotVehicles[string.lower(fwdPlate)] .. ' / Matrícula: ' .. fwdPlate }})

                            SendNUIMessage({ event = 'lockFwdFast', status = true })

                            radarInfo.fwdFast = FormatSpeed(radarInfo.fwdFastSpeed)
                        else
                            if not radarInfo.fwdPlateLocked then
                                radarInfo.fwdPlate = fwdPlate
                            end

                            if (fwdVehSpeed > radarInfo.fastLimit and not radarInfo.fwdFastLocked) then
                                if (radarInfo.lockBeep) then
                                    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
                                end

                                radarInfo.fwdFastSpeed = fwdVehSpeed
                                radarInfo.fwdFastLocked = true
                                radarInfo.fwdPlateLocked = true

                                SendNUIMessage({ event = 'lockFwdFast', status = true })
                            end

                            radarInfo.fwdFast = FormatSpeed(radarInfo.fwdFastSpeed)
                        end
                        radarInfo.fwdPrevVeh = fwdVeh
                    end
                end

                if (radarInfo.bwdXmit) then
                    local backwardPosition = GetOffsetFromEntityInWorldCoords(vehicle, radarInfo.angles[radarInfo.bwdMode].x, -radarInfo.angles[radarInfo.bwdMode].y, radarInfo.angles[radarInfo.bwdMode].z)
                    local bwdPos = { x = backwardPosition.x, y = backwardPosition.y, z = backwardPosition.z }
                    local _, bwdZ = GetGroundZFor_3dCoord(bwdPos.x, bwdPos.y, bwdPos.z + 500.0)

                    if (bwdPos.z < bwdZ and not (bwdZ > vehiclePos.z + 1.0)) then
                        bwdPos.z = bwdZ + 0.5
                    end

                    local packedBwdPos = vector3(bwdPos.x, bwdPos.y, bwdPos.z)
                    local bwdVeh = GetVehicleInDirectionSphere(vehicle, vehiclePos, packedBwdPos)

                    if (DoesEntityExist(bwdVeh) and IsEntityAVehicle(bwdVeh)) then
                        local bwdVehSpeed = round(GetVehicleSpeed(bwdVeh), 0)
                        local bwdPlate = tostring(GetVehicleNumberPlateText(bwdVeh)) or ''
                        local bwdVehHeading = round(GetEntityHeading(bwdVeh), 0)
                        local dir = IsEntityInMyHeading(h, bwdVehHeading, 100)

                        radarInfo.bwdSpeed = FormatSpeed(bwdVehSpeed)
                        radarInfo.bwdDir = dir

                        if isVehicleHot(bwdPlate) and not radarInfo.bwdFastLocked then
                            TriggerHotSound()

                            radarInfo.bwdPlate = bwdPlate
                            radarInfo.bwdFastSpeed = bwdVehSpeed
                            radarInfo.bwdFastLocked = true
                            radarInfo.bwdPlateLocked = true

                            TriggerServerEvent('wraithrs:notification', bwdPlate)

                            SendNUIMessage({ event = 'lockBwdFast', status = true })

                            radarInfo.bwdFast = FormatSpeed(radarInfo.bwdFastSpeed)
                        else
                            if not radarInfo.bwdPlateLocked then
                                radarInfo.bwdPlate = bwdPlate
                            end

                            if (bwdVehSpeed > radarInfo.fastLimit and not radarInfo.bwdFastLocked) then
                                if (radarInfo.lockBeep) then
                                    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
                                end

                                radarInfo.bwdFastSpeed = bwdVehSpeed
                                radarInfo.bwdFastLocked = true
                                radarInfo.bwdPlateLocked = true

                                SendNUIMessage({ event = 'lockBwdFast', status = true })
                            end

                            radarInfo.bwdFast = FormatSpeed(radarInfo.bwdFastSpeed)
                        end
                        radarInfo.bwdPrevVeh = bwdVeh
                    end
                end

                SendNUIMessage({
                    event = 'updateData',
                    fwdspeed = radarInfo.fwdSpeed,
                    fwdfast = radarInfo.fwdFast,
                    fwddir = radarInfo.fwdDir,
                    fwdplate = radarInfo.fwdPlate,
                    fwdplatelock = radarInfo.fwdPlateLocked,
                    bwdspeed = radarInfo.bwdSpeed,
                    bwdfast = radarInfo.bwdFast,
                    bwddir = radarInfo.bwdDir,
                    bwdplate = radarInfo.bwdPlate,
                    bwdplatelock = radarInfo.bwdPlateLocked,
                })
            end
        end
    end
end

function isVehicleHot(plate)
    if hotVehicles[string.lower(plate)] ~= nil then
        return true
    else
        return false
    end
end

function TriggerHotSound()
    PlaySoundFrontend(-1, 'Beep_Green', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, 'Beep_Green', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
end

Citizen.CreateThread(function()
    SetNuiFocus(false)

    while true do
        ManageVehicleRadar()

        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = GetPlayerPed(-1)

        local inVehicle, vehicle = IsPedSittingInAnyVehicle(playerPed), nil

        if (inVehicle) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        end

        if (((not inVehicle or (inVehicle and GetVehicleClass(vehicle) ~= 18)) and isRadarEnabled and not isHidden) or IsPauseMenuActive() and isRadarEnabled) then
            isHidden = true
            SendNUIMessage({ event = 'hideRadar', status = true })
        elseif (inVehicle and GetVehicleClass(vehicle) == 18 and isRadarEnabled and isHidden) then
            isHidden = false
            SendNUIMessage({ event = 'hideRadar', status = false })
        end

        Citizen.Wait(0)
    end
end)

RegisterNetEvent('wraithrs:resetRadar')
AddEventHandler('wraithrs:resetRadar', function()
    ResetFrontFast()
    ResetRearFast()

    exports['crp-notifications']:SendAlert('inform', 'Radar resetado.')
end)

RegisterNetEvent('wraithrs:checkFrontRadar')
AddEventHandler('wraithrs:checkFrontRadar', function()
    TriggerServerEvent('wraithrs:checkPlate', radarInfo.fwdPlate)
end)

RegisterNetEvent('wraithrs:checkRearRadar')
AddEventHandler('wraithrs:checkRearRadar', function()
    TriggerServerEvent('wraithrs:checkPlate', radarInfo.bwdPlate)
end)

RegisterNetEvent('wraithrs:addVehicle')
AddEventHandler('wraithrs:addVehicle', function(newHotVehicles)
    hotVehicles = newHotVehicles
end)

RegisterNetEvent('wraithrs:updateradarlimit')
AddEventHandler('wraithrs:updateradarlimit', function(speed)
    if tonumber(speed) == 999 then
        radarInfo.fastLimit = 60

        ResetFrontFast()
        ResetRearFast()
    else
        radarInfo.fastLimit = tonumber(speed)
    end
end)

RegisterNetEvent('wraithrs:toggleradar')
AddEventHandler('wraithrs:toggleradar', function()
    local playerPed = GetPlayerPed(-1)

    if (IsPedSittingInAnyVehicle(playerPed)) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if (GetVehicleClass(vehicle) == 18) then
            isRadarEnabled = not isRadarEnabled

            if (isRadarEnabled) then
                exports['crp-notifications']:SendAlert('inform', 'Radar ligado.')
            else
                exports['crp-notifications']:SendAlert('inform', 'Radar desligado.')
            end

            ResetFrontAntenna()
            ResetRearAntenna()

            SendNUIMessage({
                event = 'toggleRadar',
                fwdxmit = radarInfo.fwdXmit,
                fwdmode = radarInfo.fwdMode,
                bwdxmit = radarInfo.bwdXmit,
                bwdmode = radarInfo.bwdMode
            })
        else
            exports['crp-notifications']:SendAlert('inform', 'Precisas de estar num veículo da polícia.')
        end
    else
        exports['crp-notifications']:SendAlert('inform', 'Precisas de estar num veículo para ligar o radar.')
    end
end)