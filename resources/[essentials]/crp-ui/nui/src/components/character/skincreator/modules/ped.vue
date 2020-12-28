<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../../utils/lib.js';

	import optionInput from './../utils/input.vue';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faAngleLeft, faAngleRight, faFlushed, faGlasses, faHatCowboy, faSocks, faTshirt, faUserTie } from '@fortawesome/free-solid-svg-icons';
	import { faRedhat } from '@fortawesome/free-brands-svg-icons';

	library.add(faAngleLeft, faAngleRight, faHatCowboy, faGlasses, faTshirt, faFlushed, faUserTie, faSocks);

	export default {
		name: 'ped',
		components: {
			optionInput
		},
		computed: {
			...mapGetters('skincreator', {
				pedInfo: 'getPedInfo', pedData: 'getPedData'
			})
		},
		methods: {
			selectPedSkin: function(skinData) {
				send('selectPedSkin', skinData).then(data => {
					if (skinData.index) {
						this.pedData[2].value = data[0], this.pedData[2].maxValue = data[2] - 1;
						this.pedData[3].value = data[1], this.pedData[3].maxValue = data[3] - 1;
					}
				});
			},
			changeOption: function(type, option) {
				type == 1 ? this.pedInfo.type = option : this.pedInfo.sex = option;

				let data = { sex: this.pedInfo.sex };

				if (this.pedInfo.type) {
					data.index = (this.pedInfo.sex ? this.pedData[0].value : this.pedData[1].value);
				}

				this.selectPedSkin(data);
			},
			changeSkin: function(index) {
				this.selectPedSkin({ sex: this.pedInfo.sex, index: Number((this.pedInfo.sex ? this.pedData[0].value : this.pedData[1].value)) });
			},
			changeSkinValue: function(index) {
				send('modifyAccessories', { index: 0, value: this.pedData[2].value, secondValue: this.pedData[3].value });
			},
            resetSkin: function() {
                send('saveSkin', false);
            }
		},
		render (h) {
			let inputs = [], pedData = this.pedData;

			if (this.pedInfo.type) {
				for (var i = 1; i < pedData.length; i++) {
					let data = <optionInput data={ pedData[i] } click={ this.changeSkinValue }/>;

					if (i == 1) {
						let index = this.pedInfo.sex ? 0 : 1;

						data = <optionInput data={ pedData[index] } click={ this.changeSkin }/>;
					}

					inputs.push(data);
				}
			}

			return (
				<div class='options'>
					<div class='container'>
						<div class='option'>
							<div class='label-container'>
								<span>Escolhe o tipo da tua personagem</span>
							</div>
							<div class='split-controls'>
								<button onClick={ () => this.changeOption(1, false) } class={{ active: !this.pedInfo.type }}>Normal</button>
								<button onClick={ () => this.changeOption(1, true) } class={{ active: this.pedInfo.type }}>NPC</button>
							</div>
						</div>
					</div>
					<div class='container'>
						<div class='option'>
							<div class='label-container'>
								<span>Escolhe o sexo da tua personagem</span>
							</div>
							<div class='split-controls'>
								<button onClick={ () => this.changeOption(2, true) } class={{ active: this.pedInfo.sex }}>Masculino</button>
								<button onClick={ () => this.changeOption(2, false) } class={{ active: !this.pedInfo.sex }}>Feminino</button>
							</div>
						</div>
					</div>
					{ this.pedInfo.type &&
						<div class='container-three'>
							{ inputs }
						</div>
					}
					<div class='container'>
						<div class='option reset'>
							<span>O botão de reset vai colocar a tua personagem como estava antes de entrares na loja.</span>
							<button class='reset' onClick={ this.resetSkin }>Resetar</button>
						</div>
					</div>
				</div>
			);
		}
	}
</script>