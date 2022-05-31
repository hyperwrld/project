const state = () => ({
	contacts: [{ name: 'Tiago Guerreiro', number: 3333434 }],
});

const getters = {
	getData: (state) => {
		return state.contacts.sort((a, b) => a.name.localeCompare(b.name));
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
};

const mutations = {
	setData(state, data) {
		state.contacts = data;
	},
};

export default { namespaced: true, getters, state, actions, mutations };
