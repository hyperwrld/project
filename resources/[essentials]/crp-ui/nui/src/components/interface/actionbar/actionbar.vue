<script>
	import { mapGetters } from 'vuex';
	import item from './../inventory/item/item.vue';

	export default {
		name: 'actionbar',
		components: {
			item,
		},
		computed: {
			...mapGetters({
				items: 'actionbar/getItems',
				itemsList: 'inventory/getItemsList',
			}),
		},
		render() {
			return (
				<transition appear name='fade'>
					<div class='actionbar'>
						{this.items.map((data, index) => {
							if (data.itemId) {
								var itemInfo = this.itemsList.find(
									(element) => element.identifier == data.itemId
								);
							}

							return (
								<div class='slot'>
									<div class='id'>{index + 1}</div>
									{data.itemId && <item item={data} itemInfo={itemInfo} />}
								</div>
							);
						})}
					</div>
				</transition>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './actionbar.scss';
</style>
