<script>
	import { mapGetters } from 'vuex';
	import { convertTime, fragment, send } from '../../../utils/lib';

	import accounts from './accounts/accounts.vue';
	import content from './content/content.vue';

	export default {
		name: 'banking',
		props: ['closeMenu'],
		components: {
			accounts,
			content,
		},
		data() {
			return {
				currentAccount: 0,
				isLoading: false,
				currentTab: 'deposit',
			};
		},
		computed: {
			...mapGetters('banking', {
				data: 'getData',
			}),
		},
		methods: {
			closeEvent: function(event) {
				if (event.keyCode == 27) {
					this.closeMenu({
						appName: 'banking',
					});

					event.preventDefault();
				}
			},
		},
		watch: {
			currentAccount: function(newAccount) {
				this.isLoading = true;

				send('fetchTransactions', this.data.accounts[newAccount].id).then(
					(data) => {
						if (data.state) this.data.transactions = data.transactions;

						setTimeout(() => {
							this.isLoading = false;
						}, 1000);
					}
				);
			},
		},
		destroyed() {
			window.removeEventListener('keydown', this.closeEvent, false);
		},
		mounted() {
			window.addEventListener('keydown', this.closeEvent, false);
		},
		render() {
			const data = this.data;

			return (
				<transition
					appear
					enter-active-class='animated fadeIn'
					leave-active-class='animated fadeOut'
				>
					<div class='banking'>
						<div class='side-menu'>
							<div class='bank'>
								<q-icon name='fab fa-empire' />
								<span class='name'>Los Santos Bank</span>
							</div>
							<q-icon
								name='fas fa-times'
								onClick={() =>
									this.closeMenu({
										appName: 'banking',
									})
								}
							>
								<q-tooltip
									anchor='top middle'
									self='bottom middle'
									transition-show='scale'
									transition-hide='scale'
									offset={[10, 10]}
									content-style={{
										backgroundColor: 'rgba(97, 97, 97, 0.9)',
										padding: '2px 5px',
									}}
								>
									Fechar
								</q-tooltip>
							</q-icon>
						</div>
						<div class='menu'>
							<div class='header'>
								<span>
									Bem-vindo <b>{data.firstName}</b>, atualmente tens
									<b> ${data.money.toFixed(2)}</b> na carteira.
								</span>
								<div class='information'>
									<span>{data.firstName + ' ' + data.lastName}</span>
									<q-icon name='far fa-user' />
									<span>{data.characterId}</span>
								</div>
							</div>
							<div class='inner'>
								<accounts
									v-model={this.currentAccount}
									isWaiting={data.isWaiting}
									characterId={data.characterId}
									accounts={data.accounts}
								/>
								<content
									isLoading={this.isLoading}
									isWaiting={data.isWaiting}
									characterId={data.characterId}
									account={data.accounts[this.currentAccount]}
									transactions={data.transactions}
								/>
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
