<template>
    <v-container fluid>
        <div class='top-bar'>
            <div class='search-wrapper'>
                <input type='text' v-model='searchInput' placeholder='Procurar...'/>
                <font-awesome-icon :icon='["fas", "search"]'></font-awesome-icon>
            </div>
            <font-awesome-icon :icon='["fas", "user-plus"]' @click='addContact'></font-awesome-icon>
        </div>
        <div class='contact-list'>
            <v-expansion-panels flat accordion v-if='filterItems().length > 0'>
                <v-expansion-panel class='contact-square' v-for='contact in filterItems()' :key='contact.name'>
                    <v-expansion-panel-header>
                        <div class='contact-info'>
							<div class='avatar'>
								<v-avatar v-bind:style='{ background: getContactColor((contact.name).substring(0, 2)) }' size='30'>
									<span>{{ (contact.name).substring(0, 2).toUpperCase() }}</span>
								</v-avatar>
							</div>
                            <div class='name'>{{ contact.name }}</div>
                        </div>
                    </v-expansion-panel-header>
                    <v-expansion-panel-content>
						<div class='phone-number'>
							{{ 'Telemóvel: ' + contact.number }}
						</div>
						<div class='buttons'>
							<font-awesome-icon :icon='["fas", "phone-alt"]'></font-awesome-icon>
							<font-awesome-icon :icon='["fas", "comment-alt"]' @click='sendMessage(contact.number)'></font-awesome-icon>
							<font-awesome-icon :icon='["fas", "user-edit"]' @click='editContact(contact.id, contact.name, contact.number)'></font-awesome-icon>
							<font-awesome-icon :icon='["fas", "trash"]' @click='deleteContact(contact.id)'></font-awesome-icon>
						</div>
                    </v-expansion-panel-content>
                </v-expansion-panel>
            </v-expansion-panels>
        	<div v-else class='empty-list'>
				<font-awesome-icon :icon='["fas", "sad-tear"]'></font-awesome-icon>
				<span>Não foi encontrado nenhum contato.</span>
			</div>
        </div>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faSearch, faUserPlus, faPhoneAlt, faCommentAlt, faUserEdit, faTrash, faSadTear } from '@fortawesome/free-solid-svg-icons';

	import dialogs from './../dialogs/dialogs.js';

	library.add(faSearch, faUserPlus, faPhoneAlt, faCommentAlt, faUserEdit, faTrash, faSadTear);

    export default {
        name: 'contacts',
        data() {
            return {
				searchInput: ''
            }
        },
        computed: {
            ...mapGetters('phone', {
				contacts: 'getContacts'
            })
        },
        methods: {
			addContact: function() {
				dialogs.createDialog({
					attach: '.contact-list', title: 'Adicionar contato',
					choices: [
						{ key: 'name', type: 'text', min: 1, max: 20, placeholder: 'Nome', errorText: 'Escolha um nome com o máximo de 20 caracteres.' },
						{ key: 'number', type: 'number', min: 9, max: 9, placeholder: 'Número', errorText: 'Insira um número com 9 números.' }
					],
					sendButton: 'Adicionar', nuiType: 'addContact'
				}).then(response => {
					if (response) {
						this.contacts.push({ id: response.data.id, name: response.choiceData.name, number: Number(response.choiceData.number) });
					}
      			})
			},
			sendMessage: function(contactNumber) {
				dialogs.createDialog({
					attach: '.contact-list', title: 'Enviar Mensagem',
					choices: [
						{ key: 'message', placeholder: 'Mensagem', errorText: 'Insira uma mensagem para mandar a um número.' }
					],
					sendButton: 'Enviar', nuiType: 'sendMessage', additionalData: { number: contactNumber }
				}).then(response => {
					// if (response) {
					// 	let found = this.contacts.find(element => element.id == contactId);

					// 	found.name = response.choiceData.name, found.number = Number(response.choiceData.number);
					// }
      			})
			},
			editContact: function(contactId, contactName, contactNumber) {
				dialogs.createDialog({
					attach: '.contact-list', title: 'Editar contato',
					choices: [
						{ key: 'name', type: 'text', value: contactName, min: 1, max: 20, placeholder: 'Nome', errorText: 'Escolha um nome com o máximo de 20 caracteres.' },
						{ key: 'number', type: 'number', value: contactNumber, min: 9, max: 9, placeholder: 'Número', errorText: 'Insira um número com 9 números.' }
					],
					sendButton: 'Editar', nuiType: 'editContact', additionalData: { id: contactId }
				}).then(response => {
					if (response) {
						let found = this.contacts.find(element => element.id == contactId);

						found.name = response.choiceData.name, found.number = Number(response.choiceData.number);
					}
      			})
			},
			deleteContact: function(contactId) {
				dialogs.createDialog({
					attach: '.contact-list', title: 'Remover contato',
					sendButton: 'Remover', nuiType: 'deleteContact', additionalData: { id: contactId }
				}).then(response => {
					if (response) {
						let foundIndex = this.contacts.findIndex(element => element.id == contactId);

						this.contacts.splice(foundIndex, 1);
					}
      			})
			},
			filterItems: function() {
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
			getContactColor: function(string) {
				var hash = 0;

    			for (var i = 0; i < string.length; i++) {
      				hash = string.charCodeAt(i) + ((hash << 5) - hash);
				}

    			return 'hsl(' + hash % 360 + ', 30%, 70%)';
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './contacts.scss';
</style>