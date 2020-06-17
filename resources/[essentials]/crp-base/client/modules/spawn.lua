CRP.Spawn = {}

function CRP.Spawn.InitializeMenu(self)
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

    TriggerEvent('crp-base:openMainMenu')
end