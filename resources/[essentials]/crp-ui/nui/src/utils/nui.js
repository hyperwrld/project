export default {
    async send(event, data = {}) {
        return await fetch(`https://crp-ui/${event}`, {
            method: 'post',
            headers: {
              'Content-type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(data),
        }).then(response => response.json());
	}
};