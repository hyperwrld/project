<template>
    <v-container fluid>
        <div class='inventory'>
            <div class='inventory-info'>
                <div class='player-info'>
                    <div class='inventory-name'>
                        <span>{{ playerInventory.name }}</span>
                    </div>
                    <div class='inventory-weight'>
                        <span>Peso: {{ playerInventory.weight.toFixed(2) }} / {{ playerInventory.maxWeight.toFixed(2) }}</span>
                    </div>
                </div>
                <div class='secondary-info'>
                    <div class='inventory-name'>
                        <span>{{ secondaryInventory.name }}</span>
                    </div>
                    <div class='inventory-weight'>
                        <span>Peso: {{ secondaryInventory.weight.toFixed(2) }} / {{ secondaryInventory.maxWeight.toFixed(2) }}</span>
                    </div>
                </div>
            </div>
            <div class='inventory-container'>
                <div class='player-inventory'>
                    <drop @drop='onDrop($event, "player-inventory", index)' class='slot' :data-slot='index' v-for='(slot, index) in playerInventory.items' :item='slot' :key='index'>
                        <div class='slot-id' v-if='index >= 0 && index <= 3'>{{ index + 1 }}</div>

                        <drag class='item' v-if='slot.itemId != undefined'>
                            <template v-slot:drag-image>
                                <div class='item-info' v-if='itemCount != 0 && itemCount <= slot.quantity '>{{ itemCount }} [{{ itemsList[slot.itemId].weight.toFixed(2) }}]</div>
                                <div class='item-info' v-else>{{ slot.quantity }} [{{ itemsList[slot.itemId].weight.toFixed(2) }}]</div>
                                <div class='item-image'><img v-bind:src='require("./../../assets/" + itemsList[slot.itemId].image)'></div>
                                <div class='item-durability' v-if='slot.durability >= 5' :style='{ width: slot.durability + "%" }'>{{ slot.durability }}</div><div class='item-durability destroyed' v-else>Destruído</div>
                                <div class='item-name'>{{ itemsList[slot.itemId].name }}</div>
                            </template>

                            <div class='item-info'>{{ slot.quantity }} [{{ itemsList[slot.itemId].weight.toFixed(2) }}]</div>
                            <div class='item-image'><img v-bind:src='require("./../../assets/" + itemsList[slot.itemId].image)'></div>
                            <div class='item-durability' v-if='slot.durability >= 5' :style='{ width: slot.durability + "%" }'>{{ slot.durability }}</div><div class='item-durability destroyed' v-else>Destruído</div>
                            <div class='item-name'>{{ itemsList[slot.itemId].name }}</div>
                        </drag>
                    </drop>
                </div>
                <div class='inventory-controls'>
                    <input v-model='itemCount' class='count' @keypress='checkInput($event)'>
                    <drop @drop='onDrop($event, "use", index)' class='use'>Usar</drop>
                    <div class='close' @click='closeMenu'>Fechar</div>
                </div>
                <div class='secondary-inventory'>
                    <drop @drop='onDrop($event, "secondary-inventory", index)' class='slot' :data-slot='index' v-for='(slot, index) in secondaryInventory.items' :item='slot' :key='index'>
                        <drag class='item' v-if='slot.itemId != undefined'>
                            <template v-slot:drag-image>
                                <div class='item-info' v-if='itemCount != 0 && itemCount <= slot.quantity '>{{ itemCount }} [{{ itemsList[slot.itemId].weight.toFixed(2) }}]</div>
                                <div class='item-info' v-else>{{ slot.quantity }} [{{ itemsList[slot.itemId].weight.toFixed(2) }}]</div>
                                <div class='item-image'><img v-bind:src='require("./../../assets/" + itemsList[slot.itemId].image)'></div>
                                <div class='item-durability' v-if='slot.durability >= 5' :style='{ width: slot.durability + "%" }'>{{ slot.durability }}</div><div class='item-durability destroyed' v-else>Destruído</div>
                                <div class='item-name'>{{ itemsList[slot.itemId].name }}</div>
                            </template>

                            <div class='item-info'>{{ slot.quantity }} [{{ itemsList[slot.itemId].weight.toFixed(2) }}]</div>
                            <div class='item-image'><img v-bind:src='require("./../../assets/" + itemsList[slot.itemId].image)'></div>
                            <div class='item-durability' v-if='slot.durability >= 5' :style='{ width: slot.durability + "%" }'>{{ slot.durability }}</div><div class='item-durability destroyed' v-else>Destruído</div>
                            <div class='item-name'>{{ itemsList[slot.itemId].name }}</div>
                        </drag>
                    </drop>
                </div>
            </div>
        </div>
    </v-container>
</template>

<script>
    import { Drag, Drop } from 'vue-easy-dnd';
    import { mapState } from 'vuex';

    import nui from '../../utils/nui';
    import items from './items';

    export default {
        name: 'inventory',
        components: {
            Drag, Drop
        },
        data() {
            return {
                itemCount: 0,
                itemsList: items
            }
        },
        computed: {
            ...mapState({
                playerInventory: state => state.inventory.playerInventory,
                secondaryInventory: state => state.inventory.secondaryInventory
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
            closeMenu() {
                nui.send('closeMenu');
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