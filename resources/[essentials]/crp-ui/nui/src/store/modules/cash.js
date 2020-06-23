const state = () => ({
    canShow: false, currentMoney: 0, changedMoney: { status: false, type: 'remove', quantity: 0 }
})

const actions = {
    setMoneyStatus(state, data) {
        state.commit('setMoneyStatus', data);
    },
    setMoney(state, money) {
        state.commit('setMoney', money);
    },
    removeMoney(state, quantity) {
        state.commit('removeMoney', quantity);
    },
    addMoney(state, quantity) {
        state.commit('addMoney', quantity);
    }
}

const mutations = {
    setMoneyStatus(state, data) {
        state.canShow = data.status ? data.status : data;

        if (data.time) {
            setTimeout(() => { state.canShow = false }, data.time);
        }
    },
    setMoney(state, money) {
        state.currentMoney = money, state.canShow = true;

        setTimeout(() => { state.canShow = false }, 15000);
    },
    removeMoney(state, quantity) {
        state.changedMoney = { status: true, type: 'remove', quantity: quantity };
        state.currentMoney = (state.currentMoney - quantity), state.canShow = true;

        setTimeout(() => {
            state.changedMoney.status = false;

            setTimeout(() => { state.canShow = false }, 1000);
        }, 5000);
    },
    addMoney(state, quantity) {
        state.changedMoney = { status: true, type: 'add', quantity: quantity };
        state.currentMoney = (state.currentMoney + quantity), state.canShow = true;

        setTimeout(() => {
            state.changedMoney.status = false;

            setTimeout(() => { state.canShow = false }, 1000);
        }, 5000);
    }
}

export default { namespaced: true, state, actions, mutations }