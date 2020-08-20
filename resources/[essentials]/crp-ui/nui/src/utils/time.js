var moment = require('moment');

moment.locale('pt');

function convertTime(time) {
	return moment.unix(time).fromNow();
}

export { convertTime };