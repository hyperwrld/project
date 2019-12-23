var timer = null;

$('document').ready(function () {
    window.addEventListener('message', function (event) {
        switch (event.data.action) {
            case 'start':
                CreateProgress(event.data);
                break;
            case 'cancel':
                CancelProgress();
                break;
        }
    });
});

function CreateProgress(data) {
    clearTimeout(timer);

    $('#progress-text').text(data.label);

    $('#progress-container').fadeIn('slow', function () {
        $('#progress-div').stop().css({ 'width': 0, 'background-color': '#f63a0f' }).animate({
            width: '100%'
        }, {
            duration: parseInt(data.duration),
            progress: function (animation, progress, remaining) {
                if (progress > 0.05 && progress <= 0.25) {
                    $('#progress-div').css({ transition: 'background-color 0.5s ease-in-out', 'background-color': '#f27011' });
                } else if (progress > 0.25 && progress <= 0.50) {
                    $('#progress-div').css({ transition: 'background-color 0.5s ease-in-out', 'background-color': '#f2b01e' });
                } else if (progress > 0.50 && progress <= 0.75) {
                    $('#progress-div').css({ transition: 'background-color 0.5s ease-in-out', 'background-color': '#e6e600' });
                } else if (progress > 0.75) {
                    $('#progress-div').css({ transition: 'background-color 0.5s ease-in-out', 'background-color': '#009933' });
                }
            },
            complete: function () {
                $('#progress-container').fadeOut('fast', function () {
                    $('#progress-div').removeClass('cancellable');
                    $('#progress-div').css('width', 0);

                    $.post('http://crp-progressbar/finish');
                });
            }
        });
    });
};

function CancelProgress() {
    $('#progress-text').text('Ação cancelada');

    $('#progress-div').stop().css({ 'width': '100%', 'background-color': '#f63a0f' });
    $('#progress-div').removeClass('cancellable');

    timer = setTimeout(function () {
        $('#progress-container').fadeOut('slow', function () {
            $('#progress-div').css('width', 0);

            $.post('http://crp-progressbar/cancel');
        });
    }, 100);
}