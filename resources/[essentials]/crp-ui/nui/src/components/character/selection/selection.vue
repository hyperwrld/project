<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../utils/lib';

	import modals from './../dialogs/dialogs.js';
	import dialogs from './../dialogs/dialogs.vue';

	export default {
		component: {
			dialogs
		},
  		data () {
    		return {
      			currentItem: 0
    		}
  		},
		computed: {
			...mapGetters('character', {
				charactersData: 'getCharactersData'
			})
		},
		methods: {
			changeCurrentItem: function(futureIndex) {
				this.currentItem = futureIndex;
			},
            selectCharacter: function() {
                this.$store.dispatch('character/selectCharacter', this.charactersData[this.currentItem].id);
			},
			deleteCharacter: function() {
				modals.createDialog({
					title: 'Apagar o personagem', sendButton: 'Apagar', nuiType: 'deleteCharacter', additionalData: { characterId: this.charactersData[this.currentItem].id }
				}).then(response => {
					if (response) {
						this.$set(this.charactersData, this.currentItem, {});
					}
				})
			},
			createCharacter: function() {
				modals.createDialog({
					title: 'Criação de personagem', sendButton: 'Enviar', nuiType: 'createCharacter',
					choices: [
						{ key: 'firstName', type: 'text', min: 1, max: 10, placeholder: 'Primeiro nome' }, { key: 'lastName', type: 'text', min: 1, max: 10, placeholder: 'Último nome' },
						{ key: 'dateOfBirth', type: 'date', placeholder: 'Data de nascimento' },
						{ key: 'gender', type: 'select', placeholder: 'Sexo', options: [ { text: 'Masculino', value: false }, { text: 'Feminino', value: true } ] },
						{ key: 'history', type: 'textarea', placeholder: 'História', min: 100, max: 500 }
					]
				}).then(response => {
					if (response) {
						let characterData = response.choicesData;

						this.$set(this.charactersData, this.currentItem, {
							id: response.data.characterData.id, firstname: characterData.firstName, lastname: characterData.lastName, dateofbirth: characterData.dateOfBirth,
							gender: characterData.gender, job: 'unemployed', money: response.data.characterData.money, bank: response.data.characterData.bank
						});
					}
				})
			},
            handleDisconnect: function() {
                send('disconnectUser');
            }
        },
		render (h) {
			return (
				<div class='container container--fluid' id='character'>
					<div class='menu animate__animated animate__fadeIn'>
						<div class='character-list'>
							{ this.charactersData.map((character, index) => {
								return (
									<div class={'character ' + (this.currentItem == index ? 'active' : '')} onClick={ () => this.changeCurrentItem(index) }>
										{ character.firstname ?
											<div class='info-container'>
												<h3>
													{ character.firstname + ' ' + character.lastname }
													<span>// { character.dateofbirth }</span>
												</h3>
												<span>
													Sexo: { character.gender ? 'Feminino' : 'Masculino' } // Trabalho: { character.job }<br/>
													Dinheiro: { character.money + '€' } // Banco: { character.bank + '€' }<br/>
												</span>
											</div> : <h3>Slot Vazio</h3>
										}
									</div>
								)
							})}
						</div>
						<div class='buttons'>
							{ this.charactersData[this.currentItem] && this.charactersData[this.currentItem].firstname ?
								<div class='buttons-container'>
									<button onClick={ () => this.selectCharacter() }>Selecionar</button>
									<button onClick={ () => this.deleteCharacter() }>Apagar</button>
								</div> : <button onClick={ () => this.createCharacter() }>Criar</button>
							}
							<button onClick={ () => this.handleDisconnect() }>Disconectar</button>
						</div>
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './selection.scss';
</style>