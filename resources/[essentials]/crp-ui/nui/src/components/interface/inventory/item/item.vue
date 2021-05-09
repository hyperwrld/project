<script>
	import { mapGetters } from 'vuex';

	import { fragment } from '../../../../utils/lib';

	export default {
		props: {
			item: Object,
		},
		computed: {
			...mapGetters('inventory', {
				itemsList: 'getItemsList',
			}),
		},
		render() {
			let itemData = this.itemsList.find(
					(element) => element.identifier == this.item.itemId
				),
				itemPercentage;

			if (this.item.durability) {
				itemPercentage =
					itemData.decayRate != 0.0 && this.item.durability
						? 100 -
						  Math.ceil(
								((Date.now() -
									new Date(this.item.durability * 1000).getTime()) /
									(2419200000 * itemData.decayRate)) *
									100
						  )
						: 100;

				if (itemPercentage < 0) itemPercentage = 0;
			}

			return (
				<div class={`item ${itemPercentage != null ? '' : 'empty'}`}>
					<div class='item-info'>
						{this.item.quantity} [{itemData.weight.toFixed(2)}]
					</div>
					<div class='item-image'>
						<img
							src={require('./../../../../assets/items/' + itemData.image)}
						/>
					</div>
					<div class='item-name'>
						{this.item.price ? (
							<fragment>
								<span>{this.item.price}€</span>&nbsp;{`- ${itemData.name}`}
							</fragment>
						) : (
							<fragment>{itemData.name}</fragment>
						)}
					</div>
					{itemPercentage != null && (
						<div
							class='item-durability'
							style={
								itemPercentage >= 10
									? { width: itemPercentage + '%' }
									: { width: '100%', backgroundColor: '#a60505' }
							}
						/>
					)}
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './item.scss';
</style>
