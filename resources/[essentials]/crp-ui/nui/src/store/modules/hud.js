const state = () => ({
	isEnabled: true,
	moneyData: {
		canShow: false, currentMoney: 0, changedMoney: { status: false, type: 'add', quantity: 0 }
	},
    minimapData: {
		top: '0px', left: '0px', width: '0px', height: '0px', health: '0%', armour: '0%',
		hunger: '0%', thrist: '0%', breath: '0%', stress: '0%'
    },
    vehicleData: {
		isOnVehicle: false, isCompassOn: false, time: '00:00', fuel: 0,
		speed: 0, hasSeatBelt: false, location: '', direction: 0
    }
})

const getters = {
	moneyData: state => {
		return state.moneyData;
	},
	minimapData: state => {
		return state.minimapData;
	},
	vehicleData: state => {
		return state.vehicleData;
	}
}

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
	},
	setMinimapData(state, data) {
        state.commit('setMinimapData', data);
    },
    setCharacterData(state, data) {
        state.commit('setCharacterData', data);
    },
    setVehicleStatus(state, status) {
        state.commit('setVehicleStatus', status);
    },
    setCompassStatus(state, status) {
        state.commit('setCompassStatus', status);
    },
    setVehicleData(state, data) {
        state.commit('setVehicleData', data);
    },
    setCompassDirection(state, data) {
        state.commit('setCompassDirection', data);
    }
}

const mutations = {
	setMoneyStatus(state, data) {
        state.moneyData.canShow = data.status ? data.status : data;

        if (data.time) {
            setTimeout(() => { state.moneyData.canShow = false }, data.time);
        }
    },
    setMoney(state, money) {
        state.moneyData.currentMoney = money, state.moneyData.canShow = true;

        setTimeout(() => { state.moneyData.canShow = false }, 15000);
    },
    removeMoney(state, quantity) {
        state.moneyData.changedMoney = { status: true, type: 'remove', quantity: quantity };
        state.moneyData.currentMoney = (state.moneyData.currentMoney - quantity), state.moneyData.canShow = true;

        setTimeout(() => {
            state.moneyData.changedMoney.status = false;

            setTimeout(() => { state.moneyData.canShow = false }, 1000);
        }, 5000);
    },
    addMoney(state, quantity) {
        state.moneyData.changedMoney = { status: true, type: 'add', quantity: quantity };
        state.moneyData.currentMoney = (state.moneyData.currentMoney + quantity), state.moneyData.canShow = true;

        setTimeout(() => {
            state.moneyData.changedMoney.status = false;

            setTimeout(() => { state.moneyData.canShow = false }, 1000);
        }, 5000);
	},
	setMinimapData(state, data) {
        const width = window.innerWidth, height = window.innerHeight;

        state.minimapData.top = (data.y * height) + 'px', state.minimapData.left = (data.x * width) + 'px';
        state.minimapData.width = (0.18888 * height * 1.41) + 'px', state.minimapData.height = (0.18888 * height) + 'px';
    },
    setCharacterData(state, data) {
        for (var name in data) {
			state.minimapData[name] = data[name] + '%';
        }
    },
    setVehicleStatus(state, status) {
        state.vehicleData.isOnVehicle = status;
    },
    setCompassStatus(state, status) {
        state.vehicleData.isCompassOn = status;
    },
    setVehicleData(state, data) {
        for (var name in data) {
            state.vehicleData[name] = data[name];
        }
    },
    setCompassDirection(state, data) {
        state.vehicleData.direction = data;
    }
}

export default { namespaced: true, getters, state, actions, mutations }