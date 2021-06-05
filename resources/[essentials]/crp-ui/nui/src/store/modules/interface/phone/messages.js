import store from './../../../index.js';

const state = () => ({
	lastMessages: [{}, {}],
	messages: [],
});

const getters = {
	getData: (state) => {
		const currentNumber = store.getters['phone/getNumber'],
			contacts = store.getters['contacts/getData'];

		let messages = [];

		for (let i = 0; i < state.lastMessages.length; i++) {
			let number =
				currentNumber != state.lastMessages[i].sender
					? state.lastMessages[i].sender
					: state.lastMessages[i].receiver;
			let contact = contacts.find((element) => element.number === number);

			messages[i] = {
				number: number,
				name: contact ? contact.name : number,
				message: state.lastMessages[i].message,
				time: state.lastMessages[i].time,
			};
		}

		return messages;
	},
	getMessages: (state) => {
		return state.messages;
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
	setMessages(state, data) {
		state.commit('setMessages', data);
	},
	setMessage(state, data) {
		state.commit('setMessage', data);
	},
};

const mutations = {
	setData(state, data) {
		state.lastMessages = data;
	},
	setMessages(state, data) {
		state.messages = data;
	},
	setMessage(state, data) {
		let messageIndex = state.lastMessages.findIndex(
			(element) =>
				element.receiver == data.receiver || element.sender == data.receiver
		);

		messageIndex == -1
			? state.lastMessages.push(data)
			: state.lastMessages.splice(messageIndex, 1, data);

		state.messages.push(data);
	},
};

export default { namespaced: true, getters, state, actions, mutations };
