<script>
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faSignOutAlt } from '@fortawesome/free-solid-svg-icons';

	import dialogs from './dialogs/dialogs.js';

	import { convertTime } from './../../../utils/lib.js';
	import { mapGetters } from 'vuex';

	library.add(faSignOutAlt);

	export default {
		name: 'banking',
		props: ['closeMenu'],
		data () {
			return {
				currentAccount: 0, isLoading: false, isUsingMenu: false
			}
		},
		computed: {
			...mapGetters('banking', {
				data: 'getData'
			})
		},
		methods: {
			getReceiver: function(data) {
				var otherId = data.receiver_id, otherName = data.receiver_name, currentId = data.sender_id, currentName = data.sender_name, receivedMoney = false;

                if (data.receiver_id == this.data.accounts[this.currentAccount].id) {
                    otherId = data.sender_id, otherName = data.sender_name, currentId = data.receiver_id, currentName = data.receiver_name, receivedMoney = true;
				}

				return [otherId, otherName, currentId, currentName, receivedMoney];
            },
			depositMoney() {
				console.log('sdsddssdds')
				dialogs.createDialog({
					title: 'Depositar dinheiro',
					choices: [
						{ key: 'name', type: 'text', min: 1, max: 20, placeholder: 'Nome', errorText: 'Escolha um nome com o máximo de 20 caracteres.' },
						{ key: 'number', type: 'number', min: 9, max: 9, placeholder: 'Número', errorText: 'Insira um número com 9 números.' }
					],
					sendText: 'Adicionar', nuiType: 'addContact'
				})
			}
		},
		render() {
			let data = this.data;

			console.log(data)

			return (
				<transition appear name='fade'>
					<div class='banking'>
						<div class='accounts'>
							{ data.accounts.map((account, index) => {
								return (
									<div class={`account ${ (index == this.currentAccount) ? 'selected' : '' }`}>
										<div class='information'>
											<span class='data'>{ account.name + ' | ' + account.id }</span>
											<span class='type'>{ account.type + ' / ' + account.owner_name }</span>
											<div class='money'>
												{ account.money + ',00€'}
											</div>
										</div>
										<div class='buttons'>
											<button>RETIRAR</button>
											<button onClick={ this.depositMoney }>DEPOSITAR</button>
											<button>TRANSFERIR</button>
										</div>
									</div>
								)
							})}
						</div>
						<div class='transactions'>
							{ data.transactions.map((transaction) => {
								var [otherId, otherName, currentId, currentName, receivedMoney] = this.getReceiver(transaction);

								return (
									<div class='border'>
										<div class='transaction'>
											<div class='information'>
												<span class='account'>{ otherName + ' / ' + otherId }</span>
												<span class='id'>{ transaction.id }</span>
											</div>
											<div class='data'>
												<div>
													<span class='time'>{ convertTime(transaction.time) }</span>
													<span>{ transaction.sender_fullname }</span>
												</div>
												<span class={ `money ${ receivedMoney ? '' : 'removed'}` }>
													{ (receivedMoney ? '+' : '-') + transaction.money + ',00€' }
												</span>
												<div class='receiver'>
													<span class='account'>{ currentId }</span>
													<span>{ currentName }</span>
												</div>
											</div>
											{ transaction.comment &&
												<div class='message'>
													Mensagem: <br/> { transaction.comment }
												</div>
											}
										</div>
									</div>
								)
							})}
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