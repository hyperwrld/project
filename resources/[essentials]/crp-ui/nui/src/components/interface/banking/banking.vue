<script>
	import { mapGetters } from 'vuex';
	import { convertTime } from '../../../utils/lib';

	import dialogs from './dialogs/dialogs.vue';

	export default {
		name: 'banking',
		props: ['closeMenu'],
		data() {
			return {
				currentAccount: 0,
				isLoading: false,
				isUsingMenu: false,
			};
		},
		computed: {
			...mapGetters('banking', {
				data: 'getData',
			}),
		},
		methods: {
			depositMoney: function(accountId) {
				if (this.isLoading || this.isUsingMenu) return;

				this.isUsingMenu = true;

				console.log(accountId);

				this.$q
					.dialog({
						component: dialogs,
						parent: this,
						title: 'Depositar dinheiro',
						choices: [
							{
								key: 'money',
								type: 'number',
								min: 1,
								max: 10,
								rules: [
									(val) => (val && val.length > 0) || 'Campo obrigatório',
									(val) =>
										(val && Number(val) > 0) || 'Insere um número positivo',
								],
								label: 'Dinheiro',
							},
							{
								key: 'comment',
								type: 'textarea',
								max: 255,
								rules: [
									(val) => (val && val.length > 0) || 'Campo obrigatório',
								],
								label: 'Comentário',
							},
						],
						buttonLabel: 'Depositar',
						nuiType: 'depositMoney',
						additionalData: {
							accountId: accountId,
						},
					})
					.onOk((data) => {
						let account = this.data.accounts.find(
							(element) => element.id == accountId
						);

						this.$set(account, 'money', account.money + Number(data.money));
						console.log(data, account);

						// this.$set(this.data.accounts[index], 'money', {});
						// this.$set(this.charactersData, this.currentItem, {});
						// this.$set(this.charactersData, this.currentItem, {});
					})
					.onDismiss(() => {
						this.isUsingMenu = false;
					});

				// (val && Number(val) < 0) ||
				// 'Insere um número positivo.',
			},
		},
		render() {
			return (
				<transition
					appear
					enter-active-class='animated fadeIn'
					leave-active-class='animated fadeOut'
				>
					<div class='banking'>
						<div class='side-menu'>
							<div class='header'>
								<span>Banco de</span>
								<span>Los Santos</span>
							</div>
							<div class='accounts'>
								{this.data.accounts.map((account, index) => {
									return (
										<div
											class={`account ${
												this.currentAccount == index ? 'selected' : ''
											}`}
										>
											<div class='information'>
												<span class='name'>
													{account.name + ' | ' + account.id}
												</span>
												<span class='type'>{account.type}</span>
												<span class='owner'>{account.owner_name}</span>
												<span class='money'>{account.money + '.00€'}</span>
											</div>
											<div class='actions'>
												<q-btn
													dark
													dense
													color='grey-9'
													label='Depositar'
													size='11px'
													padding='0 5px'
													onClick={() => this.depositMoney(account.id)}
												/>
												<q-btn
													dark
													dense
													color='warning'
													label='Retirar'
													size='11px'
													padding='0 5px'
												/>
												<q-btn
													dark
													dense
													color='primary'
													label='Transferir'
													size='11px'
													padding='0 5px'
												/>
											</div>
										</div>
									);
								})}
							</div>
						</div>
						<div class='content'>
							<div class='transactions'>
								{this.data.transactions.map((transaction) => {
									let transactionState =
										transaction.receiver_id ==
										this.data.accounts[this.currentAccount].id;

									return (
										<div class='transaction'>
											<div class='header'>
												<span class='account'>
													{transaction.receiver_name +
														' | ' +
														transaction.receiver_id}
												</span>
												<span class='id'>{transaction.id}</span>
											</div>
											<div class='information'>
												<div class='details'>
													<span class='time'>
														{convertTime(transaction.time)}
													</span>
													<span>{transaction.sender_fullname}</span>
												</div>
												<span
													class={`money ${transactionState ? 'add' : 'remove'}`}
												>
													{transaction.money + '.00€'}
												</span>
												<div class='details'>
													<span class='account'>{transaction.sender_id}</span>
													<span>{transaction.sender_name}</span>
												</div>
											</div>
											<div class='footer'>
												<span>Mensagem: </span>
												<span>{transaction.comment}</span>
											</div>
										</div>
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
	@import './banking.scss';
</style>
