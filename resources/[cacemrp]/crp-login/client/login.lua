local isMenuOpen = false

local function sendMessage(data)
	SendNUIMessage(data)
end

local function openMenu()
	isMenuOpen = true

	sendMessage({ open = true })
	SetNuiFocus(true, true)

	Citizen.CreateThread(function()
		while isMenuOpen do
			Citizen.Wait(0)

			HideHudAndRadarThisFrame()
			DisableAllControlActions(0)
			TaskSetBlockingOfNonTemporaryEvents(GetPlayerPed(-1), true)
		end
	end)
end

local function closeMenu()
	isMenuOpen = false

	EnableAllControlActions(0)
	TaskSetBlockingOfNonTemporaryEvents(GetPlayerPed(-1), false)
	SetNuiFocus(false, false)
end

local function disconnect()
	TriggerServerEvent('crp-base:disconnect')
end

local function nuiCallBack(data)
	local events = exports['crp-base']:getModule('Events')

	if data.close then closeMenu() end
	if data.disconnect then disconnect() end
	if data.showcursor or not data.showcursor then SetNuiFocus(true, data.showcursor) end

	if data.fetchcharacters then
		events:Trigger('crp-db:fetchplayercharacters', nil, function(data)
			sendMessage({ playercharacters = data })
		end)
	end

	if data.createcharacter then
		events:Trigger('crp-base:createcharacter', data.chardata, function(created)
			if not created then
				sendMessage({ error = true, message = 'Ocorreu um erro ao criar a sua personagem, contacte um administrador se isto continuar.' })
				return
			end

			if type(created) == 'table' and created.error then
				sendMessage({ error = created.error, message = created.message })
				return
			end

			sendMessage({ reload = true })
		end)
	end

	if data.deletecharacter then
		events:Trigger('crp-db:deletecharacter', data.deletecharacter, function(deleted)
			sendMessage({ reload = true })
		end)
	end

	if data.selectcharacter then
		events:Trigger('crp-base:selectcharacter', data.character, function(data)
			if not data.loggedin then
				sendMessage({ error = true, message = 'Ocorreu um erro ao entrar na sua personagem, contacte um administrador se isto continuar.' })
				return
			end

			local playerPed, player = GetPlayerPed(-1), exports['crp-base']:getModule('LocalPlayer')

			player:setCurrentCharacter(data.character)

			sendMessage({ close = true })

			--SetPlayerInvincible(playerPed, true)

			TriggerEvent('crp-base:firstSpawn')

			closeMenu()

			Citizen.Wait(5000)

			TriggerEvent('crp-apartments:relog')

			Citizen.Wait(1000)

			--SetPlayerInvincible(playerPed, false)
		end)
	end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

AddEventHandler('crp-base:spawnInitialized', function()
	openMenu()
end)