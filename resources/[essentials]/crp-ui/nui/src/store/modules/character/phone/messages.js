import store from './../../../index.js';

const state = () => ({
	messages: []
})

const getters = {
	getMessages: state => {
		const currentNumber = store.getters['phone/getNumber'], contacts = store.getters['contacts/getContacts'];

		let messages = [];

		for (let i = 0; i < state.messages.length; i++) {
			let number = currentNumber != state.messages[i].sender ? state.messages[i].sender : state.messages[i].receiver;
			let contact = contacts.find(element => element.number === number);

			messages[i] = {
				number: number, name: contact ? contact.name : number, message: state.messages[i].message, time: state.messages[i].time
			}
		}

		return messages;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
	},
	setMessage(state, data) {
		state.commit('setMessage', data);
	}
}

const mutations = {
	setData(state, data) {
		state.messages = data;
	},
	setMessage(state, data) {
		let message = state.messages.find(element => (element.receiver == data.receiver) || (element.sender == data.receiver));

		if (message) {
			message.sender = message.number, message.receiver = data.receiver, message.message = data.message;
		}
	}
}

export default { namespaced: true, getters, state, actions, mutations }