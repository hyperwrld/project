<script>
	import { mapGetters } from 'vuex';
	import { convertTime, send } from './../../../../../../utils/lib.js';

	export default {
		name: 'message',
		props: ['data'],
		data() {
			return {
				messageText: '',
			};
		},
		computed: {
			...mapGetters({
				number: 'phone/getNumber',
				messages: 'messages/getMessages',
			}),
		},
		methods: {
			goBack() {
				this.$router.push({ name: 'messages' });
			},
			scrollDown() {
				let element = document.querySelector('.message:last-child');

				element.scrollIntoView({ behavior: 'smooth' });
			},
			sendMessage() {
				if (this.messageText.length <= 0) {
					return;
				}

				send('sendMessage', {
					number: this.data.number,
					message: this.messageText,
				}).then((data) => {
					if (data.state) {
						this.messageText = '';

						this.$store.dispatch('messages/setMessage', data.message);
					}
				});
			},
		},
		watch: {
			messages: function() {
				setTimeout(() => {
					this.scrollDown();
				}, 250);
			},
		},
		mounted() {
			this.scrollDown();
		},
		render() {
			return (
				<div class='message'>
					<div class='top'>
						<q-icon name='fas fa-angle-left' onClick={this.goBack} />
						<span>{this.data.name}</span>
						<q-icon name='fas fa-phone-alt' />
					</div>
					<div class='content'>
						<div class='messages'>
							{this.messages.map((message) => {
								return (
									<div
										class={`message ${
											this.data.number != message.sender ? '' : 'other'
										}`}
									>
										<span>{message.message}</span>
										<div class='time'>{convertTime(message.time)}</div>
									</div>
								);
							})}
						</div>
						<div class='bottom'>
							<v-textarea
								auto-grow
								placeholder='Enviar mensagem...'
								v-model={this.messageText}
								rows={1}
								row-height={10}
								maxlength={255}
							/>
							<q-icon name='fas fa-paper-plane' onClick={this.sendMessage} />
						</div>
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './message.scss';
</style>
