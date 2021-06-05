<script>
	import { mapGetters } from 'vuex';
	import { fragment, convertTime } from './../../../../../utils/lib.js';

	import dialogs from './../../modules/dialogs/dialogs.js';

	export default {
		name: 'messages',
		computed: {
			...mapGetters('messages', {
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
			sendMessage: function() {
				dialogs
					.createDialog({
						attach: '.messages',
						title: 'Enviar Mensagem',
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
		},
		render() {
			const isNotEmpty = this.filterItems().length > 0 ? true : false;

			return (
				<div class='messages'>
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
						<q-icon name='fas fa-envelope' onClick={() => this.sendMessage()}>
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
								Enviar Mensagem
							</q-tooltip>
						</q-icon>
					</q-toolbar>
					<div class={`content ${isNotEmpty ? '' : 'empty'}`}>
						{isNotEmpty ? (
							<q-list dense dark>
								{this.filterItems().map((message) => {
									return (
										<div class='message'>
											<q-icon name='fas fa-user-circle' />
											<span class='name'>{message.name}</span>
											<span class='text'>{message.message}</span>
											<q-badge
												color='deep-purple-8'
												label={convertTime(message.time)}
											/>
										</div>
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
	@import './messages.scss';
</style>
