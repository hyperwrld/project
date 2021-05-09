const state = () => ({
	adverts: [],
});

const getters = {
	getAdverts: (state) => {
		return state.adverts.sort((a, b) => b.id - a.id);
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
};

const mutations = {
	setData(state, data) {
		state.adverts = data;
	},
};

export default { namespaced: true, getters, state, actions, mutations };
