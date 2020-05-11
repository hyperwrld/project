var isMenuOpen = false, isInService = false, currentMenu = null, hairColors = null, makeupColors = null;
let headBlend = {}, whitelisted = {};

whitelisted['male'] = {
    jackets:[1],
    undershirts:[],
    pants:[],
    decals:[],
    vest:[],
    hats:[],
}

whitelisted['female'] = {
    jackets:[],
    undershirts:[],
    pants:[],
    vest:[],
    hats:[],
}

$('#clothesmenu').fadeOut(0), $('#barbermenu').fadeOut(0);

$(function() {
    $('.modal').modal();

    window.addEventListener('message', function (event) {
        switch (event.data.eventName) {
			case 'enableMenu':
                isMenuOpen = event.data.status;

                if (isMenuOpen) {
                    currentMenu = $('#' + event.data.menuName);
                    isInService = event.data.isInService;
                    document.body.style.display = 'block';

                    setTimeout(function () {
                        currentMenu.fadeIn(500);
                    }, 1);
                } else {
                    currentMenu.fadeOut(500);

                    setTimeout(function () {
                        document.body.style.display = 'none';
                    }, 500);
                }
                break;
            case 'setColors':
                hairColors = CreatePalette(event.data.hairColors);
                makeupColors = CreatePalette(event.data.makeupColors);

                AddPalettes();
                SetHairColor(event.data.hairColor);
                break;
            case 'setTotals':
                UpdateTotals(event.data.drawTotal, event.data.propDrawTotal, event.data.textureTotal, event.data.headOverlayTotal, event.data.skinTotal);
                break;
            case 'setHead':
                headBlend = event.data.headBlend;

                SetupHeadBlend();
                SetupHeadOverlay(event.data.headOverlay);
                SetupHeadStructure(event.data.headStructure);
                break;
            case 'setClothesData':
                UpdateInputs(event.data.drawables, event.data.props, event.data.drawTextures, event.data.propTextures, event.data.skin);
                break;
            case 'setTattoos':
                SetupTattoosTotals(event.data.totals)
                SetupTattoosValues(event.data.values)
                break;
            default:
                break;
        }
    });

    document.onkeyup = function (data) {
        if (isMenuOpen) {
            if (data.which == 27) {
                if ($('#closemenu').hasClass('open')) {
                    $('#closemenu').modal('close');
                } else {
                    $('#closemenu').modal('open');
                }
            }
        }
    };

    $('#save').on('click', function() {
        CloseMenu(true);
    })

    $('#discard').on('click', function() {
        CloseMenu(false);
    })

    $('.button-menu').on('click', function () {
        $('.button-menu').removeClass('active');

        $('.button-menu').each(function() {
            $('#' + $(this).attr('data-target')).fadeOut(100);
        });

        let target = $('#' + $(this).attr('data-target'));

        $(this).addClass('active');

        target.fadeIn(100);
    })

    $('.button-left').on('click', function () {
        var input = $(this).parent().find('.input-number');

        input.val(parseInt(input.val()) - 1);

        InputChange(input, false);
    });

    $('.button-right').on('click', function () {
        var input = $(this).parent().find('.input-number');

        input.val(parseInt(input.val()) + 1);

        InputChange(input, true);
    });

    $('.input-number').on('input', function () {
        InputChange($(this), true);
    });

    $('.slider-range').on('input', function() {
        if (currentMenu.is($('#barbermenu'))) {
            var activeID = $('#barbermenu').find('.active').attr('id');

            switch (activeID) {
                case 'button-inheritance':
                    SaveHeadBlend();
                    break;
                case 'button-faceshape':
                    SaveFaceShape($(this));
                    break;
                case 'button-appear':
                case 'button-hair':
                case 'button-features':
                    SaveHeadOverlay($(this));
                    break;
            }
        }
    });

    $('.tog_head').on('click', function() {
        ToggleCam($(this));

        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ switchCam: true, name: 'head' }));
    });

    $('.tog_torso').on('click', function() {
        ToggleCam($(this));

        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ switchCam: true, name: 'torso' }));
    });

    $('.tog_leg').on('click', function() {
        ToggleCam($(this));

        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ switchCam: true, name: 'leg' }));
    });

    $('.tog_cam').on('click', function() {
        ToggleCam($(this));

        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ switchCam: true, name: 'cam' }));
    });

    $('.tog_hat').on('click', function() {
        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ toggleClothes: true, name: 'hats' }));
    });

    $('.tog_glasses').on('click', function() {
        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ toggleClothes: true, name: 'glasses' }));
    });

    $('.tog_tops').on('click', function() {
        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({
            toggleClothes: true, name: 'tops', table: [ 'jackets', 'undershirts', 'torsos', 'vest', 'bags', 'neck', 'decals' ]
        }));
    });

    $('.tog_legs').on('click', function() {
        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ toggleClothes: true, name: 'legs' }));
    })

    $('.tog_mask').on('click', function() {
        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ toggleClothes: true, name: 'masks' }));
    });

    $('#reset').on('click', function() {
        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ resetSkin: true }));
    });

    window.addEventListener('keydown', throttle(function (event) {
        var input = $(event.target), num = input.hasClass('input-number'), _key = false;

        if (event.which == 39 || event.which == 68) {
            if (num === false) {
                _key = 'left';
            } else if (num) {
                input.val(parseInt(input.val()) + 1);

                InputChange(input, true);
            }
        }

        if (event.which == 37 || event.which == 65) {
            if (num === false) {
                _key = 'right';
            } else if (num) {
                input.val(parseInt(input.val()) - 1);

                InputChange(input, false);
            }
        }

        if (_key) {
            $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ rotate: true, key: _key }));
        }
    }, 50))

});

