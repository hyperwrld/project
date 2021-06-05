<script>
	import { mapGetters } from 'vuex';
	import { fragment, convertTime } from './../../../../../utils/lib.js';
	import { copyToClipboard } from 'quasar';

	import dialogs from './../../modules/dialogs/dialogs.js';

	export default {
		name: 'contacts',
		computed: {
			...mapGetters('contacts', {
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
			addContact: function() {
				dialogs
					.createDialog({
						attach: '.contacts',
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
							this.data.push({
								id: response.data.id,
								name: response.choiceData.name,
								number: Number(response.choiceData.number),
							});
						}
					});
			},
			sendMessage: function(contactNumber) {
				dialogs
					.createDialog({
						attach: '.contacts',
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
							this.$store.dispatch(
								'messages/setMessage',
								response.data.message
							);
						}
					});
			},
			editContact: function(contactId, contactName, contactNumber) {
				dialogs
					.createDialog({
						attach: '.contacts',
						title: 'Editar contato',
						choices: [
							{
								key: 'name',
								type: 'text',
								value: contactName,
								max: 20,
								label: 'Nome',
								rules: [
									(val) => (val && val.length > 0) || 'Campo obrigatório',
								],
							},
							{
								key: 'number',
								type: 'number',
								value: contactNumber,
								label: 'Número',
								rules: [
									(val) => (val && val.length > 0) || 'Campo obrigatório',
									(val) =>
										(val && val.length <= 9) ||
										'Insere um número com 9 caracteres',
								],
							},
						],
						sendText: 'Editar',
						nuiType: 'editContact',
						data: { id: contactId },
					})
					.then((response) => {
						if (response) {
							let found = this.data.find((element) => element.id == contactId);

							(found.name = response.choiceData.name),
								(found.number = Number(response.choiceData.number));
						}
					});
			},
			deleteContact: function(contactId) {
				dialogs
					.createDialog({
						attach: '.contacts',
						title: 'Apagar contato',
						sendText: 'Apagar',
						nuiType: 'deleteContact',
						data: { id: contactId },
					})
					.then((response) => {
						if (response) {
							let foundIndex = this.data.findIndex(
								(element) => element.id == contactId
							);

							this.data.splice(foundIndex, 1);
						}
					});
			},
			copyNumber: function(contactNumber) {
				copyToClipboard(contactNumber);
			},
		},
		render() {
			const isNotEmpty = this.filterItems().length > 0 ? true : false;

			return (
				<div class='contacts'>
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
						<q-icon name='fas fa-user-plus' onClick={() => this.addContact()}>
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
								Adicionar contato
							</q-tooltip>
						</q-icon>
					</q-toolbar>
					<div class={`content ${isNotEmpty ? '' : 'empty'}`}>
						{isNotEmpty ? (
							<q-list dense dark>
								{this.filterItems().map((contact) => {
									return (
										<q-expansion-item
											icon='fas fa-user-circle'
											label={contact.name}
											group='contacts'
											dark
										>
											<q-card dark>
												<q-card-actions align='around'>
													<q-icon name='fas fa-phone-alt'>
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
														onClick={() => this.sendMessage(contact.number)}
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
													<q-icon
														name='fas fa-user-edit'
														onClick={() =>
															this.editContact(
																contact.id,
																contact.name,
																contact.number
															)
														}
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
															Editar contato
														</q-tooltip>
													</q-icon>
													<q-icon
														name='fas fa-trash'
														onClick={() => this.deleteContact(contact.id)}
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
															Apagar contato
														</q-tooltip>
													</q-icon>
													<q-icon
														name='fas fa-clipboard'
														onClick={() => this.copyNumber(contact.number)}
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
															Copiar número
														</q-tooltip>
													</q-icon>
												</q-card-actions>
											</q-card>
										</q-expansion-item>
									);
								})}
							</q-list>
						) : (
							<fragment>
								<q-icon name='fas fa-sad-tear' />
								<span>Não foi encontrado nenhum contato.</span>
							</fragment>
						)}
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './contacts.scss';
</style>
