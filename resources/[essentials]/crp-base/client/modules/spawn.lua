CRP.Spawn, CRP.SpawnPoints = {}, {}

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

    TriggerEvent('crp-ui:openMenu', 'character')
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

function CRP.Spawn:InitializeSpawnSelection(motelSpawnPoint)
    local playerPed = PlayerPedId()

    SetEntityCoords(playerPed, 151.381, -1008.003, -99.0)
    FreezeEntityPosition(playerPed, true)
    SetEntityInvincible(playerPed, true)

    CRP.SpawnPoints = {
        { ['x'] = -204.93,  ['y'] = -1010.13, ['z'] = 29.55,  ['h'] = 180.99, ['info'] = 'ALTEE STREET TRAIN STATION', ['spawnType'] = 1 },
        { ['x'] = 272.16,   ['y'] = 185.44,   ['z'] = 104.67, ['h'] = 320.57, ['info'] = 'VINEWOOD BLVD TAXI STAND',   ['spawnType'] = 1 },
        { ['x'] = -1833.96, ['y'] = -1223.5,  ['z'] = 13.02,  ['h'] = 310.63, ['info'] = 'THE BOARDWALK',              ['spawnType'] = 1 },
        { ['x'] = 1122.11,  ['y'] = 2667.24,  ['z'] = 38.04,  ['h'] = 180.39, ['info'] = 'HARMONY MOTEL',              ['spawnType'] = 1 },
        { ['x'] = 453.29,   ['y'] = -662.23,  ['z'] = 28.01,  ['h'] = 5.73,   ['info'] = 'LS BUS STATION',             ['spawnType'] = 1 },
        { ['x'] = -1266.53, ['y'] = 273.86,   ['z'] = 64.66,  ['h'] = 28.52,  ['info'] = 'THE RICHMAN HOTEL',          ['spawnType'] = 1 },
        { ['x'] = 145.62,   ['y'] = 6563.19,  ['z'] = 32.0,   ['h'] = 42.83,  ['info'] = 'PALETO GAS STATION',         ['spawnType'] = 1 },
        { ['x'] = -214.24,  ['y'] = 6178.87,  ['z'] = 31.17,  ['h'] = 40.11,  ['info'] = 'PALETO BUS STOP',            ['spawnType'] = 1 }
    }

    CRP.SpawnPoints[#CRP.SpawnPoints + 1] = motelSpawnPoint

    TriggerEvent('crp-ui:openMenu', 'spawnSelection', CRP.SpawnPoints)

    DoScreenFadeIn(2500)

    CRP.Spawn:TriggerCameraAnimation()
end

local isSpawning, canKillCam, currentSelection, cam = false, false, 1, 0

function CRP.Spawn:TriggerCameraAnimation()
    canKillCam = true

    if isSpawning then
        return
    end

    Citizen.Wait(1)

    canKillCam = false

    local camSelection = currentSelection

    DoScreenFadeOut(1)

    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local x = CRP.SpawnPoints[currentSelection]['x']
    local y = CRP.SpawnPoints[currentSelection]['y']
    local z = CRP.SpawnPoints[currentSelection]['z']
    local h = CRP.SpawnPoints[currentSelection]['h']

    SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
    SetCamActive(cam, true)

    RenderScriptCams(true, false, 0, true, true)
    DoScreenFadeIn(1500)

    local i, camAngle = 3200, -90.0

    while i > 1 and camSelection == currentSelection and not isSpawning and not canKillCam do
        local factor = i / 50

        if i < 1 then
            i = 1
        end

        i = i - factor

        SetCamCoord(cam, x, y, z + i)

        if i < 1200 then
            DoScreenFadeIn(600)
        end

        if i < 90.0 then
            camAngle = i - i - i
        end

        SetCamRot(cam, camAngle, 0.0, 0.0)

        Citizen.Wait(0)
    end
end

function CRP.Spawn:ChangeSelection(index)
    if isSpawning then
        return
    end

    currentSelection = index

    CRP.Spawn:TriggerCameraAnimation()
end

function CRP.Spawn:SpawnCharacter()
    local playerPed = GetPlayerPed(-1)

    isSpawning = true

    DoScreenFadeOut(100)

    Citizen.Wait(100)

    local x = CRP.SpawnPoints[currentSelection]['x']
    local y = CRP.SpawnPoints[currentSelection]['y']
    local z = CRP.SpawnPoints[currentSelection]['z']
    local h = CRP.SpawnPoints[currentSelection]['h']

    ClearFocus()
    SetNuiFocus(false, false)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)

    if CRP.SpawnPoints[currentSelection]['spawnType'] == 1 then
        SetEntityCoords(playerPed, x, y, z)
        SetEntityHeading(playerPed, h)
    elseif CRP.SpawnPoints[currentSelection]['spawnType'] == 2 then
        -- TODO: TriggerEvent('crp-apartments:buildHotelInterior', myRoomNumber, myRoomNumber)
    elseif CRP.SpawnPoints[currentSelection]['spawnType'] == 3 then
        -- TODO:
    end

    SetEntityInvincible(playerPed, false)
    FreezeEntityPosition(playerPed, false)

    Citizen.Wait(4000)

    DoScreenFadeIn(100)

    if DoesCamExist(cam) then
        DestroyCam(cam, false)
    end
end