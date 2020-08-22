var moment = require('moment');

moment.locale('pt');

export const convertTime = (time) => {
	return moment.unix(time).fromNow();
}

export const processMessage = (message) => {
	const matches = message.match(/https:\/\/\S*?(\.png|\.gif|\.jpg|\.jpeg|\.webp)(.*?\s|.*)/g);
	const imgs = matches ? matches.map(element => element.trim()) : [];

	let msg = message

	imgs.forEach(element => msg = msg.replace(element, ''));

	return { message: msg, imgs}
}