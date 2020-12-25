local isCreatingCharacter, currentPed, cam = false

CRP.Spawn = {}

function CRP.Spawn:InitializeIntro()
	local playerPed = PlayerPedId()

	CRP.Gameplay:InitializeNatives()

	SetEntityCoords(playerPed, 907.71, 1039.36, 290.67, 0.0, 0.0, 0.0, true)
	SetEntityVisible(playerPed, false)
	SetEntityInvincible(playerPed, true)
	FreezeEntityPosition(playerPed, true)

	isCreatingCharacter = true

	Citizen.CreateThread(function()
		while isCreatingCharacter do
			Citizen.Wait(500)

			CRP.Spawn:ConcealPlayers()
		end
	end)

	-- Meter de noite quando se spawna

	local firstCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 907.71, 1039.36, 295.67, 2.5, 0.0, 38.68, 45.0, true, 0)

	DoScreenFadeOut(0)
	SetCamActive(firstCam, true)
	RenderScriptCams(true, false, 5000, true, true)

	local secondCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 853.67, 990.04, 295.67, 2.5, 0.0, 30.37, 45.0, true, 0)

    SetCamActiveWithInterp(secondCam, firstCam, 15000, 100, 100)

    Citizen.Wait(1500)

	DoScreenFadeIn(500)

	Citizen.Wait(1500)

	exports['crp-ui']:openApp('intro', nil, false)

	Citizen.Wait(6000)

	exports['crp-ui']:closeApp('intro')

	CRP.Spawn:InitializeMenu()
end

function CRP.Spawn:InitializeMenu()
	local playerPed, data = PlayerPedId(), RPC:execute('fetchCharacters')

	DoScreenFadeOut(500)

	Citizen.Wait(500)

	SetEntityVisible(playerPed, true)
	FreezeEntityPosition(playerPed, false)

	DestroyAllCams(true)
	RenderScriptCams(false, false, 2000, true, true)

	if data[1] and data[1].skin then
		exports['crp-skincreator']:setCharacterSkin(data[1].skin)
	else
		local modelHash = `mp_m_freemode_01`

		if GetRandomNumber(10) <= 5 then
			modelHash = `mp_f_freemode_01`
		end

		exports['crp-skincreator']:setSkin(modelHash)
	end

	playerPed = PlayerPedId()

	SetEntityCoords(playerPed, 409.8483, -1001.0, -100.0, 0.0, 0.0, 0.0)
	SetEntityHeading(playerPed, 5.39)

	print(GetEntityCoords(playerPed))

	firstCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 415.55, -998.50, -99.29, 0.00, 0.00, 89.75, 50.00, false, 0)

    SetCamActive(firstCam, true)
    RenderScriptCams(true, false, 2000, true, true)

	LoadAnimationSet('move_m@gangster@var_e')

	SetPedMovementClipset(playerPed, 'move_m@gangster@var_e', 0.1)

	RemoveAnimSet('move_m@gangster@var_e')

	Citizen.Wait(1000)

	TaskGoStraightToCoord(playerPed, 409.8483, -998.54, -100.0, 0.15, -1, 265.70, 100)

	DoScreenFadeIn(7500)

	secondCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 413.55, -998.50, -98.79, 0.00, 0.00, 89.75, 50.00, false, 0)

	SetCamActiveWithInterp(secondCam, firstCam, 5000, true, true)

	exports['crp-ui']:openApp('selection', data, true)
end

function CRP.Spawn:SpawnCharacter(characterData)
	if not characterData.skin then
		TriggerEvent('crp-skincreator:openShop', 1)
	end

	print(json.encode(characterData))
end

function CRP.Spawn:ConcealPlayers(status)
	for _, player in ipairs(GetActivePlayers()) do
		if player ~= PlayerId() and ((status and NetworkIsPlayerConcealed(player)) or (not status and not NetworkIsPlayerConcealed(player))) then
			NetworkConcealPlayer(player, status, true)
		end
	end
end