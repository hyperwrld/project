var moment = require('moment');

moment.locale('pt');

export const convertTime = (time) => {
	return moment.unix(time).fromNow();
};

export const processMessage = (message) => {
	const matches = message.match(
		/https:\/\/\S*?(\.png|\.gif|\.jpg|\.jpeg|\.webp)(.*?\s|.*)/g
	);
	let imgs = matches ? matches.map((element) => element.trim()) : [],
		msg = message;

	imgs.forEach((element) => (msg = msg.replace(element, '')));
	imgs = imgs.filter((element) => doesImageExist(element) !== false);

	return { message: msg, imgs };
};

export const doesImageExist = (imageUrl) => {
	var http = new XMLHttpRequest();

	http.open('HEAD', imageUrl, false);
	http.send();

	return http.status != 404;
};

export const send = async (event, data = {}) => {
	return await fetch(`https://crp-ui/${event}`, {
		method: 'post',
		headers: {
			'Content-type': 'application/json; charset=UTF-8',
		},
		body: JSON.stringify(data),
	}).then((response) => response.json());
};

export const fragment = {
	functional: true,
	render: (h, ctx) => ctx.children,
};
