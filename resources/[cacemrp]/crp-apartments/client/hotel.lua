local myspawnpointsk, killcam, spawning, insideapartment = {}, false, false, false
local myroomcoords = { x = 175.09986877441, y = -904.7946166992, z = -98.999984741211 }
local currentroom  = { x = 1420.0, y = 1420.0, z = -900.0 }

apartments = {
	[1]  = { ['x'] = 312.96, ['y'] = -218.27, ['z'] = 54.22 },
	[2]  = { ['x'] = 311.27, ['y'] = -217.74, ['z'] = 54.22 },
	[3]  = { ['x'] = 307.63, ['y'] = -216.43, ['z'] = 54.22 }, 
	[4]  = { ['x'] = 307.71, ['y'] = -213.40, ['z'] = 54.22 }, 
	[5]  = { ['x'] = 309.95, ['y'] = -208.48, ['z'] = 54.22 },
	[6]  = { ['x'] = 311.78, ['y'] = -203.50, ['z'] = 54.22 }, 
	[7]  = { ['x'] = 313.72, ['y'] = -198.61, ['z'] = 54.22 },
	[8]  = { ['x'] = 315.53, ['y'] = -195.24, ['z'] = 54.22 },
	[9]  = { ['x'] = 319.23, ['y'] = -196.43, ['z'] = 54.22 },
	[10] = { ['x'] = 321.08, ['y'] = -197.23, ['z'] = 54.22 },
	[11] = { ['x'] = 312.98, ['y'] = -218.36, ['z'] = 58.01 },
	[12] = { ['x'] = 311.10, ['y'] = -217.64, ['z'] = 58.01 },
	[13] = { ['x'] = 307.37, ['y'] = -216.34, ['z'] = 58.01 },
	[14] = { ['x'] = 307.76, ['y'] = -213.59, ['z'] = 58.01 },
	[15] = { ['x'] = 309.76, ['y'] = -208.25, ['z'] = 58.01 },
	[16] = { ['x'] = 311.48, ['y'] = -203.75, ['z'] = 58.01 },
	[17] = { ['x'] = 313.65, ['y'] = -198.22, ['z'] = 58.01 },
	[18] = { ['x'] = 315.47, ['y'] = -195.19, ['z'] = 58.01 },
	[19] = { ['x'] = 319.39, ['y'] = -196.58, ['z'] = 58.01 },
	[20] = { ['x'] = 321.19, ['y'] = -197.31, ['z'] = 58.01 },
	[21] = { ['x'] = 329.49, ['y'] = -224.92, ['z'] = 54.22 },
	[22] = { ['x'] = 331.33, ['y'] = -225.56, ['z'] = 54.22 },
	[23] = { ['x'] = 335.18, ['y'] = -227.14, ['z'] = 54.22 },
	[24] = { ['x'] = 336.71, ['y'] = -224.66, ['z'] = 54.22 },
	[25] = { ['x'] = 338.79, ['y'] = -219.11, ['z'] = 54.22 },
	[26] = { ['x'] = 340.43, ['y'] = -214.78, ['z'] = 54.22 },
	[27] = { ['x'] = 342.28, ['y'] = -209.32, ['z'] = 54.22 },
	[28] = { ['x'] = 344.39, ['y'] = -204.45, ['z'] = 54.22 },
	[29] = { ['x'] = 346.75, ['y'] = -197.52, ['z'] = 54.23 },
	[30] = { ['x'] = 329.70, ['y'] = -224.65, ['z'] = 58.01 }, 
	[31] = { ['x'] = 331.52, ['y'] = -225.52, ['z'] = 58.01 }, 
	[32] = { ['x'] = 335.16, ['y'] = -227.07, ['z'] = 58.01 },
	[33] = { ['x'] = 336.35, ['y'] = -224.58, ['z'] = 58.01 }, 
	[34] = { ['x'] = 338.56, ['y'] = -219.34, ['z'] = 58.01 },
	[35] = { ['x'] = 340.50, ['y'] = -214.33, ['z'] = 58.01 },
	[36] = { ['x'] = 342.41, ['y'] = -209.25, ['z'] = 58.01 },
	[37] = { ['x'] = 344.03, ['y'] = -204.98, ['z'] = 58.01 },
	[38] = { ['x'] = 346.08, ['y'] = -199.59, ['z'] = 58.01 }, 	
}

currentselection, myroomnumber, myroomtype, myroomlock, cam = 1, 1, 1, true, 0
curapartmentnumber, curroomtype = 0, 1

