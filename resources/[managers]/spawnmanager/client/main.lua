local isSpawning = false

local function freezePlayer(playerId, freeze)
    SetPlayerControl(playerId, not freeze, false)

    local playerPed = GetPlayerPed(playerId)

    if not freeze then
        if not IsEntityVisible(playerPed) then
            SetEntityVisible(playerPed, true)
        end

        if not IsPedInAnyVehicle(playerPed) then
            SetEntityCollision(playerPed, true)
        end

        FreezeEntityPosition(playerPed, false)
        SetPlayerInvincible(playerId, false)
    else
        if IsEntityVisible(playerPed) then
            SetEntityVisible(playerPed, false)
        end

        SetEntityCollision(playerPed, false)
        FreezeEntityPosition(playerPed, true)
        SetPlayerInvincible(playerId, true)

        if not IsPedFatallyInjured(playerPed) then
            ClearPedTasksImmediately(playerPed)
        end
    end
end

function spawnPlayer(coords)
    if isSpawning then
        return
    end

    isSpawning = true

    Citizen.CreateThread(function()
		DoScreenFadeOut(500)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

        freezePlayer(PlayerId(), true)
		RequestCollisionAtCoord(coords)

		local playerPed = PlayerPedId()

        SetEntityCoordsNoOffset(playerPed, coords, false, false, false, true)
		NetworkResurrectLocalPlayer(coords, true, true, false)

        playerPed = PlayerPedId()

        ClearPedTasksImmediately(playerPed)
        RemoveAllPedWeapons(playerPed)
        ClearPlayerWantedLevel(PlayerId())

        local time = GetGameTimer()

        while (not HasCollisionLoadedAroundEntity(playerPed) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end

        ShutdownLoadingScreen()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)

            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end

        freezePlayer(PlayerId(), false)

        TriggerEvent('playerSpawned')

        isSpawning = false
    end)
end

exports('spawnPlayer', spawnPlayer)