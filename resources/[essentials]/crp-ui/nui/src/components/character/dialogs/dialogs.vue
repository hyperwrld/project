<script>
	import { mapGetters } from 'vuex';

	export default {
		props: {
			title: String,
			type: Boolean
		},
		data() {
			return {
				firstName: '', lastName: ''
			}
		},
		render (h) {
			let isLoading = false;
			// this.choices = [ 'olaaa'];
			this.type = true;
			this.title = 'Criação de Personagem'

			return (
				<div class='dialog'>
					{ isLoading ? LoadingComponent() :
						<div class='container'>
							<h3>{ this.title }</h3>
							{ this.type &&
								<div class='inputs-container'>
									<div class='firstName'>
										<span>Primeiro nome:</span>
										<input type='text' maxlength='10'/>
									</div>
									<div class='lastName'>
										<span>Último nome:</span>
										<input type='text' maxlength='10'/>
									</div>
									<div class='dateOfBirth'>
										<span>Data de nascimento:</span>
										<input type='date' name='dob'/>
									</div>
									<div class='gender'>
										<span>Sexo:</span>
										<select name='gender'>
											<option value='true'>Masculino</option>
											<option value='false'>Feminino</option>
										</select>
									</div>
									<div class='history'>
										<span>História:</span>
										<textarea name='history' rows='4' cols='50' maxlength='500'/>
									</div>
								</div>
							}
							<div class='bottom'>
								<button>Cancelar</button><button>Enviar</button>
							</div>
						</div>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './dialogs.scss';
</style>