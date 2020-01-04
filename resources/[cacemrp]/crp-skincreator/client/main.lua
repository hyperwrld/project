local isMenuOpen, camera = false, 1

local function sendMessage(data)
	SendNUIMessage(data)
end

local function openMenu(type)
	isMenuOpen = true

	sendMessage({ open = true })
	SetNuiFocus(true, true)

	local playerPed = GetPlayerPed(-1)

	SetPlayerInvincible(playerPed, true)

	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(camera, false)

	if (not DoesCamExist(camera)) then
		camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

		SetCamCoord(camera, GetEntityCoords(playerPed))
		SetCamRot(camera, 0.0, 0.0, 0.0)
		SetCamActive(camera,  true)
		RenderScriptCams(true,  false,  0,  true,  true)
		SetCamCoord(camera, GetEntityCoords(playerPed))
	end

	local x, y, z = table.unpack(GetEntityCoords(playerPed))

	if type == 'face' or type == 'hair' then
		SetCamCoord(camera, x + 0.2, y + 0.5, z + 0.7)
		SetCamRot(camera, 0.0, 0.0, 150.0)
	elseif type == 'clothes' then
		SetCamCoord(camera, x + 0.3, y + 2.0, z + 0.0)
		SetCamRot(camera, 0.0, 0.0, 170.0)
	end

	Citizen.CreateThread(function()
		while isMenuOpen do
			Citizen.Wait(0)

			HideHudAndRadarThisFrame()
			DisableAllControlActions(0)
			TaskSetBlockingOfNonTemporaryEvents(playerPed, true)
		end
	end)
end

local function closeMenu()
	isMenuOpen = false

	local playerPed = GetPlayerPed(-1)

	EnableAllControlActions(0)
	TaskSetBlockingOfNonTemporaryEvents(playerPed, false)
	SetNuiFocus(false, false)

	FreezeEntityPosition(playerPed, false)
	SetPlayerInvincible(playerPed, false)
end

local function nuiCallBack(data, cb)
	local events = exports['crp-base']:getModule('Events')

	if data.close then closeMenu() end

	if data.setSkin then

	end

	if data.updateSkin then

	end

	if data.rotateHeading then
		local currentHeading = GetEntityHeading(GetPlayerPed(-1))

		if data.right then
			heading = currentHeading - tonumber(data.value)
		elseif data.left then
			heading = currentHeading + tonumber(data.value)
		end
	end

	if data.zoom then
		zoom = data.zoomdata
	end
end

RegisterNUICallback('nuiMessage', nuiCallBack)