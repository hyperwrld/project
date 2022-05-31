import { send } from '../../../utils/lib';

const state = () => ({
	state: false,
	message: '',
	progress: 0,
	interval: null,
});

const getters = {
	getTaskbarData: (state) => {
		return state;
	},
};

const actions = {
	setTaskbar(state, data) {
		state.commit('setTaskbar', data);
	},
	stopTaskbar(state, data) {
		state.commit('stopTaskbar', data);
	},
};

const mutations = {
	setTaskbar(state, data) {
		if (state.state) {
			return;
		}

		(state.state = true), (state.progress = 0), (state.message = data.message);

		state.interval = setInterval(() => {
			state.progress++;

			if (state.progress == 100) {
				clearInterval(state.interval);

				state.state = false;

				send('finishedTask');
			}
		}, (data.time * 1000) / 100);
	},
	stopTaskbar(state) {
		clearInterval(state.interval);

		state.state = false;

		send('canceledTask', state.progress);
	},
};

export default { namespaced: true, getters, state, actions, mutations };
