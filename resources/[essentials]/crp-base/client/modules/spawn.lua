CRP.Spawn = {}

function CRP.Spawn:InitializeMenu()
    local playerPed = GetPlayerPed(-1)

    FreezeEntityPosition(playerPed, true)

    TransitionToBlurred(500)
    DoScreenFadeOut(500)

    ShutdownLoadingScreen()

    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)

    SetCamRot(cam, 0.0, 0.0, 15.0, 2)
    SetCamCoord(cam, 180.789, -1035.451, 296.092)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    SetEntityCoordsNoOffset(playerPed, 180.789, -1035.451, 296.092, false, false, false, true)
    SetEntityVisible(playerPed, false)

    DoScreenFadeIn(500)

    while IsScreenFadingIn() do
        Citizen.Wait(0)
    end

    TriggerEvent('crp-ui:openMenu', 'characterList')
end

function CRP.Spawn:InitializeFirstSpawn()
    Citizen.CreateThread(function()
        local playerPed, playerId = GetPlayerPed(-1), PlayerId()

        DisableAllControlActions(0)

        TriggerScreenblurFadeIn(500)
        DoScreenFadeOut(500)

        while IsScreenFadingOut() do
            Citizen.Wait(0)
        end

        local spawn = {
            ['model'] = 'mp_m_freemode_01', ['x'] = -1037.75, ['y'] = -2738.04, ['z'] = 20.17, ['h'] = 333.78
        }

        RequestModel(spawn['model'])

        while not HasModelLoaded(spawn['model']) do
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), spawn['model'])
        SetModelAsNoLongerNeeded(spawn['model'])
        SetPedDefaultComponentVariation(GetPlayerPed(-1))

        RequestCollisionAtCoord(spawn['x'], spawn['y'], spawn['z'])
        SetEntityCoordsNoOffset(playerPed, spawn['x'], spawn['y'], spawn['z'], false, false, false, true)
        NetworkResurrectLocalPlayer(spawn['x'], spawn['y'], spawn['z'], spawn['h'], true, true, false)

        ClearPedTasksImmediately(playerPed)
        RemoveAllPedWeapons(playerPed)
        ClearPlayerWantedLevel(playerId)

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(playerPed) do
            if GetGameTimer() - startedCollision > 8000 then
                break
            end
            Citizen.Wait(0)
        end

        FreezeEntityPosition(playerPed, false)
        SetEntityVisible(GetPlayerPed(-1), true)

        TriggerScreenblurFadeOut(500)
        DoScreenFadeIn(500)

        Citizen.Wait(500)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end

        TriggerEvent('chat:addMessage', { color = {255, 255, 255}, templateId = 'red', args = { 'INFO', 'Bem-vindo ao cacem, chama um taxi para te conseguires mover mais rápido na cidade.' }})

        EnableAllControlActions(0)

        TriggerEvent('crp-skincreator:openMenu', 'barbermenu', true)
    end)
end