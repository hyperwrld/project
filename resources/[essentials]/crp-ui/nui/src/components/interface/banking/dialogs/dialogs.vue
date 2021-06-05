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
							this.$emit('ok', Object.assign(sendData, data));
							this.hide();
						} else {
							this.$q.notify({
								type: 'negative',
								timeout: 2500,
								message: data.message
									? data.message
									: 'Ocorreu um erro, se este erro persistir contacte um administrador.',
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
															rules={choice.rules}
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
															autogrow
															rules={choice.rules}
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
		font-family: 'Quantico', sans-serif;
		width: fit-content;
		max-width: 500px;

		background: #212121;
		color: ivory;

		.q-card__section {
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;

			.text-h5 {
				text-transform: uppercase;
				margin-bottom: 30px;
				font-weight: bold;
			}

			.column {
				display: grid;
				gap: 15px;
				width: 205px;
			}
		}

		&::v-deep {
			input::-webkit-outer-spin-button,
			input::-webkit-inner-spin-button {
				-webkit-appearance: none;
				margin: 0;
			}
		}
	}
</style>
