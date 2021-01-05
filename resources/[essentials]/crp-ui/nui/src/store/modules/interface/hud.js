const state = () => ({
	hideState: true, top: 0, left: 0, width: 0, height: 0,
	health: 0, armour: 0, hunger: 0, thirst: 0, breath: 0, stress: 0,
	isOnVehicle: false, isCompassOn: false, time: '00:00', fuel: 0, speed: 0, hasSeatbelt: false,
	zoneName: '', streetName: '', direction: 0, isSpeedLimiterOn: false
})

const getters = {
	getHudData: state => {
		return state;
	}
}

const actions = {
	setMinimap(state, data) {
		state.commit('setMinimap', data);
	},
	setHudHideState(state, data) {
		state.commit('setHudHideState', data);
	},
	setData(state, data) {
		state.commit('setData', data);
	}
}

const mutations = {
	setMinimap(state, data) {
        const width = window.innerWidth, height = window.innerHeight;

        state.top = (data.y * height), state.left = (data.x * width);
        state.width = (0.18888 * height * 1.41), state.height = (0.18888 * height);
	},
	setHudHideState(state, data) {
		state.hideState = data;
	},
	setData(state, data) {
		for (var name in data) {
			state[name] = data[name];
		}
	}
}

export default { namespaced: true, getters, state, actions, mutations }