$(function() {
	var mapHeight = 0.18888, mapWidthRatio = 1.41, hasBelt = false;

	window.addEventListener('message', function(event) {
		switch(event.data.eventName) {
			case 'hudPosition':
				var width = $(window).width(), height = $(window).height();
				var x = event.data.topX, y = event.data.topY;

                $('.minimap').css({
					'top': (y * height) + 'px',
					'left': (x * width) + 'px',
					'width': (mapHeight * height * mapWidthRatio) + 'px',
					'height': (mapHeight * height)
                })

				break;
			case 'updateHud':
				var health = $('.sub-health'), armour = $('.sub-armour'), breath = $('.sub-breath'), stress = $('.sub-stress');

				health.css({'width': (event.data.health - 100) + '%'});
				armour.css({'width': (event.data.armour) + '%'});

				if (event.data.isUnderWater == true) {
					if (!breath.parent().hasClass('active')) {
						breath.parent().addClass('active');
					}
					breath.css({'width': (event.data.breath * 10) + '%'});
				} else if (breath.parent().hasClass('active')) {
					breath.parent().removeClass('active');
				}

                stress.css({'width': (event.data.stress) + '%'});

                break;
            case 'updateGps':
                var vehicleInfo = $('.vehicle-info');

                if (event.data.hide) {
                    vehicleInfo.hide()
                } else {
                    if (event.data.show) {
                        vehicleInfo.show()
                    }

                    var street = $('.street'), others = $('.others'), time = $('.time');

                    time.text(event.data.time)

                    if (hasBelt) {
                        others.html(event.data.speed + '&nbsp;&nbsp;<font size="1">km/h</font>&nbsp;&nbsp;&nbsp;&nbsp;' + event.data.fuel + '&nbsp;&nbsp;<font size="1">Gasolina</font>&nbsp;&nbsp;&nbsp;&nbsp;' + '<font size="3" color="green">CINTO</font>')
                    } else {
                        others.html(event.data.speed + '&nbsp;&nbsp;<font size="1">km/h</font>&nbsp;&nbsp;&nbsp;&nbsp;' + event.data.fuel + '&nbsp;&nbsp;<font size="1">Gasolina</font>&nbsp;&nbsp;&nbsp;&nbsp;' + '<font size="3" color="red">CINTO</font>')
                    }

                    street.text(event.data.locationName)
                }

                break;
			case 'updateStatus':
				var hunger = $('.sub-hunger'), thirst = $('.sub-thirst'), stress = $('.sub-stress');

				hunger.css({'width': (event.data.hunger) + '%'});
                thirst.css({'width': (event.data.thirst) + '%'});
                stress.css({'width': (event.data.stress) + '%'});

				break;
			default:
				break;
		}
	});
});