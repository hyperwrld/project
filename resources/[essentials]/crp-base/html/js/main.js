$(function() {
    let moneyIcon = '€';

    window.addEventListener('message', function(event) {
        if (event.data.state == 'add') {
        	$('.tiny').remove();

			var element = $("<div class='tiny'>+<font style='color: rgb(0, 125, 0); font-weight: 700; margin-right: 6px;'>" + moneyIcon + '</font>' + addCommas(event.data.money) + '</div>');

			$('#money').append(element);

			setTimeout(function () {
				$(element).fadeOut(600, function () { $(this).remove(); });
			}, 1000);
        } else if (event.data.state == 'remove') {
        	$('.tiny').remove();

			var element = $("<div class='tiny'>-<font style='color: rgb(250, 0, 0); font-weight: 700; margin-right: 6px;'>" + moneyIcon + '</font>' + addCommas(event.data.money) + '</div>');

			$('#money').append(element);

			setTimeout(function () {
				$(element).fadeOut(600, function () { $(this).remove(); });
			}, 1000)
        } else if (event.data.state == 'activate') {
			document.getElementById('cash').innerHTML = "<div><font style='color: rgb(0, 125, 0); font-weight: 700; margin-right: 6px;'>" + moneyIcon + '</font>' + addCommas(event.data.money);
        }
    });
});

const cType = 1;

function addCommas(string) {
    string += '';
    let x = string.split('.');
    let x1 = x[0];
    let x2 = x.length > 1 ? '.' + x[1] : '';
    let rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        if (!cType || cType === 1)
            x1 = x1.replace(rgx, '$1' + '<span style="margin-left: 3px; margin-right: 3px;"/>' + '$2');
        if (cType === 2)
            x1 = x1.replace(rgx, '$1' + ',' + '$2');
        else
            x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}