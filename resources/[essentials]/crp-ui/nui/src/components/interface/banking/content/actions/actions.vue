<script>
	import { fragment, send } from './../../../../../utils/lib';

	export default {
		name: 'actions',
		props: {
			isLoading: Boolean,
			isWaiting: Boolean,
			characterId: Number,
			account: Object,
		},
		data() {
			return {
				currentTab: 'deposit',
				quantity: undefined,
				iban: undefined,
				description: undefined,
			};
		},
		methods: {
			depositMoney: function(money, description) {
				if (this.isLoading || this.isWaiting)
					return this.$q.notify({
						type: 'negative',
						timeout: 1500,
						message: 'Não é possível concluir essa ação no momento',
					});

				this.$store.dispatch('banking/setWaitingState', true);

				send('depositMoney', {
					accountId: this.account.id,
					money: money,
					description: description,
				}).then((data) => {
					if (data.state) {
						this.$set(
							this.account,
							'money',
							this.account.money + Number(money)
						);

						this.$store.dispatch('banking/addTransaction', data.transaction);
					}

					this.$q.notify({
						type: data.state ? 'positive' : 'negative',
						timeout: 1000,
						message: data.message
							? data.message
							: 'Ocorreu um erro, se este erro persistir contacte um administrador.',
					});

					setTimeout(() => {
						this.$store.dispatch('banking/setWaitingState', false);

						if (data.state) {
							this.quantity = undefined;
							this.description = undefined;
						}
					}, 1500);
				});
			},
			withdrawMoney: function(money, description) {
				if (this.isLoading || this.isWaiting)
					return this.$q.notify({
						type: 'negative',
						timeout: 1500,
						message: 'Não é possível concluir essa ação no momento',
					});

				this.$store.dispatch('banking/setWaitingState', true);

				send('withdrawMoney', {
					accountId: this.account.id,
					money: money,
					description: description,
				}).then((data) => {
					if (data.state) {
						this.$set(
							this.account,
							'money',
							this.account.money - Number(money)
						);

						this.$store.dispatch('banking/addTransaction', data.transaction);
					}

					this.$q.notify({
						type: data.state ? 'positive' : 'negative',
						timeout: 1000,
						message: data.message
							? data.message
							: 'Ocorreu um erro, se este erro persistir contacte um administrador.',
					});

					setTimeout(() => {
						this.$store.dispatch('banking/setWaitingState', false);

						if (data.state) {
							this.quantity = undefined;
							this.description = undefined;
						}
					}, 1500);
				});
			},
			transferMoney: function(money, iban, description) {
				if (this.isLoading || this.isWaiting)
					return this.$q.notify({
						type: 'negative',
						timeout: 1500,
						message: 'Não é possível concluir essa ação no momento',
					});

				this.$store.dispatch('banking/setWaitingState', true);

				send('transferMoney', {
					accountId: this.account.id,
					money: money,
					iban: iban,
					description: description,
				}).then((data) => {
					if (data.state) {
						this.$set(
							this.account,
							'money',
							this.account.money - Number(money)
						);

						this.$store.dispatch('banking/addTransaction', data.transaction);
					}

					this.$q.notify({
						type: data.state ? 'positive' : 'negative',
						timeout: 1000,
						message: data.message
							? data.message
							: 'Ocorreu um erro, se este erro persistir contacte um administrador.',
					});

					setTimeout(() => {
						this.$store.dispatch('banking/setWaitingState', false);

						if (data.state) {
							this.quantity = undefined;
							this.iban = undefined;
							this.description = undefined;
						}
					}, 1500);
				});
			},
		},
		watch: {
			currentTab: function() {
				this.quantity = undefined;
				this.iban = undefined;
				this.description = undefined;
			},
		},
		render() {
			const quantityRules = [
				(val) => (val && val.length > 0) || 'Campo obrigatório',
				(val) => (val && Number(val) > 0) || 'Insira um valor positivo',
				(val) =>
					(val && Number(val) <= 999999) || 'Insira um valor menor que 999,999',
			];

			return (
				<q-card class='actions'>
					<q-tabs
						dense
						dark
						inline-label
						class='text-grey'
						active-color='primary'
						indicator-color='primary'
						align='justify'
						v-model={this.currentTab}
					>
						<q-tab
							name='deposit'
							icon='fas fa-piggy-bank'
							label='Depositar'
							disable={this.isWaiting && this.currentTab != 'deposit'}
						></q-tab>
						{(this.account.withdraw ||
							this.account.owner == this.characterId) && (
							<fragment>
								<q-tab
									name='withdraw'
									icon='fas fa-money-bill-wave'
									label='Levantar'
									disable={this.isWaiting && this.currentTab != 'withdraw'}
								></q-tab>
								<q-tab
									name='transfer'
									icon='fas fa-donate'
									label='Transferir'
									disable={this.isWaiting && this.currentTab != 'transfer'}
								></q-tab>
							</fragment>
						)}
					</q-tabs>
					<q-tab-panels v-model={this.currentTab} animated>
						<q-tab-panel name='deposit'>
							<q-form
								onSubmit={() =>
									this.depositMoney(this.quantity, this.description)
								}
							>
								<q-input
									v-model={this.quantity}
									type='number'
									dense
									standout
									dark
									no-error-icon
									lazy-rules='ondemand'
									label='Montante'
									rules={quantityRules}
									class='quantity'
								/>
								<q-input
									v-model={this.description}
									type='textarea'
									dense
									standout
									dark
									hide-bottom-space
									no-error-icon
									counter
									lazy-rules='ondemand'
									label='Descrição'
									maxlength='255'
									input-style='max-height: 5vh; min-height: 5vh'
									rules={[
										(val) => (val && val.length > 0) || 'Campo obrigatório',
									]}
									class='description'
								/>
								<q-btn
									type='submit'
									color='green-8'
									icon='fas fa-piggy-bank'
									label='Depositar'
									loading={this.isWaiting}
								></q-btn>
							</q-form>
						</q-tab-panel>
						<q-tab-panel name='withdraw'>
							<q-form
								onSubmit={() =>
									this.withdrawMoney(this.quantity, this.description)
								}
							>
								<q-input
									v-model={this.quantity}
									type='number'
									dense
									standout
									dark
									no-error-icon
									lazy-rules='ondemand'
									label='Montante'
									rules={quantityRules}
									class='quantity'
								/>
								<q-input
									v-model={this.description}
									type='textarea'
									dense
									standout
									dark
									hide-bottom-space
									no-error-icon
									counter
									lazy-rules='ondemand'
									label='Descrição'
									maxlength='255'
									input-style='max-height: 5vh; min-height: 5vh'
									rules={[
										(val) => (val && val.length > 0) || 'Campo obrigatório',
									]}
									class='description'
								/>
								<q-btn
									type='submit'
									color='amber-14'
									icon='fas fa-money-bill'
									label='Levantar'
									loading={this.isWaiting}
								></q-btn>
							</q-form>
						</q-tab-panel>
						<q-tab-panel name='transfer'>
							<q-form
								class='transfer'
								onSubmit={() =>
									this.transferMoney(this.quantity, this.iban, this.description)
								}
							>
								<q-input
									v-model={this.iban}
									type='number'
									dense
									standout
									dark
									no-error-icon
									lazy-rules='ondemand'
									label='IBAN'
									rules={[
										(val) => (val && val.length > 0) || 'Campo obrigatório',
										(val) =>
											(val && Number(val) > 0) || 'Insira um número positivo',
									]}
									class='iban'
								/>
								<q-input
									v-model={this.quantity}
									type='number'
									dense
									standout
									dark
									no-error-icon
									lazy-rules='ondemand'
									label='Montante'
									rules={quantityRules}
									class='quantity'
								/>
								<q-input
									v-model={this.description}
									type='textarea'
									dense
									standout
									dark
									hide-bottom-space
									no-error-icon
									counter
									lazy-rules='ondemand'
									label='Descrição'
									maxlength='255'
									input-style='max-height: 5vh; min-height: 5vh'
									rules={[
										(val) => (val && val.length > 0) || 'Campo obrigatório',
									]}
									class='description'
								/>
								<q-btn
									type='submit'
									color='primary'
									icon='fas fa-donate'
									label='Transferir'
									loading={this.isWaiting}
								></q-btn>
							</q-form>
						</q-tab-panel>
					</q-tab-panels>
				</q-card>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './actions.scss';
</style>
