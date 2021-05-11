<script>
	import { mapGetters } from 'vuex';
	import { Drag, Drop } from 'vue-easy-dnd';

	import item from './../item/item.vue';

	export default {
		name: 'container',
		props: {
			drop: Function,
			informations: Object,
			items: Object,
		},
		components: {
			Drag,
			Drop,
			item,
		},
		computed: {
			...mapGetters('inventory', {
				itemsList: 'getItemsList',
			}),
		},
		methods: {
			switchName: function(name) {
				let containerName = name.match(/^[^-]*[^ -]/g)[0];

				switch (containerName) {
					case 'character':
						return 'Inventário Pessoal';
					case 'drop':
						return 'Chão';
					case 'container':
						return 'Contentor';
					default:
						return name;
				}
			},
		},
		render() {
			let informations = this.informations;

			return (
				<div class='container'>
					<div class='information'>
						<span>{this.switchName(informations.name)}</span>
						<div
							style={{
								width:
									(informations.weight / informations.maxWeight) * 100 + '%',
							}}
						/>
					</div>
					<div class='slots'>
						{this.items.map((data, index) => {
							if (data.itemId) {
								var itemInfo = this.itemsList.find(
									(element) => element.identifier == data.itemId
								);
							}

							return (
								<drop
									class='slot'
									data-type={informations.name}
									data-slot={index}
									on-drop={(event) =>
										this.drop(event, informations.name, index)
									}
								>
									{index >= 0 && index <= 3 && (
										<div class='id'>{index + 1}</div>
									)}
									{data.itemId && (
										<drag class='item'>
											<template slot='drag-image'>
												<img
													class='drag-image'
													src={require('./../../../../assets/items/' +
														itemInfo.image)}
												/>
											</template>
											<item item={data} itemInfo={itemInfo} />
										</drag>
									)}
								</drop>
							);
						})}
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './container.scss';
</style>
