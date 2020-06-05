export default {
    async send(data = {}) {
        return await fetch('http://crp-garage/nuiMessage', {
            method: 'post',
            headers: {
                'Content-type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(data),
        }).then(response => response.json())
            .then(function (data) {
                return data
            });
    },
    emulate(type, data = null) {
        window.dispatchEvent(
            new MessageEvent('message', {
                data: {
                    type,
                    data,
                },
            }),
        );
    },
};
