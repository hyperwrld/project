<script>
	import { mapGetters } from 'vuex';
	import container from './container/container.vue';
	import { Drag, Drop } from 'vue-easy-dnd';

	export default {
		name: 'inventory',
		props: ['closeMenu'],
		components: {
			container,
			Drag,
			Drop,
		},
		computed: {
			...mapGetters('inventory', {
				data: 'getData',
			}),
		},
		data() {
			return {
				itemCount: 0,
			};
		},
		methods: {
			checkInput: function(event) {
				event = event ? event : window.event;

				if (event.keyCode >= 48 && event.keyCode <= 57) return true;

				event.preventDefault();
			},
			onDrop: function(event, inventory, index) {
				const currentIndex = event.source.$el.offsetParent.dataset.slot,
					currentInventory = event.source.$el.offsetParent.dataset.type;

				if (inventory == 'use') {
					return this.$store.dispatch('inventory/useItem', {
						inventory: currentInventory,
						index: currentIndex,
					});
				}

				this.$store.dispatch('inventory/moveItem', {
					current: currentInventory,
					future: inventory,
					index: currentIndex,
					futureIndex: index,
					quantity: this.itemCount,
				});
			},
			closeEvent: function(event) {
				if (event.keyCode == 27) {
					this.closeMenu({
						appName: 'inventory',
						first: this.data.firstName,
						second: this.data.secondName,
					});

					event.preventDefault();
				}
			},
		},
		destroyed() {
			window.removeEventListener('keydown', this.closeEvent, false);
		},
		mounted() {
			window.addEventListener('keydown', this.closeEvent, false);
		},
		render() {
			let data = this.data;

			return (
				<transition
					appear
					enter-active-class='animated fadeIn'
					leave-active-class='animated fadeOut'
				>
					<div class='inventory'>
						<container
							drop={this.onDrop}
							informations={{
								name: data.firstName,
								weight: data.firstWeight,
								maxWeight: data.firstMaxWeight,
							}}
							items={data.firstItems}
						/>
						<div class='controls'>
							<input
								class='count'
								v-model={this.itemCount}
								on-keypress={(event) => this.checkInput(event)}
							/>
							<drop class='use' on-drop={(event) => this.onDrop(event, 'use')}>
								<q-icon name='fas fa-hand-paper' />
							</drop>
						</div>
						<container
							drop={this.onDrop}
							informations={{
								name: data.secondName,
								weight: data.secondWeight,
								maxWeight: data.secondMaxWeight,
							}}
							items={data.secondItems}
						/>
					</div>
				</transition>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './inventory.scss';
</style>
