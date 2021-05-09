import store from './../../index.js';

const state = () => ({
	compactMode: true,
	currentNumber: undefined,
});

const getters = {
	getNumber: (state) => {
		return state.currentNumber;
	},
	getCompactMode: (state) => {
		return state.compactMode;
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
};

const mutations = {
	setData(state, data) {
		if (data) {
			(state.currentNumber = data.currentNumber),
				(state.compactMode = data.compactMode);

			for (var name in data) {
				if (name == 'currentNumber' || name == 'compactMode') continue;

				store.dispatch(name + '/setData', data[name]);
			}
		}
	},
};

export default { namespaced: true, getters, state, actions, mutations };
