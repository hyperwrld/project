var defaultHTML;
var isPlayerLoaded = false;
var isWaiting = false;
var LoadingMessages = new Array('Aguarde enquanto metemos carvão na máquina &#128642;', 'Aguarde enquanto estamos a carregar a torradeira &#128012;');


$(function () {
    defaultHTML = $('.main-container').clone();

    var cleaveDate = new Cleave('.input-date', {
        date: true,
        datePattern: ['d', 'm', 'Y'],
        dateMax: '2002-01-01',
        dateMin: '1920-01-01',
        delimiter: '/',
    });

    CreateCharacterButton();

    CreateSpawnButton();

    window.addEventListener('message', function (event) {
        if (event.data.open == true) {
            ShowHUD();
        } else if (event.data.reload == true) {
            isWaiting = false;

            $('.main-container').replaceWith(defaultHTML.clone());
            $('.main-container').css({ 'display': 'none' });
            $('.register-container').css({ 'display': 'none' });

            $('#form').trigger('reset');
            $('#register-form').scrollTop(0);

            $.post('http://crp-login/nuiMessage', JSON.stringify({ fetchcharacters: true, showcursor: true }));
        } else if (event.data.close == true) {
            $('.main-container').replaceWith(defaultHTML.clone());

            $('.main-container').css({ 'display': 'none' });
            $('.register-container').css({ 'display': 'none' });
            $('.spawn-container').css({ 'display': 'none' });

            $('#disconnect').css({ 'display': 'none' });
        } else if (event.data.error == true) {
            TriggerErrorNotification(event.data.message);
        } else if (event.data.playercharacters || event.data.playercharacters == undefined) {
            isWaiting = false;

            setTimeout(function () { showSelection(event.data); }, 5000);
        }
    });
});

function ShowHUD() {
    var disconnect = document.getElementById('disconnect');

    disconnect.setAttribute('style', 'display: block;');

    disconnect.addEventListener('click', function () {
        $.post('http://crp-login/nuiMessage', JSON.stringify({ disconnect: true }));
    }, false);

    $('.login-container').css({ 'display': 'block' });
    $('.load-txt').show();

    DesactivateLoading();

    document.onkeyup = function (data) {
        if (data.which == 13) { // ENTER
            $('.load-txt').hide();

            $('.login-container').css({ 'display': 'none' });

            ActivateLoading();

            $.post('http://crp-login/nuiMessage', JSON.stringify({ fetchcharacters: true, showcursor: true }));
            document.onkeyup = null;
        }
    };
}

function showSelection(data) {
    var id = 0;

    DesactivateLoading()

    $('.main-container').show();

    if (Array.isArray(data.playercharacters) && data.playercharacters.length) {
        $.each(data.playercharacters, function (index, char) {
            id = id + 1;

            var charactername = document.getElementById('charid-' + id).getElementsByClassName('character-n')[0];
            var characterinfo = document.getElementById('charid-' + id).getElementsByClassName('character-detail')[0];
            var playbutton = document.getElementById('charid-' + id).getElementsByClassName('btn-play btn-block')[0];
            var deletebutton = document.getElementById('charid-' + id).getElementsByClassName('btn-delete btn-block')[0];
            var createbutton = document.getElementById('charid-' + id).getElementsByClassName('btn-create btn-block')[0];

            createbutton.setAttribute('style', 'display: none;');

            charactername.textContent = char.firstname + ' ' + char.lastname;

            characterinfo.innerHTML = '</br><b>Sexo:</b></br>' + char.sex + '</br></br><b>Data de Nascimento:</b></br>' + char.dateofbirth + '</br></br><b>Profissão:</b></br>' + JSON.parse(char.job).label + '</br></br><b>Dinheiro:</b></br>' + char.money + ' €</br></br><b>Banco:</b></br>' + char.bank + ' €</br></br><b>História:</b></br>' + char.history;

            SetElementState(playbutton, deletebutton, 'block', 'display');

            playbutton.addEventListener('click', function () {
                console.log(char.id)
                $.post('http://crp-login/nuiMessage', JSON.stringify({ selectcharacter: true, character: char.id, showcursor: true }));
            }, false);

            deletebutton.addEventListener('click', function () {
                charactername.textContent = 'Deseja eliminar a personagem?';

                SetElementState(deletebutton, playbutton, 'none', 'display');

                ShowConfirmationButtons(deletebutton.parentNode.parentNode, char, data);
            }, false);

            if (data.playercharacters.length == id) {
                for (i = (id + 1); i < 7; i++) {
                    var createbutton = document.getElementById('charid-' + i).getElementsByClassName('btn-create btn-block')[0];

                    createbutton.setAttribute('style', 'display: block;');

                    createbutton.addEventListener('click', function () {
                        var characterContainer = document.getElementsByClassName('register-container')[0];

                        $('.main-container').css({ 'display': 'none' });

                        characterContainer.setAttribute('style', 'display: block;');
                    }, false);
                }
            }
        });
    } else {
        for (i = 1; i < 7; i++) {
            var createbutton = document.getElementById('charid-' + i).getElementsByClassName('btn-create btn-block')[0];

            createbutton.setAttribute('style', 'display: block;');

            createbutton.addEventListener('click', function () {
                var characterContainer = document.getElementsByClassName('register-container')[0];

                $('.main-container').css({ 'display': 'none' });

                characterContainer.setAttribute('style', 'display: block;');
            }, false);
        }
    }
}

