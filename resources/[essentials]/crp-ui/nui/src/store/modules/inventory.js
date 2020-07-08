import nui from '../../utils/nui';
import itemsList from '../../components/inventory/items';

const state = () => ({
    statusData: { inventory: false, actionbar: false },
    playerInventory: { name: 'undefined', weight: 0, maxWeight: 325, items: [] },
    secondaryInventory: { name: 'undefined', type: 0, weight: 0, maxWeight: 1000, items: [], coords: {} },
    actionItems: []
})

const actions = {
    setInventory(state, data) {
        state.commit('setInventory', data);
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
    setInventory(state, data) {
        nui.send('getInventories', data).then(data => {
            state.playerInventory.name = data.playerInventory.name, state.secondaryInventory.name = data.secondaryInventory.name;
            state.secondaryInventory.maxWeight = data.secondaryInventory.maxWeight, state.playerInventory.items = [], state.secondaryInventory.items = [];
            state.secondaryInventory.type = data.secondaryInventory.type, state.secondaryInventory.coords = data.secondaryInventory.coords ? data.secondaryInventory.coords : {};

            for (let i = 0; i < 40; i++) {
                state.playerInventory.items.push({});
            }

            for (let i = 0; i < data.playerInventory.items.length; i++) {
                state.playerInventory.items.splice(data.playerInventory.items[i].slot - 1, 1, { itemId: data.playerInventory.items[i].name, quantity: data.playerInventory.items[i].count, durability: data.playerInventory.items[i].durability });
            }

            for (let i = 0; i < data.secondaryInventory.maxSlots; i++) {
                state.secondaryInventory.items.push({});
            }

            for (let i = 0; i < data.secondaryInventory.items.length; i++) {
                state.secondaryInventory.items.splice(data.secondaryInventory.items[i].slot - 1, 1, { itemId: data.secondaryInventory.items[i].name, quantity: data.secondaryInventory.items[i].count, durability: data.secondaryInventory.items[i].durability });
            }

            this.commit('inventory/calculateWeight');
        });

        state.statusData.inventory = true;
    },
    moveItem(state, data) {
        const from = data.currentInventory == 'player-inventory' ? true : false, to = data.futureInventory == 'player-inventory' ? true : false;
        var fromArray = from ? state.playerInventory.items : state.secondaryInventory.items, toArray = to ? state.playerInventory.items : state.secondaryInventory.items;

        if ((Number(data.currentIndex) != Number(data.futureIndex)) || (from != to)) {
            nui.send('moveItem', {
                currentInventory: from ? state.playerInventory.name : state.secondaryInventory.name, futureInventory: to ? state.playerInventory.name : state.secondaryInventory.name,
                currentIndex: Number(data.currentIndex) + 1, futureIndex: Number(data.futureIndex) + 1, itemCount: Number(data.itemCount), type: Number(state.secondaryInventory.type), coords: state.secondaryInventory.coords
            }).then(moveData => {
                if (moveData.status) {
                    const currentSlotData = moveData.currentSlot ? { itemId: moveData.currentSlot.name, quantity: moveData.currentSlot.count, durability: moveData.currentSlot.durability } : {};
                    const futureSlotData = moveData.futureSlot ? { itemId: moveData.futureSlot.name, quantity: moveData.futureSlot.count, durability: moveData.futureSlot.durability } : {};

                    fromArray.splice(data.currentIndex, 1, currentSlotData), toArray.splice(data.futureIndex, 1, futureSlotData);

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
        if (data.items) {
            state.actionItems = [];

            for (let i = 0; i < 4; i++) {
                if (data.items[i]) {
                    state.actionItems.push({ itemId: data.items[i].name, quantity: data.items[i].count, durability: data.items[i].durability });
                } else {
                    state.actionItems.push({});
                }
            }
        }

        state.statusData.actionbar = data.status;
    }
}

export default { namespaced: true, state, actions, mutations }