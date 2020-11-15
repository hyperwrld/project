<script>
	import { mapGetters } from 'vuex';

	export default {
		name: 'currency',
		computed: {
			...mapGetters('currency', {
				currencyData: 'getCurrencyData'
			})
		},
		methods: {
			formatNumber: function(number) {
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
			}
		},
		render (h) {
			return (
				<div class='currency'>
					{ this.currencyData.canShow &&
						<transition name='fadeInOut' appear>
							<div class='inner-container'>
								<div class='money'>
									<span>€ </span>{ this.formatNumber(this.currencyData.currentMoney) }
								</div>
								{ this.currencyData.transactionStatus &&
									<transition name='fade' appear>
										<div class='transaction'>
											<span class={ this.currencyData.transactionType }>{ (this.currencyData.transactionType == 'add' ? '+' : '-') + ' €'}</span> { this.currencyData.transactionQuantity }
										</div>
									</transition>
								}
							</div>
						</transition>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './currency.scss';
</style>