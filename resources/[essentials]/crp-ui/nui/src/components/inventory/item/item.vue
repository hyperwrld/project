<script>
	import items from './../items.js';

	export default {
		props: {
			item: Object
		},
		data() {
			return {
				itemsList: items
			}
		},
		render (h) {
			let itemLabel = this.item.price ? `<span>${ this.item.price }€</span> - ${ this.itemsList[this.item.itemId].name }` : this.itemsList[this.item.itemId].name;
			let itemPercentage = this.itemsList[this.item.itemId].decayRate != 0.0 ?
				100 - Math.ceil(((Math.floor(Date.now() / 1000) - this.item.durability) / (2419200 * this.itemsList[this.item.itemId].decayRate)) * 100) : 100;

			if (itemPercentage < 0) itemPercentage = 0;

			const durabilityLabel = itemPercentage >= 10 ? itemPercentage : (itemPercentage <= 0 ? 'Destruído' : 'Quase destruído');

			return (
				<div class='item'>
					<div class='item-info'>{ this.item.quantity } [{ this.itemsList[this.item.itemId].weight.toFixed(2) }]</div>
					<div class='item-image'>
						<img src={ require('./../../../assets/' + this.itemsList[this.item.itemId].image) }></img>
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