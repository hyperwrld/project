$(function () {
    window.addEventListener('message', function (event) {
        switch (event.data.event) {
            case 'open':
                $('#waiting').show();
                $('body').addClass('active');

                if (event.data.type) {
                    $('#deposit').show();

                    $('#deposit2').hide();
                } else {
                    $('#deposit').hide();

                    $('#deposit2').show();
                }

                break;
            case 'updateInfo':
                $('.curbalance').html(event.data.balance);

                $('.username').html(event.data.name);

                break;
            case 'close':
                $('#waiting, #general, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
                $('body').removeClass('active');

                break;
            default: break;
        }
    });
});

$('.btn-sign-out').click(function () {
    $('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').hide();

    console.log('teste')

    $('body').removeClass('active');

    $.post('http://crp-banking/nuiMessage', JSON.stringify({ close: true }));
})

$('.back').click(function () {
    $('#depositUI, #withdrawUI, #transferUI').hide();

    $('#general').show();
})

$('#deposit').click(function () {
    $('#general').hide();

    $('#depositUI').show();
})

$('#withdraw').click(function () {
    $('#general').hide();

    $('#withdrawUI').show();
})

$('#transfer').click(function () {
    $('#general').hide();

    $('#transferUI').show();
})

$('#fingerprint-content').click(function () {
    $('.fingerprint-active, .fingerprint-bar').addClass('active')

    setTimeout(function () {
        $('#general').css('display', 'block')
        $('#topbar').css('display', 'flex')
        $('#waiting').css('display', 'none')

        $('.fingerprint-active, .fingerprint-bar').removeClass('active')
    }, 1400);
})

$('#deposit1').submit(function (event) {
    event.preventDefault();

    $.post('http://crp-banking/nuiMessage', JSON.stringify({ deposit: true, amount: $('#amount').val() }));

    $('#depositUI').hide();
    $('#general').show();
    $('#amount').val('');
});

$('#transfer1').submit(function (event) {
    event.preventDefault();

    $.post('http://crp-banking/nuiMessage', JSON.stringify({ transfer: true, target: $('#to').val(), amount: $('#amountt').val() }));

    $('#transferUI').hide();
    $('#general').show();
    $('#amountt').val('');
});

$('#withdraw1').submit(function (event) {
    event.preventDefault();

    $.post('http://crp-banking/nuiMessage', JSON.stringify({ withdraw: true, amount: $('#amountw').val() }));

    $('#withdrawUI').hide();
    $('#general').show();
    $('#amountw').val('');
});

document.onkeyup = function (data) {
    if (data.which == 27) {
        $('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
        $('body').removeClass('active');

        $.post('http://crp-banking/nuiMessage', JSON.stringify({ close: true }));
    }
}