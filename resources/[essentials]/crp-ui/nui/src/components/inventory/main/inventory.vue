<template>
    <v-container fluid>
        <div class='inventory'>
            <div class='inventory-info'>
                <div class='player-info'>
					<inventoryInfo :info='PLAYER_INVENTORY'/>
                </div>
                <div class='secondary-info'>
					<inventoryInfo :info='SECONDARY_INVENTORY'/>
                </div>
            </div>
            <div class='inventory-container'>
                <div class='player-inventory'>
                    <drop @drop='onDrop($event, "player-inventory", index)' class='slot' :data-slot='index' v-for='(slot, index) in PLAYER_INVENTORY.items' :item='slot' :key='index'>
                        <div class='slot-id' v-if='index >= 0 && index <= 3'>{{ index + 1 }}</div>

                        <drag class='item' v-if='slot.itemId != undefined'>
                            <template v-slot:drag-image>
                                <item :item='returnData(slot)'/>
                            </template>

							<item :item='slot'/>
                        </drag>
                    </drop>
                </div>
                <div class='inventory-controls'>
                    <input v-model='itemCount' class='count' @keypress='checkInput($event)'>
                    <drop @drop='onDrop($event, "use", index)' class='use'>Usar</drop>
                    <div class='close' @click='closeMenu'>Fechar</div>
                </div>
                <div class='secondary-inventory'>
                    <drop @drop='onDrop($event, "secondary-inventory", index)' class='slot' :data-slot='index' v-for='(slot, index) in SECONDARY_INVENTORY.items' :item='slot' :key='index'>
                        <drag class='item' v-if='slot.itemId != undefined'>
							<template v-slot:drag-image>
								<item :item='returnData(slot)'/>
							</template>

							<item :item='slot'/>
                        </drag>
                    </drop>
                </div>
            </div>
        </div>
    </v-container>
</template>

<script>
    import { Drag, Drop } from 'vue-easy-dnd';
    import { mapGetters } from 'vuex';

    import nui from '../../../utils/nui';
	import item from './../item/item';

	const inventoryInfo = {
		props: ['info'],
		render (h) {
			return (
				<div>
					<div class='inventory-name'>
                        <span>{ this.info.name }</span>
                    </div>
                    <div class='inventory-weight'>
                        <span>Peso: { this.info.weight.toFixed(2) } / { this.info.maxWeight.toFixed(2) }</span>
                    </div>
				</div>
			);
		}
	};

    export default {
		name: 'inventory',
		props: ['closeMenu'],
        components: {
            Drag, Drop, inventoryInfo, item
        },
        data() {
            return {
                itemCount: 0
            }
        },
        computed: {
			...mapGetters('inventory', {
				PLAYER_INVENTORY: 'GET_PLAYER_INVENTORY',
        		SECONDARY_INVENTORY: 'GET_SECONDARY_INVENTORY'
    		})
        },
        methods: {
            onDrop(event, futureInventory, futureIndex) {
                var currentIndex = event.source.$el.offsetParent.dataset.slot, currentInventory = event.source.$el.offsetParent.parentElement.className;

                if (futureInventory == 'use') {
                    this.$store.dispatch('inventory/useItem', { currentInventory: currentInventory, currentIndex: currentIndex });
                } else if (currentInventory != undefined && futureInventory != undefined && currentIndex != undefined && futureIndex != undefined) {
                    this.$store.dispatch('inventory/moveItem', { currentInventory: currentInventory, futureInventory: futureInventory, currentIndex: currentIndex, futureIndex: futureIndex, itemCount: this.itemCount });
                }
            },
            checkInput: function(event) {
                event = (event) ? event : window.event;

                if (event.keyCode >= 48 && event.keyCode <= 57)
                    return true;
                else {
                    event.preventDefault();
                }
			},
			returnData: function(data) {
				return {
					itemId: data.itemId, quantity: Number((this.itemCount != 0 && this.itemCount <= data.quantity) ? this.itemCount : data.quantity),
					durability: data.durability, price: data.price
				};
			}
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('keydown', (event) => {
                if (event.keyCode == 27) {
                    this.closeMenu();
                }
            }, false);
        }
    };
</script>

<style scoped lang='scss'>
    @import './inventory.scss';
</style>