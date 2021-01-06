<script>
	import { mapGetters } from 'vuex';

	export default {
		props: {
			item: Object
		},
		computed: {
			...mapGetters('inventory', {
				itemsList: 'getItemsList'
			})
		},
		render (h) {
			let itemData = this.itemsList.find(element => element.identifier == this.item.itemId);
			let itemLabel = this.item.price ? `<span>${ this.item.price }€</span> - ${ itemData.name }` : itemData.name;
			let itemPercentage = itemData.decayRate != 0.0 && this.item.durability ?
				100 - Math.ceil((((Date.now() - new Date(this.item.durability * 1000).getTime()) / (2419200000 * itemData.decayRate)) * 100)) : 100;

			if (itemPercentage < 0) itemPercentage = 0;

			const durabilityLabel = itemPercentage >= 10 ? itemPercentage : (itemPercentage <= 0 ? 'Destruído' : 'Quase destruído');

			return (
				<div class='item'>
					<div class='item-info'>{ this.item.quantity } [{ itemData.weight.toFixed(2) }]</div>
					<div class='item-image'>
						<img src={ require('./../../../../assets/' + itemData.image) }></img>
					</div>
					<div class='item-durability' style={ itemPercentage >= 10 ? { width: itemPercentage + '%' } : { width: '100%', backgroundColor: '#a60505' }}>
						{ durabilityLabel }
					</div>
					<div class='item-name' domPropsInnerHTML={ itemLabel }></div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './item.scss';
</style>