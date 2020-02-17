local keys, searchedVehicles, hotwiredVehicles = {}, {}, {}
local isDoingSomething, isDoingAnimation, isTurningEngineOff, isUsingKeys, vehicleTimer = false, false, false, false, 0

RegisterNetEvent('crp-keys:updateKeys')
AddEventHandler('crp-keys:updateKeys', function(characterKeys)
    for i = 1, #characterKeys do
        if not HasVehicleKey(characterKeys[i]) then
            table.insert(keys, characterKeys[i])
        end
    end
end)

RegisterNetEvent('crp-keys:updateKey')
AddEventHandler('crp-keys:updateKey', function(vehicle, vehiclePlate, state)
    vehiclePlate = vehiclePlate or GetVehicleNumberPlateText(vehicle)

    if state then
        if not HasVehicleKey(vehiclePlate) then
            table.insert(keys, vehiclePlate)
        end
    else
        if HasVehicleKey(vehiclePlate) then
            table.remove(keys, FindTableIndex(keys, vehiclePlate))
        end
    end
end)

RegisterNetEvent('crp-keys:giveKey')
AddEventHandler('crp-keys:giveKey', function()
    if #keys == 0 then
        exports['crp-notifications']:SendAlert('inform', 'Não tens nenhuma chave para dar.')
        return
    end

    local playerPed = GetPlayerPed(-1)
    local coordsA, coordsB = GetEntityCoords(playerPed, 1), GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 100.0, 0.0)
    local vehicle = GetVehicleInDirection(coordsA, coordsB)

    if vehicle == nil or not DoesEntityExist(vehicle) then
        exports['crp-notifications']:SendAlert('inform', 'Não foi encontrado nenhum veículo.')
        return
    end

    if not HasVehicleKey(GetVehicleNumberPlateText(vehicle)) then
        exports['crp-notifications']:SendAlert('inform', 'Não tens as chaves deste veículo.')
        return
    end

    if #(GetEntityCoords(vehicle) - GetEntityCoords(playerPed, 0)) > 4.0 then
        exports['crp-notifications']:SendAlert('inform', 'Estás muito longe do veículo.')
        return
    end

    local player, distance = GetClosestPlayer()

    if distance ~= -1 and distance > 4.0 then
        TriggerServerEvent('crp-keys:giveKey', GetPlayerServerId(player), GetVehicleNumberPlateText(vehicle))

        exports['crp-notifications']:SendAlert('success', 'Acabaste de dar as chaves do teu veículo.')
    else
        exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum jogador próximo.')
    end
end)

RegisterNetEvent('crp-keys:turnEngine')
AddEventHandler('crp-keys:turnEngine', function(state)
    if state then
        local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))

        if GetVehicleEngineHealth(vehicle) > 200 then
            vehicleTimer = 0

            SetVehicleEngineOn(vehicle, 0, 1, 1)

            Citizen.Wait(100)

            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, 1, 0, 1)

            Citizen.Wait(100)

            if not GetIsVehicleEngineRunning(vehicle) then
                SetVehicleEngineOn(vehicle, 1, 1, 1)
            end
        else
            SetVehicleEngineOn(vehicle, 0, 0, 1)
            SetVehicleUndriveable(vehicle, true)
        end
    else
        if isTurningEngineOff then
            return
        end

        vehicleTimer, isTurningEngineOff = 1000, true

        while vehicleTimer > 0 do
            Citizen.Wait(0)
            local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))

            SetVehicleEngineOn(vehicle, 0, 1, 1)

            vehicleTimer = vehicleTimer - 1
        end

        vehicleTimer, isTurningEngineOff = 0, false
    end
end)

RegisterNetEvent('crp-keys:vehicleStatus')
AddEventHandler('crp-keys:vehicleStatus', function(vehicle)
    local playerPed = GetPlayerPed(-1)
    local isInVehicle, vehicleStatus = IsPedInAnyVehicle(playerPed), GetVehicleDoorLockStatus(vehicle)

    if not isInVehicle then
        TriggerVehicleAnimation()
    end

    if vehicleStatus == 1 or vehicleStatus == 0 then
        vehicleStatus = SetVehicleDoorsLocked(vehicle, 2)

        SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)

        TriggerServerEvent('interact-sound:playWithinDistance', 2.5, 'vehiclesound', 0.5)

        exports['crp-notifications']:SendAlert('inform', 'Veículo trancado.')

        if not isInVehicle then
            TriggerVehicleLights(vehicle, true)
        end
    else
        vehicleStatus = SetVehicleDoorsLocked(vehicle, 1)

        TriggerServerEvent('interact-sound:playWithinDistance', 2.5, 'vehiclesound', 0.5)

        exports['crp-notifications']:SendAlert('inform', 'Veículo destrancado.')

        if not isInVehicle then
            TriggerVehicleLights(vehicle, false)
        end
    end

    Citizen.Wait(1000)

    isUsingKeys = false
