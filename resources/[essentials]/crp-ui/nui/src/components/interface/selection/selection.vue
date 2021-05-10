<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../utils/lib';

	import dialogs from './dialogs/dialogs.vue';

	export default {
		name: 'selection',
		props: ['closeMenu'],
		data() {
			return {
				currentItem: 0,
				isLoading: false,
				isUsingMenu: false,
			};
		},
		computed: {
			...mapGetters('selection', {
				charactersData: 'getCharactersData',
			}),
		},
		methods: {
			formatDate: function(date) {
				if (!date) return null;

				const [year, month, day] = date.split('-');

				return `${day}/${month}/${year}`;
			},
			changeCurrentItem: function(futureIndex) {
				if (
					this.isLoading ||
					this.isUsingMenu ||
					this.currentItem == futureIndex
				)
					return;

				this.currentItem = futureIndex;

				send('changedCharacter', this.charactersData[this.currentItem]);
			},
			selectCharacter: function() {
				if (this.isLoading || this.isUsingMenu) return;

				this.isLoading = true;

				send('selectCharacter', this.charactersData[this.currentItem].id).then(
					(data) => {
						if (data.state)
							this.closeMenu({
								appName: 'selection',
								characterData: data.characterData,
							});

						setTimeout(() => {
							this.isLoading = false;
						}, 5000);
					}
				);
			},
			deleteCharacter: function() {
				if (this.isLoading || this.isUsingMenu) return;

				this.isUsingMenu = true;

				this.$q
					.dialog({
						component: dialogs,
						parent: this,
						title: 'Apagar o personagem',
						buttonLabel: 'Apagar',
						nuiType: 'deleteCharacter',
						additionalData: {
							characterId: this.charactersData[this.currentItem].id,
						},
					})
					.onOk(() => {
						this.$set(this.charactersData, this.currentItem, {});
					})
					.onDismiss(() => {
						this.isUsingMenu = false;
					});
			},
			createCharacter: function() {
				if (this.isLoading || this.isUsingMenu) return;

				this.isUsingMenu = true;

				this.$q
					.dialog({
						component: dialogs,
						parent: this,
						title: 'Criação de personagem',
						choices: [
							{
								key: 'firstName',
								type: 'text',
								min: 3,
								max: 10,
								label: 'Primeiro nome',
							},
							{
								key: 'lastName',
								type: 'text',
								min: 3,
								max: 10,
								label: 'Último nome',
							},
							{
								key: 'dateOfBirth',
								type: 'date',
								label: 'Data de nascimento',
							},
							{
								key: 'gender',
								type: 'select',
								options: [
									{
										label: 'Masculino',
										value: false,
									},
									{
										label: 'Feminino',
										value: true,
									},
								],
							},
						],
						buttonLabel: 'Criar',
						nuiType: 'createCharacter',
					})
					.onOk((characterData) => {
						this.$set(this.charactersData, this.currentItem, {
							id: characterData.data,
							firstname: characterData.sendData.firstName,
							lastname: characterData.sendData.lastName,
							dateofbirth: this.formatDate(characterData.sendData.dateOfBirth),
							gender: characterData.sendData.gender,
							job: 'Desempregado',
						});
					})
					.onDismiss(() => {
						this.isUsingMenu = false;
					});
			},
			handleDisconnect: function() {
				if (this.isLoading || this.isUsingMenu) return;

				send('disconnectUser');
			},
		},
		render() {
			return (
				<transition
					appear
					enter-active-class='animated fadeIn'
					leave-active-class='animated fadeOut'
				>
					<div class='selection'>
						<div class='character-list'>
							{this.charactersData.map((character, index) => {
								return (
									<div
										class={
											'character ' + (this.currentItem == index ? 'active' : '')
										}
										onClick={() => this.changeCurrentItem(index)}
									>
										{character.firstname ? (
											<div class='info-container'>
												<h3>
													{character.firstname + ' ' + character.lastname}
													<span>// {character.dateofbirth}</span>
												</h3>
												<span>
													Sexo: {character.gender ? 'Feminino' : 'Masculino'} |
													Trabalho: {character.job}
												</span>
											</div>
										) : (
											<h3>Slot Vazio</h3>
										)}
									</div>
								);
							})}
						</div>
						{this.charactersData[this.currentItem] &&
						this.charactersData[this.currentItem].firstname ? (
							<div class='buttons'>
								<button
									class={this.isLoading ? 'loading' : ''}
									onClick={() => this.selectCharacter()}
								>
									Selecionar{' '}
									{this.isLoading && (
										<q-icon name='fas fa-circle-notch fa-spin' />
									)}
								</button>
								<button onClick={() => this.deleteCharacter()}>Apagar</button>
								<button onClick={() => this.handleDisconnect()}>
									Disconectar
								</button>
							</div>
						) : (
							<div class='buttons'>
								<button onClick={() => this.createCharacter()}>Criar</button>
								<button onClick={() => this.handleDisconnect()}>
									Disconectar
								</button>
							</div>
						)}
					</div>
				</transition>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './selection.scss';
</style>
