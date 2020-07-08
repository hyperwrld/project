<template>
    <div class='action-bar'>
        <div class='slot' v-for='(slot, index) in actionItems' :item='slot' :key='index'>
            <div class='slot-id'>{{ index + 1 }}</div>

            <div class='item' v-if='slot.itemId != undefined'>
                <div class='item-info'>{{ slot.quantity }} [{{ itemsList[slot.itemId].weight.toFixed(2) }}]</div>
                <div class='item-image'><img v-bind:src='require("./../../../assets/" + itemsList[slot.itemId].image)'></div>
                <div class='item-durability' v-if='slot.durability >= 5' :style='{ width: slot.durability + "%" }'>{{ slot.durability }}</div><div class='item-durability destroyed' v-else>Destruído</div>
                <div class='item-name'>{{ itemsList[slot.itemId].name }}</div>
            </div>
        </div>
    </div>
</template>

<script>
    import { mapState } from 'vuex';

    import nui from '../../../utils/nui';
    import items from '../items';

    export default {
        name: 'inventory',
        computed: {
            ...mapState({
                actionItems: state => state.inventory.actionItems
            })
        },
        data() {
            return {
                itemsList: items
            }
        },
    };
</script>

<style scoped lang='scss'>
    @import './actionbar.scss';
</style>