end)

-- RegisterNetEvent('crp-keys:engineHasKeys')
-- AddEventHandler('car:engineHasKeys', function(vehicle, allow)

--     if isCop then
--         allow = true
--     end
--     if allow then
--         if IsVehicleEngineOn(targetVehicle) then
--             if not waitKeys then
--                 waitKeys = true
--                 SetVehicleEngineOn(targetVehicle,0,1,1)
--                 SetVehicleUndriveable(targetVehicle,true)
--                 TriggerEvent("DoShortHudText", "Engine Halted",9)
--                 Citizen.Wait(300)
--                 waitKeys = false
--             end
--         else
--             if not waitKeys then
--                 waitKeys = true
--                 TriggerEvent("keys:startvehicle")
--                 TriggerEvent("DoShortHudText", "Engine Started",9)
--                 Citizen.Wait(300)
--                 waitKeys = false
--             end
--         end
--     end
-- end)


-- local bypass = false
-- local enforce = 0
-- local dele = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, 27) then
            local playerPed = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsUsing(playerPed)

            if not IsPedGettingIntoAVehicle(playerPed) and vehicle and GetPedInVehicleSeat(vehicle, -1) == playerPed and HasVehicleKey(GetVehicleNumberPlateText(vehicle)) then
                if not isUsingKeys then
                    isUsingKeys = true

                    if IsVehicleEngineOn(vehicle) then
                        SetVehicleEngineOn(vehicle, 0, 1, 1)
                        SetVehicleUndriveable(vehicle, true)

                        exports['crp-notifications']:SendAlert('inform', 'Veículo desligado.')
                    else
                        TriggerEvent('crp-keys:turnEngine', true)

                        exports['crp-notifications']:SendAlert('inform', 'Veículo ligado.')
                    end

                    Citizen.Wait(500)

                    isUsingKeys = false
                end
            end
        end

        if IsControlJustPressed(0, 303) then
            local playerPed = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsUsing(playerPed)

            if not DoesEntityExist(vehicle) then
                local coordsA, coordsB = GetEntityCoords(playerPed, 1), GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 100.0, 0.0)

                vehicle = GetVehicleInDirection(coordsA, coordsB)
            end

            if DoesEntityExist(vehicle) and not isUsingKeys and HasVehicleKey(GetVehicleNumberPlateText(vehicle)) then
                isUsingKeys = true

                TriggerEvent('crp-keys:vehicleStatus', vehicle)
            end

            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    local lastVehicle = 0

    while true do
        Citizen.Wait(0)

        local playerPed = GetPlayerPed(-1)

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsUsing(playerPed)
            local vehiclePlate = GetVehicleNumberPlateText(vehicle)

            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                if (lastVehicle ~= vehicle and not HasVehicleKey(vehiclePlate)) or not HasVehicleKey(vehiclePlate) then
                    TriggerEvent('crp-keys:turnEngine', false)
                end

                if not HasVehicleKey(vehiclePlate) then
                    if vehicleTimer > 0 then
                        local cords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.0, 1.0)

                        DrawText3D(cords.x, cords.y, cords.z, '[G] Procurar / [H] Ligação direta')
                    end

                    if IsControlJustReleased(2, 47) and not isDoingSomething then
                        Citizen.Wait(1000)

                        SearchVehicle()
                    end

                    if IsControlJustReleased(2, 74) and not isDoingSomething then
                        Citizen.Wait(1000)

                        HotwireVehicle()
                    end
                else
                    Citizen.Wait(500)
                end

                lastVehicle = vehicle
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local letSleep, playerPed = true, GetPlayerPed(-1)

        if GetVehiclePedIsTryingToEnter(playerPed) ~= nil and GetVehiclePedIsTryingToEnter(playerPed) ~= 0 then
            letSleep = false

            local currentVehicle = GetVehiclePedIsTryingToEnter(playerPed)
            local vehiclePlate = GetVehicleNumberPlateText(currentVehicle)

            if not HasVehicleKey(vehiclePlate) then
                local vehicleDriver = GetPedInVehicleSeat(currentVehicle, -1)

                if not isDoingSomething and vehicleDriver ~= 0 and (not IsPedAPlayer(vehicleDriver) or IsEntityDead(vehicleDriver)) then
                    isDoingSomething = true

                    if IsEntityDead(vehicleDriver) then
                        TriggerClientEvent('crp-alerts:alertPolice', 15.0, currentVehicle)

                        exports['crp-progressbar']:StartProgressBar({ duration = 3500, label = 'Roubando as chaves' }, function(finished)
                            if finished then
                                TriggerServerEvent('crp-keys:addKey', currentVehicle, vehiclePlate)
                                -- ! TriggerEvent("timer:stolenvehicle",plate1) / add timer to stolen vehicle maybe?
                            end

                            isDoingSomething = false
                        end)
                    else
                        if (GetRandomNumber(100) < 65) or isVehicleCompatible(currentVehicle) then
                            TriggerEvent('crp-alerts:alertPolice', 15.0, 'PersonRobbed', currentVehicle)

                            exports['crp-progressbar']:StartProgressBar({ duration = 3500, label = 'Roubando as chaves' }, function(finished)
                                if finished then
                                    TriggerServerEvent('crp-keys:addKey', currentVehicle, vehiclePlate)
                                end

                                isDoingSomething = false
                            end)
                        else
                            SetVehicleDoorsLocked(currentVehicle, 2)

                            Citizen.Wait(1000)

                            TriggerEvent('crp-alerts:alertPolice', 15.0, 'PersonRobbed', currentVehicle)

                            SetVehicleCanBeUsedByFleeingPeds(currentVehicle, true)

                            Citizen.Wait(100)

                            TaskReactAndFleePed(vehicleDriver, playerPed)
                            SetPedKeepTask(vehicleDriver, true)

                            local isWaiting = true

                            Citizen.CreateThread(function()
                                repeat
                                    Citizen.Wait(0)

                                    DisableControlAction(0, 23, true)
                                until isWaiting == false
                            end)

                            Citizen.Wait(3000)

                            isWaiting, isDoingSomething = false, false
                        end
                    end
                end
            end
        elseif isDoingSomething then
            Citizen.Wait(1000)

            if isDoingSomething and not GetVehiclePedIsUsing(playerPed) then
                exports['crp-progressbar']:CancelAction()
            end
        end

        if IsPedJacking(playerPed) then
            local vehicle, isCheckingVehicle = GetVehiclePedIsUsing(playerPed), true
            local vehiclePlate = GetVehicleNumberPlateText(vehicle)

            letSleep = false

            while isCheckingVehicle do
                Citizen.Wait(0)

                local isInVehicle = IsPedInAnyVehicle(playerPed, false)

                if not isInVehicle then
                    isCheckingVehicle = false
                end

                if IsVehicleEngineOn(vehicle) and not HasVehicleKey(vehiclePlate) then
                    TriggerEvent('crp-keys:turnEngine', false)

                    isCheckingVehicle = false
                end
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

