const state = () => ({
	list: [], group: {}
})

const getters = {
	getJobList: state => {
		return state.list;
	},
	getJobGroup: state => {
		return state.group;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
	}
}

const mutations = {
	setData(state, data) {
		state.list = data;
	}
}

export default { namespaced: true, getters, state, actions, mutations }