var defaultHTML;

$(function() {
	defaultHTML = $('.spawn-container').clone();

    window.addEventListener('message', function(event) {
        switch(event.data.eventName) {
			case 'show':
                createSpawnSelection(event.data.spawnPoints)
				break;
			case 'hide':
                $('.spawn-container').css({'display':'none'});
                break;
			default:
                break;
        }
    });
});

function createSpawnSelection(data) {
    $('.spawn-container').replaceWith(defaultHTML.clone());

    var spawnButton = document.getElementsByClassName('btn-spawn')[0];

	spawnButton.addEventListener('click', function() {
		$.post('http://crp-apartments/nuiMessage', JSON.stringify({ confirmSpawn: true }));
    });

    for (var i = 0; i < data.length; i++) {
        var button = document.createElement('button');

        button.className = 'btn-loc btn-block';
	    button.innerHTML = data[i]['info'];

	    var div = document.getElementsByClassName('spawn-container')[0];

	    div.appendChild(button);

        RegisterButton(button, i);
    }

    $('.spawn-container').css({'display':'block'});
}

function RegisterButton(button, number) {
    button.addEventListener('click', function() {
        $.post('http://crp-apartments/nuiMessage', JSON.stringify({ selectedSpawn: true, selectionId: Number(number) }));
    });
}