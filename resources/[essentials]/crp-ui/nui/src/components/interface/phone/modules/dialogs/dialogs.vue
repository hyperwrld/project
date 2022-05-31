<script>
	import { fragment, send } from './../../../../../utils/lib.js';

	export default {
		name: 'dialogs',
		data() {
			return {
				isLoading: false,
				loaderClass: 'loading',
			};
		},
		props: {
			attach: String,
			title: String,
			choices: Array,
			buttonLabel: String,
			nuiType: String,
			data: Object,
		},
		methods: {
			cancelDialog: function() {
				this.$emit('cancel');
			},
			submitDialog: function() {
				const choiceData = typeof this.data == 'object' ? this.data : {};

				for (let i = 0; i < this.choices.length; i++) {
					choiceData[this.choices[i].key] = this.choices[i].value;
				}

				(this.loaderState = true), (this.loaderClass = 'loading');

				send(this.nuiType, choiceData).then((data) => {
					this.loaderClass = data.state ? 'done' : 'failure';

					setTimeout(() => {
						if (data.state) {
							this.$emit('submit', { choiceData: choiceData, data: data });
						}

						this.loaderState = false;
					}, 1000);
				});
			},
		},
		render() {
			let choices = this.choices;

			return (
				<div class='dialog'>
					<transition appear enter-active-class='animated bounceIn'>
						<q-form class={this.isLoading ? 'loading' : ''} ref='formRef'>
							{this.isLoading ? (
								<div class={`loader ${this.loaderClass}`}>
									<svg
										class='spinner'
										width='43px'
										height='43px'
										viewBox='0 0 44 44'
										xmlns='http://www.w3.org/2000/svg'
									>
										<circle
											class='path'
											fill='none'
											stroke-width='4'
											stroke-linecap='round'
											cx='22'
											cy='22'
											r='20'
										/>
									</svg>
								</div>
							) : (
								<fragment>
									<div class='text-h5 text-center'>{this.title}</div>
									<div class='choices'>
										{choices.map((choice) => {
											return (
												<q-input
													dark
													type={choice.type}
													ref={choice.key}
													v-model={choice.value}
													dense
													square
													filled
													lazy-rules
													no-error-icon
													rules={choice.rules}
													maxlength={choice.max}
													label={choice.label}
													input-style={{
														resize: 'none',
													}}
												/>
											);
										})}
									</div>
									<div class='actions'>
										<q-btn
											size='12px'
											color='negative'
											label='Fechar'
											onClick={this.cancelDialog}
										/>
										<q-btn
											type='submit'
											size='12px'
											color='primary'
											label={this.buttonLabel}
										/>
									</div>
								</fragment>
							)}
						</q-form>
					</transition>
					}
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './dialogs.scss';
</style>
