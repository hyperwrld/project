playerPed, menuType, camera, zPos, fov, startPosition, startCamPosition = PlayerPedId(), 1, nil, 0, 90.0

local oldSkin, currentTattos, clothing, isInsideZone = {}, {}, {}, false

Citizen.CreateThread(function()
	for k, shop in pairs(shops) do
		if shop.isPublic then
			local shopName, icon, color, size = 'Loja de roupa', 73, 3, 0.65

			if shop.data == 3 then
				shopName, icon, color, size = 'Barbearia', 71, 1, 0.75
			elseif shop.data == 4 then
				shopName, icon, color, size = 'Loja de tatuagens', 75, 1, 0.75
			end

			exports['crp-base']:createBlip('skinShop' .. k, shop.coords, icon, color, size, shopName)
		end
	end

	exports['crp-lib']:createBoxZones(shops, 'skinZone', GetCurrentResourceName())
end)

AddEventHandler('crp-skincreator:onPlayerInOut', function(isPointInside, zone)
	if isPointInside then
		ListenForKeys(zone.data)

		exports['crp-ui']:toggleInteraction(true, '[E] mudar de roupa')
	else
		exports['crp-ui']:toggleInteraction(false)
	end

	isInsideZone = isPointInside
end)

function ListenForKeys(type)
	Citizen.CreateThread(function()
		while isInsideZone do
			Citizen.Wait(0)

			if IsControlJustReleased(0, 38) then
				TriggerEvent('crp-skincreator:openShop', type)
			end
		end
	end)
end

AddEventHandler('crp-skincreator:openShop', function(type) 	-- type: 1 (all), 2 (clothing), 3 (hairshop), 4 (tattoos)
	playerPed, oldSkin, menuType = PlayerPedId(), getCurrentSkin(), type

	local data, heading = {}, GetEntityHeading(playerPed)

	triggerCustomCamera()

	if menuType == 2 then
		data = {
			type = menuType, heading = heading, variations = getVariations(), totals = getTotals(), currentModel = getCurrentModel()
		}
	elseif menuType == 3 then
		data = {
			type = menuType, heading = heading, headOverlays = getHeadOverlays(), colors = getColors(), variations = getVariations(), totals = getTotals()
		}
	else
		data = {
			type = menuType, heading = heading, headBlend = getHeadBlend(), faceFeatures = getFaceFeatures(), currentModel = getCurrentModel(),
			headOverlays = getHeadOverlays(), colors = getColors(), variations = getVariations(), totals = getTotals()
		}
	end

	exports['crp-ui']:openApp('skincreator', data)
end)

RegisterUICallback('selectPedSkin', function(data, cb)
	local model

	if data.index then
		if data.sex then
			model = maleSkins[data.index]
		else
			model = femaleSkins[data.index]
		end
	else
		if data.sex then
			model = `mp_m_freemode_01`
		else
			model = `mp_f_freemode_01`
		end
	end

	if not (GetEntityModel(playerPed) == model) then
		setSkin(model)

		updateData()
	end

	if not data.index then
		return cb('ok')
	end

	local drawable = GetPedDrawableVariation(playerPed, index)

	cb({
		drawable, GetPedTextureVariation(playerPed, index), GetNumberOfPedDrawableVariations(playerPed, index), GetNumberOfPedTextureVariations(playerPed, index, drawable)
	})
end)

RegisterUICallback('modifyHeadBlend', function(data, cb)
	SetPedHeadBlendData(playerPed, data[1], data[2], data[3], data[4], data[5], data[6], RoundNumber(data[7], 1), RoundNumber(data[8], 1), RoundNumber(data[9], 1), false)

	cb('ok')
end)

RegisterUICallback('modifyFaceFeature', function(data, cb)
	SetPedFaceFeature(playerPed, data.index, RoundNumber(data.scale, 1))

	cb('ok')
end)

RegisterUICallback('modifyHeadOverlay', function(data, cb)
	SetPedHeadOverlay(playerPed, data.index, data.value, RoundNumber(data.opacity, 1))

	cb('ok')
end)

RegisterUICallback('modifyBodyFeature', function(data, cb)
	local callbackData = 'ok'

	if data.index == -1 then
		SetPedEyeColor(playerPed, data.value)
	elseif data.index == 0 then
		SetPedComponentVariation(playerPed, 2, data.value, data.secondValue, 2)

		if data.isMain then
			callbackData = { GetNumberOfPedTextureVariations(playerPed, 2, data.value) }
		end
	else
		if data.value == -1 then
			data.value = 255
		end

		SetPedHeadOverlay(playerPed, data.index, data.value, RoundNumber(data.secondValue, 1))
	end

	cb(callbackData)
end)

