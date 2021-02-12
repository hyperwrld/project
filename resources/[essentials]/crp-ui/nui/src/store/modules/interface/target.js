const state = () => ({
	hideState: true, activeState: false, options: [{label: 'Abrir o ATM'}, { label: 'Entrar de servico' }]
})

const getters = {
	getData: state => {
		return state;
	}
}

const actions = {
	setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
    setData(state, data) {
        state.hideState = data.state;
    }
}

export default { namespaced: true, getters, state, actions, mutations }