function CloseMenu(canSave) {
    $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ close: true, canSave: canSave, menuName: currentMenu.selector.replace('#', '') }));
}

function UpdateTotals(drawTotal, propDrawTotal, textureTotal, headOverlayTotal, skinTotal) {
    for (var i = 0; i < Object.keys(drawTotal).length; i++) {
        if (drawTotal[i][0] == 'hair') {
            $('.hair').each(function() {
                $(this).find('.total-number').eq(0).text(drawTotal[i][1]);
            })
        }
        $('#' + drawTotal[i][0]).find('.total-number').eq(0).text(drawTotal[i][1]);
    }

    for (var i = 0; i < Object.keys(propDrawTotal).length; i++) {
        $('#' + propDrawTotal[i][0]).find('.total-number').eq(0).text(propDrawTotal[i][1]);
    }

    for (const key of Object.keys(textureTotal)) {
        $('#' + key).find('.total-number').eq(1).text(textureTotal[key]);
    }

    for (const key of Object.keys(headOverlayTotal)) {
        $('#' + key).find('.total-number').eq(0).text(headOverlayTotal[key]);
    }

    let skinConts = $('#skins').find('.total-number');

    skinConts.eq(0).text(skinTotal[0]+1);
    skinConts.eq(1).text(skinTotal[1]+1);
}

function UpdateInputs(drawables, props, drawTextures, propTextures, skin) {
    for (var i = 0; i < Object.keys(drawables).length; i++) {
        if (drawables[i][0] == 'hair') {
            $('.hair').each(function() {
                $(this).find('.input-number').eq(0).val(drawables[i][1]);
            })
        }
        $('#' + drawables[i][0]).find('.input-number').eq(1).val(drawables[i][1]);
    }

    for (var i = 0; i < Object.keys(props).length; i++) {
        $('#' + props[i][0]).find('.input-number').eq(0).val(props[i][1]);
    }

    for (var i = 0; i < Object.keys(drawTextures).length; i++) {
        $('#' + drawTextures[i][0]).find('.input-number').eq(1).val(drawTextures[i][1]);
    }
    for (var i = 0; i < Object.keys(propTextures).length; i++) {
        $('#' + propTextures[i][0]).find('.input-number').eq(1).val(propTextures[i][1]);
    }

    if (skin['name'] == 'skin_male') {
        $('#skin_male').val(skin['value'])

        if ($('#skin_female').val() != 0) {
            $('#skin_female').val(0);
        }
    } else {
        $('#skin_female').val(skin['value'])

        if ($('#skin_male').val() != 0) {
            $('#skin_male').val(0);
        }
    }
}

