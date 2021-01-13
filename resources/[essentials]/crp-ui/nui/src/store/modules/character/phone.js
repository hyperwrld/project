const state = () => ({
	currentNumber: undefined, history: [], conversations: [], contacts: [], tweets: [], adverts: []
})

const getters = {
	getHistory: state => {
		for (let i = 0; i < state.history.length; i++) {
			let contact = state.contacts.find(element => element.number === state.history[i].number)

			state.history[i].name = contact ? contact.name : state.history[i].number;
		}

        return state.history;
	}
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