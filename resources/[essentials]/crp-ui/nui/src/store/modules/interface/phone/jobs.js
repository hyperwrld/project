const state = () => ({
	list: [],
	group: {
		members: [
			{ name: 'Tiago Guerreiro', isLeader: true },
			{ name: 'Andre Esteves', isReady: true },
			{ name: 'Joao Carvalho', isLeader: false },
			{ name: 'Luis Severino', isReady: true },
		],
	},
});

const getters = {
	getJobList: (state) => {
		return state.list;
	},
	getJobGroup: (state) => {
		return state.group;
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
	setGroupData(state, data) {
		state.commit('setGroupData', data);
	},
};

const mutations = {
	setData(state, data) {
		state.list = data;
	},
	setGroupData(state, data) {
		state.group = data;
	},
};

export default { namespaced: true, getters, state, actions, mutations };
