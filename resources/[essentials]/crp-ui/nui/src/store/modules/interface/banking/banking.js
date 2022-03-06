import { development, production } from './data.js';

const state = process.env.NODE_ENV == 'development' ? development : production;

const getters = {
	getData: (state) => {
		return state;
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
	setWaitingState(state, data) {
		state.commit('setWaitingState', data);
	},
	addTransaction(state, data) {
		state.commit('addTransaction', data);
	},
};

const mutations = {
	setData(state, data) {
		for (var name in data) {
			state[name] = data[name];
		}
	},
	setWaitingState(state, data) {
		state['isWaiting'] = data;
	},
	addTransaction(state, data) {
		state['transactions'].push(data);

		switch (data.type) {
			case 1:
				state['money'] = state['money'] + data.money;
				break;
			case 2:
				state['money'] = state['money'] - data.money;
				break;
			default:
				break;
		}
	},
};

export default { namespaced: true, getters, state, actions, mutations };
