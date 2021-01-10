const state = () => ({
	items: []
})

const getters = {
	getItems: state => {
		return state.items;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
	setData(state, data) {
		for (let i = 0; i < 4; i++) {
			let slot = data[i] ? { itemId: data[i].name, quantity: data[i].count, durability: data[i].creation_time } : {};

			state.items[i] = slot;
		}
    }
}

export default { namespaced: true, getters, state, actions, mutations }