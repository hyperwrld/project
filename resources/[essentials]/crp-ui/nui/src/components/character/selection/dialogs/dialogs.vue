<script>
	import { mapGetters } from 'vuex';

	import { send } from './../../../../utils/lib.js';

	export default {
		name: 'dialogs',
		props: {
			title: String,
			type: Boolean,
			choices: Array,
			sendButton: String,
			nuiType: String,
			additionalData: Object
		},
		methods: {
			closeDialog: function() {
				this.$emit('cancel');
			},
			submitDialog: function() {
				if (this.isLoading) return;

				let choicesData = typeof(this.additionalData) == 'object' ? this.additionalData : {}, errorCount = 0;

				if (this.choices && this.choices.length > 0) {
					for (let i = 0; i < this.choices.length; i++) {
						let choice = this.choices[i];

						if (choice.value == undefined || ((choice.max && choice.value.length > choice.max) || (choice.min && choice.value.length < choice.min))) {
							this.$set(choice, 'error', true);

							errorCount = errorCount + 1;
						} else {
							this.$set(choice, 'error', false);

							choicesData[choice.key] = choice.value;
						}
					}
				}

				if (errorCount == 0) {
					this.isLoading = true;

					send(this.nuiType, choicesData).then(data => {
						setTimeout(() => {
							if (data.status) {
								this.$emit('submit', { choicesData: choicesData, data: data });
							}

							this.isLoading = false;
						}, 1000);
					});
				}
			}
		},
		data() {
			return {
				isLoading: false
			}
		},
		render (h) {
			return (
				<transition appear name='fade'>
					<div class='dialogs'>
						<h3>{ this.title }</h3>
						{ this.choices && this.choices.length > 0 &&
							<div class='inputs-container'>
								{ this.choices.map((choice, index) => {
									return (
										<div class={ choice.key + (choice.error ? ' error' : '') }>
											<span>{ choice.placeholder + ':' }</span>
											{ choice.type == 'select' ?
												<select name={ choice.key } v-model={ choice.value }>
													{ choice.options.map((option, index) => {
														return <option value={ option.value }>{ option.text }</option>
													})}
												</select> : <input v-model={ choice.value } type={ choice.type } maxlength={ choice.max } max='2000-01-01'/>
											}
										</div>
									)
								})}
							</div>
						}
						<div class='bottom'>
							<button onClick={ () => this.closeDialog() }>Voltar</button>
							<button class={ this.isLoading ? 'loading' : '' } onClick={ () => this.submitDialog() }>
								{ this.sendButton } { this.isLoading &&
									<i class='fa fa-circle-o-notch fa-spin'/>
								}
							</button>
						</div>
					</div>
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './dialogs.scss';
</style>