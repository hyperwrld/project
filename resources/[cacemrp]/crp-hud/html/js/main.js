$(function() {
	var mapHeight = 0.18888, mapWidthRatio = 1.41;

	window.addEventListener('message', function(event) {
		switch(event.data.eventName) {
			case 'hudPosition':
				var width = $(window).width(), height = $(window).height();
				var x = event.data.topX, y = event.data.topY;
				var div = $('.minimap');

				div.css({
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