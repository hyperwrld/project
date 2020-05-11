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

function DisplayHelpText(string) {
    SetTextComponentFormat('STRING')
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
};