import store from './../../index.js';

const state = () => ({
	currentNumber: undefined
})

const getters = {
	getNumber: state => {
		return state.currentNumber;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
	}
}

const mutations = {
	setData(state, data) {
		if (data) {
			state.currentNumber = data.currentNumber;

			for (var name in data) {
				if (name == 'currentNumber') continue;

				store.dispatch(name + '/setData', data[name]);
			}
		}
	}
}

export default { namespaced: true, getters, state, actions, mutations }