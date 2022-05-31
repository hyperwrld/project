<script>
	import { fragment, convertTime } from '../../../../utils/lib';

	import actions from './actions/actions.vue';

	export default {
		name: 'content',
		props: {
			isLoading: Boolean,
			isWaiting: Boolean,
			characterId: Number,
			account: Object,
			transactions: Array,
		},
		components: {
			actions,
		},
		render() {
			return (
				<div class='content'>
					<div class='account_info'>
						<div class='info'>
							<span class='title'>IBAN |</span>
							{this.account.id}
						</div>
						<div class='info'>
							<span class='title'>Titular |</span>
							{this.account.owner_name}
						</div>
						<div class='info'>
							<span class='title'>Tipo de conta |</span>
							{this.account.type}
						</div>
					</div>
					<actions
						isLoading={this.isLoading}
						isWaiting={this.isWaiting}
						characterId={this.characterId}
						account={this.account}
					/>
					<div class='transactions'>
						<div class='title'>
							<q-icon name='fas fa-calendar-alt' />
							<span>Últimas Transações</span>
						</div>
						<div class='list'>
							<div class='subtitles'>
								<span>Transação</span>
								<span>Remetente</span>
								<span>Destinatário</span>
								<span>IBAN</span>
								<span>Valor</span>
								<span>Data</span>
							</div>
							{this.isLoading ? (
								<div class='inner loading'>
									<q-icon name='fas fa-circle-notch fa-spin' />
									Loading
								</div>
							) : (
								<transition-group
									appear
									enter-active-class='animated fadeInRight'
									leave-active-class='animated fadeOutRight'
									tag='div'
									class='inner'
								>
									{[...this.transactions].reverse().map((transaction) => {
										return (
											<q-expansion-item
												dark
												group='accounts'
												key={transaction.id}
											>
												<template slot='header'>
													<q-item-section>
														{transaction.type_name}
													</q-item-section>
													<q-item-section>
														{transaction.sender_name == null
															? transaction.sender_fullname
															: transaction.receiver_name != null
															? `${transaction.sender_name} (${transaction.sender_fullname})`
															: transaction.sender_name}
													</q-item-section>
													<q-item-section>
														{transaction.receiver_name != null
															? transaction.receiver_name
															: transaction.sender_fullname}
													</q-item-section>
													<q-item-section>
														{this.account.id == transaction.receiver_id
															? transaction.sender_id
															: transaction.receiver_id}
													</q-item-section>
													<q-item-section
														class={
															this.account.id == transaction.receiver_id
																? 'money_positive'
																: 'money_negative'
														}
													>
														${transaction.money.toFixed(2)}
													</q-item-section>
													<q-item-section>
														{convertTime(transaction.time)}
													</q-item-section>
												</template>
												<q-card>
													<q-card-section>
														<span class='caption'>Descrição |</span>
														{transaction.description}
													</q-card-section>
													<q-card-section>
														<span class='caption'>Transferência ID |</span>
														{transaction.id}
													</q-card-section>
												</q-card>
											</q-expansion-item>
										);
									})}
								</transition-group>
							)}
						</div>
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './content.scss';
</style>
