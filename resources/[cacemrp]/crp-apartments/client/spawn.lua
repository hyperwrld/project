local isSpawning, canKillCam, isInside, currentSelection, cam, spawnPoints = false, false, false, 1, 0, {}

myRoomNumber, myRoomType = 1, 1

RegisterNetEvent('crp-apartments:spawnSelection')
AddEventHandler('crp-apartments:spawnSelection', function(number, roomType)
    local playerPed = GetPlayerPed(-1)

    isSpawning, currentSelection = false, 1
    myRoomNumber, myRoomType = number, roomType

    SetEntityCoords(playerPed, 151.381, -1008.003, -99.0)

    FreezeEntityPosition(playerPed, true)
	SetEntityInvincible(playerPed, true)

    spawnPoints = {
        [1] =  { ['x'] = -204.93,  ['y'] = -1010.13, ['z'] = 29.55,  ['h'] = 180.99, ['info'] = ' Altee Street Train Station', ['spawnType'] = 1 },
		[2] =  { ['x'] = 272.16,   ['y'] = 185.44,   ['z'] = 104.67, ['h'] = 320.57, ['info'] = ' Vinewood Blvd Taxi Stand',   ['spawnType'] = 1 },
		[3] =  { ['x'] = -1833.96, ['y'] = -1223.5,  ['z'] = 13.02,  ['h'] = 310.63, ['info'] = ' The Boardwalk',              ['spawnType'] = 1 },
		[4] =  { ['x'] = 145.62,   ['y'] = 6563.19,  ['z'] = 32.0,   ['h'] = 42.83,  ['info'] = ' Paleto Gas Station',         ['spawnType'] = 1 },
		[5] =  { ['x'] = -214.24,  ['y'] = 6178.87,  ['z'] = 31.17,  ['h'] = 40.11,  ['info'] = ' Paleto Bus Stop',            ['spawnType'] = 1 },
		[6] =  { ['x'] = 1122.11,  ['y'] = 2667.24,  ['z'] = 38.04,  ['h'] = 180.39, ['info'] = ' Harmony Motel',              ['spawnType'] = 1 },
		[7] =  { ['x'] = 453.29,   ['y'] = -662.23,  ['z'] = 28.01,  ['h'] = 5.73,   ['info'] = ' LS Bus Station',             ['spawnType'] = 1 },
		[8] =  { ['x'] = -1266.53, ['y'] = 273.86,   ['z'] = 64.66,  ['h'] = 28.52,  ['info'] = ' The Richman Hotel',          ['spawnType'] = 1 },
    }

    if roomType == 1 then
        spawnPoints[#spawnPoints + 1] = { ['x'] = 326.38, ['y'] = -212.11, ['z'] = 54.09, ['h'] = 166.11, ['info'] = 'Apartamento', ['spawnType'] = 2 }
    elseif roomType == 2 then
        spawnPoints[#spawnPoints + 1] = { ['x'] = 326.38, ['y'] = -212.11, ['z'] = 54.09, ['h'] = 166.11, ['info'] = 'Apartamento', ['spawnType'] = 2 }
    end

	SendNUIMessage({
        eventName = 'show', spawnPoints = spawnPoints
    })

	SetNuiFocus(true, true)

    DoScreenFadeIn(2500)

    TriggerCameraAnimation()
end)

local function nuiCallBack(data)
	if data.selectedSpawn then
        if isSpawning then
            return
        end

		currentSelection = data.selectionId + 1

		TriggerCameraAnimation()
	end

	if data.confirmSpawn then
		local playerPed = GetPlayerPed(-1)

		isSpawning = true

		DoScreenFadeOut(100)

		Citizen.Wait(100)

		SendNUIMessage({
            eventName = 'hide'
        })

        local x = spawnPoints[currentSelection]['x']
		local y = spawnPoints[currentSelection]['y']
		local z = spawnPoints[currentSelection]['z']
		local h = spawnPoints[currentSelection]['h']

		ClearFocus()
		SetNuiFocus(false, false)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)

		if spawnPoints[currentSelection]['spawnType'] == 1 then
            SetEntityCoords(playerPed, x, y, z)
			SetEntityHeading(playerPed, h)
        elseif spawnPoints[currentSelection]['spawnType'] == 2 then
            TriggerEvent('crp-apartments:buildHotelInterior', myRoomNumber, myRoomNumber)
        elseif spawnPoints[currentSelection]['spawnType'] == 3 then

        end

        SetEntityInvincible(playerPed, false)
        FreezeEntityPosition(playerPed, false)

        Citizen.Wait(4000)

        DoScreenFadeIn(100)

        if DoesCamExist(cam) then
            DestroyCam(cam, false)
        end
	end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

function TriggerCameraAnimation()
	canKillCam = true

    if isSpawning then
        return
    end

	Citizen.Wait(1)

	canKillCam = false

	local camSelection = currentSelection

	DoScreenFadeOut(1)

	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	local x = spawnPoints[currentSelection]['x']
	local y = spawnPoints[currentSelection]['y']
	local z = spawnPoints[currentSelection]['z']
	local h = spawnPoints[currentSelection]['h']

	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
    SetCamActive(cam, true)

	RenderScriptCams(true, false, 0, true, true)
	DoScreenFadeIn(1500)

	local i, camAngle = 3200, -90.0

	while i > 1 and camSelection == currentSelection and not isSpawning and not canKillCam do
		local factor = i / 50

        if i < 1 then
            i = 1
        end

		i = i - factor

		SetCamCoord(cam, x, y, z + i)

        if i < 1200 then
            DoScreenFadeIn(600)
        end

        if i < 90.0 then
            camAngle = i - i - i
        end

		SetCamRot(cam, camAngle, 0.0, 0.0)

		Citizen.Wait(1)
	end
end