RegisterNetEvent('crp-apartments:relog')
AddEventHandler('crp-apartments:relog', function()
	currentselection = 1

	TriggerServerEvent('crp-apartments:returnhouses')
end)

RegisterNetEvent('crp-apartments:showui')
AddEventHandler('crp-apartments:showui', function(roomnumber, roomtype)
	local playerPed = GetPlayerPed(-1)

	spawning = false

	SetEntityCoords(playerPed, 152.09986877441, -1004.7946166992, -98.999984741211)
	FreezeEntityPosition(playerPed, true)
	SetEntityInvincible(playerPed, true)

	print('hi guys')

	myroomnumber = roomnumber
	myroomtype   = roomtype

	myspawnpoints = {
		[1] =  { ['x'] = -204.93,  ['y'] = -1010.13, ['z'] = 29.55,  ['h'] = 180.99, ['info'] = ' Altee Street Train Station', ['spawntype'] = 1 },
		[2] =  { ['x'] = 272.16,   ['y'] = 185.44,   ['z'] = 104.67, ['h'] = 320.57, ['info'] = ' Vinewood Blvd Taxi Stand',   ['spawntype'] = 1 },
		[3] =  { ['x'] = -1833.96, ['y'] = -1223.5,  ['z'] = 13.02,  ['h'] = 310.63, ['info'] = ' The Boardwalk',              ['spawntype'] = 1 },
		[4] =  { ['x'] = 145.62,   ['y'] = 6563.19,  ['z'] = 32.0,   ['h'] = 42.83,  ['info'] = ' Paleto Gas Station',         ['spawntype'] = 1 },
		[5] =  { ['x'] = -214.24,  ['y'] = 6178.87,  ['z'] = 31.17,  ['h'] = 40.11,  ['info'] = ' Paleto Bus Stop',            ['spawntype'] = 1 },
		[6] =  { ['x'] = 1122.11,  ['y'] = 2667.24,  ['z'] = 38.04,  ['h'] = 180.39, ['info'] = ' Harmony Motel',              ['spawntype'] = 1 },
		[7] =  { ['x'] = 453.29,   ['y'] = -662.23,  ['z'] = 28.01,  ['h'] = 5.73,   ['info'] = ' LS Bus Station',             ['spawntype'] = 1 },
		[8] =  { ['x'] = -1266.53, ['y'] = 273.86,   ['z'] = 64.66,  ['h'] = 28.52,  ['info'] = ' The Richman Hotel',          ['spawntype'] = 1 },
	}

	myspawnpoints[#myspawnpoints + 1] = { ['x'] = 326.38, ['y'] = -212.11, ['z'] = 54.09, ['h'] = 166.11, ['info'] = 'Apartamento', ['spawntype'] = 2 }

	SendNUIMessage({ opensection = 'main' })

	SetNuiFocus(true, true)

	for i = 1, #myspawnpoints do
		SendNUIMessage({ 
			opensection = 'enterspawn',
			textmessage = myspawnpoints[i]['info'],
			tableid     = i, 
		})
	end

	DoScreenFadeIn(2500)
	movecamera()
end)

local function nuiCallBack(data)
	if data.selectedspawn then
		if spawning then return end

		currentselection = data.selectionid

		movecamera()

		print('moving camera to location')
	end

	if data.confirmspawn then
		local playerPed = GetPlayerPed(-1)

		spawning = true

		DoScreenFadeOut(100)

		Citizen.Wait(100)

		print('confirmed a spawn location')

		SendNUIMessage({ opensection = 'close' })

		local x = myspawnpoints[currentselection]['x']
		local y = myspawnpoints[currentselection]['y']
		local z = myspawnpoints[currentselection]['z']
		local h = myspawnpoints[currentselection]['h']

		ClearFocus()

		SetNuiFocus(false, false)

		RenderScriptCams(false, false, 0, 1, 0)

		if myspawnpoints[currentselection]['spawntype'] == 1 then
			SetEntityCoords(playerPed, x, y, z)
			SetEntityHeading(playerPed, h)

			print('spawned outside')
		elseif myspawnpoints[currentselection]['spawntype'] == 2 then
			ProcessBuildType(myroomnumber, myroomtype)

			print('spawned on the apartment')
		else
			print('error spawning?!')
		end

		SetEntityInvincible(playerPed, false)
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		if IsEntityVisible(playerPed) then
			print('estou aqui')
		else
			print('não estou aqui')
		end

		Citizen.Wait(4000)

		DoScreenFadeIn(1000)

		if DoesCamExist(cam) then DestroyCam(cam, false) end
	end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

function movecamera()
	killcam = true

	if spawning then return end

	Citizen.Wait(1)

	killcam = false

	local camselection = currentselection

	DoScreenFadeOut(1)

	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	local x = myspawnpoints[currentselection]['x']
	local y = myspawnpoints[currentselection]['y']
	local z = myspawnpoints[currentselection]['z']
	local h = myspawnpoints[currentselection]['h']
	
	i = 3200

	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)

	RenderScriptCams(true,  false,  0,  true,  true)

	DoScreenFadeIn(1500)

	local camangle = -90.0

	while i > 1 and camselection == currentselection and not spawning and not killcam do
		local factor = i / 50

		if i < 1 then i = 1 end

		i = i - factor

		SetCamCoord(cam, x, y, z + i)

		if i < 1200 then DoScreenFadeIn(600) end
		if i < 90.0 then camangle = i - i - i end

		SetCamRot(cam, camangle, 0.0, 0.0)

		Citizen.Wait(1)
	end
