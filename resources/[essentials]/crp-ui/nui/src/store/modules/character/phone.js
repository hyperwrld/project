const state = () => ({
	currentNumber: undefined, history: [], conversations: [], contacts: [], tweets: [], adverts: []
})

const getters = {

}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
	setData(state, data) {

    }
}

export default { namespaced: true, getters, state, actions, mutations }