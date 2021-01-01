const state = () => ({
	status: false, firstMessage: '', secondMessage: ''
})

const getters = {
	getInteractionsData: state => {
		return state;
	}
}

const actions = {
	setInteractionsData(state, data) {
		state.commit('setInteractionsData', data);
	}
}

const mutations = {
	setInteractionsData(state, data) {
		state.status = data.status;

		if (data.status) {
			state.firstMessage = data.firstMessage;

			if (data.secondMessage) {
				state.secondMessage = data.secondMessage;
			}
		}

	}
}

export default { namespaced: true, getters, state, actions, mutations }