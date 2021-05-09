const state = () => ({
	state: false,
	firstMessage: '',
	secondMessage: '',
});

const getters = {
	getInteractionsData: (state) => {
		return state;
	},
};

const actions = {
	setInteractionsData(state, data) {
		state.commit('setInteractionsData', data);
	},
};

const mutations = {
	setInteractionsData(state, data) {
		state.state = data.state;

		if (data.state) {
			(state.firstMessage = data.firstMessage),
				(state.secondMessage = data.secondMessage ? data.secondMessage : '');
		}
	},
};

export default { namespaced: true, getters, state, actions, mutations };
