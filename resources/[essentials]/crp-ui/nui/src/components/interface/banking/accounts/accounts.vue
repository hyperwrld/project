<script>
	export default {
		name: 'accounts',
		props: {
			isWaiting: Boolean,
			characterId: Number,
			value: Number,
			accounts: Array,
		},
		data() {
			return {
				accountId: this.accounts[0].id,
			};
		},
		methods: {
			changeAccount: function(accountId) {
				if (this.isWaiting)
					return this.$q.notify({
						type: 'negative',
						timeout: 2500,
						message: 'Não é possível concluir essa ação no momento.',
					});

				let index = this.accounts.findIndex(
					(account) => account.id == accountId
				);

				if (index != this.value) {
					this.accountId = accountId;

					this.$emit('input', index);
				}
			},
		},
		render() {
			return (
				<div class='accounts'>
					<div class='category'>
						<span class='title'>Contas Pessoais</span>
						<div class='list'>
							{this.accounts
								.filter((acc) => acc.owner == this.characterId)
								.map((account) => {
									return (
										<div
											class={`account ${
												this.accountId == account.id ? 'selected' : ''
											}`}
											onClick={() => this.changeAccount(account.id)}
										>
											<span class='name'>{account.name}</span>
											<span>${account.money.toFixed(2)}</span>
										</div>
									);
								})}
						</div>
					</div>
					<div class='category'>
						<span class='title'>Contas Partilhadas</span>
						<div class='list'>
							{this.accounts
								.filter((acc) => acc.owner != this.characterId)
								.map((account) => {
									return (
										<div
											class={`account ${
												this.accountId == account.id ? 'selected' : ''
											}`}
											onClick={() => this.changeAccount(account.id)}
										>
											<span class='name'>{account.name}</span>
											<span>${account.money.toFixed(2)}</span>
										</div>
									);
								})}
						</div>
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './accounts.scss';
</style>