function InputChange(element, inputType) {
    var inputs = $(element).parent().parent().find('.input-number'), total = 0;

    if (currentMenu.is($('#clothesmenu')) || $(element).parents('.panel').hasClass('hair')) {
        if (element.is(inputs.eq(0))) {
            total = inputs.eq(0).parent().find('.total-number').text();

            inputs.eq(1).val(0);
        } else {
            total = inputs.eq(1).parent().find('.total-number').text();
        }

        if (parseInt($(element).val()) > parseInt(total) - 1) {
            $(element).val(-1);
        } else if (parseInt($(element).val()) < -1) {
            $(element).val(parseInt(total) - 1);
        }

        if (element.is(inputs.eq(1)) && $(element).val() == -1) {
            $(element).val(0);
        }

        if (!isInService && ($('#skin_female').val() == 1 || $('#skin_male').val() == 1)) {
            let clothingName = $(element).parents('.panel').attr('id'), clothingID = parseInt($(element).val());
            let isNotValid = true, gender = 'male';

            if ($('#skin_female').val() >= 1 && $('#skin_male').val() == 0) {
                gender = 'female';
            }

            if (element.is(inputs.eq(0)) && whitelisted[gender][clothingName]){
                while (isNotValid) {
                    if (whitelisted[gender][clothingName].indexOf(clothingID) > -1 ){
                        isNotValid = true;

                        if (inputType) {
                            clothingID++;
                        } else {
                            clothingID--;
                        }
                    } else {
                        isNotValid = false;
                    }
                }
            }
            $(element).val(clothingID);
        }

        if ($(element).parents('.panel').attr('id') == 'skins') {
            $.post('http://crp-skincreator/nuiMessage', JSON.stringify({
                setSkin: true, name: $(element).attr('id'), value: $(element).val()
            }))
        } else {
            let nameId = '';

            if (currentMenu.is($('#barbermenu')))
                nameId = 'hair';
            else {
                nameId = $(element).parent().parent().parent().attr('id').split('#')[0];
            }

            $.post('http://crp-skincreator/nuiMessage', JSON.stringify({
                updateClothes: true, name: nameId, value: inputs.eq(0).val(), texture: inputs.eq(1).val()
            })).done(function(data) {
                inputs.eq(1).parent().find('.total-number').text(data);
            });
        }
    } else if (currentMenu.is($('#barbermenu'))) {
        if (element.is(inputs.eq(0))) {
            total = inputs.eq(0).parent().find('.total-number').text();
        } else {
            total = inputs.eq(1).parent().find('.total-number').text();
        }

        var value = parseInt($(element).val(), 10);

        total = parseInt(total, 10) - 1;

        if (value > 255) {
            value = 0;
        } else if (value === 254) {
            value = total;
        } else if (value < 0 || value > total) {
            value = 255;
        }

        $(element).val(value);

        var activeID = $('#barbermenu').find('.active').attr('id');

        switch (activeID) {
            case 'button-inheritance':
                SaveHeadBlend();
                break;
            case 'button-appear':
            case 'button-hair':
            case 'button-features':
                SaveHeadOverlay(element);
                break;
        }
    } else if (currentMenu.is($('#tattoomenu'))) {
        total = inputs.eq(0).parent().find('.total-number').text();

        if (parseInt($(element).val()) > parseInt(total)-1) {
            $(element).val(0);
        } else if (parseInt($(element).val()) < 0) {
            $(element).val(parseInt(total) - 1);
        }

        let tattoos = {}, categEles = $('#tattoos .scroll-container').children();

        categEles.each(function () {
            tattoos[$(this).attr('id')] = $(this).find('.input-number').val();
        })

        $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ setTattoos: true, tattoos: tattoos }));
    }
}

function ToggleCam(element) {
    $('tog_head').removeClass('active');
    $('tog_torso').removeClass('active');
    $('tog_leg').removeClass('active');

    element.addClass('active');
}

function SetHairColor(data) {
    $('.hair').each(function() {
        var palettes = $(this).find('.color_palette_container').eq(0).find('.color_palette');

        $(palettes[data[0]]).addClass('active');

        palettes = $(this).find('.color_palette_container').eq(1).find('.color_palette');

        $(palettes[data[1]]).addClass('active');
    })
}

function SetupHeadBlend() {
    if (headBlend == null)  {
        return;
    }

    var sf = $('#shapeFirstP'), ss = $('#shapeSecondP'), st = $('#shapeThirdP');

    sf.find('.input-number').eq(0).val(headBlend['shapeFirst']);
    sf.find('.input-number').eq(1).val(headBlend['skinFirst']);
    ss.find('.input-number').eq(0).val(headBlend['shapeSecond']);
    ss.find('.input-number').eq(1).val(headBlend['skinSecond']);
    st.find('.input-number').eq(0).val(headBlend['shapeThird']);
    st.find('.input-number').eq(1).val(headBlend['skinThird']);

    $('#fmix').find('input').val(parseFloat(headBlend['shapeMix']) * 100);
    $('#smix').find('input').val(parseFloat(headBlend['skinMix']) * 100);
    $('#tmix').find('input').val(parseFloat(headBlend['thirdMix']) * 100);
}

