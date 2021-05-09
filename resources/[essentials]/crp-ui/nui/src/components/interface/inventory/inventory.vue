<script>
	import { mapGetters } from 'vuex';
	import { Drag, Drop } from 'vue-easy-dnd';

	import item from './item/item.vue';

	export default {
		name: 'inventory',
		props: ['closeMenu'],
		components: {
			item,
			Drag,
			Drop,
		},
		computed: {
			...mapGetters('inventory', {
				data: 'getInventoryData',
			}),
		},
		data() {
			return {
				itemCount: 0,
			};
		},
		methods: {
			getSecondName: function(name) {
				if (name.includes('drop')) {
					return 'Chão';
				} else if (name.includes('container')) {
					return 'Contentor';
				} else {
					return name;
				}
			},
			returnData: function(data) {
				const quantity = Number(
					this.itemCount != 0 && this.itemCount <= data.quantity
						? this.itemCount
						: data.quantity
				);

				return {
					itemId: data.itemId,
					quantity: quantity,
					durability: data.durability,
					price: data.price,
				};
			},
			onDrop: function(event, inventory, index) {
				const currentIndex = event.source.$el.offsetParent.dataset.slot,
					currentInventory = event.source.$el.offsetParent.dataset.type;

				if (inventory == 'use') {
					this.$store.dispatch('inventory/useItem', {
						inventory: currentInventory,
						index: currentIndex,
					});
				} else {
					this.$store.dispatch('inventory/moveItem', {
						current: currentInventory,
						future: inventory,
						index: currentIndex,
						futureIndex: index,
						quantity: this.itemCount,
					});
				}
			},
			checkInput: function(event) {
				event = event ? event : window.event;

				if (event.keyCode >= 48 && event.keyCode <= 57) return true;
				else {
					event.preventDefault();
				}
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
			const data = this.data;

			return (
				<transition appear name='fade'>
					<div class='inventory'>
						<div class='container'>
							<div class='information'>
								<span>Inventário Pessoal</span>
								<div
									style={{
										width: (data.firstWeight / data.firstMaxWeight) * 100 + '%',
									}}
								/>
							</div>
							<div class='slots'>
								{data.firstItems.map((slot, index) => {
									return (
										<drop
											class='slot'
											data-type={data.firstName}
											data-slot={index}
											on-drop={(event) =>
												this.onDrop(event, data.firstName, index)
											}
										>
											{index >= 0 && index <= 3 && (
												<div class='slot-id'>{index + 1}</div>
											)}
											{slot.itemId && (
												<drag class='item'>
													<template v-slot='drag-image'>
														<item item={this.returnData(slot)} />
													</template>

													<item item={slot} />
												</drag>
											)}
										</drop>
									);
								})}
							</div>
						</div>
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
						<div class='container'>
							<div class='information'>
								<span>{this.getSecondName(data.secondName)}</span>
								<div
									style={
										data.type != 7
											? {
													width:
														(data.secondWeight / data.secondMaxWeight) * 100 +
														'%',
											  }
											: { width: data.craftProgress + '%' }
									}
								/>
							</div>
							<div class='slots'>
								{data.isCrafting && (
									<div class='crafting-info'>
										Craftando<span>...</span>
									</div>
								)}
								{data.secondItems.map((slot, index) => {
									return (
										<drop
											class='slot'
											data-type={data.secondName}
											data-slot={index}
											on-drop={(event) =>
												this.onDrop(event, data.secondName, index)
											}
										>
											{slot.itemId && (
												<drag class='item'>
													<template v-slot='drag-image'>
														<item item={this.returnData(slot)} />
													</template>

													<item item={slot} />
												</drag>
											)}
										</drop>
									);
								})}
							</div>
						</div>
					</div>
				</transition>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './inventory.scss';
</style>
