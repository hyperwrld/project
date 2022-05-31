<script>
	export default {
		name: 'dialogs',
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
			onOkClick(state) {
				this.$emit('ok', state);
				this.hide();
			},
			onCancelClick() {
				this.hide();
			},
		},
		render() {
			return (
				<q-dialog
					no-backdrop-dismiss
					noEscDismiss
					ref='dialog'
					onHide={this.onDialogHide}
				>
					<q-card class='q-dialog-plugin'>
						<q-card-section class='q-px-xl'>
							<div class='text-h5 text-center'>Deseja comprar esta roupa?</div>
						</q-card-section>
						<q-card-actions align='center'>
							<q-btn
								padding='xs lg'
								color='positive'
								label='Comprar'
								onClick={() => this.onOkClick(true)}
							/>
							<q-btn
								padding='xs lg'
								color='primary'
								label='Voltar'
								onClick={this.onCancelClick}
							/>
							<q-btn
								padding='xs lg'
								color='negative'
								label='Fechar'
								onClick={() => this.onOkClick(false)}
							/>
						</q-card-actions>
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
		background-color: rgba(35, 35, 35, 1);
		color: ivory;

		.text-h5 {
			text-transform: uppercase;
			font-weight: bold;
		}
	}
</style>
