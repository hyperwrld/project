import nui from '../../utils/nui';

const state = () => ({
	itemsList: [],
    playerInventory: { name: 'undefined', weight: 0, maxWeight: 325, items: [{ itemId: 137902532} ] },
    secondaryInventory: { name: 'undefined', type: 0, shopType: 0, weight: 0, maxWeight: 1000, items: [], coords: {} },
    actionData: { status: false, items: [] }, itemsQueue: []
})

const getters = {
	GET_PLAYER_INVENTORY: state => {
		return state.playerInventory;
	},
	GET_SECONDARY_INVENTORY: state => {
		return state.secondaryInventory;
	},
	getActionData: state => {
		return state.actionData;
	},
	GET_ITEMS_QUEUE: state => {
		return state.itemsQueue;
	},
	getItemsList: state =>  {
		return state.itemsList;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
	},
	setAppData(state, data) {
		state.commit('setAppData', data);
	},
    moveItem(state, data) {
        state.commit('moveItem', data);
    },
    calculateWeight(state) {
        state.commit('calculateWeight');
    },
    setActionData(state, data) {
        state.commit('setActionData', data);
    }
}

const mutations = {
    setData(state, data) {
		state.playerInventory.name = data.player.name;
		state.playerInventory.items = [], state.secondaryInventory.items = [];

		for (var name in data.secondary) {
			if (name != 'items') {
				state.secondaryInventory[name] = data.secondary[name];
			}
		}

		for (let i = 0; i < 40; i++) {
			const itemData = data.player.items.find(element => (element.slot - 1) == i);

			let slotData = {};

			if (itemData) {
				slotData = { itemId: itemData.item, quantity: itemData.count, meta: itemData.meta, durability: itemData.creation_time };
			}

			state.playerInventory.items[i] = slotData;
		}

		for (let i = 0; i < state.secondaryInventory.maxSlots; i++) {
			const itemData = data.secondary.items.find(element => (element.slot - 1) == i);

			let slotData = {};

			if (itemData) {
				slotData = { itemId: itemData.item, quantity: itemData.count, meta: itemData.meta, durability: itemData.creation_time };

				if (state.secondaryInventory.type == 5) slotData.price = itemData.price;
			}

			state.secondaryInventory.items[i] = slotData;
		}

		this.commit('inventory/calculateWeight');
	},
	setAppData(state, data) {
		state.itemsList = data;
	},
    moveItem(state, data) {
        const from = data.currentInventory == 'player-inventory' ? true : false, to = data.futureInventory == 'player-inventory' ? true : false;
        var fromArray = from ? state.playerInventory.items : state.secondaryInventory.items, toArray = to ? state.playerInventory.items : state.secondaryInventory.items;

        if ((Number(data.currentIndex) != Number(data.futureIndex)) || (from != to)) {
            nui.send('moveItem', {
                current: from ? state.playerInventory.name : state.secondaryInventory.name, future: to ? state.playerInventory.name : state.secondaryInventory.name,
                currentIndex: Number(data.currentIndex) + 1, futureIndex: Number(data.futureIndex) + 1, count: Number(data.itemCount), type: Number(state.secondaryInventory.type)
            }).then(moveData => {
                if (moveData.status) {
                    const currentData = moveData.current ? { itemId: moveData.current.item, quantity: moveData.current.count, durability: moveData.current.creation_time } : {};
                    const futureData = moveData.future ? { itemId: moveData.future.item, quantity: moveData.future.count, durability: moveData.future.creation_time } : {};

					fromArray.splice(data.currentIndex, 1, currentData), toArray.splice(data.futureIndex, 1, futureData);

                    this.commit('inventory/calculateWeight');
                }
            });
        }
    },
    calculateWeight(state) {
        var playerWeight = 0, secondaryWeight = 0;

        for (let i = 0; i < state.playerInventory.items.length; i++) {
            if (state.playerInventory.items[i].itemId) {
				let item = state.itemsList.find(element => element.identifier == state.playerInventory.items[i].itemId);

                playerWeight = playerWeight + (item.weight * state.playerInventory.items[i].quantity);
            }
        }

        for (let i = 0; i < state.secondaryInventory.items.length; i++) {
            if (state.secondaryInventory.items[i].itemId) {
				let item = state.itemsList.find(element => element.identifier == state.secondaryInventory.items[i].itemId);

                secondaryWeight = secondaryWeight + (item.weight * state.secondaryInventory.items[i].quantity);
            }
        }

        state.playerInventory.weight = playerWeight, state.secondaryInventory.weight = secondaryWeight;
    },
    setActionData(state, data) {
		if (data.items != undefined) {
			for (let i = 0; i < 4; i++) {
				let slotData = {};

				if (data.items[i]) {
					slotData = { itemId: data.items[i].name, quantity: data.items[i].count, durability: data.items[i].creation_time };
				}

				state.actionData.items[i] = slotData;
			}
		}

		state.actionData.status = data.status;
    }
}

export default { namespaced: true, getters, state, actions, mutations }