local shopLocations = {
    [1]  = { ['x'] = 75.643,    ['y'] = -1392.841, ['z'] = 28.400, ['type'] = 'clothesmenu' },
    [2]  = { ['x'] = -822.06,   ['y'] = -1073.754, ['z'] = 10.352, ['type'] = 'clothesmenu' },
    [3]  = { ['x'] = 425.248,   ['y'] = -806.5,    ['z'] = 28.515, ['type'] = 'clothesmenu' },
    [4]  = { ['x'] = -1192.044, ['y'] = -767.571,  ['z'] = 16.343, ['type'] = 'clothesmenu' },
    [5]  = { ['x'] = -163.381,  ['y'] = -303.624,  ['z'] = 38.757, ['type'] = 'clothesmenu' },
    [6]  = { ['x'] = 125.185,   ['y'] = -224.674,  ['z'] = 53.582, ['type'] = 'clothesmenu' },
    [7]  = { ['x'] = -710.384,  ['y'] = -152.602,  ['z'] = 36.439, ['type'] = 'clothesmenu' },
    [8]  = { ['x'] = -1450.246, ['y'] = -237.025,  ['z'] = 48.834, ['type'] = 'clothesmenu' },
    [9]  = { ['x'] = -3171.236, ['y'] = 1042.866,  ['z'] = 19.887, ['type'] = 'clothesmenu' },
    [10] = { ['x'] = 1196.774,  ['y'] = 2709.862,  ['z'] = 37.247, ['type'] = 'clothesmenu' },
    [11] = { ['x'] = 614.44,    ['y'] = 2763.788,  ['z'] = 41.112, ['type'] = 'clothesmenu' },
    [12] = { ['x'] = -1101.088, ['y'] = 2710.478,  ['z'] = 18.132, ['type'] = 'clothesmenu' },
    [13] = { ['x'] = 1693.659,  ['y'] = 4822.568,  ['z'] = 41.087, ['type'] = 'clothesmenu' },
    [14] = { ['x'] = 4.504,     ['y'] = 6512.537,  ['z'] = 30.902, ['type'] = 'clothesmenu' },
    [15] = { ['x'] = 137.034,   ['y'] = -1707.488, ['z'] = 28.316, ['type'] = 'barbermenu'  },
    [16] = { ['x'] = -1282.113, ['y'] = -1116.666, ['z'] = 6.014,  ['type'] = 'barbermenu'  },
    [17] = { ['x'] = 1213.103,  ['y'] = -472.599,  ['z'] = 65.232, ['type'] = 'barbermenu'  },
    [18] = { ['x'] = -32.887,   ['y'] = -153.152,  ['z'] = 56.101, ['type'] = 'barbermenu'  },
    [19] = { ['x'] = -814.428,  ['y'] = -184.034,  ['z'] = 36.593, ['type'] = 'barbermenu'  },
    [20] = { ['x'] = 1931.077,  ['y'] = 3730.735,  ['z'] = 31.868, ['type'] = 'barbermenu'  },
    [21] = { ['x'] = -277.51,   ['y'] = 6227.918,  ['z'] = 30.72,  ['type'] = 'barbermenu'  },
    [22] = { ['x'] = 1321.568,  ['y'] = -1652.798, ['z'] = 51.299, ['type'] = 'tattoomenu'  },
    [23] = { ['x'] = -1155.435, ['y'] = -1426.154, ['z'] = 3.978,  ['type'] = 'tattoomenu'  },
    [24] = { ['x'] = 323.611,   ['y'] = 179.666,   ['z'] = 102.61, ['type'] = 'tattoomenu'  },
    [25] = { ['x'] = -3169.012, ['y'] = 1076.71,   ['z'] = 19.853, ['type'] = 'tattoomenu'  },
    [26] = { ['x'] = 1864.106,  ['y'] = 3748.159,  ['z'] = 32.056, ['type'] = 'tattoomenu'  },
    [27] = { ['x'] = -293.637,  ['y'] = 6199.787,  ['z'] = 30.512, ['type'] = 'tattoomenu'  },

    [30] = { ['x'] = 454.543,   ['y'] = -990.63,   ['z'] = 29.714, ['type'] = 'clothesmenu' }, -- Polícia
    [31] = { ['x'] = 301.116,   ['y'] = -596.436,  ['z'] = 42.308, ['type'] = 'clothesmenu' }, -- Médicos
}

isMenuOpen, cam, isCamActive, oldSkin = false, 0, false, 0
playerPed, tattoosCategories, tattoosHashList, toggleClothes = GetPlayerPed(-1), GetTattoosCategories(), GetTemporaryTattoosList(), {}

function RefreshMenu()
    local hairColors, makeupColors = {}, {}

    for i = 0, GetNumHairColors() - 1 do
        local r, g, b = GetPedHairRgbColor(i)

        hairColors[i] = { r, g, b }
    end

    for i = 0, GetNumMakeupColors()-1 do
        local r, g, b = GetPedMakeupRgbColor(i)

        makeupColors[i] = { r, g, b }
    end

    SendNUIMessage({
        eventName = 'setColors',
        hairColor = GetPedHair(),
        hairColors = hairColors,
        makeupColors = makeupColors
    })

    SendNUIMessage({
        eventName = 'setTotals',
        drawTotal = GetDrawablesTotal(),
        propDrawTotal = GetPropDrawablesTotal(),
        textureTotal = GetTextureTotals(),
        headOverlayTotal = GetHeadOverlayTotals(),
        skinTotal = GetSkinTotal()
    })

    SendNUIMessage({
        eventName = 'setHead',
        headBlend = GetPedHeadBlendData(),
        headOverlay = GetHeadOverlayData(),
        headStructure = GetHeadStructureData()
    })

    SendNUIMessage({
        eventName = 'setClothesData',
        drawables = GetDrawables(),
        props = GetProps(),
        drawTextures = GetDrawTextures(),
        propTextures = GetPropTextures(),
        skin = GetSkin()
    })

    SendNUIMessage({
        eventName = 'setTattoos',
        totals = tattoosCategories,
        values = GetTattoos()
    })