function SearchVehicle()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsUsing(playerPed)

    if searchedVehicles[vehicle] then
        return
    end

    searchedVehicles[vehicle], isDoingSomething = true, true

    TriggerEvent('crp-keys:turnEngine', false)

    if not IsPedInAnyVehicle(playerPed, false) then
        isDoingSomething = false
        return
    end

    exports['crp-progressbar']:StartProgressBar({ duration = 5000, label = 'Procurando...' }, function(finished)
        if finished then
            if not IsPedInAnyVehicle(playerPed, false) then
                isDoingSomething = false
                return
            end

            local randomNumber = GetRandomNumber(0, 100)

            if randomNumber >= 95 then
                exports['crp-notifications']:SendAlert('success', 'Encontraste as chaves no veículo e ligaste-o.')

                TriggerServerEvent('crp-keys:addKey', vehicle, GetVehicleNumberPlateText(vehicle))

                Citizen.Wait(1000)

                SetVehicleEngineOn(vehicle, 1, 1, 1)
                SetVehicleUndriveable(vehicle, false)
            else
                Citizen.Wait(1000)

                exports['crp-progressbar']:StartProgressBar({ duration = 5000, label = 'Procurando no resto do veículo...' }, function(finished)
                    if finished then
                        if not IsPedInAnyVehicle(playerPed, false) then
                            isDoingSomething = false
                            return
                        end

                        randomNumber = GetRandomNumber(0, 100)

                        if randomNumber >= 87 then
                            -- ! Found a item (give random item to player)

                            exports['crp-notifications']:SendAlert('success', 'Encontraste um item no veículo.')
                        else
                            exports['crp-notifications']:SendAlert('error', 'Não encontraste nada no veículo.')
                        end
                    end
                end)
            end
        end

        isDoingSomething = false
    end)
end

