const state = () => ({
	canShow: false, currentMoney: 0, transactionStatus: false,
	transactionType: 'add', transactionQuantity: 0
})

const getters = {
	getCurrencyData: state => {
		return state;
	}
}

const actions = {
	setCurrencyHudStatus(state, data) {
		state.commit('setCurrencyHudStatus', data);
	},
	setCurrentMoney(state, data) {
		state.commit('setCurrentMoney', data);
	},
	addMoney(state, data) {
		state.commit('addMoney', data);
	},
	removeMoney(state, data) {
		state.commit('removeMoney', data);
	}
}

const mutations = {
	setCurrencyHudStatus(state, data) {
		state.canShow = data.time ? true : data;

        if (data.time) {
            setTimeout(() => { state.canShow = false }, data.time);
        }
	},
	setCurrentMoney(state, data) {
		state.currentMoney = data, state.canShow = true;

        setTimeout(() => { state.canShow = false }, 15000);
	},
	addMoney(state, data) {
		state.currentMoney = (state.currentMoney + data), state.canShow = true;
		state.transactionStatus = true, state.transactionType = 'add', transactionQuantity = data;

		setTimeout(() => {
			state.transactionStatus = false;

			setTimeout(() => {
				state.canShow = false;
			}, 1000);
		}, 5000);
	},
	removeMoney(state, data) {
		state.currentMoney = (state.currentMoney - data), state.canShow = true;
		state.transactionStatus = true, state.transactionType = 'remove', transactionQuantity = data;

		setTimeout(() => {
			state.transactionStatus = false;

			setTimeout(() => {
				state.canShow = false;
			}, 1000);
		}, 5000);
	}
}

export default { namespaced: true, getters, state, actions, mutations }