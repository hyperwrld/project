local isInMenu, currentPed, cam = false

CRP.Spawn = {}

function CRP.Spawn:InitializeMenu()
	DoScreenFadeOut(0)

	local playerPed, data = PlayerPedId(), RPC:execute('fetchCharacters')

	CRP.Gameplay:InitializeNatives()

	Citizen.Wait(500)

	isInMenu = true

	Citizen.CreateThread(function()
		while isInMenu do
			Citizen.Wait(0)

			setConcealStatus(true)

			DisableAllControlActions(0)
		end
	end)

	SetEntityVisible(playerPed, true)
	FreezeEntityPosition(playerPed, false)

	if data[1] and data[1].skin then
		exports['crp-skincreator']:setCharacterSkin(json.decode(data[1].skin))
	else
		setRandomSkin()
	end

	playerPed = PlayerPedId()

	SetEntityCoords(playerPed, 409.8483, -1001.0, -100.0, 0.0, 0.0, 0.0)
	SetEntityHeading(playerPed, 5.39)

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

	Citizen.Wait(2500)

	exports['crp-ui']:openApp('selection', data, true)
end

function CRP.Spawn:ChangeCharacter(data)
	if data.skin then
		exports['crp-skincreator']:setCharacterSkin(json.decode(data.skin))
	else
		setRandomSkin()
	end
end

function CRP.Spawn:SpawnCharacter(data)
	local playerPed = PlayerPedId()

	if not data.skin then
		TriggerEvent('crp-skincreator:openShop', 1)
	end

	if not data.position then
		DoScreenFadeOut(1000)

		Citizen.Wait(1500)

		DestroyAllCams(true)
		RenderScriptCams(false, false, 2000, true, true)

		Citizen.Wait(1000)

		SetEntityCoords(playerPed, -1046.93, -2753.75, 7.56)
		SetEntityHeading(playerPed, 334.42)

		TaskGoStraightToCoord(playerPed, -1040.99, -2743.54, 13.95, 1.0, -1, 330.0, 1000)

		Citizen.Wait(1500)

		DoScreenFadeIn(500)

		while GetScriptTaskStatus(playerPed, 0x7d8f4411) ~= 7 do
			Citizen.Wait(0)
		end
	else

	end

	isInMenu = false

	setConcealStatus(false)
end

function setConcealStatus(status)
	for _, player in ipairs(GetActivePlayers()) do
		if player ~= PlayerId() and ((status and NetworkIsPlayerConcealed(player)) or (not status and not NetworkIsPlayerConcealed(player))) then
			NetworkConcealPlayer(player, status, true)
		end
	end
end

function setRandomSkin()
	local modelHash = `mp_m_freemode_01`

	if GetRandomNumber(10) <= 5 then
		modelHash = `mp_f_freemode_01`
	end

	exports['crp-skincreator']:setSkin(modelHash)
end