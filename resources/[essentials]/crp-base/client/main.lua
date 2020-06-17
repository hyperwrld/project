local isMenuOpen = false

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

AddEventHandler('crp-base:openMainMenu', function()
    isMenuOpen = true

    SendNUIMessage({ eventName = 'toggleMenu', status = true, component = 'mainMenu' })

    SetNuiFocus(true, true)

    Citizen.CreateThread(function()
        while isMenuOpen do
			Citizen.Wait(0)

			HideHudAndRadarThisFrame()
			DisableAllControlActions(0)
			TaskSetBlockingOfNonTemporaryEvents(GetPlayerPed(-1), true)
		end
    end)
end)

local function closeMenu()
	isMenuOpen = false

	EnableAllControlActions(0)
	TaskSetBlockingOfNonTemporaryEvents(GetPlayerPed(-1), false)
	SetNuiFocus(false, false)
end

local function nuiCallBack(data, cb)
	if data.close then closeMenu() end
	if data.disconnect then TriggerServerEvent('crp-base:disconnect') end

    if data.error then
        exports['crp-notifications']:SendAlert('error', data.errorMessage)
    end

    if data.fetchCharacters then
        cb(CRP.RPC:execute('FetchCharacters'))
	end

    if data.createCharacter then
        local _data = CRP.RPC:execute('CreateCharacter', data.character)

        if _data and not _data.status then
            local errorMessage = 'Ocorreu um erro ao criar a sua personagem, contacte um administrador, caso o problema continue.'

            if data.message then
                errorMessage = data.message
            end

            exports['crp-notifications']:SendAlert('error', errorMessage)

            cb({ status = false })
            return
        end

        cb(_data)
	end

    if data.deleteCharacter then
		events:Trigger('crp-base:deleteCharacter', data.characterId, function(deleted)
			cb(true)
		end)
	end

    if data.selectCharacter then
        events:Trigger('crp-base:selectCharacter', data.characterId, function(data)
			if not data.isLoggedIn then
				cb({ status = true, message = 'Ocorreu um erro ao entrar na sua personagem, contacte um administrador se isto continuar.' })
				return
            end

            local playerPed, player, newCharacter = GetPlayerPed(-1), exports['crp-base']:getModule('Player'), false

            if data.characterData.skin == nil then
                newCharacter = true
            end

			player:setVar('character', data.id)

			SendNUIMessage({ eventName = 'close' })

            SetPlayerInvincible(playerPed, true)

			closeMenu()

            Citizen.Wait(5000)

            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            TriggerScreenblurFadeOut(500)

            if newCharacter then
                TriggerEvent('crp-base:spawnPlayer')
            else
                TriggerEvent('crp-skincreator:setPedFeatures', data.characterData.skin)
            end

            TriggerServerEvent('crp-apartments:spawnSelection', newCharacter)

            Citizen.Wait(1000)

			SetPlayerInvincible(GetPlayerPed(-1), false)
		end)
	end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

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