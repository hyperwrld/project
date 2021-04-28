<script>
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faCheck, faExclamationCircle, faSpinner, faTimes } from '@fortawesome/free-solid-svg-icons';
	import { fragment, send } from './../../../../utils/lib.js';

	library.add(faSpinner, faTimes, faCheck, faExclamationCircle);

	export default {
		name: 'dialogs',
		data() {
			return {
				state: true, loaderState: false, loaderClass: 'loading', errorsList: []
			}
		},
		props: {
			title: String, choices: Array,
			sendText: String, nuiType: String, data: Object
		},
		methods: {
			cancelDialog: function() {
				this.$emit('cancel');
			},
			submitDialog: function() {
				const choiceData = typeof(this.data) == 'object' ? this.data : {};

				if (this.choices && this.choices.length > 0) {
					this.errorsList = [];

					for (let i = 0; i < this.choices.length; i++) {
						const choice = this.choices[i];

						if (choice.value == undefined || ((choice.max && choice.value.length > choice.max) || (choice.min && choice.value.length < choice.min))) {
							this.errorsList.push(choice.errorText);
						} else {
							choiceData[choice.key] = choice.value;
						}
					}
				}

				if (this.errorsList.length == 0) {
					this.loaderState = true, this.loaderClass = 'loading';

					send(this.nuiType, choiceData).then(data => {
						this.loaderClass = data.state ? 'done' : 'failure';

						setTimeout(() => {
							if (data.state) {
								this.$emit('submit', { choiceData: choiceData, data: data });
							}

							this.loaderState = false;
						}, 1000);
					});
				}
			}
		},
		render() {
			return (
				<transition appear name='fade'>
					<v-dialog v-model={ this.state } persistent max-width='290' attach='.transactions' hide-overlay>
						<div class={ `card ${ this.loaderState ? 'loading' : (!this.choices || this.choices.length <= 0) ? 'empty' : '' }` }>
							{ this.loaderState ?
								<div class={ `loader ${ this.loaderClass }` }>
									<svg class='spinner' width='43px' height='43px' viewBox='0 0 44 44' xmlns='http://www.w3.org/2000/svg'>
										<circle class='path' fill='none' stroke-width='4' stroke-linecap='round' cx='22' cy='22' r='20'/>
									</svg>
								</div>
								:
								<fragment>
									<span class='title'>{ this.title }</span>
									{ (this.choices && this.choices.length > 0) &&
										<div class='content'>
											{ this.choices.map((choice) => {
												return (
													<fragment>
														{ choice.type ?
															<input type={ choice.type } v-model={ choice.value } placeholder={ choice.placeholder } maxlength={ choice.max } required/>
															:
															<textarea type='text' v-model={ choice.value } placeholder={ choice.placeholder } required/>
														}
													</fragment>
												)
											})}
										</div>
									}
									<div class='buttons'>
										<button onClick={ this.cancelDialog }>Voltar</button>
										<button onClick={ this.submitDialog }>{ this.sendText }</button>
									</div>

									{ (this.choices && this.errorsList.length > 0) &&
										<div class='errors'>
											{ this.errorsList.map((error) => {
												return (
													<div class='error'>
														<font-awesome-icon icon={ ['fas', 'exclamation-circle'] }/> { error }
													</div>
												)
											})}
										</div>
									}
								</fragment>
							}
						</div>
					</v-dialog>
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './dialogs.scss';
</style>