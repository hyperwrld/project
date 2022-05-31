<script>
	import { mapGetters } from 'vuex';
	import { fragment, convertTime } from './../../../../../utils/lib.js';

	import dialogs from './../../modules/dialogs/dialogs.js';

	export default {
		name: 'history',
		computed: {
			...mapGetters('history', {
				data: 'getData',
			}),
		},
		data() {
			return {
				searchInput: '',
			};
		},
		methods: {
			filterItems: function() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.data;
				}

				if (isNaN(this.searchInput)) {
					return this.data.filter(
						(c) => c.name.toLowerCase().indexOf(search) > -1
					);
				}

				return this.data.filter(
					(c) =>
						c.name
							.toString()
							.toLowerCase()
							.indexOf(search) > -1
				);
			},
			callNumber: function(contactNumber) {
				if (contactNumber) {
					return;
				}

				dialogs
					.createDialog({
						attach: '.history',
						title: 'Telefonar',
						choices: [
							{
								key: 'number',
								type: 'number',
								label: 'Número',
								rules: [
									(val) => (val && val.length > 0) || 'Campo obrigatório',
									(val) =>
										(val && val.length <= 9) ||
										'Insere um número com 9 caracteres',
								],
							},
						],
						buttonLabel: 'Chamar',
						nuiType: 'callNumber',
					})
					.then((response) => {
						if (response) {
							console.log('ll');
						}
					});
			},
			sendMessage: function(contactNumber) {
				dialogs
					.createDialog({
						attach: '.history',
						title: 'Enviar Mensagem',
						choices: [
							{
								key: 'message',
								type: 'textarea',
								max: 255,
								label: 'Mensagem',
								rules: [
									(val) => (val && val.length > 0) || 'Campo obrigatório',
								],
							},
						],
						buttonLabel: 'Enviar',
						nuiType: 'sendMessage',
						data: { number: contactNumber },
					})
					.then((response) => {
						if (response) {
							console.log('ll');
						}
					});
			},
			addContact: function() {
				dialogs
					.createDialog({
						attach: '.history',
						title: 'Adicionar contato',
						choices: [
							{
								key: 'name',
								type: 'text',
								max: 20,
								label: 'Nome',
								rules: [
									(val) => (val && val.length > 0) || 'Campo obrigatório',
								],
							},
							{
								key: 'number',
								type: 'number',
								label: 'Número',
								rules: [
									(val) => (val && val.length > 0) || 'Campo obrigatório',
									(val) =>
										(val && val.length <= 9) ||
										'Insere um número com 9 caracteres',
								],
							},
						],
						buttonLabel: 'Adicionar',
						nuiType: 'addContact',
					})
					.then((response) => {
						if (response) {
							console.log('ll');
						}
					});
			},
		},
		render() {
			const isNotEmpty = this.filterItems().length > 0 ? true : false;

			return (
				<div class='history'>
					<q-toolbar>
						<q-input
							v-model={this.searchInput}
							debounce='500'
							filled
							placeholder='Procurar...'
							dark
							dense
						>
							<template slot='append'>
								<q-icon name='fas fa-search' />
							</template>
						</q-input>
						<q-icon name='fas fa-phone-alt' onClick={() => this.callNumber()}>
							<q-tooltip
								anchor='center left'
								self='center right'
								transition-show='scale'
								transition-hide='scale'
								offset={[10, 10]}
								content-style={{
									backgroundColor: 'rgba(97, 97, 97, 0.9)',
									padding: '2px 5px',
								}}
							>
								Chamar
							</q-tooltip>
						</q-icon>
					</q-toolbar>
					<div class={`content ${isNotEmpty ? '' : 'empty'}`}>
						{isNotEmpty ? (
							<q-list dense dark>
								{this.filterItems().map((call) => {
									return (
										<q-expansion-item
											icon={`fas fa-phone-alt state ${
												call.state ? 'incoming' : ''
											}`}
											label={call.name.toString()}
											caption={convertTime(call.time)}
											group='history'
											dark
										>
											<q-card dark>
												<q-card-actions align='around'>
													<q-icon
														name='fas fa-phone-alt'
														onClick={() => this.callNumber(call.number)}
													>
														<q-tooltip
															anchor='bottom middle'
															self='top middle'
															transition-show='scale'
															transition-hide='scale'
															offset={[10, 10]}
															content-style={{
																backgroundColor: 'rgba(97, 97, 97, 0.9)',
																padding: '2px 5px',
															}}
														>
															Telefonar
														</q-tooltip>
													</q-icon>
													<q-icon
														name='fas fa-comment-alt'
														onClick={() => this.sendMessage(call.number)}
													>
														<q-tooltip
															anchor='bottom middle'
															self='top middle'
															transition-show='scale'
															transition-hide='scale'
															offset={[10, 10]}
															content-style={{
																backgroundColor: 'rgba(97, 97, 97, 0.9)',
																padding: '2px 5px',
															}}
														>
															Mandar mensagem
														</q-tooltip>
													</q-icon>
													{!isNaN(call.name) && (
														<q-icon
															name='fas fa-user-plus'
															onClick={() => this.addContact()}
														>
															<q-tooltip
																anchor='bottom middle'
																self='top middle'
																transition-show='scale'
																transition-hide='scale'
																offset={[10, 10]}
																content-style={{
																	backgroundColor: 'rgba(97, 97, 97, 0.9)',
																	padding: '2px 5px',
																}}
															>
																Adicionar contato
															</q-tooltip>
														</q-icon>
													)}
												</q-card-actions>
											</q-card>
										</q-expansion-item>
									);
								})}
							</q-list>
						) : (
							<fragment>
								<q-icon name='fas fa-sad-tear' />
								<span>Não foi encontrada nenhuma mensagem.</span>
							</fragment>
						)}
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './history.scss';
</style>
