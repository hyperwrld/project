CRP.SpawnManager = {}

function CRP.SpawnManager.Initialize(self)
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)

        FreezeEntityPosition(playerPed, true)

        TransitionToBlurred(500)
        DoScreenFadeOut(500)

        ShutdownLoadingScreen()

        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)

        SetCamRot(cam, 0.0, 0.0, 15.0, 2)
        SetCamCoord(cam, 180.789, -1035.451, 296.092)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        SetEntityCoordsNoOffset(playerPed, 180.789, -1035.451, 296.092, false, false, false, true)

        --SetEntityVisible(playerPed, false)

        TriggerEvent('crp-base:spawnInitialized')

        DoScreenFadeIn(500)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end
    end)
end

function CRP.SpawnManager.InitialSpawn(self)
	Citizen.CreateThread(function()
        DisableAllControlActions(0)

        TransitionToBlurred(500)        
        DoScreenFadeOut(500)

        while IsScreenFadingOut() do
            Citizen.Wait(0)
        end

        local spawn = CRP.Enums.SpawnLocations.Initial[1]

        spawn = {
            model = 'mp_m_freemode_01',
            x = spawn[1],
            y = spawn[2],
            z = spawn[3],
            heading = spawn[4]
        }

        local playerPed = GetPlayerPed(-1)

        if spawn.model then
            RequestModel(spawn.model)

            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)
                Wait(0)
            end

            SetPlayerModel(PlayerId(), spawn.model)
            SetModelAsNoLongerNeeded(spawn.model)
            SetPedDefaultComponentVariation(GetPlayerPed(-1))
        end

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        SetEntityCoordsNoOffset(playerPed, spawn.x, spawn.y, spawn.z, false, false, false, true)

        SetEntityVisible(playerPed, true)
        FreezeEntityPosition(playerPed, false)

        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)
        
        ClearPedTasksImmediately(playerPed)
        RemoveAllPedWeapons(playerPed)
        ClearPlayerWantedLevel(PlayerId())

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(playerPed) do
            if GetGameTimer() - startedCollision > 8000 then break end
            Citizen.Wait(0)
        end

        Citizen.Wait(500)
        
        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end

        TransitionFromBlurred(500)
        EnableAllControlActions(0)
    end)
end

AddEventHandler('crp-base:firstSpawn', function()
    CRP.SpawnManager:InitialSpawn()

    Citizen.CreateThread(function()
        Citizen.Wait(600)
        DestroyAllCams(true)
        RenderScriptCams(false, true, 1, true, true)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end)
end)

RegisterNetEvent('crp-base:money')
AddEventHandler('crp-base:money', function(state, money)
	SendNUIMessage({ state = state, money = money })
end)