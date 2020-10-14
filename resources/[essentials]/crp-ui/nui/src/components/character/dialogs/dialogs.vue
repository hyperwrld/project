<script>
	import { mapGetters } from 'vuex';

	export default {
		props: {
			title: {
				type: String,
				default: () => ''
			},
			type: {
				type: Boolean,
				default: () => false
			},
			choices: {
				type: Array,
				default: () => []
			},
			sendButton: {
				type: String,
				default: () => ''
			},
			nuiType: {
				type: String,
				default: () => ''
			}
		},
		methods: {
			closeDialog: function() {
				this.$emit('close');
			},
			submitDialog: function() {

			}
		},
		data() {
			return {
				firstName: '', lastName: ''
			}
		},
		render (h) {
			return (
				<div class='dialog animate__animated animate__fadeIn'>
					<div class='container'>
						<h3>{ this.title }</h3>
						{ this.choices.length > 0 &&
							<div class='inputs-container'>
								{ this.choices.map((choice, index) => {
									return (
										<div class={ choice.key }>
											<span>{ choice.placeholder }</span>
											{ choice.type == 'select' ?
												<select name={ choice.key }>
													{ choice.options.map((option, index) => {
														return <option>{ option.text }</option>
													})}
												</select>
												: choice.type == 'textarea' ? <textarea name={ choice.key } rows='4' cols='50' maxlength={ choice.max }/>
												: <input type={ choice.type } maxlength={ choice.max }/>
											}
										</div>
									)
								})}
							</div>
						}
						<div class='bottom'>
							<button>Voltar</button><button>{ this.sendButton }</button>
						</div>
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './dialogs.scss';
</style>