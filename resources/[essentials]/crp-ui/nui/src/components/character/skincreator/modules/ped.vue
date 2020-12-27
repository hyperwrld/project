<script>
	import { mapGetters } from 'vuex';

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
				pedInfo: 'getPedInfo', pedData: 'getPed'
			})
		},
		methods: {
			changeOption: function(type, option) {
				type == 1 ? this.pedInfo.type = option : this.pedInfo.sex = option;
			}
		},
		data () {
    		return {
				data: {
					type: false, sex: false
				}
    		}
		},
		render (h) {
			let inputs = [], pedData = this.pedData;

			if (this.pedInfo.type) {
				for (var i = 1; i < pedData.length; i++) {
					let data = <optionInput data={ pedData[i] }/>;

					if (i == 1) {
						let index = this.pedInfo.sex ? 0 : 1;

						data = <optionInput data={ pedData[index] }/>;
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
				</div>
			);
		}
	}
</script>