playerPed = PlayerPedId()

local oldSkin, currentTattos = {}, {}

AddEventHandler('crp-skincreator:openMenu', function()
	playerPed, oldSkin = PlayerPedId(), 0

	exports['crp-ui']:openApp('skincreator', getData(), true)
end)

RegisterUICallback('modifyHeadBlend', function(data, cb)
	SetPedHeadBlendData(playerPed, data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], false)

	cb('ok')
end)

RegisterUICallback('modifyFaceFeature', function(data, cb)
	SetPedFaceFeature(playerPed, data.index, data.scale)

	cb('ok')
end)

RegisterUICallback('modifyHeadOverlay', function(data, cb)
	SetPedHeadOverlay(playerPed, data.index, data.value, data.opacity)

	cb('ok')
end)

RegisterUICallback('modifyBodyFeature', function(data, cb)
	local callbackData = 'ok'

	if data.index == 0 then
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

			SetPedHeadOverlayColor(playerPed, data.index, colourType, tonumber(data.firstColor), secondColor)
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

function getData()
	return {
		headBlend = getHeadBlend(), faceFeatures = getFaceFeatures(), headOverlays = getHeadOverlays(),
		colors = getColors(), variations = getVariations(), totals = getTotals()
	}
end