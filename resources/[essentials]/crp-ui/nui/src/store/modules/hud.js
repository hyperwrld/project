const state = () => ({
    isEnabled: true,
    minimapData: { top: '0px', left: '0px', width: '0px', height: '0px' },
    characterData: {
        'health': '0%', 'armour': '0%',
        'hunger': { value: '0%', leftOver: '100%' }, 'thirst': { value: '0%', leftOver: '100%' }, 'breath': { value: '0%', leftOver: '100%' }, 'stress': { value: '0%', leftOver: '100%' },
    },
    isOnVehicle: false,
    vehicleData: { time: '00:00', fuel: 0, speed: 0, hasSeatBelt: false, location: '', direction: 0 }
})

const actions = {
    setMinimapData(state, data) {
        state.commit('setMinimapData', data);
    },
    setCharacterData(state, data) {
        state.commit('setCharacterData', data);
    },
    setVehicleData(state, data) {
        state.commit('setVehicleData', data);
    },
    setCompassDirection(state, data) {
        state.commit('setCompassDirection', data);
    }
}

const mutations = {
    setMinimapData(state, data) {
        const width = window.innerWidth, height = window.innerHeight;

        state.minimapData.top = (data.y * height) + 'px', state.minimapData.left = (data.x * width) + 'px';
        state.minimapData.width = (0.18888 * height * 1.41) + 'px', state.minimapData.height = (0.18888 * height) + 'px';
    },
    setCharacterData(state, data) {
        for (var name in data) {
            if (name != 'health' && name != 'armour') {
                state.characterData[name] = { value: data[name] + '%', leftOver: (100 - data[name]) + '%' };
            } else {
                state.characterData[name] = data[name] + '%';
            }
        }
    },
    setVehicleData(state, data) {
        for (var name in data) {
            state.vehicleData[name] = data[name];
        }
    },
    setCompassDirection(state, data) {
        state.vehicleData.direction = data;
    }
}

export default { namespaced: true, state, actions, mutations }