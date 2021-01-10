<script>
	import { mapGetters } from 'vuex';

	import item from './../inventory/item/item.vue';

	export default {
		name: 'actionbar',
		components: {
			item
		},
		computed: {
			...mapGetters('actionbar', {
				items: 'getItems'
			})
		},
		render(h) {
			return (
				<transition appear name='fade'>
					<div class='actionbar'>
						{ this.items.map((data, index) => {
							return (
								<div class='slot'>
									<div class='id'>{ index + 1 }</div>
									{ data.itemId &&
										<item item={ data }/>
									}
								</div>
							)
						})}
					</div>
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './actionbar.scss';
</style>