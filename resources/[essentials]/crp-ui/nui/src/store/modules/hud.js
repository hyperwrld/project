const state = () => ({
    isEnabled: true,
    characterData: {
        'health': '0%', 'armour': '0%',
        'hunger': { value: '0%', leftOver: '100%' }, 'thirst': { value: '0%', leftOver: '100%' }, 'breath': { value: '0%', leftOver: '100%' }, 'stress': { value: '0%', leftOver: '100%' },
    },
    isOnVehicle: false,
})

const actions = {
    setCharacterData(state, data) {
        state.commit('setCharacterData', data);
    }
}

const mutations = {
    setCharacterData(state, data) {
        for (var name in data) {
            if (name != 'health' && name != 'armour') {
                state.characterData[name] = { value: data[name] + '%', leftOver: (100 - data[name]) + '%' };
            } else {
                state.characterData[name] = data[name] + '%';
            }
        }
    }
}

export default { namespaced: true, state, actions, mutations }