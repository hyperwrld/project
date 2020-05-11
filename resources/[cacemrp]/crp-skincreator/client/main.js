var shopLocations = [
    { x : 75.643,    y : -1392.841, z : 28.400, type : 'clothesmenu' }, { x : -822.06,   y : -1073.754, z : 10.352, type : 'clothesmenu' },
    { x : 425.248,   y : -806.5,    z : 28.515, type : 'clothesmenu' }, { x : -1192.044, y : -767.571,  z : 16.343, type : 'clothesmenu' },
    { x : -163.381,  y : -303.624,  z : 38.757, type : 'clothesmenu' }, { x : 125.185,   y : -224.674,  z : 53.582, type : 'clothesmenu' },
    { x : -710.384,  y : -152.602,  z : 36.439, type : 'clothesmenu' }, { x : -1450.246, y : -237.025,  z : 48.834, type : 'clothesmenu' },
    { x : -3171.236, y : 1042.866,  z : 19.887, type : 'clothesmenu' }, { x : 1196.774,  y : 2709.862,  z : 37.247, type : 'clothesmenu' },
    { x : 614.44,    y : 2763.788,  z : 41.112, type : 'clothesmenu' }, { x : -1101.088, y : 2710.478,  z : 18.132, type : 'clothesmenu' },
    { x : 1693.659,  y : 4822.568,  z : 41.087, type : 'clothesmenu' }, { x : 4.504,     y : 6512.537,  z : 30.902, type : 'clothesmenu' },
    { x : 137.034,   y : -1707.488, z : 28.316, type : 'barbermenu'  }, { x : -1282.113, y : -1116.666, z : 6.014,  type : 'barbermenu'  },
    { x : 1213.103,  y : -472.599,  z : 65.232, type : 'barbermenu'  }, { x : -32.887,   y : -153.152,  z : 56.101, type : 'barbermenu'  },
    { x : -814.428,  y : -184.034,  z : 36.593, type : 'barbermenu'  }, { x : 1931.077,  y : 3730.735,  z : 31.868, type : 'barbermenu'  },
    { x : -277.51,   y : 6227.918,  z : 30.72,  type : 'barbermenu'  }, { x : 1321.568,  y : -1652.798, z : 51.299, type : 'tattoomenu'  },
    { x : -1155.435, y : -1426.154, z : 3.978,  type : 'tattoomenu'  }, { x : 323.611,   y : 179.666,   z : 102.61, type : 'tattoomenu'  },
    { x : -3169.012, y : 1076.71,   z : 19.853, type : 'tattoomenu'  }, { x : 1864.106,  y : 3748.159,  z : 32.056, type : 'tattoomenu'  },
    { x : -293.637,  y : 6199.787,  z : 30.512, type : 'tattoomenu'  }, { x : 454.543,   y : -990.63,   z : 29.714, type : 'clothesmenu' }, // Polícia
    { x : 301.116,   y : -596.436,  z : 42.308, type : 'clothesmenu' } // Médicos
];

var isMenuOpen = false, cam = 0, isCamActive = false, oldSkin = {}, currentTattoos = {}, isNewCharacter = false;
var playerPed = GetPlayerPed(-1), tattoosCategories = GetTattoosCategories(), tattoosHashList = GetTemporaryTattoosList(), toggleClothes = [];

function RefreshMenu() {
    var hairColors = [], makeupColors = [];

    for (var i = 0; i < GetNumHairColors(); i++) {
        const [r, g, b] = GetPedHairRgbColor(i);

        hairColors[i] = [r, g, b];
    };

    for (var i = 0; i < GetNumMakeupColors(); i++) {
        const [r, g, b] = GetPedMakeupRgbColor(i);

        makeupColors[i] = [r, g, b];
    };

    SendNuiMessage(JSON.stringify({
        eventName: 'setColors',
        hairColor: GetPedHair(),
        hairColors: hairColors,
        makeupColors: makeupColors
    }));

    SendNuiMessage(JSON.stringify({
        eventName: 'setTotals',
        drawTotal: GetDrawablesTotal(),
        propDrawTotal: GetPropDrawablesTotal(),
        textureTotal: GetTextureTotals(),
        headOverlayTotal: GetHeadOverlayTotals(),
        skinTotal: GetSkinTotal()
    }));

    SendNuiMessage(JSON.stringify({
        eventName: 'setHead',
        headBlend: GetPedHeadBlend(),
        headOverlay: GetHeadOverlayData(),
        headStructure: GetHeadStructureData()
    }));

    SendNuiMessage(JSON.stringify({
        eventName: 'setClothesData',
        drawables: GetDrawables(),
        props: GetProps(),
        drawTextures: GetDrawTextures(),
        propTextures: GetPropTextures(),
        skin: GetSkin()
    }));

    SendNuiMessage(JSON.stringify({
        eventName: 'setTattoos',
        totals: tattoosCategories,
        values: GetTattoos()
    }));
};

function OpenMenu(name, isNew) {
    playerPed = GetPlayerPed(-1), oldSkin = GetCurrentPed(), isNewCharacter = isNew;

    FreezePedCameraRotation(playerPed, true);

    RefreshMenu();
    ToggleMenu(true, name);

    var thread = setTick(async () => {
        if (isMenuOpen) {
            await Wait(25000);

            InvalidateIdleCam();
        } else {
            clearTick(thread)
        }
    });
};

