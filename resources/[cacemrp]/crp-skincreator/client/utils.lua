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
				data[i] = { overlayValue = overlayValue, firstColour = firstColour, secondColour = secondColour, opacity = overlayOpacity }
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