end

function ProcessBuildType(roomnumber, roomtype)
	local playerPed = GetPlayerPed(-1)

	insideapartment = true

	DoScreenFadeOut(1)

	TriggerEvent('crp-weather:insidehotel') -- WEATHER RAIN ETC

	SetEntityInvincible(playerPed, true)

	TriggerEvent('crp-doors:dooranim')

	if roomtype == 1 then
		buildroom(roomnumber, roomtype)

		-- Bem vindo ao Hotel! (notification)
	end

	curapartmentnumber = roomnumber

	-- SOM DA PORTA A FECHAR

	TriggerEvent('crp-doors:dooranim')

	CleanUpPeds()

	SetEntityInvincible(playerPed, false)
	FreezeEntityPosition(playerPed, false)

	Citizen.Wait(1000)

	DoScreenFadeIn(1000)
end

function CleanUpPeds()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local handle, ObjectFound = FindFirstPed()
    local success

    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = GetDistanceBetweenCoords(coords, pos, true)
        if distance < 50.0 and ObjectFound ~= playerPed then
    		if IsPedAPlayer(ObjectFound) or IsEntityAVehicle(ObjectFound) then

    		else
    			DeleteEntity(ObjectFound)
    		end            
        end
        success, ObjectFound = FindNextPed(handle)
    until not success

    EndFindPed(handle)
end

