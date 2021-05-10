<script>
	import { fragment, send } from '../../../../utils/lib';

	export default {
		name: 'dialogs',
		props: {
			title: String,
			choices: Array,
			buttonLabel: String,
			nuiType: String,
			additionalData: Object,
		},
		data() {
			return {
				isLoading: false,
				data: this.choices,
			};
		},
		methods: {
			show() {
				this.$refs.dialog.show();
			},
			hide() {
				this.$refs.dialog.hide();
			},
			onDialogHide() {
				this.$emit('hide');
			},
			onSubmit() {
				let formRef = this.$refs['formRef'];

				formRef.validate();

				if (formRef.hasError) {
					return;
				}

				let sendData =
					typeof this.additionalData == 'object' ? this.additionalData : {};

				this.isLoading = true;

				if (this.data) {
					for (let i = 0; i < this.data.length; i++) {
						let data = this.data[i];

						sendData[data.key] = data.value;
					}
				}

				send(this.nuiType, sendData).then((data) => {
					setTimeout(() => {
						if (data.state) {
							this.$emit('ok', { sendData: sendData, data: data });
							this.hide();
						} else {
							this.$q.notify({
								type: 'negative',
								timeout: 2500,
								message: `Ocorreu um erro, se este erro persistir contacte um administrador.`,
							});
						}

						this.isLoading = false;
					}, 1000);
				});
			},
			onCancelClick() {
				if (this.isLoading) return;

				this.hide();
			},
		},
		render() {
			return (
				<q-dialog no-backdrop-dismiss ref='dialog' onHide={this.onDialogHide}>
					<q-card class='q-dialog-plugin'>
						<q-form ref='formRef' onSubmit={this.onSubmit}>
							<q-card-section class='q-px-xl'>
								<div class='text-h5 text-center'>{this.title}</div>
								{this.data && this.data.length > 0 && (
									<div class='column'>
										{this.data.map((choice) => {
											return (
												<fragment>
													{choice.type == 'select' ? (
														<q-select
															dark
															dense
															square
															filled
															ref={choice.key}
															v-model={choice.value}
															options={choice.options}
															lazy-rules
															rules={[
																(val) => val != null || 'Campo obrigatório',
															]}
															emit-value
															map-options
															stack-label
															options-dense
															label='Sexo'
														/>
													) : (
														<q-input
															dark
															type={choice.type}
															ref={choice.key}
															v-model={choice.value}
															dense
															square
															filled
															stack-label
															lazy-rules
															rules={[
																(val) =>
																	(val && val.length > 0) ||
																	'Campo obrigatório',
															]}
															maxlength={choice.max}
															max='2000-01-01'
															label={choice.label}
														/>
													)}
												</fragment>
											);
										})}
									</div>
								)}
							</q-card-section>
							<q-card-actions align='right'>
								<q-btn
									padding='xs lg'
									color='negative'
									label='Fechar'
									onClick={this.onCancelClick}
								/>
								<q-btn
									type='submit'
									padding='xs lg'
									color='primary'
									label={this.buttonLabel}
									loading={this.isLoading}
								/>
							</q-card-actions>
						</q-form>
					</q-card>
				</q-dialog>
			);
		},
	};
</script>

<style scoped lang="scss">
	.q-dialog-plugin {
		width: 100%;
		max-width: 500px;
		font-family: 'Quantico', sans-serif;
		background-color: rgba(9, 10, 14, 1);
		color: ivory;

		::-webkit-calendar-picker-indicator {
			filter: invert(1);
		}

		.text-h5 {
			text-transform: uppercase;
			margin-bottom: 30px;
			font-weight: bold;
		}

		.column {
			display: grid;
			grid-template-columns: repeat(2, 1fr);
			gap: 15px;
			column-gap: 50px;
		}
	}
</style>
