<template>
    <v-container fluid>
        <div class='top-bar'>
            <div class='search-wrapper'>
                <input type='text' v-model='searchInput' placeholder='Procurar...'/>
                <font-awesome-icon :icon='["fas", "search"]'></font-awesome-icon>
            </div>
            <font-awesome-icon :icon='["fas", "phone-alt"]' @click='callNumber'></font-awesome-icon>
        </div>
        <div class='history-list'>
            <v-expansion-panels flat accordion v-if='filterItems().length > 0'>
                <v-expansion-panel class='history-square' v-for='call in filterItems()' :key='call.name'>
                    <v-expansion-panel-header>
                        <div class='number-info'>
                            <div class='name'>{{ call.name }}</div>
                            <div class='time'>{{ convertTime(call.time) }}</div>
                        </div>
                    </v-expansion-panel-header>
                    <v-expansion-panel-content>
                        <font-awesome-icon :icon='["fas", "phone-alt"]'></font-awesome-icon>
                        <font-awesome-icon :icon='["fas", "comment-alt"]' @click='sendMessage(call.number)'></font-awesome-icon>
                        <font-awesome-icon v-if='!isNaN(call.name)' :icon='["fas", "user-plus"]' @click='addContact(call.number)'></font-awesome-icon>
                    </v-expansion-panel-content>
                </v-expansion-panel>
            </v-expansion-panels>
			<div v-else class='empty-list'>
				<font-awesome-icon :icon='["fas", "sad-tear"]'></font-awesome-icon>
				<span>Não foi encontrado nenhum registo de chamadas.</span>
			</div>
        </div>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';
	import { convertTime } from './../../../utils/lib.js';
	import dialogs from './../dialogs/dialogs.js';

    export default {
		name: 'history',
        data() {
            return {
				searchInput: ''
            }
        },
        computed: {
            ...mapGetters('phone', {
                callHistory: 'getCallHistory'
            })
        },
        methods: {
			sendMessage: function(contactNumber) {
				dialogs.createDialog({
					attach: '.history-list', title: 'Enviar Mensagem',
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
			addContact: function(contactNumber) {
				dialogs.createDialog({
					attach: '.history-list', title: 'Adicionar contato',
					choices: [
						{ key: 'name', type: 'text', min: 1, max: 20, placeholder: 'Nome', errorText: 'Escolha um nome com o máximo de 20 caracteres.' }
					],
					sendButton: 'Adicionar', nuiType: 'addContact', additionalData: { number: contactNumber }
				}).then(response => {
					// if (response) {
						// let found = this.contacts.find(element => element.id == contactId);

						// found.name = response.choiceData.name, found.number = Number(response.choiceData.number);
					// }
      			})
			},
            callNumber: function() {
                this.$store.dispatch('phone/setDialogStatus', { name: 'callNumber', status: true });
			},
			filterItems: function() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.callHistory;
				}

				if (isNaN(this.searchInput)) {
					return this.callHistory.filter(c => c.name.toLowerCase().indexOf(search) > -1);
				} else {
					return this.callHistory.filter(c => c.name.toString().toLowerCase().indexOf(search) > -1);
				}
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './history.scss';
</style>