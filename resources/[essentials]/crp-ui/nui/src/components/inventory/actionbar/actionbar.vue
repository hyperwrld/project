<template>
	<v-container fluid id='actionbar'>
		<div class='item-status'>
			<transition name='fade' v-for='item in ITEMS_QUEUE'>
				<div class='slot'>
					<div class='type'>USOU 1X</div>
					<div class='item'>
						<div class='item-image status'><img v-bind:src='require("./../../../assets/" + itemsList[item.itemId].image)'></div>
						<div class='item-name status'>{{ itemsList[item.itemId].name }}</div>
					</div>
				</div>
			</transition>
		</div>
		<transition name='fade'>
			<div class='action-bar' v-if='actionData.status'>
				<div class='slot' v-for='(slot, index) in actionData.items' :item='slot' :key='index'>
					<div class='slot-id'>{{ index + 1 }}</div>

					<div class='item' v-if='slot.itemId != undefined'>
						<item :item='slot'/>
					</div>
				</div>
			</div>
		</transition>
	</v-container>
</template>

<script>
    import { mapGetters } from 'vuex';

	import item from './../item/item.vue';

    export default {
		name: 'inventory',
		components: {
			item
		},
        computed: {
			...mapGetters('inventory', {
				actionData: 'getActionData', queueData: 'getQueueData', itemsList: 'getItemsList'
			})
        }
    };
</script>

<style scoped lang='scss'>
    @import './actionbar.scss';
</style>