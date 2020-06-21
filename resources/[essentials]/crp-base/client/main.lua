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

    if data.skin == nil then
        isNewCharacter = true
    end

    SetPlayerInvincible(playerPed, true)

    Citizen.Wait(5000)

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyAllCams(false)

    TriggerScreenblurFadeOut(500)

    if newCharacter then
        CRP.Spawn:InitializeFirstSpawn()
    else
        TriggerEvent('crp-skincreator:setPedFeatures', data.skin)
    end

    TriggerServerEvent('crp-apartments:spawnSelection', newCharacter)

    Citizen.Wait(1000)

    SetPlayerInvincible(GetPlayerPed(-1), false)
    FreezeEntityPosition(GetPlayerPed(-1), false)
end)