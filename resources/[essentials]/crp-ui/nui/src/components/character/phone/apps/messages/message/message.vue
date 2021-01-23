<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faUser, faSearch, faEnvelope, faSadTear } from '@fortawesome/free-solid-svg-icons';

	import { convertTime } from './../../../../../../utils/lib.js';

	// import dialogs from './../../dialogs/dialogs.js';

	library.add(faSearch, faEnvelope, faUser, faSadTear);

	export default {
		name: 'message',
		props: ['data'],
		computed: {
			...mapGetters('phone', {
				messages: 'getMessages'
			})
		},
		render(h) {
			const data = this.data ? this.data : { messages: []};

			return (
				<div class='message'>
					<div class='top'>
						<font-awesome-icon icon={ 'fas', 'angle-left' }/>
						<span>Tim Almeida</span>
						<font-awesome-icon icon={ 'fas', 'phone-alt' }/>
					</div>
					<div class='messages'>
						{ data.messages.map((message, index) => {
							return (
								<div class='message'>
									<span class='message'>
										{ message.message }
									</span>
									<div class='time'>
										{ convertTime(message.time) }
									</div>
								</div>
							)
						})}
					</div>
					<div class='bottom'>
						<v-textarea auto-grow placeholder='Enviar mensagem...' rows={ 1 } row-height={ 10 } maxlength={ 255 }/>
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './message.scss';
</style>