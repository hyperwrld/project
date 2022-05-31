const state = () => ({
	userCharacters: [],
});

const getters = {
	getCharactersData: (state) => {
		return state.userCharacters;
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
};

const mutations = {
	setData(state, data) {
		state.userCharacters = data;

		for (var i = state.userCharacters.length; i < 5; i++) {
			state.userCharacters.push({});
		}
	},
};

export default { namespaced: true, getters, state, actions, mutations };