end

function OpenMenu(name)
    playerPed, oldSkin = GetPlayerPed(-1), GetCurrentPed()

    FreezePedCameraRotation(playerPed, true)

    RefreshMenu()
    ToggleMenu(true, name)

    Citizen.CreateThread(function()
        repeat
            Wait(5000)

            InvalidateIdleCam()
        until isMenuOpen == false
    end)
end

local function nuiCallBack(data, cb)
	local events = exports['crp-base']:getModule('Events')

    if data.updateClothes then
        local selectedValue = hasValue(drawableNames, data.name)

        toggleClothes[data.name] = nil

        if (selectedValue > -1) then
            SetPedComponentVariation(playerPed, tonumber(selectedValue), tonumber(data.value), tonumber(data.texture), 2)

            cb({ tonumber(GetNumberOfPedPropTextureVariations(playerPed, tonumber(selectedValue), tonumber(data.value))) })
        else
            selectedValue = hasValue(propNames, data.name)

            if (tonumber(data.value) == -1) then
                ClearPedProp(playerPed, tonumber(selectedValue))
            else
                SetPedPropIndex(playerPed, tonumber(selectedValue), tonumber(data.value), tonumber(data.texture), true)
            end

            cb({ GetNumberOfPedPropTextureVariations(playerPed, tonumber(selectedValue), tonumber(data.value)) })
        end
    end

    if data.setSkin then
        local skins

        if data.name == 'skin_male' then
            skins = maleSkins
        else
            skins = femaleSkins
        end

        local skin = skins[tonumber(data.value)]

        RotateEntity(180.0)

        SetSkin(GetHashKey(skin), true)

        Citizen.Wait(1)

        RotateEntity(180.0)

        RefreshMenu()

        cb(true)
    end

    if data.resetSkin then
        LoadSkin(oldSkin)

        cb(true)
    end

    if data.saveHeadBlend then
        SetPedHeadBlendData(playerPed, tonumber(data.shapeFirst), tonumber(data.shapeSecond), tonumber(data.shapeThird), tonumber(data.skinFirst), tonumber(data.skinSecond),
        tonumber(data.skinThird), tonumber(data.shapeMix) / 100, tonumber(data.skinMix) / 100, tonumber(data.thirdMix) / 100, false)

        cb(true)
    end

    if data.saveHairColor then
        if data.firstColour ~= nil and data.secondColour ~= nil then
            SetPedHairColor(playerPed, tonumber(data.firstColour), tonumber(data.secondColour))
        end

        cb(true)
    end

    if data.saveFaceFeatures then
        local index = hasValue(faceFeatures, data.name)

        if index <= -1 then
            return
        end

        SetPedFaceFeature(playerPed, index, tonumber(data.scale) / 100)

        cb(true)
    end

    if data.saveHeadOverlay then
        local index = hasValue(headOverlays, data.name)

        SetPedHeadOverlay(playerPed, index, tonumber(data.value), tonumber(data.opacity) / 100)

        cb(true)
    end

    if data.saveHeadOverlayColor then
        local index, color = hasValue(headOverlays, data.name), tonumber(data.secondColour)
        local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(playerPed, index)

        if color == nil then
            color = tonumber(data.firstColour)
        end

        SetPedHeadOverlayColor(playerPed, index, colourType, tonumber(data.firstColour), color)

        cb(true)
    end

    if data.close then
        SaveSkin(data.canSave)

        ToggleMenu(false, false)

        cb(true)
    end

    if data.toggleCursor then
        TriggerCustomCamera('torso')

        SetNuiFocus(false, false)
        FreezePedCameraRotation(playerPed, false)

        cb(true)
    end

    if data.rotate then
        if data['key'] == 'left' then
            RotateEntity(20)
        else
            RotateEntity(-20)
        end

        cb(true)
    end

    if data.switchCam then
        TriggerCustomCamera(data.name)

        cb(true)
    end

    if data.toggleClothes then
        if data.name == 'tops' then
            for k, v in pairs(data.table) do
                ToggleProps(v)
            end
        else
            ToggleProps(data.name)
        end

        cb(true)
    end

    if data.setTattoos then
        SetTattoos(data.tattoos)

        cb(true)
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep = false, true

        for k, v in pairs(shopLocations) do
            local distance = #(coords - (vector3(v.x, v.y, v.z)))

            if distance < 10.0 then
                DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 130, 201, 100, false, false, 2, false, nil, nil, false)

                letSleep = false

                if distance < 1.5 then
					DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abrir a ~g~loja~s~.')

                    if IsControlJustReleased(0, 38) then
						OpenMenu(v.type)
					end
                end
            end
		end

		if letSleep then
			Citizen.Wait(1500)
        end
	end
end)

function DisplayHelpText(string)
    SetTextComponentFormat('STRING')
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNUICallback('nuiMessage', nuiCallBack)