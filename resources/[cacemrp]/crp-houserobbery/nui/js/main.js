var minRot = -90, maxRot = 90, solveDeg = (Math.random() * 180) - 90, solvePadding = 4, maxDistanceFromSolve = 45;
var pinRot = 0, cylinderRot = 0, lastMousePos = 0, mouseSmoothing = 2, keyRepeatRate = 25, cylinderRotSpeed = 3, pinDamage = 33.33;
var pinHealth = 100, pinDamageInterval = 150, userPushingCylinder = false;
var pin, cylinder, driver, cylinderRotationInterval, pinLastDamaged;

$(function() {
    pin = $('#pin'), cylinder = $('#cylinder'), driver = $('#driver');

    window.addEventListener('message', function(event) {
        switch(event.data.eventName) {
			case 'show':
                $('body').show();
				break;
			default:
                break;
        }
    });

    $('body').on('mousemove', function(event){
        if (lastMousePos) {
            var pinRotChange = (event.clientX - lastMousePos) / mouseSmoothing;

            pinRot += pinRotChange;
            pinRot = util.clamp(pinRot,maxRot,minRot);

            pin.css({ transform: 'rotateZ(' + pinRot + 'deg)'})
        }

        lastMousePos = event.clientX;
    });

    $('body').on('mouseleave', function(event){
        lastMousePos = 0;
    });

    $('body').on('keydown', function(event){
        if ((event.keyCode == 87 || event.keyCode == 65 || event.keyCode == 83 || event.keyCode == 68 || event.keyCode == 37 || event.keyCode == 39) && !userPushingCylinder) {
            pushCylinder();
        }
    });

    $('body').on('keyup', function(event){
        if ((event.keyCode == 87 || event.keyCode == 65 || event.keyCode == 83 || event.keyCode == 68 || event.keyCode == 37 || event.keyCode == 39)) {
            unpushCylinder();
        }
    });

    $('body').on('keyup', function(event){
        if (event.keyCode == 27) {
            $.post('http://crp-houserobbery/nuiMessage', JSON.stringify({ cancel: true }));

            restart()
        }
    });
})

function pushCylinder() {
    var distanceFromSolve, cylinderRotationAllowance;

    clearInterval(cylinderRotationInterval);

    userPushingCylinder = true;
    distanceFromSolve = Math.abs(pinRot - solveDeg) - solvePadding;
    distanceFromSolve = util.clamp(distanceFromSolve, maxDistanceFromSolve, 0)

    cylinderRotationAllowance = util.convertRanges(distanceFromSolve, 0, maxDistanceFromSolve, 1, 0.02);
    cylinderRotationAllowance = cylinderRotationAllowance * maxRot;

    cylinderRotationInterval = setInterval(function() {
        cylinderRot += cylinderRotSpeed;

        if (cylinderRot >= maxRot) {
            cylinderRot = maxRot;

            clearInterval(cylinderRotationInterval)

            $.post('http://crp-houserobbery/nuiMessage', JSON.stringify({ open: true }));

            restart()
        } else if (cylinderRot >= cylinderRotationAllowance) {
            cylinderRot = cylinderRotationAllowance;

            damagePin()
        }

        cylinder.css({ transform: 'rotateZ(' + cylinderRot + 'deg)' });
        driver.css({ transform: 'rotateZ(' + cylinderRot + 'deg)' });
    }, keyRepeatRate);
}

function unpushCylinder() {
    userPushingCylinder = false;

    clearInterval(cylinderRotationInterval);

    cylinderRotationInterval = setInterval(function(){
        cylinderRot -= cylinderRotSpeed;

        cylinderRot = Math.max(cylinderRot, 0);

        cylinder.css({ transform: 'rotateZ(' + cylinderRot + 'deg)' })
        driver.css({ transform: 'rotateZ(' + cylinderRot + 'deg)' })

        if (cylinderRot <= 0) {
            cylinderRot = 0;

            clearInterval(cylinderRotationInterval);
        }
    }, keyRepeatRate);
}

function damagePin() {
    if (!pinLastDamaged || Date.now() - pinLastDamaged > pinDamageInterval) {
        var tl = new TimelineLite();

        pinHealth -= pinDamage;
        pinLastDamaged = Date.now()

        tl.to(pin, (pinDamageInterval / 4) / 1000, { rotationZ: pinRot - 2 });
        tl.to(pin, (pinDamageInterval / 4) / 1000, { rotationZ: pinRot });

        if (pinHealth <= 0) {
            breakPin();
        }
    }
}

function breakPin() {
    var tl, pinTop, pinBot;

    clearInterval(cylinderRotationInterval);

    tl = new TimelineLite();

    tl.to(pin.find('.top'), 0.7, { rotationZ: -400, x: -200, y: -100, opacity: 0 });
    tl.to(pin.find('.bot'), 0.7, { rotationZ: 400, x: 200, y: 100, opacity: 0, onComplete: function() {
        $.post('http://crp-houserobbery/nuiMessage', JSON.stringify({ remove: true }));

        restart()
    }}, 0)

    tl.play();
}

util = {};

util.clamp = function(val, max, min) {
    return Math.min(Math.max(val, min), max);
}

util.convertRanges = function(oldValue, oldMin, oldMax, newMin, newMax) {
    return (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) + newMin
}

function restart() {
    $('body').hide();

    cylinderRot = 0, pinHealth = 100, pinRot = 0;

    solveDeg = (Math.random() * 180) - 90;

    pin.css({ transform: 'rotateZ(' + pinRot + 'deg)' })
    cylinder.css({ transform: 'rotateZ(' + cylinderRot + 'deg)' })
    driver.css({ transform: 'rotateZ(' + cylinderRot + 'deg)' })

    tl = new TimelineLite();

    tl.to(pin.find('.top'), 0, { rotationZ: 0, x: 0, y: 0, opacity: 1 });
    tl.to(pin.find('.bot'), 0, { rotationZ: 0, x: 0, y: 0, opacity: 1 });
}