function SaveHeadBlend() {
    $.post('http://crp-skincreator/nuiMessage', JSON.stringify({
        saveHeadBlend: true, shapeFirst: $('#shapeFirst').val(), shapeSecond: $('#shapeSecond').val(), shapeThird: $('#shapeThird').val(), skinFirst: $('#skinFirst').val(),
        skinSecond: $('#skinSecond').val(), skinThird: $('#skinThird').val(), shapeMix: $('#shapeMix').val(), skinMix: $('#skinMix').val(), thirdMix: $('#thirdMix').val()
    }));
}

function SaveFaceShape(element) {
    $.post('http://crp-skincreator/nuiMessage', JSON.stringify({ saveFaceFeatures: true, name: element.attr('data-value'), scale: element.val() }));
}

function SetupHeadStructure(data) {
    let sliders = $('#faceshape').find('.slider-range');

    for (const key of Object.keys(data)) {
        sliders.each(function() {
            if ($(this).attr('data-value') == key) {
                $(this).val(parseFloat(data[key]) * 100);
            }
        })
    }
}

function SetupHeadOverlay(data) {
    for (var i = 0; i < data.length; i++) {
        var element = $('#' + data[i]['name']), inputs = element.find('input');

        inputs.eq(0).val(parseInt(data[i]['overlayValue']));
        inputs.eq(1).val(parseInt(data[i]['overlayOpacity'] * 100));

        var palettes = element.find('.color_palette_container').eq(0).find('.color_palette');

        $(palettes[data[i]['firstColour']]).addClass('active');
        palettes = element.find('.color_palette_container').eq(1).find('.color_palette');
        $(palettes[data[i]['secondColour']]).addClass('active');
    }
}

function SaveHeadOverlay(element) {
    var id = element.parents('.panel').attr('id'), inputs = element.parents('.panel-bottom').find('input');
    let opacity = inputs.eq(1).val() ? inputs.eq(1).val() : 0;

    $.post('http://crp-skincreator/nuiMessage', JSON.stringify({
        saveHeadOverlay: true, name: id, value: inputs.eq(0).val(), opacity: opacity
    }));
}

function AddPalettes() {
    $('.collapsible').collapsible();

    $('.color_palette_container').each(function () {
        $(this).empty();

        if ($(this).hasClass('haircol')) {
            $(this).append($(hairColors));
        }

        if ($(this).hasClass('makeupcol')) {
            $(this).append($(makeupColors));
        }
    });

    $('.color_palette').on('click', function() {
        var palettes = $(this).parents('.panel').find('.color_palette_container');

        $(this).parent().find('.color_palette').removeClass('active');
        $(this).addClass('active');

        if ($(this).parents('.panel').hasClass('hair')) {
            $.post('http://crp-skincreator/nuiMessage', JSON.stringify({
                saveHairColor: true, firstColour: palettes.eq(0).find('.active').attr('value'), secondColour: palettes.eq(1).find('.active').attr('value')
            }));
        } else {
            $.post('http://crp-skincreator/nuiMessage', JSON.stringify({
                saveHeadOverlayColor: true, firstColour: palettes.eq(0).find('.active').attr('value'), secondColour: palettes.eq(1).find('.active').attr('value'), name: $(this).parents('.panel').attr('id')
            }));
        }
    })
}

function CreatePalette(array) {
    var string = "";

    for (var i = 0; i < Object.keys(array).length; i++) {
        var color = array[i][0] + "," + array[i][1] + "," + array[i][2];

        string += '<div class="color_palette" style="background-color: rgb(' + color + ')" value="' + i + '"></div>';
    }

    return string
}

function SetupTattoosTotals(totals) {
    for (let i = 0; i < Object.keys(totals).length; i++) {
        $('#' + totals[i][0]).find('.total-number').text(totals[i][1]);
    }
}

function SetupTattoosValues(data) {
    for (let i = 0; i < Object.keys(data).length; i++) {
        $('#' + data[i][0]).find('.input-number').val(data[i][1]);
    }
}

const throttle = (func, limit) => {
    let inThrottle

    return (...args) => {
        if (!inThrottle) {
            func(...args)
            inThrottle = setTimeout(() => inThrottle = false, limit)
        }
    }
};