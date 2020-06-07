Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        if NetworkIsPlayerActive(PlayerId()) then
            ShutdownLoadingScreenNui()

			TriggerEvent('crp-base:onPlayerJoined')
			break
		end
	end
end)

AddEventHandler('crp-base:spawnPlayer', function()
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
end)