on('crp-skincreator:openMenu', (name, isNew) => {
    OpenMenu(name, isNew);
});

on('crp-skincreator:setPedFeatures', (data) => {
    playerPed = GetPlayerPed(-1);

    LoadSkin(data);
});

const nuiCallBack = function(data, cb) {
    if (data.updateClothes) {
        var selectedValue = hasValue(drawableNames, data.name);

        toggleClothes[data.name] = null;

        if (selectedValue > -1) {
            SetPedComponentVariation(playerPed, Number(selectedValue), Number(data.value), Number(data.texture), 2);

            cb([Number(GetNumberOfPedPropTextureVariations(playerPed, Number(selectedValue), Number(data.value)))]);
        } else {
            selectedValue = hasValue(propNames, data.name);

            if (Number(data.value) == -1) {
                ClearPedProp(playerPed, Number(selectedValue));
            } else {
                SetPedPropIndex(playerPed, Number(selectedValue), Number(data.value), Number(data.texture), true);
            };

            cb([GetNumberOfPedPropTextureVariations(playerPed, Number(selectedValue), Number(data.value))]);
        };
    };

    if (data.setSkin) {
        var skins;

        if (data.name == 'skin_male') {
            skins = maleSkins;
        } else {
            skins = femaleSkins;
        };

        var skin = skins[Number(data.value)];

        RotateEntity(180.0);

        SetSkin(GetHashKey(skin), true);

        Citizen.Wait(1);

        RotateEntity(180.0);

        RefreshMenu();

        cb(true);
    };

    if (data.resetSkin) {
        LoadSkin(oldSkin);

        cb(true);
    };

    if (data.saveHeadBlend) {
        SetPedHeadBlendData(playerPed, Number(data.shapeFirst), Number(data.shapeSecond), Number(data.shapeThird), Number(data.skinFirst), Number(data.skinSecond),
        Number(data.skinThird), Number(data.shapeMix) / 100, Number(data.skinMix) / 100, Number(data.thirdMix) / 100, false);

        cb(true);
    };

    if (data.saveHairColor) {
        if (data.firstColour != null && data.secondColour != null) {
            SetPedHairColor(GetPlayerPed(-1), Number(data.firstColour), Number(data.secondColour));
        };

        cb(true);
    };

    if (data.saveFaceFeatures) {
        var index = hasValue(faceFeatures, data.name);

        if (index <= -1) {
            return;
        };

        SetPedFaceFeature(playerPed, index, Number(data.scale) / 100);

        cb(true);
    };

    if (data.saveHeadOverlay) {
        var index = hasValue(headOverlays, data.name);

        SetPedHeadOverlay(playerPed, index, Number(data.value), Number(data.opacity) / 100);

        cb(true);
    };

    if (data.saveHeadOverlayColor) {
        var index = hasValue(headOverlays, data.name), color = Number(data.secondColour);
        const [retval, overlayValue, colourType, firstColour, secondColour, overlayOpacity] = GetPedHeadOverlayData(playerPed, index);

        if (color == null) {
            color = Number(data.firstColour);
        };

        SetPedHeadOverlayColor(playerPed, index, colourType, Number(data.firstColour), color);

        cb(true);
    };

    if (data.close) {
        SaveSkin(data.canSave);

        ToggleMenu(false, data.menuName);

        cb(true);
    };

    if (data.toggleCursor) {
        TriggerCustomCamera('torso');

        SetNuiFocus(false, false);
        FreezePedCameraRotation(playerPed, false);

        cb(true);
    };

    if (data.rotate) {
        if (data['key'] == 'left') {
            RotateEntity(20);
        } else {
            RotateEntity(-20);
        };

        cb(true);
    };

    if (data.switchCam) {
        TriggerCustomCamera(data.name);

        cb(true);
    };

    if (data.toggleClothes) {
        if (data.name == 'tops') {
            for (const [k, v] of Object.entries(data.table)) {
                ToggleProps(v);
            };
        } else {
            ToggleProps(data.name);
        };

        cb(true);
    };

    if (data.setTattoos) {
        SetTattoos(data.tattoos);

        cb(true);
    };
};

RegisterNuiCallbackType('nuiMessage');
on('__cfx_nui:nuiMessage', nuiCallBack);

setTick(async() => {
    var coords = GetEntityCoords(PlayerPedId()), letSleep = true;

    for (const [k, v] of Object.entries(shopLocations)) {
        const distance = GetDistanceBetweenCoords(coords[0], coords[1], coords[2], v.x, v.y, v.z, true);

        if (distance < 10.0) {
            DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 130, 201, 100, false, false, 2, true, null, null, false);

            letSleep = false;

            if (distance < 1.5) {
                DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abrir a ~g~loja~s~.');

                if (IsControlJustReleased(0, 38)) {
					OpenMenu(v.type, false);
            	};
            };
        };
    };

    if (letSleep) {
        await Wait(3000);
    };
});

function DisplayHelpText(string) {
    SetTextComponentFormat('STRING')
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
};