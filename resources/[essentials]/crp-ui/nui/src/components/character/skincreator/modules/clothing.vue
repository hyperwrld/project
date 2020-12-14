<script>
	import { mapGetters } from 'vuex';

	import optionInput from './../utils/input.vue';

	import { send } from './../../../../utils/lib.js';

	export default {
		name: 'clothing',
		components: {
			optionInput
		},
		computed: {
			...mapGetters('skincreator', {
				clothing: 'getClothing'
			})
		},
		methods: {
			modifyClothing: function(index, isMain) {
				let clothing = this.clothing.find(element => element.id == index);

				send('modifyClothing', {
					index: Number(index), value: Number(clothing.value), secondValue: Number(clothing.subOptions[0].value)
				}).then(data => {
					if (isMain) {
						clothing.subOptions[0].maxValue = data, clothing.subOptions[0].value = 0;
					}
				});
			}
		},
		render (h) {
			let options = [];

			for (let i = 0; i < this.clothing.length; i++) {
				let data = <div class='container'>
					<optionInput data={ this.clothing[i] } click={ this.modifyClothing }/>
					<optionInput data={ this.clothing[i].subOptions[0] } click={ this.modifyClothing }/>
				</div>

				options.push(data);
			}

			return (
				<div class='options'>
					{ options }
				</div>
			);
		}
	}
</script>