var defaultHTML;

$(function() {
	defaultHTML = $('.spawn-container').clone();

    window.addEventListener('message', function(event) {
    	if (event.data.opensection == 'main') {
			createDefaultPage()

			$('.spawn-container').css({'display':'block'});
    	} else if (event.data.opensection == 'enterspawn') {
    		createButton(event.data.textmessage, event.data.tableid)
    	} else if (event.data.opensection == 'close') {
    		$('.spawn-container').replaceWith(defaultHTML.clone());
			$('.spawn-container').css({'display':'none'});
    	}
    });
});

function createButton(text, id) {
	var button = document.createElement('button');

	button.className = 'btn-loc btn-block';
	button.innerHTML = text;

	var div = document.getElementsByClassName('spawn-container')[0];

	div.appendChild(button);

	button.addEventListener('click', function() {
  		$.post('http://crp-apartments/nuiMessage', JSON.stringify({ selectedspawn : true, selectionid : id })); 
	});
}

function createDefaultPage() {
    $('.spawn-container').replaceWith(defaultHTML.clone());

	var spawnButton = document.getElementsByClassName('btn-spawn')[0];

	spawnButton.addEventListener('click', function() {
		$.post('http://crp-apartments/nuiMessage', JSON.stringify({ confirmspawn : true })); 
	});
}