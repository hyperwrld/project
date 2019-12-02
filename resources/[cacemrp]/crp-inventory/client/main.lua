local isInventoryOpen, Inventories = false, {}

local function sendMessage(data)
	SendNUIMessage(data)
end

local function closeInventory()
	isInventoryOpen = false

	EnableAllControlActions(0)
	SetNuiFocus(false, false)
end

local function showInventory()
	if isInventoryOpen then 
		closeInventory()
		return
	end

	local playerPed = PlayerPedId()
	local coords, closestInventory, closestInventoryDistance, closestInventoryCoords = GetEntityCoords(playerPed), nil, nil, nil

	for i = 1, #Inventories, 1 do
		local distance = GetDistanceBetweenCoords(coords, Inventories[i].coords.x, Inventories[i].coords.y, Inventories[i].coords.z, true)

		if distance <= 2.0 then
			if closestInventory ~= nil and closestInventoryDistance ~= nil then
				if closestInventoryDistance < distance then
					closestInventory = Inventories[i].name
					closestInventoryDistance = distance
					closestInventoryCoords = { x = coords.x, y = coords.y, z = coords.z }
				end
			else
				closestInventory = Inventories[i].name
				closestInventoryDistance = distance
				closestInventoryCoords = { x = coords.x, y = coords.y, z = coords.z }
			end
		end
	end

	isInventoryOpen = true

	local player = exports['crp-base']:getModule('LocalPlayer')
	local events, id = exports['crp-base']:getModule('Events'), player:getCurrentCharacter()

	if closestInventory == nil then
		closestInventoryCoords = { x = coords.x, y = coords.y, z = coords.z }
		closestInventory = 'drop-' .. math.random(0, 100000)

		events:Trigger('crp-inventory:getInventory', id, function(data)
			sendMessage({ 
				event = 'open', 
				playerData = { id = id, items = data }, 
				secondaryData = { id = closestInventory, coords = closestInventoryCoords, type = 1, items = nil },
			})
		end)
	else
		events:Trigger('crp-inventory:getInventories', { id = id, inventory = closestInventory }, function(data)
			sendMessage({ 
				event = 'open', 
				playerData = { id = id, items = data.player }, 
				secondaryData = { id = closestInventory, coords = closestInventoryCoords, type = 1, items = data.secondary },
			})
		end)
	end

	SetNuiFocus(true, true)

	Citizen.CreateThread(function()
		while isInventoryOpen do
			Citizen.Wait(0)

			DisableAllControlActions(0)
		end
	end)
end

local function nuiCallBack(data, cb)
	local events = exports['crp-base']:getModule('Events')

	if data.close then closeInventory() end

	if data.moveitem then
		events:Trigger('crp-inventory:moveItem', data.itemdata, function(data)
			cb(data)
		end)
	end

	if data.swapitem then
		events:Trigger('crp-inventory:swapItems', data.itemsdata, function(data)
			cb(data)
		end)
	end

	if data.sucess then
		PlaySoundFrontend(-1, 'ERROR', 'HUD_LIQUOR_STORE_SOUNDSET', false)
	end

	if data.error then
		PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
	end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 289) and IsInputDisabled(0) then
			showInventory()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords, letSleep = GetEntityCoords(playerPed), true

		for k, v in pairs(Inventories) do
			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)

			if distance <= 20.0 then
				DrawMarker(20, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 0.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
				letSleep = false
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('crp-inventory:updateInventories')
AddEventHandler('crp-inventory:updateInventories', function(newInventories)
	Inventories = newInventories
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and isInventoryOpen then
        closeInventory()
    end
end)