import store from './../../../index.js';

const state = () => ({
	history: [
		{
			name: 'Tiago Guerreiro',
			state: true,
			number: 967301022,
			time: 1620941446,
		},
		{
			name: 'Joao Guerreiro',
			state: false,
			number: 967301022,
			time: 1620941000,
		},
	],
});

const getters = {
	getData: (state) => {
		const contacts = store.getters['contacts/getData'];

		for (let i = 0; i < state.history.length; i++) {
			let contact = contacts.find(
				(element) => element.number === state.history[i].number
			);

			state.history[i].name = contact ? contact.name : state.history[i].number;
		}

		return state.history;
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
};

const mutations = {
	setData(state, data) {
		state.history = data;
	},
};

export default { namespaced: true, getters, state, actions, mutations };
