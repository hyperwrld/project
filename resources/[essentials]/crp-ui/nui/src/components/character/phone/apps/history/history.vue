<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faPhoneAlt, faCommentAlt, faUser, faCar, faAd, faCog, faMapPin, faCamera } from '@fortawesome/free-solid-svg-icons';
	import { faTwitter } from '@fortawesome/free-brands-svg-icons';

	import { fragment, convertTime } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';

	library.add(faPhoneAlt, faCommentAlt, faUser, faCar, faTwitter, faAd, faCog, faMapPin, faCamera);

	export default {
		name: 'history',
		data() {
			return {
				searchInput: ''
			}
		},
		computed: {
			...mapGetters('history', {
				history: 'getHistory'
			})
		},
		methods: {
			filterItems() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.history;
				}

				if (isNaN(this.searchInput)) {
					return this.history.filter(c => c.name.toLowerCase().indexOf(search) > -1);
				} else {
					return this.history.filter(c => c.name.toString().toLowerCase().indexOf(search) > -1);
				}
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
			addContact: function(contactNumber) {
				dialogs.createDialog({
					attach: '.list', title: 'Adicionar contato',
					choices: [
						{ key: 'name', type: 'text', min: 1, max: 20, placeholder: 'Nome', errorText: 'Escolha um nome com o máximo de 20 caracteres.' }
					],
					sendText: 'Adicionar', nuiType: 'addContact', data: { number: contactNumber }
				}).then(response => {
					// if (response) {
						// let found = this.contacts.find(element => element.id == contactId);

						// found.name = response.choiceData.name, found.number = Number(response.choiceData.number);
					// }
      			})
			}
		},
		render(h) {
			const isNotEmpty = this.filterItems().length > 0 ? true : false;

			return (
				<div class='history'>
					<div class='top'>
					    <div class='search-wrapper'>
							<input type='text' v-model={ this.searchInput } placeholder='Procurar...'/>
							<font-awesome-icon icon={ ['fas', 'search'] }/>
						</div>
						<font-awesome-icon icon={ ['fas', 'phone-alt'] }/>
					</div>
					<div class={`list ${ isNotEmpty ? '' : 'empty'}`}>
						{ isNotEmpty ?
							<v-expansion-panels flat accordion>
								{ this.filterItems().map((call, index) => {
									return (
										<v-expansion-panel>
											<v-expansion-panel-header>
												<font-awesome-icon icon={ ['fas', 'phone-alt'] } class={ call.isIncoming ? 'incoming' : '' }/>
												<div class='name'>
													{ call.name }
												</div>
												<div class='time'>
													{ convertTime(call.time) }
												</div>
											</v-expansion-panel-header>
											<v-expansion-panel-content>
												<font-awesome-icon icon={ ['fas', 'phone-alt'] } onClick={ () => this.addContact(call.number) }/>
												<font-awesome-icon icon={ ['fas', 'comment-alt'] } onClick={ () => this.sendMessage(call.number) }/>
												{ !isNaN(call.name) &&
													<font-awesome-icon icon={ ['fas', 'user-plus'] }/>
												}
											</v-expansion-panel-content>
										</v-expansion-panel>
									)
								})}
            				</v-expansion-panels>
							:
							<fragment>
								<font-awesome-icon icon={ ['fas', 'sad-tear'] }/>
								<span>Não foi encontrado nenhum registo de chamadas.</span>
							</fragment>
						}
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './history.scss';
</style>