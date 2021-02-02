<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faUser, faSearch, faEnvelope, faSadTear } from '@fortawesome/free-solid-svg-icons';

	import { fragment, convertTime, send } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';

	library.add(faSearch, faEnvelope, faUser, faSadTear);

	export default {
		name: 'messages',
		data() {
			return {
				searchInput: ''
			}
		},
		computed: {
			...mapGetters('messages', {
				lastMessages: 'getLastMessages'
			})
		},
		methods: {
			filterItems: function() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.lastMessages;
				}

				if (isNaN(this.searchInput)) {
					return this.lastMessages.filter(c => c.name.toLowerCase().indexOf(search) > -1);
				} else {
					return this.lastMessages.filter(c => c.name.toString().toLowerCase().indexOf(search) > -1);
				}
			},
			getMessageColor: function(string) {
				var hash = 0;

				for (var i = 0; i < string.length; i++) {
					hash = string.charCodeAt(i) + ((hash << 5) - hash);
				}

				return 'hsl(' + hash % 360 + ', 30%, 70%)';
			},
			openMessage: function(name, number) {
				send('getMessages', number).then(data => {
					this.$store.dispatch('messages/setMessages', data.messages);

					this.$router.push({ name: 'message', params: { data: { name: name, number: number }}});
				});
			},
			sendMessage: function() {
				dialogs.createDialog({
					attach: '.list', title: 'Enviar Mensagem',
					choices: [
						{ key: 'number', type: 'number', placeholder: 'Número', max: 9, errorText: 'Insira um número com 9 números.' },
						{ key: 'message', placeholder: 'Mensagem', errorText: 'Insira uma mensagem para mandar a um número.' }
					],
					sendText: 'Enviar', nuiType: 'sendMessage'
				}).then(response => {
					if (response) {
						this.$store.dispatch('messages/setMessage', response.data.message);
					}
				})
			}
		},
		render() {
			const isNotEmpty = this.filterItems().length > 0 ? true : false;

			return (
				<div class='messages'>
					<div class='top'>
						<div class='search-wrapper'>
							<input type='text' v-model={ this.searchInput } placeholder='Procurar...'/>
							<font-awesome-icon icon={ ['fas', 'search'] }/>
						</div>
						<font-awesome-icon icon={ ['fas', 'envelope'] } onClick={ this.sendMessage }/>
					</div>
					<div class={`list ${ isNotEmpty ? '' : 'empty'}`}>
						{ isNotEmpty ?
							<fragment>
								{ this.filterItems().map((message) => {
									return (
										<div class='message' onClick={ () => this.openMessage(message.name, message.number)}>
											<v-avatar style={{ background: this.getMessageColor((message.name).toString().substring(0, 2)) }} size='30'>
												{ isNaN(message.name) ?
													<span>{ (message.name).substring(0, 2).toUpperCase() }</span>
													:
													<font-awesome-icon icon={ ['fas', 'user'] }/>
												}
											</v-avatar>
											<div class='information'>
												<div class='name'>{ message.name }</div>
												<div class='last-message'>{ message.message }</div>
												<div class='time'>{ convertTime(message.time) }</div>
											</div>
										</div>
									)
								})}
							</fragment>
							:
							<fragment>
								<font-awesome-icon icon={ ['fas', 'sad-tear'] }/>
								<span>Não foi encontrada nenhuma mensagem.</span>
							</fragment>
						}
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './messages.scss';
</style>