function buildroom(roomnumber, roomtype)
	local playerPed = GetPlayerPed(-1)

	SetEntityCoords(playerPed, 152.09986877441, -1004.7946166992, -98.999984741211)

	Citizen.Wait(5000)

	local generator = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211 }

	generator.x = (175.09986877441) + ((roomnumber * 12.0))

	print('oal tudo bem?')
	
	if roomnumber == myroomnumber then
		myroomcoords = generator
	else
		currentroom = generator
	end
 
	SetEntityCoords(playerPed, generator.x - 1, generator.y - 4, generator.z + 1.8)

	local building = CreateObject(GetHashKey("playerhouse_hotel"), generator.x - 0.7, generator.y - 0.33, generator.z - 1.31, false, false, false)

	FreezeEntityPosition(building, true)

	Citizen.Wait(100)

	FloatTilSafe(roomtype, building)

	CreateObject(GetHashKey("v_49_motelmp_stuff"), generator.x, generator.y, generator.z, false, false, false)
	CreateObject(GetHashKey("v_49_motelmp_bed"), generator.x + 1.4, generator.y - 0.55, generator.z, false, false, false)
	CreateObject(GetHashKey("v_49_motelmp_clothes"), generator.x - 2.0, generator.y + 2.0,generator.z + 0.15, false, false, false)
	CreateObject(GetHashKey("v_49_motelmp_winframe"), generator.x + 0.74,generator.y - 4.26,generator.z + 1.11, false, false, false)
	CreateObject(GetHashKey("v_49_motelmp_glass"), generator.x + 0.74, generator.y - 4.26,generator.z + 1.13, false, false, false)
	CreateObject(GetHashKey("v_49_motelmp_curtains"), generator.x + 0.74, generator.y - 4.15, generator.z + 0.9, false, false, false)

	CreateObject(GetHashKey("v_49_motelmp_screen"), generator.x - 2.21, generator.y - 0.6, generator.z + 0.79, false, false, false)

	CreateObject(GetHashKey("v_res_fa_trainer02r"), generator.x - 1.9, generator.y + 3.0, generator.z + 0.38, false, false, false)
	CreateObject(GetHashKey("v_res_fa_trainer02l"), generator.x - 2.1, generator.y + 2.95, generator.z + 0.38, false, false, false)

	local sink = CreateObject(GetHashKey("prop_sink_06"), generator.x + 1.1, generator.y + 4.0, generator.z, false, false, false)
	local chair1 = CreateObject(GetHashKey("prop_chair_04a"), generator.x + 2.1, generator.y - 2.4, generator.z, false, false, false)
	local chair2 = CreateObject(GetHashKey("prop_chair_04a"), generator.x + 0.7, generator.y - 3.5, generator.z, false, false, false)
	local kettle = CreateObject(GetHashKey("prop_kettle"), generator.x - 2.3, generator.y + 0.6, generator.z + 0.9, false, false, false)
	local tvCabinet = CreateObject(GetHashKey("Prop_TV_Cabinet_03"), generator.x - 2.3, generator.y - 0.6, generator.z, false, false, false)
	local tv = CreateObject(GetHashKey("prop_tv_06"), generator.x - 2.3, generator.y - 0.6, generator.z + 0.7, false, false, false)
	local toilet = CreateObject(GetHashKey("Prop_LD_Toilet_01"), generator.x + 2.1, generator.y + 2.9, generator.z, false, false, false)
	local clock = CreateObject(GetHashKey("Prop_Game_Clock_02"), generator.x - 2.55, generator.y - 0.6, generator.z + 2.0, false, false, false)
	local phone = CreateObject(GetHashKey("v_res_j_phone"), generator.x + 2.4, generator.y - 1.9, generator.z + 0.64, false, false, false)
	local ironBoard = CreateObject(GetHashKey("v_ret_fh_ironbrd"), generator.x - 1.7, generator.y + 3.5, generator.z + 0.15, false, false, false)
	local iron = CreateObject(GetHashKey("prop_iron_01"), generator.x - 1.9, generator.y + 2.85, generator.z + 0.63, false, false, false)
	local mug1 = CreateObject(GetHashKey("V_Ret_TA_Mug"), generator.x - 2.3, generator.y + 0.95, generator.z + 0.9, false, false, false)
	local mug2 = CreateObject(GetHashKey("V_Ret_TA_Mug"), generator.x - 2.2, generator.y + 0.9, generator.z + 0.9, false, false, false)

	CreateObject(GetHashKey("v_res_binder"), generator.x - 2.2, generator.y + 1.3, generator.z + 0.87, false, false, false)
	
	FreezeEntityPosition(sink, true)
	FreezeEntityPosition(chair1, true)	
	FreezeEntityPosition(chair2, true)
	FreezeEntityPosition(tvCabinet, true)	
	FreezeEntityPosition(tv, true)		
	
	SetEntityHeading(chair1, GetEntityHeading(chair1) + 270)
	SetEntityHeading(chair2, GetEntityHeading(chair2) + 180)
	SetEntityHeading(kettle, GetEntityHeading(kettle) + 90)
	SetEntityHeading(tvCabinet, GetEntityHeading(tvCabinet) + 90)
	SetEntityHeading(tv, GetEntityHeading(tv) + 90)
	SetEntityHeading(toilet, GetEntityHeading(toilet) + 270)
	SetEntityHeading(clock, GetEntityHeading(clock) + 90)
	SetEntityHeading(phone, GetEntityHeading(phone) + 220)
	SetEntityHeading(ironBoard, GetEntityHeading(ironBoard) + 90)
	SetEntityHeading(iron, GetEntityHeading(iron) + 230)
	SetEntityHeading(mug1, GetEntityHeading(mug1) + 20)
	SetEntityHeading(mug2, GetEntityHeading(mug2) + 230)

	curroomtype = 1
end

function FloatTilSafe(roomtype, buildingsent)
	local playerPed = GetPlayerPed(-1)

	SetEntityInvincible(playerPed, true)
	FreezeEntityPosition(playerPed, true)

	local coords = GetEntityCoords(playerPed)
	local processing, counter, building = 3, 100, buildingsent

	while processing == 3 do
		Citizen.Wait(100)

		if DoesEntityExist(building) then
			processing = 2
		end

		if counter == 0 then
			processing = 1
		end

		counter = counter - 1
	end

	if counter > 0 then
		SetEntityCoords(playerPed, coords)
		CleanUpPeds()
	elseif processing == 1 then
		if roomtype == 2 then
			SetEntityCoords(playerPed, 267.48132324219, -638.818359375, 42.020294189453)
		elseif roomtype == 3 then
			SetEntityCoords(playerPed, 160.26762390137, -641.96905517578, 47.073524475098)
		elseif roomtype == 1 then
			SetEntityCoords(playerPed, 312.96966552734, -218.2705078125, 54.221797943115)
		end
		-- FAILED TO LOAD, PLEASE RETRY
	end
end