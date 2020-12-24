function getHeadBlend()
	return exports['crp-lib']:getHeadBlend(playerPed)
end

function getFaceFeatures()
	local data = {}

	for i = 1, 20, 1 do
        data[i] = GetPedFaceFeature(playerPed, i - 1)
    end

    return data
end

function getHeadOverlays()
	local data = {}

	for i = 1, 12, 1 do
		local retval, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(playerPed, i - 1)

		if retval then
			if colourType == 0 then
				data[i] = { overlayValue = overlayValue, opacity = overlayOpacity }
			else
				data[i] = { overlayValue = overlayValue, colourType = colourType, firstColour = firstColour, secondColour = secondColour, opacity = overlayOpacity }
			end
		end
	end

	return data
end

function getColors()
	local hairColors, makeupColors = {}, {}

	for i = 1, GetNumHairColors() do
		local r, g, b = GetPedHairRgbColor(i - 1)

        hairColors[i] = { r, g, b }
	end

	for i = 1, GetNumMakeupColors() do
		local r, g, b = GetPedMakeupRgbColor(i - 1)

        makeupColors[i] = { r, g, b }
	end

	return {
		hairColors = hairColors, hairColor = GetPedHairColor(playerPed),
		hairHightlightColor = GetPedHairHighlightColor(playerPed), makeupColors = makeupColors
	}
end

function getVariations()
	local drawables, drawablesTextures = {}, {}

	for i = 1, 12 do
		drawables[i], drawablesTextures[i] = GetPedDrawableVariation(playerPed, i - 1), GetPedTextureVariation(playerPed, i - 1)
	end

	local props, propsTextures = {}, {}

	for i = 1, 8 do
		props[i], propsTextures[i] = GetPedPropIndex(playerPed, i - 1), GetPedPropTextureIndex(playerPed, i - 1)
	end

	return {
		drawables = drawables, drawablesTextures = drawablesTextures, props = props, propsTextures = propsTextures
	}
end

function getTotals()
	local variations = getVariations()
	local drawables, drawablesTextures = {}, {}

	for i = 1, 12 do
		drawables[i] = GetNumberOfPedDrawableVariations(playerPed, i - 1)
	end

	for i = 1, #variations.drawables do
		drawablesTextures[i] = GetNumberOfPedTextureVariations(playerPed, i - 1, variations.drawables[i])
	end

	local props, propsTextures = {}, {}

	for i = 1, 8 do
		props[i] = GetNumberOfPedPropDrawableVariations(playerPed, i - 1)
	end

	for i = 1, #variations.props do
		propsTextures[i] = GetNumberOfPedPropTextureVariations(playerPed, i - 1, variations.props[i])
	end

	return {
		drawables = drawables, drawablesTextures = drawablesTextures, props = props, propsTextures = propsTextures
	}
end

function getCurrentModel()
	local model = GetEntityModel(playerPed)

	for i = 1, #maleSkins do
		if `maleSkins[i]` == model then
			return true, 'male'
		end
	end

	for i = 1, #femaleSkins do
		if `femaleSkins[i]` == model then
			return true, 'female'
		end
	end

	return false
end

function getCurrentSkin()
	return {
		model = GetEntityModel(playerPed), headBlend = getHeadBlend(), faceFeatures = getFaceFeatures(),
		headOverlays = getHeadOverlays(), colors = getColors(), variations = getVariations(), totals = getTotals()
	}
end

function setOldSkin(data)
	setSkin(data.model)

	setClothing(data.variations.drawables, data.variations.props, data.variations.drawablesTextures, data.variations.propsTextures)
	setFaceFeatures(data.faceFeatures)
	setHeadOverlays(data.headOverlays)

	local headBlend = data.headBlend

	SetPedHairColor(playerPed, data.hairColor, data.hairHightlightColor)
	SetPedHeadBlendData(playerPed, headBlend[1], headBlend[2], headBlend[3], headBlend[4], headBlend[5], headBlend[6], headBlend[7], headBlend[8], headBlend[9], false)
end

function setSkin(model)
	SetEntityInvincible(playerPed, true)

	if IsModelInCdimage(model) and IsModelValid(model) then
		LoadModel(model)

		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)

		playerPed = PlayerPedId()

		SetPedDefaultComponentVariation(playerPed)
	end

	SetEntityInvincible(playerPed, false)
end

function setClothing(drawables, props, drawablesTextures, propsTextures)
	for i = 1, 12 do
		SetPedComponentVariation(playerPed, i - 1, drawables[i], drawablesTextures[i], 2)
	end

	for i = 1, 8 do
		ClearPedProp(playerPed, i - 1)

		SetPedPropIndex(playerPed, i - 1, props[i], propsTextures[i], true)
	end
end

function setFaceFeatures(data)
    for i = 1, 20 do
        SetPedFaceFeature(player, i-  1, data[i])
    end
end

function setHeadOverlays(data)
	for i = 1, 12 do
		SetPedHeadOverlay(playerPed, i - 1, data[i].overlayValue, data[i].overlayOpacity)

		if data[i].firstColour then
			SetPedHeadOverlayColor(playerPed, i - 1, data[i].colourType, data[i].firstColour, data[i].secondColour)
		end
	end
end