RegisterUICallback('modifyFeatureColor', function(data, cb)
	if data.index == 0 then
		SetPedHairColor(playerPed, tonumber(data.firstColor), tonumber(data.secondColor))
	else
		local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(playerPed, data.index)

		if success then
			local secondColor = tonumber(data.secondColor)

			if not secondColor then
				secondColor = tonumber(data.firstColor)
			end

			SetPedHeadOverlayColor(playerPed, data.index, data.colorType, tonumber(data.firstColor), secondColor)
		end
	end

	cb('ok')
end)

RegisterUICallback('modifyClothing', function(data, cb)
	local callbackData

	if data.index == 0 then
		if data.value == -1 then
			ClearPedProp(playerPed, data.index)
		else
			SetPedPropIndex(playerPed, data.index, data.value, data.secondValue, true)
		end

		callbackData = { GetNumberOfPedPropTextureVariations(playerPed, data.index, data.value) }
	else
		SetPedComponentVariation(playerPed, data.index, data.value, data.secondValue, 2)

        callbackData = { GetNumberOfPedTextureVariations(playerPed, data.index, data.value) }
	end

	cb(callbackData)
end)

RegisterUICallback('modifyAccessories', function(data, cb)
	local callbackData

	if data.isProp then
		if data.value == -1 then
			ClearPedProp(playerPed, data.index)
		else
			SetPedPropIndex(playerPed, data.index, data.value, data.secondValue, true)
		end

		callbackData = { GetNumberOfPedPropTextureVariations(playerPed, data.index, data.value) }
	else
		SetPedComponentVariation(playerPed, data.index, data.value, data.secondValue, 2)

        callbackData = { GetNumberOfPedTextureVariations(playerPed, data.index, data.value) }
	end

	cb(callbackData)
end)

RegisterUICallback('toggleClothing', function(data, cb)
	local model = GetEntityModel(playerPed)
	local success, modelSex = isMpModel(model)

	if success then
		if clothing[data] then
			for i = 1, #clothing[data] do
				local clothes = clothing[data][i]

				if (data == 1 and i ~= 1) and (clothes.value) ~= -1 then
					SetPedPropIndex(playerPed, clothes.id, clothes.value, clothes.secondValue, true)
				else
					SetPedComponentVariation(playerPed, clothes.id, clothes.value, clothes.secondValue, 2)
				end
			end

			clothing[data] = nil
		else
			local defaultClothing = defaultMaleClothing[data].male

			if not modelSex then
				defaultClothing = defaultMaleClothing[data].female
			end

			clothing[data] = {}

			for i = 1, #defaultClothing do
				local clothes, id, value, secondValue = defaultClothing[i]

				if data == 1 and type(clothes) == 'number' then
					id, value, secondValue = clothes, GetPedPropIndex(playerPed, clothes), GetPedPropTextureIndex(playerPed, clothes)

					ClearPedProp(playerPed, clothes)
				else
					id, value, secondValue = clothes.id, GetPedDrawableVariation(playerPed, clothes.id), GetPedTextureVariation(playerPed, clothes.id)

					SetPedComponentVariation(playerPed, clothes.id, clothes.value, clothes.secondValue, 2)
				end

				clothing[data][i] = { id = id, value = value, secondValue = secondValue }
			end
		end
	end

	cb('ok')
end)

RegisterUICallback('toggleAnimation', function(data, cb)
	if not IsPedUsingScenario(playerPed, 'WORLD_HUMAN_HUMAN_STATUE') then
		TaskPlayAnimation(playerPed, nil, 'WORLD_HUMAN_HUMAN_STATUE')
	else
		ClearPedTasks(playerPed)
	end

	cb('ok')
end)

RegisterUICallback('modifyCameraValue', function(data, cb)
	if data.type == 0 then
		changeCameraHeight(data.value)
	elseif data.type == 1 then
		changeCameraZoom(data.value)
	else
		SetEntityHeading(playerPed, RoundNumber(data.value, 1))
	end

	cb('ok')
end)

RegisterUICallback('saveSkin', function(data, cb)
	if data then
		TriggerServerEvent('crp-skincreator:saveSkin', getCurrentSkin())
	else
		setCharacterSkin(oldSkin)

		updateData()
	end

	cb('ok')
end)

AddEventHandler('crp-ui:closedMenu', function(name, data)
	if name ~= 'skincreator' then
		return
	end

	if camera then
		camera = nil
	end

	ClearPedTasks(playerPed)
	FreezeEntityPosition(playerPed, false)
	DestroyAllCams(true)
	RenderScriptCams(false, false, 1, false, false)

	TriggerEvent('crp-base:setPedConfigFlag')

	zPos, fov, startPosition, startCamPosition = 0, 90.0, nil, nil
end)