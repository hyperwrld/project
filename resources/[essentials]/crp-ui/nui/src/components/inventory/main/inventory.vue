<template>
    <v-container fluid>
        <div class='inventory'>
            <div class='inventory-info'>
                <div class='player-info'>
					<inventoryInfo :info='inventories.player'/>
                </div>
                <div class='secondary-info'>
					<inventoryInfo :info='inventories.secondary'/>
                </div>
            </div>
            <div class='inventory-container'>
                <div class='player-inventory'>
                    <drop @drop='onDrop($event, "player-inventory", index)' class='slot' :data-slot='index' v-for='(slot, index) in inventories.player.items' :item='slot' :key='index'>
                        <div class='slot-id' v-if='index >= 0 && index <= 3'>{{ index + 1 }}</div>

                        <drag class='item' v-if='slot.itemId != undefined'>
                            <template v-slot:drag-image>
                                <item :item='returnData(slot)' :itemsList='itemsList'/>
                            </template>

							<item :item='slot' :itemsList='itemsList'/>
                        </drag>
                    </drop>
                </div>
                <div class='inventory-controls'>
                    <input v-model='itemCount' class='count' @keypress='checkInput($event)'>
                    <drop @drop='onDrop($event, "use", index)' class='use'>Usar</drop>
                    <div class='close' @click='closeMenu'>Fechar</div>
                </div>
                <div class='secondary-inventory'>
                    <drop @drop='onDrop($event, "secondary-inventory", index)' class='slot' :data-slot='index' v-for='(slot, index) in inventories.secondary.items' :item='slot' :key='index'>
                        <drag class='item' v-if='slot.itemId != undefined'>
							<template v-slot:drag-image>
								<item :item='returnData(slot)' :itemsList='itemsList'/>
							</template>

							<item :item='slot' :itemsList='itemsList'/>
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
	import items from '../items';

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

	const item = {
		props: ['item', 'itemsList'],
		render (h) {
			let itemDurabilityLabel = this.item.durability >= 10 ? this.item.durability : (this.item.durability <= 0 ? 'Destruído' : 'Quase destruído');
			let itemLabel = this.item.price ? `<span>${ this.item.price }€</span> - ${ this.itemsList[this.item.itemId].name }` : this.itemsList[this.item.itemId].name;

			return (
				<div>
					<div class='item-info'>{ this.item.quantity } [{ this.itemsList[this.item.itemId].weight.toFixed(2) }]</div>
					<div class='item-image'>
						<img src={ require('./../../../assets/' + this.itemsList[this.item.itemId].image) }></img>
					</div>
					<div class='item-durability' style={ this.item.durability >= 10 ? { width: this.item.durability + '%' } : { width: '100%', backgroundColor: '#a60505' }}>
						{ itemDurabilityLabel }
					</div>
					<div class='item-name' domPropsInnerHTML={ itemLabel }></div>
				</div>
			);
		}
	}

    export default {
		name: 'inventory',
		props: ['closeMenu'],
        components: {
            Drag, Drop, inventoryInfo, item
        },
        data() {
            return {
                itemCount: 0,
                itemsList: items
            }
        },
        computed: {
            ...mapGetters('inventory', ['inventories'])
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