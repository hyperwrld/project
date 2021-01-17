<script>
	export default {
		name: 'dialog',
		methods: {
			closeDialog: function() {
				this.$emit('cancel');
			},
			submitDialog: function(boolean) {
				this.$emit('submit', boolean);
			}
		},
		render (h) {
			return (
				<div class='dialog'>
					<h3>Deseja comprar esta roupa?</h3>
					<div class='buttons'>
						<button class='back' onClick={ () => this.closeDialog() }>Voltar</button>
						<button class='save' onClick={ () => this.submitDialog(true) }>Salvar</button>
						<button class='close' onClick={ () => this.submitDialog(false) }>Fechar</button>
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
	.dialog {
		font-family: 'Quantico', sans-serif;

		position: absolute;
		top: 50%;
		left: 50%;

		transform: translate(-50%, -50%);
		width: 80%;

		color: rgba(255, 255, 255, 0.75);
		background-color: #232323;
		box-shadow: 0px 0px 5px 0px black;

		border-radius: 2.5px;
		padding: 5px;
		border: 0.5px solid rgba(255, 255, 255, 0.75);

		h3 {
			text-align: center;
		}

		.buttons {
			margin-top: 10px;

			button {
				font-family: 'Quantico', sans-serif;

				text-transform: uppercase;
				float: right;
				border-radius: 2.5px;

				padding: 1px 5px;
				font-size: 0.9em;
				color: ivory;

				outline: none;
				border: none;

				&.back {
					float: left;
					background-color: rgba(29, 132, 230, 1.0);
				}

				&.close {
					margin-right: 10px;
					background-color: rgba(239, 0, 0, 1.0);
				}

				&.save {
					background-color: rgba(5, 148, 9, 1.0);
				}
			}
		}
	}
</style>