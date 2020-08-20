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

AddEventHandler('crp-base:spawnPlayer', function(data)
    local playerPed, isNewCharacter = GetPlayerPed(-1), false

    if data == nil then
        isNewCharacter = true
    end

    SetPlayerInvincible(playerPed, true)

    Citizen.Wait(5000)

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyAllCams(false)

    TriggerScreenblurFadeOut(500)

    if isNewCharacter then
        CRP.Spawn:InitializeFirstSpawn()
    else
        TriggerEvent('crp-skincreator:setPedFeatures', data)
    end

    TriggerServerEvent('crp-apartments:selectMotel', isNewCharacter)

    Citizen.Wait(1000)

    SetPlayerInvincible(GetPlayerPed(-1), false)
    FreezeEntityPosition(GetPlayerPed(-1), false)
end)

AddEventHandler('crp-base:spawnSelection', function(spawnPoint)
    CRP.Spawn:InitializeSpawnSelection(spawnPoint)
end)

RegisterNetEvent('crp-base:updateJob')
AddEventHandler('crp-base:updateJob', function(job, name, notify)
    if notify then
        local text = 'Novo trabalho: ' .. name .. '.'

        if job == 'unemployed' then
            text = 'Estás desempregado.'
        end

        TriggerEvent('crp-ui:setAlert', { type = 'inform', text = text, time = 3500 })
    end

    if job == 'unemployed' then
		SetPedRelationshipGroupDefaultHash(GetPlayerPed(-1), GetHashKey('PLAYER'))
    end

    TriggerEvent('crp-base:updateCurrentJob', job)
end)

function RegisterUiCallback(name, func)
    TriggerEvent('crp-ui:registerNuiCallback', name, func)
end

function WaitRegisterUiCallback()
    local isReady = exports['crp-ui']:isNuiCallbackReady()

    while not isReady do
        Citizen.Wait(1000)

        isReady = exports['crp-ui']:isNuiCallbackReady()
    end

    RegisterUiCallback('disconnect', function(data, cb)
        TriggerServerEvent('crp-base:disconnect')

        cb(true)
    end)

    RegisterUiCallback('error', function(errorMessage, cb)
        TriggerEvent('crp-ui:setAlert', { text = errorMessage, type = 'error' })

        cb(true)
    end)

    RegisterUiCallback('fetchCharacters', function(data, cb)
        cb(CRP.RPC:execute('FetchCharacters'))
    end)

    RegisterUiCallback('createCharacter', function(characterData, cb)
        local data = CRP.RPC:execute('CreateCharacter', characterData)

        if data and not data.status then
            local errorMessage = 'Ocorreu um erro ao criar a sua personagem, contacte um administrador, caso o problema continue.'

            if data.message then
                errorMessage = data.message
            end

            TriggerEvent('crp-ui:setAlert', { text = errorMessage, type = 'error' })

            cb({ status = false })
            return
        end

        cb(data)
    end)

    RegisterUiCallback('deleteCharacter', function(characterId, cb)
        local data = CRP.RPC:execute('DeleteCharacter', characterId)

        if not data.status then
            TriggerEvent('crp-ui:setAlert', { text = 'Ocorreu um erro ao eliminar a sua personagem, contacte um administrado, caso o problema continue.', type = 'error' })

            cb({ status = false })
            return
        end

        cb(data)
    end)

    RegisterUiCallback('selectCharacter', function(characterId, cb)
        local data = CRP.RPC:execute('SelectCharacter', characterId)

        if not data and data ~= nil then
            TriggerEvent('crp-ui:setAlert', { text = 'Ocorreu um erro ao carregar a sua personagem, contacte um administrador se isto continuar.', type = 'error' })
            return
        end

        TriggerEvent('crp-base:spawnPlayer', data)

        Citizen.Wait(4000)

        TriggerEvent('crp-ui:closeMenu')

        cb(true)
    end)

    RegisterUiCallback('changeSelection', function(index, cb)
        CRP.Spawn:ChangeSelection(index)

        cb(true)
    end)

    RegisterUiCallback('confirmSpawn', function(data, cb)
        CRP.Spawn:SpawnCharacter()

        cb(true)
    end)
end

WaitRegisterUiCallback()