<script>
	import { mapGetters } from 'vuex';

	export default {
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
				this.$store.dispatch('character/deleteCharacter', this.charactersData[this.currentItem].id);
			},
			createCharacter: function() {

			},
            handleDisconnect: function() {
                nui.send('disconnect');
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
													<span>// { character.dob }</span>
												</h3>
												<span>
													Sexo: { character.gender } // Trabalho: { character.job }<br/>
													Dinheiro: { character.money + '€' } // Banco: { character.bank + '€' }<br/>
												</span>
											</div> : <h3>Slot Vazio</h3>
										}
									</div>
								)
							})}
						</div>
						<div class='buttons'>
							{ this.charactersData[this.currentItem].firstname ?
								<div class='buttons-container'>
									<button onClick={ () => this.selectCharacter(this.currentItem) }>Selecionar</button>
									<button onClick={ () => this.deleteCharacter(this.currentItem) }>Apagar</button>
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
    @import './character.scss';
</style>