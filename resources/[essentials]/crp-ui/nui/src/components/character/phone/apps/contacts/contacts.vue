<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faCommentAlt, faPhoneAlt, faSadTear, faSearch, faTrash, faUserEdit, faUserPlus } from '@fortawesome/free-solid-svg-icons';

	import { fragment } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';

	library.add(faSearch, faUserPlus, faPhoneAlt, faCommentAlt, faUserEdit, faTrash, faSadTear);

	export default {
		name: 'contacts',
		data() {
			return {
				searchInput: ''
			}
		},
		computed: {
			...mapGetters('contacts', {
				contacts: 'getContacts'
			})
		},
		methods: {
			filterItems() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.contacts;
				}

				if (isNaN(this.searchInput)) {
					return this.contacts.filter(c => c.name.toLowerCase().indexOf(search) > -1);
				} else {
					return this.contacts.filter(c => c.name.toString().toLowerCase().indexOf(search) > -1);
				}
			},
			getContactColor(string) {
				var hash = 0;

    			for (var i = 0; i < string.length; i++) {
      				hash = string.charCodeAt(i) + ((hash << 5) - hash);
				}

    			return 'hsl(' + hash % 360 + ', 30%, 70%)';
			},
			addContact() {
				dialogs.createDialog({
					attach: '.list', title: 'Adicionar contato',
					choices: [
						{ key: 'name', type: 'text', min: 1, max: 20, placeholder: 'Nome', errorText: 'Escolha um nome com o máximo de 20 caracteres.' },
						{ key: 'number', type: 'number', min: 9, max: 9, placeholder: 'Número', errorText: 'Insira um número com 9 números.' }
					],
					sendText: 'Adicionar', nuiType: 'addContact'
				}).then(response => {
					if (response) {
						this.contacts.push({ id: response.data.id, name: response.choiceData.name, number: Number(response.choiceData.number) });
					}
      			})
			},
			sendMessage(contactNumber) {
				dialogs.createDialog({
					attach: '.list', title: 'Enviar Mensagem',
					choices: [
						{ key: 'message', placeholder: 'Mensagem', errorText: 'Insira uma mensagem para mandar a um número.' }
					],
					sendText: 'Enviar', nuiType: 'sendMessage', data: { number: contactNumber }
				}).then(response => {
					// if (response) {
					// 	let found = this.contacts.find(element => element.id == contactId);

					// 	found.name = response.choiceData.name, found.number = Number(response.choiceData.number);
					// }
      			})
			},
			editContact(contactId, contactName, contactNumber) {
				dialogs.createDialog({
					attach: '.contact-list', title: 'Editar contato',
					choices: [
						{ key: 'name', type: 'text', value: contactName, min: 1, max: 20, placeholder: 'Nome', errorText: 'Escolha um nome com o máximo de 20 caracteres.' },
						{ key: 'number', type: 'number', value: contactNumber, min: 9, max: 9, placeholder: 'Número', errorText: 'Insira um número com 9 números.' }
					],
					sendText: 'Editar', nuiType: 'editContact', data: { id: contactId }
				}).then(response => {
					if (response) {
						let found = this.contacts.find(element => element.id == contactId);

						found.name = response.choiceData.name, found.number = Number(response.choiceData.number);
					}
      			})
			},
			deleteContact(contactId) {
				dialogs.createDialog({
					attach: '.contact-list', title: 'Remover contato', sendText: 'Remover', nuiType: 'deleteContact', data: { id: contactId }
				}).then(response => {
					if (response) {
						let foundIndex = this.contacts.findIndex(element => element.id == contactId);

						this.contacts.splice(foundIndex, 1);
					}
      			})
			}
		},
		render(h) {
			const isNotEmpty = this.filterItems().length > 0 ? true : false;

			return (
				<div class='contacts'>
					<div class='top'>
					    <div class='search-wrapper'>
							<input type='text' v-model={ this.searchInput } placeholder='Procurar...'/>
							<font-awesome-icon icon={ ['fas', 'search'] }/>
						</div>
						<font-awesome-icon icon={ ['fas', 'user-plus'] } onClick={ this.addContact }/>
					</div>
					<div class={`list ${ isNotEmpty ? '' : 'empty'}`}>
						{ isNotEmpty ?
							<v-expansion-panels flat accordion>
								{ this.filterItems().map((contact, index) => {
									return (
										<v-expansion-panel>
											<v-expansion-panel-header>
												<v-avatar style={{ background: this.getContactColor((contact.name).substring(0, 2)) }} size='30'>
													<span>{ (contact.name).substring(0, 2).toUpperCase() }</span>
												</v-avatar>
												<span>{ contact.name }</span>
											</v-expansion-panel-header>
											<v-expansion-panel-content>
												<span>{ 'Telemóvel: ' + contact.number }</span>
												<div class='buttons'>
													<font-awesome-icon icon={ ['fas', 'phone-alt'] }/>
													<font-awesome-icon icon={ ['fas', 'comment-alt'] } onClick={ () => this.sendMessage(contact.number) }/>
													<font-awesome-icon icon={ ['fas', 'user-edit'] } onClick={ () => this.editContact(contact.id, contact.name, contact.number) }/>
													<font-awesome-icon icon={ ['fas', 'trash'] } onClick ={ () => this.deleteContact(contact.id)}/>
												</div>
											</v-expansion-panel-content>
										</v-expansion-panel>
									)
								})}
            				</v-expansion-panels>
							:
							<fragment>
								<font-awesome-icon icon={ ['fas', 'sad-tear'] }/>
								<span>Não foi encontrado nenhum contato.</span>
							</fragment>
						}
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './contacts.scss';
</style>