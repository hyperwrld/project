CRP.Spawn = {}

function CRP.Spawn:InitializeIntro()
	local playerPed = PlayerPedId()

	SetEntityCoords(playerPed, 907.71, 1039.36, 290.67, 0.0, 0.0, 0.0, true)
	SetEntityVisible(playerPed, false)
	SetEntityInvincible(playerPed, true)
	FreezeEntityPosition(playerPed, true)

	local firstCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 907.71, 1039.36, 295.67, 2.5, 0.0, 38.68, 32.0, true, 0)
	local secondCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 853.67, 990.04, 295.67, 2.5, 0.0, 30.37, 32.0, true, 0)

	DoScreenFadeOut(0)
	SetCamActive(firstCam, true)
    RenderScriptCams(true, false, 5000, true, true)
    SetCamActiveWithInterp(secondCam, firstCam, 15000, 100, 100)

    Citizen.Wait(1500)

	DoScreenFadeIn(500)

	Citizen.Wait(1500)

	exports['crp-ui']:openApp('intro', nil, false)

	Citizen.Wait(5000)

	CRP.Spawn:InitializeMenu()
end

local currentPed

function CRP.Spawn:InitializeMenu()
	local playerPed, data = PlayerPedId(), RPC:execute('fetchCharacters')

	DoScreenFadeIn(500)

	Citizen.Wait(1000)

	SetEntityCoords(playerPed, 8.16, -664.74, 16.13, 0.0, 0.0, 0.0, true)
	SetEntityVisible(playerPed, false)
	SetEntityInvincible(playerPed, true)
	FreezeEntityPosition(playerPed, true)

	LoadModel('mp_m_freemode_01')

	currentPed = CreatePed('PED_TYPE_CIVMALE', 'mp_m_freemode_01', 11.08, -663.11, 16.13, 110.13, false, true)

	if data[1] then

	end

	DoScreenFadeOut(500)

	Citizen.Wait(1000)

	exports['crp-ui']:openApp('selection', data, true)
end

function CRP.Spawn:SpawnCharacter(characterData)

end