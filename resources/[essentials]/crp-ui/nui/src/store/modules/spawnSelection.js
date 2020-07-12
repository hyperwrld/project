import nui from '../../utils/nui';

const state = () => ({
    currentSelection: 0,
    spawnPoints: []
})

const actions = {
    setSpawnSelection(state, data) {
        state.commit('setSpawnSelection', data);
    },
    changeSelection(state, index) {
        state.commit('changeSelection', index);
    },
    confirmSpawn(state) {
        state.commit('confirmSpawn');
    },
}

const mutations = {
    setSpawnSelection(state, data) {
        state.spawnPoints = Object.values(data), state.currentSelection = 0;
    },
    changeSelection(state, index) {
        state.currentSelection = index;

        nui.send('changeSelection', index + 1);
    },
    confirmSpawn(state) {
        this.commit('app/setAppData', { status: false });

        nui.send('confirmSpawn');
    }
}

export default { namespaced: true, state, actions, mutations }