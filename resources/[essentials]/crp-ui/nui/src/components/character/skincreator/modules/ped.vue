<script>
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
		methods: {
			changeOption: function(type, option) {
				type ? this.data.type = option : this.data.sex = option;
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
			const data = this.data;

			return (
				<div class='options'>
					<div class='option'>
						<div class='label-container'>
							<span>Escolhe o tipo da tua personagem</span>
						</div>
						<div class='split-controls'>
							<button onClick={ () => this.changeOption(true, false) } class={{ active: !data.type }}>Normal</button>
                    		<button onClick={ () => this.changeOption(true, true) } class={{ active: data.type }}>NPC</button>
						</div>
					</div>
					<div class='option'>
						<div class='label-container'>
							<span>Escolhe o sexo da tua personagem</span>
						</div>
						<div class='split-controls'>
							<button onClick={ () => this.changeOption(false, true) } class={{ active: data.sex }}>Masculino</button>
                    		<button onClick={ () => this.changeOption(false, false) } class={{ active: !data.sex }}>Feminino</button>
						</div>
					</div>
					{ data.type &&
						<div class='container'>
							<optionInput/>
							<optionInput/>
						</div>
					}
				</div>
			);
		}
	}
</script>