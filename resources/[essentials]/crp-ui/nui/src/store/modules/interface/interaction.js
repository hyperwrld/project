const state = () => ({
	status: false, message: ''
})

const getters = {
	getInteractionData: state => {
		return state;
	}
}

const actions = {
	setInteractionData(state, data) {
		state.commit('setInteractionData', data);
	}
}

const mutations = {
	setInteractionData(state, data) {
		state.status = data.status, state.message = data.message;
	}
}

export default { namespaced: true, getters, state, actions, mutations }