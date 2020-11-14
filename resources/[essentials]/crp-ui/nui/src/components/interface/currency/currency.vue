<script>
	import { mapGetters } from 'vuex';

	export default {
		name: 'currency',
		computed: {
			...mapGetters('interface', {
				currencyData: 'getCurrencyData'
			})
		},
		methods: {
			formatNumber: function(number) {
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
			},
		},
		render (h) {
			return (
				<div class='currency'>
					<div class='money'>
						<span>€ </span>{ formatNumber(currencyData.currentMoney) }
					</div>
					{ currencyData.canShow && currencyData.status &&
						<div class='inner-container'>
							<span class={ currencyData.type }>{ (currencyData.type == 'add' ? '+' : '-') + ' €'}</span> { currencyData.quantity }
						</div>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './currency.scss';
</style>