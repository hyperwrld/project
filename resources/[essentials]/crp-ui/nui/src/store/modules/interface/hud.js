const state = () => ({
	top: 0, left: 0, width: 0, height: 0,
	characterData: {
		health: ['heart', 0], armour: ['shield-alt', 0], hunger: ['hamburger', 0],
		thirst: ['tint', 0], breath: ['lungs', 0], stress: ['brain', 0]
	},
	isOnVehicle: false, isCompassOn: false, time: '00:00', fuel: 0,
	speed: 0, hasSeatBelt: false, location: '', direction: 0
})

const getters = {
	getHudData: state => {
		return state;
	}
}

const actions = {
	setMinimapData(state, data) {
		state.commit('setMinimapData', data);
	},
	setCharacterData(state, data) {
		state.commit('setCharacterData', data);
	},
	setHudData(state, data) {
		state.commit('setHudData', data);
	},
	setVehicleHudData(state, data) {
        state.commit('setVehicleHudData', data);
    }
}

const mutations = {
	setMinimapData(state, data) {
        const width = window.innerWidth, height = window.innerHeight;

        state.top = (data.y * height), state.left = (data.x * width);
        state.width = (0.18888 * height * 1.41), state.height = (0.18888 * height);
	},
	setCharacterHudData(state, data) {
        for (var name in data) {
			state.characterData[name][1] = data[name];
        }
	},
	setHudData(state, data) {
		state[data.name] = data.value;
	},
	setVehicleHudData(state, data) {
        for (var name in data) {
            state.vehicleData[name] = data[name];
        }
    }
}

export default { namespaced: true, getters, state, actions, mutations }