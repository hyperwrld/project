var radarEnabled = false, targets = [];

$(function() {
    InitiliazeRadar();

    var radarContainer = $('#policeradar');

    var fwdArrowFront = radarContainer.find('.fwdarrowfront'), fwdArrowBack = radarContainer.find('.fwdarrowback');
    var bwdArrowFront = radarContainer.find('.bwdarrowfront'), bwdArrowBack = radarContainer.find('.bwdarrowback');

    var fwdSame = radarContainer.find('.fwdsame'), fwdOpp = radarContainer.find('.fwdopp'), fwdXmit = radarContainer.find('.fwdxmit');
    var bwdSame = radarContainer.find('.bwdsame'), bwdOpp = radarContainer.find('.bwdopp'), bwdXmit = radarContainer.find('.bwdxmit');

    var fwdPlate = radarContainer.find('#fwdplate'), bwdPlate = radarContainer.find('#bwdplate');

    window.addEventListener('message', function (event) {
        switch(event.data.event) {
            case 'toggleRadar':
                radarEnabled = !radarEnabled;
                radarContainer.fadeToggle();

                if (event.data.fwdxmit) {
                    fwdXmit.addClass('active');
                } else if (event.data.fwdxmit == false) {
                    fwdXmit.removeClass('active');
                }

                if (event.data.bwdxmit) {
                    bwdXmit.addClass('active');
                } else if (event.data.bwdxmit == false) {
                    bwdXmit.removeClass('active');
                }

                if (event.data.fwdmode) {
                    ModeSwitch(fwdSame, fwdOpp, event.data.fwdmode);
                }

                if (event.data.bwdmode) {
                    ModeSwitch(bwdSame, bwdOpp, event.data.bwdmode);
                }

                break;
            case 'hideRadar':
                if (event.data.status) {
                    radarContainer.fadeOut();
                } else {
                    radarContainer.fadeIn();
                }

                break;
            case 'updateData':
                UpdateSpeed('fwdspeed', event.data.fwdspeed);
                UpdateSpeed('fwdfast', event.data.fwdfast);
                UpdateSpeed('bwdspeed', event.data.bwdspeed);
                UpdateSpeed('bwdfast', event.data.bwdfast);

                if (event.data.fwddir || event.data.fwddir == false || event.data.fwddir == null) {
                    UpdateArrowDir(fwdArrowFront, fwdArrowBack, event.data.fwddir);
                }

                if (event.data.bwddir || event.data.bwddir == false || event.data.bwddir == null) {
                    UpdateArrowDir(bwdArrowFront, bwdArrowBack, event.data.bwddir);
                }

                UpdateStatus('fwdplate', event.data.fwdplatelock);
                UpdateStatus('bwdplate', event.data.bwdplatelock);

                fwdPlate.html(event.data.fwdplate);
                bwdPlate.html(event.data.bwdplate);

                break;
            case 'lockFwdFast':
                LockSpeed('fwdfast', event.data.status)
                break;
            case 'lockBwdFast':
                LockSpeed('bwdfast', event.data.status)
                break;
            default:
                console.log('Received unhandled event ' + event.data.event);
            break;
        }
    });
})

function InitiliazeRadar() {
    $('.container').each(function(i, obj) {
        $(this).find('[data-target]').each(function(x, subObj) {
            targets[$(this).attr('data-target')] = $(this)
        })
    });
}

function UpdateSpeed(attr, data) {
    targets[attr].find('.speednumber').each(function(i, obj) {
        $(obj).html(data[i]);
    });
}

function UpdatePlate(attr, data) {
    $('.' + attr).html(data);
}

function LockSpeed(attr, state) {
    targets[attr].find('.speednumber').each(function(i, obj) {
        if (state == true) {
            $(obj).css('color', '#940000');
        } else {
            $(obj).css('color', '#ff0000');
        }
    });
}

function UpdateStatus(attr, state) {
    if (state) {
        $('#' + attr).css('color', '#109401');
    } else {
        $('#' + attr).css('color', '#18f400');
    }
}

function ModeSwitch(sameEle, oppEle, state) {
    if (state == 'same') {
        sameEle.addClass('active');
        oppEle.removeClass('active');
    } else if (state == 'opp') {
        oppEle.addClass('active');
        sameEle.removeClass('active');
    } else if (state == 'none') {
        oppEle.removeClass('active');
        sameEle.removeClass('active');
    }
}

function UpdateArrowDir(fwdEle, bwdEle, state) {
    if (state == true) {
        fwdEle.addClass('active');
        bwdEle.removeClass('active');
    } else if (state == false) {
        bwdEle.addClass('active');
        fwdEle.removeClass('active');
    } else if (state == null) {
        fwdEle.removeClass('active');
        bwdEle.removeClass('active');
    }
}