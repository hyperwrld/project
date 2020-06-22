local hasJoined, canShuffle, timer = false, false, 0

local function SetGameplayVariables()
    if hasJoined then
        return
    end

    hasJoined = true

    Citizen.CreateThread(function()
        for i = 1, 25 do
            EnableDispatchService(i, false)
        end

        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerId(), true, true)

        while true do
            Citizen.Wait(0)

            local playerPed, playerId = GetPlayerPed(-1), PlayerId()
            local position, vehicle = GetEntityCoords(playerPed, false), GetVehiclePedIsIn(playerPed, false)

            SetPlayerWantedLevel(playerId, 0, false)
            SetPlayerWantedLevelNow(playerId, false)
            ClearAreaOfCops(position, 400.0)

            SetPlayerHealthRechargeMultiplier(playerId, 0.0) -- Disable Health Regenerate
            DisablePlayerVehicleRewards(playerId) -- Disable Vehicle Rewards
            SetPedSuffersCriticalHits(playerPed, false) -- Disable Headshot Damage

            if IsPedInAnyVehicle(playerPed, false) and not canShuffle then
                if GetPedInVehicleSeat(vehicle, 0) == playerPed then
                    if not GetIsTaskActive(playerPed, 164) and GetIsTaskActive(playerPed, 165) then
                        SetPedIntoVehicle(PlayerPedId(), vehicle, 0)
                    end
                end
            end
        end
    end)
end

AddEventHandler('crp-base:onPlayerJoined', function()
    CRP.Spawn:InitializeMenu()

    SetGameplayVariables()
end)

RegisterNetEvent('crp-base:displayMe')
AddEventHandler('crp-base:displayMe', function(player, message)
    local playerPed, targetPed = GetPlayerPed(-1), GetPlayerPed(GetPlayerFromServerId(player))

    if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) < 8.0 and HasEntityClearLosToEntity(playerPed, targetPed, 17) then
        DisplayMe(message, targetPed)
    end
end)

-- TODO: Finish display /me

function DisplayMe(message, targetPed)
    timer, meCount = 900, meCount + 0.20

    local currentMessage = meCount

    while timer > 0 do
        Citizen.Wait(0)

        timer = timer - 1

        local coords, isInVehicle = GetEntityCoords(targetPed), IsPedInAnyVehicle(targetPed, false)

        if not isInVehicle and GetFollowPedCamViewMode() == 0 then
            DrawText3D(coords['x'], coords['y'], coords['z'] + (currentMessage / 2) - 0.2, message, timer)
        elseif not isInVehicle and GetFollowPedCamViewMode() == 4 then
            DrawText3D(coords['x'], coords['y'], coords['z'] + (currentMessage / 7) - 0.1, message, timer)
        elseif GetFollowPedCamViewMode() == 4 then
            DrawText3D(coords['x'], coords['y'], coords['z'] + (currentMessage / 7) - 0.2, message, timer)
        else
            DrawText3D(coords['x'], coords['y'], coords['z'] + currentMessage - 1.25, message, timer)
        end
    end
end

function DrawText3D(x, y, z, text, opacity)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if opacity > 255 then
        opacity = 255
    end

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, opacity)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(1, 0, 0, 0, 250)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(1)

        SetTextEntry('STRING')
        AddTextComponentString(text)
        DrawText(_x, _y)

        local factor = (string.len(text)) / 250

        if opacity >= 120 then
            DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 11, 1, 11, 120)
        else
            DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 11, 1, 11, opacity)
        end
    end
end