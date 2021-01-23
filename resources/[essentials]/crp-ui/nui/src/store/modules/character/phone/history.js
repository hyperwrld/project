import store from './../../../index.js';

const state = () => ({
	history: []
})

const getters = {
	getHistory: (state) => {
		const contacts = store.getters['contacts/getContacts'];

		for (let i = 0; i < state.history.length; i++) {
			let contact = contacts.find(element => element.number === state.history[i].number)

			state.history[i].name = contact ? contact.name : state.history[i].number;
		}

        return state.history;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
	}
}

const mutations = {
	setData(state, data) {
		state.history = data;
	}
}

export default { namespaced: true, getters, state, actions, mutations }