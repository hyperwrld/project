var moment = require('moment');

moment.locale('pt');

export const convertTime = (time) => {
	return moment.unix(time).fromNow();
}

export const processMessage = (message) => {
	const matches = message.match(/https:\/\/\S*?(\.png|\.gif|\.jpg|\.jpeg|\.webp)(.*?\s|.*)/g);
	let imgs = matches ? matches.map(element => element.trim()) : [], msg = message;

	imgs.forEach(element => msg = msg.replace(element, ''));
	imgs = imgs.filter(element => doesImageExist(element) !== false);

	return { message: msg, imgs };
}

export const doesImageExist = (imageUrl) => {
	var image = new Image();

	image.src = imageUrl;

    if (image.width == 0) {
       	return false;
    } else {
       	return true;
    }
};