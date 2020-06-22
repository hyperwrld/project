const state = () => ({
    isEnabled: true,
    characterData: {
        'health': '100%', 'armour': '100%',
        'hunger': { value: '100%', leftOver: '0%' }, 'thirst': { value: '100%', leftOver: '0%' }, 'breath': { value: '100%', leftOver: '0%' }, 'stress': { value: '100%', leftOver: '0%' },
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