import nui from '../../utils/nui';

const state = () => ({
    isEnabled: false,
    currentComponent: 'character'
})

const actions = {
    setAppData(state, data) {
        state.commit('setAppData', data);
    }
}

const mutations = {
    setAppData(state, data) {
        if (data.component) {
            state.currentComponent = data.component;
        }

        state.isEnabled = data.status;

        if (!state.isEnabled) {
            nui.send('closeMenu');
        }
    }
}

export default { namespaced: true, state, actions, mutations }