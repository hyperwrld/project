<script>
	export default {
		name: 'item',
		props: {
			item: Object,
			itemInfo: Object,
		},
		render() {
			let item = this.item,
				itemInfo = this.itemInfo,
				itemPercentage;

			if (item.durability) {
				itemPercentage =
					itemInfo.decayRate != 0.0 && item.durability
						? 100 -
						  Math.ceil(
								((Date.now() - new Date(item.durability * 1000).getTime()) /
									(2419200000 * itemInfo.decayRate)) *
									100
						  )
						: 100;

				if (itemPercentage < 0) itemPercentage = 0;
			}

			return (
				<div class={`item-container ${itemPercentage != null ? '' : 'empty'}`}>
					<div class='info'>
						{item.quantity} [{itemInfo.weight.toFixed(2)}]
					</div>
					<div class='image'>
						<img
							src={require('./../../../../assets/items/' + itemInfo.image)}
						/>
					</div>
					<div class='name'>
						{item.price && <span>{item.price}€</span> + ' - '}
						{itemInfo.name}
					</div>
					{itemPercentage != null && (
						<div
							class='durability'
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
