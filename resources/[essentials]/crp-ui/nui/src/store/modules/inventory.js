import nui from '../../utils/nui';
import itemsList from '../../components/inventory/items';

const state = () => ({
    playerInventory: { name: 'undefined', weight: 0, maxWeight: 325, items: [] },
    secondaryInventory: { name: 'undefined', type: 0, shopType: 0, weight: 0, maxWeight: 1000, items: [], coords: {} },
    actionItems: []
})

const getters = {
	GET_PLAYER_INVENTORY: state => {
		return state.playerInventory
	},
	GET_SECONDARY_INVENTORY: state => {
		return state.secondaryInventory
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    },
    moveItem(state, data) {
        state.commit('moveItem', data);
    },
    calculateWeight(state) {
        state.commit('calculateWeight');
    },
    setActionBar(state, data) {
        state.commit('setActionBar', data);
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
                playerWeight = playerWeight + (itemsList[state.playerInventory.items[i].itemId].weight * state.playerInventory.items[i].quantity);
            }
        }

        for (let i = 0; i < state.secondaryInventory.items.length; i++) {
            if (state.secondaryInventory.items[i].itemId) {
                secondaryWeight = secondaryWeight + (itemsList[state.secondaryInventory.items[i].itemId].weight * state.secondaryInventory.items[i].quantity);
            }
        }

        state.playerInventory.weight = playerWeight, state.secondaryInventory.weight = secondaryWeight;
    },
    setActionBar(state, data) {
        state.actionItems = [];

        for (let i = 0; i < 4; i++) {
            if (data[i]) {
                state.actionItems.push({ itemId: data[i].name, quantity: data[i].count, durability: data[i].durability });
            } else {
                state.actionItems.push({});
            }
        }
    }
}

export default { namespaced: true, getters, state, actions, mutations }