function CreateCharacterButton() {
    $('#createchar').click(function (event) {
        event.preventDefault();

        if (isWaiting == false) {
            isWaiting = true;

            var history = $('#history').val();

            if (history.length < 100) {
                TriggerErrorNotification('A sua história tem menos de 100 caracteres.');
                return;
            } else if (history.length > 1000) {
                TriggerErrorNotification('A sua história tem mais de 1000 caracteres.');
                return;
            }

            $.post('http:/crp-login/nuiMessage', JSON.stringify({
                createcharacter: true,
                showcursor: true,
                chardata: {
                    firstname: $('#firstname').val(),
                    lastname: $('#lastname').val(),
                    dateofbirth: $('#dateofbirth').val(),
                    sex: $('#sex').val(),
                    history: history
                }
            }));
        }
    });

    $('#backcharlist').click(function (event) {
        event.preventDefault();

        if (isWaiting == false) {
            isWaiting = true;

            $('.main-container').replaceWith(defaultHTML.clone());
            $('.main-container').css({ 'display': 'none' });
            $('.register-container').css({ 'display': 'none' });

            $('#form').trigger('reset');
            $('#register-form').scrollTop(0);

            $.post('http://crp-login/nuiMessage', JSON.stringify({ fetchcharacters: true, showcursor: true }));
        }
    });
}

function CreateSpawnButton() {
    $('.btn-loc').click(function (event) {
        console.log($(this).attr('data-spawnid'))

        $.post('http:/crp-login/nuiMessage', JSON.stringify({
            selectedspawn: true,
            spawnid: $(this).attr('data-spawnid')
        }));
    });
}

function TriggerErrorNotification(message) {
    isWaiting = false;

    var notification = document.getElementById('notification');

    notification.setAttribute('style', 'display: block;');
    notification.innerHTML = message;

    setTimeout(function () {
        $('#notification').fadeOut(3000, 'swing');
    }, 5000)
}

function ShowConfirmationButtons(parent, char, data) {
    var parentID = parent.getAttribute('id');
    var yesbutton = document.getElementById(parentID).getElementsByClassName('btn-delyes btn-block')[0];
    var nobutton = document.getElementById(parentID).getElementsByClassName('btn-delno btn-block')[0];

    SetElementState(yesbutton, nobutton, 'block', 'display');

    yesbutton.addEventListener('click', function () {
        $.post('http://crp-login/nuiMessage', JSON.stringify({
            deletecharacter: char,
            showcursor: true,
        }));
    }, false);

    nobutton.addEventListener('click', function () {
        SetElementState(yesbutton, nobutton, 'none', 'display');

        showSelection(data);
    }, false);
}

function SetElementState(element1, element2, state, style) {
    element1.setAttribute('style', style + ': ' + state + ';');
    element2.setAttribute('style', style + ': ' + state + ';');
}

function ActivateLoading() {
    $('.loading').show();

    $('.loading-txt').html(LoadingMessages[Math.floor(Math.random() * LoadingMessages.length)]);
}

function DesactivateLoading() {
    $('.loading').hide();
}