function HotwireVehicle()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsUsing(playerPed)

    if hotwiredVehicles[vehicle] then
        return
    end

    TriggerAnimation(true)

    hotwiredVehicles[vehicle], isDoingSomething = true, true

    TriggerEvent('crp-keys:turnEngine', false)

    if not IsPedInAnyVehicle(playerPed, false) then
        isDoingSomething, vehicleTimer = false, 0
        return
    end

    vehicleTimer = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'nMonetaryValue')
    vehicleTimer = GetRandomNumber(math.ceil(vehicleTimer / 2), math.ceil(vehicleTimer))

    if vehicleTimer > 100000 then
        vehicleTimer = 100000
    end

    if vehicleTimer > 35000 then
        vehicleTimer = 35000
    end

    exports['crp-progressbar']:StartProgressBar({ duration = vehicleTimer, label = 'Fazendo ligação direta' }, function(finished)
        if finished then
            if not IsPedInAnyVehicle(playerPed, false) then
                isDoingSomething = false
                return
            end

            local randomNumber = GetRandomNumber(0, 100)

            if randomNumber >= 73 then
                TriggerServerEvent('crp-keys:addKey', vehicle, GetVehicleNumberPlateText(vehicle))

                Citizen.Wait(1000)

                SetVehicleEngineOn(vehicle, 1, 1, 1)
                SetVehicleUndriveable(vehicle, false)

                exports['crp-notifications']:SendAlert('success', 'Ligação direta feita com sucesso.')
            else
                SetVehicleAlarm(vehicle, true)
	            StartVehicleAlarm(vehicle)

                exports['crp-notifications']:SendAlert('error', 'Não conseguiste fazer ligação direta ao veículo.')
            end
        end

        TriggerAnimation(false)

        isDoingSomething, vehicleTimer = false, 0
    end)
end

function TriggerAnimation(state)
    local playerPed = GetPlayerPed(-1)

    if not state then
        isDoingAnimation = false
        ClearPedTasks(playerPed)
        return
    end

    isDoingAnimation = true

    RequestAnimDict('mini@repair')

    while not HasAnimDictLoaded('mini@repair') do
        Citizen.Wait(0)
    end

    Citizen.CreateThread(function()
        while isDoingAnimation do
            if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_player', 3) then
                ClearPedSecondaryTask(playerPed)

                TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, 8.0, -1, 16, 0, 0, 0, 0)
            end

            Citizen.Wait(1)
        end
    end)

    ClearPedTasks(playerPed)
end

function TriggerVehicleAnimation()
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

function TriggerVehicleLights(vehicle, status)
    if status then
        SetVehicleLights(vehicle, 2)
        SetVehicleBrakeLights(vehicle, true)
        SetVehicleInteriorlight(vehicle, true)
        SetVehicleIndicatorLights(vehicle, 0, true)
        SetVehicleIndicatorLights(vehicle, 1, true)

        Citizen.Wait(450)

        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)

        Citizen.Wait(450)

        SetVehicleInteriorlight(vehicle, true)
        SetVehicleIndicatorLights(vehicle, 0, true)
        SetVehicleIndicatorLights(vehicle, 1, true)

        Citizen.Wait(450)

        SetVehicleLights(vehicle, 0)
        SetVehicleBrakeLights(vehicle, false)
        SetVehicleInteriorlight(vehicle, false)
        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)
    else
        SetVehicleLights(vehicle, 2)
        SetVehicleFullbeam(vehicle, true)
        SetVehicleBrakeLights(vehicle, true)
        SetVehicleInteriorlight(vehicle, true)
        SetVehicleIndicatorLights(vehicle, 0, true)
        SetVehicleIndicatorLights(vehicle, 1, true)

        Citizen.Wait(450)

        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)

        Citizen.Wait(450)

        SetVehicleInteriorlight(vehicle, true)
        SetVehicleIndicatorLights(vehicle, 0, true)
        SetVehicleIndicatorLights(vehicle, 1, true)

        Citizen.Wait(450)

        SetVehicleLights(vehicle, 0)
        SetVehicleFullbeam(vehicle, false)
        SetVehicleBrakeLights(vehicle, false)
        SetVehicleInteriorlight(vehicle, false)
        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)
    end
end

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

function HasVehicleKey(vehiclePlate)
    for k, v in pairs(keys) do
        if v == vehiclePlate then
            return true
        end
    end
    return false
end

function isVehicleCompatible(vehicle)
    local vehicleClass = GetVehicleClass(vehicle)

    if vehicleClass == 13 or vehicleClass == 8 then
        return true
    end

    return false
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

function FindTableIndex(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end