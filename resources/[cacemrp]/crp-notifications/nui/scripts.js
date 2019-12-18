var notifications = {};

$(function () {
    window.addEventListener('message', function (event) {
        switch (event.data.event) {
            case 'alert':
                let notification = CreateNotification(event.data);

                $('.container').append(notification);

                setTimeout(function () {
                    $.when(notification.fadeOut()).done(function () {
                        notification.remove()
                    });
                }, event.data.length != null ? event.data.length : 2500);

                break;
            case 'customAlert':
                if (notifications[event.data.id] === undefined) {
                    let notification = CreateNotification(event.data);

                    $('.container').append(notification);

                    notifications[event.data.id] = {
                        notification: notification,
                        timer: setTimeout(function () {
                            let notification = notifications[event.data.id].notification;

                            $.when(notification.fadeOut()).done(function () {
                                notification.remove();

                                clearTimeout(notifications[event.data.id].timer);

                                delete notifications[event.data.id];
                            });
                        }, event.data.length != null ? event.data.length : 2500)
                    };
                } else {
                    clearTimeout(notifications[event.data.id].timer);

                    UpdateNotification(event.data);

                    notifications[event.data.id].timer = setTimeout(function () {
                        let notification = notifications[event.data.id].notification;

                        $.when(notification.fadeOut()).done(function () {
                            notification.remove();

                            clearTimeout(notifications[event.data.id].timer);

                            delete notifications[event.data.id];
                        });
                    }, event.data.length != null ? event.data.length : 2500)
                }

                break;
            case 'persistantAlert':
                if (event.data.action == 'start') {
                    if (notifications[event.data.id] === undefined) {
                        let notification = CreateNotification(event.data);

                        $('.container').append(notification);

                        notifications[event.data.id] = {
                            notification: notification
                        };
                    } else UpdateNotification(event.data);
                } else if (event.data.action == 'end') {
                    if (notifications[event.data.id] != null) {
                        let notification = $(notifications[event.data.id].notification);

                        $.when(notification.fadeOut()).done(function () {
                            notification.remove();

                            delete notifications[event.data.id];
                        });
                    }
                }

                break;
            default:
                break;
        }
    });
});

function CreateNotification(data) {
    let notification = $(document.createElement('div'));

    notification.addClass('notification').addClass(data.type);
    notification.html(data.text);
    notification.fadeIn();

    return notification;
}

function UpdateNotification(data) {
    let notification = $(notifications[data.id]);

    notification.addClass('notification').addClass(data.type);
    notification.html(data.text);
}