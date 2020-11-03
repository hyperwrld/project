local currentPed, cam

CRP.Spawn = {}

function CRP.Spawn:InitializeIntro()
	local playerPed = PlayerPedId()

	CRP.Gameplay:InitializeNatives()

	SetEntityCoords(playerPed, 907.71, 1039.36, 290.67, 0.0, 0.0, 0.0, true)
	SetEntityVisible(playerPed, false)
	SetEntityInvincible(playerPed, true)
	FreezeEntityPosition(playerPed, true)

	local firstCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 907.71, 1039.36, 295.67, 2.5, 0.0, 38.68, 45.0, true, 0)
	local secondCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 853.67, 990.04, 295.67, 2.5, 0.0, 30.37, 45.0, true, 0)

	DoScreenFadeOut(0)
	SetCamActive(firstCam, true)
    RenderScriptCams(true, false, 5000, true, true)
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

	Citizen.Wait(500)

	DoScreenFadeOut(1000)

	Citizen.Wait(1000)

	DestroyAllCams(true)
	SetEntityCoords(playerPed, 8.16, -664.74, 16.13, 0.0, 0.0, 0.0, true)
	SetEntityVisible(playerPed, false)
	SetEntityInvincible(playerPed, true)
	FreezeEntityPosition(playerPed, true)

	local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 7.59, -664.55, 15.86, 1.0, 0.0, 290.54, 45.0, true, 0)

	SetCamActive(cam, true)
    RenderScriptCams(true, false, 5000, true, true)
	LoadModel('mp_m_freemode_01')

	currentPed = CreatePed('PED_TYPE_CIVMALE', 'mp_m_freemode_01', 11.08, -663.11, 16.13, 110.13, false, true)

	if data[1] then

	end

	Citizen.Wait(500)

	DoScreenFadeIn(500)

	Citizen.Wait(1000)

	exports['crp-ui']:openApp('selection', data, true)
end

function CRP.Spawn:SpawnCharacter(characterData)

end