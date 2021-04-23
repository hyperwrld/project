<script>
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faSignOutAlt } from '@fortawesome/free-solid-svg-icons';

	import { mapGetters } from 'vuex';

	library.add(faSignOutAlt);

	export default {
		name: 'banking',
		props: ['closeMenu'],
		computed: {
			...mapGetters('banking', {
				data: 'getData'
			})
		},
		render() {
			let data = this.data;

			console.log(data)

			return (
				<transition appear name='fade'>
					<div class='banking'>
						<div class='accounts'>
							{ data.accounts.map((account) => {
								return (
									<div class='account'>
										<div class='information'>
											<span class='data'>{ account.name + ' | ' + account.id }</span>
											<span class='type'>{ account.type + ' / ' + account.owner_name }</span>
											<div class='money'>
												{ account.money + ',00€'}
											</div>
										</div>
										<div class='buttons'>
											<button><img src={ require('./../../../assets/withdraw.png') }/></button>
											<button><img src={ require('./../../../assets/deposit.png') }/></button>
											<button><img src={ require('./../../../assets/transfer.png') }/></button>
										</div>
									</div>
								)
							})}
						</div>
						<div class='transactions'>
							<div class='border'>
								<div class='transaction'>
									<div class='information'>
										<span class='account'>Conta Partilhada / 6378854</span>
										<span class='id'>865234ad-6a92-11e7-8846-b05adad3f0ae</span>
									</div>
									<div class='data'>
										<div>
											<span class='time'>03/03/2011</span>
											<span>Lewis Hamilton</span>
										</div>
										<span class='money'>+300.00$</span>
										<div class='receiver'>
											<span class='account'>63783354</span>
											<span>Emilio Chafe</span>
										</div>
									</div>
									<div class='message'>
										Mensagem: pqppqpeperprpetprtyprtyptyr
									</div>
								</div>
							</div>
						</div>
					</div>
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './banking.scss';
</style>