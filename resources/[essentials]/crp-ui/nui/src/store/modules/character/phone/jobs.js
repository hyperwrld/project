const state = () => ({
	list: [], group: {}
})

const getters = {
	getJobList: state => {
		if (state.list.length > 0) {
			return state.list.filter(element => (element.maxGrade == 0 && element.identifier != 'unemployed'));
		}

		return state.list;
	},
	getJobGroup: state => {
		return state.group;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
	},
	setGroupData(state, data) {
		state.commit('setGroupData', data);
	}
}

const mutations = {
	setData(state, data) {
		state.list = data;
	},
	setGroupData(state, data) {
		state.group = data;
	}
}

export default { namespaced: true, getters, state, actions, mutations }