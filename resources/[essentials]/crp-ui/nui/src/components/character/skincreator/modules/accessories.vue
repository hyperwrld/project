<script>
	import { mapGetters } from 'vuex';

	import optionInput from './../utils/input.vue';

	import { send } from './../../../../utils/lib.js';

	export default {
		name: 'accessories',
		components: {
			optionInput
		},
		computed: {
			...mapGetters('skincreator', {
				accessories: 'getAccessories'
			})
		},
		methods: {
			modifyAccessories: function(index, isMain, isProp) {
				let accessory = this.accessories.find(element => element.id == index && element.isProp == isProp);

				send('modifyAccessories', {
					index: Number(index), value: Number(accessory.value), secondValue: Number(accessory.subOptions[0].value), isProp: isProp
				}).then(data => {
					if (isMain) {
						accessory.subOptions[0].maxValue = data, accessory.subOptions[0].value = 0;
					}
				});
			}
		},
		render (h) {
			let options = [];

			for (let i = 0; i < this.accessories.length; i++) {
				let data = <div class='container'>
					<optionInput data={ this.accessories[i] } click={ this.modifyAccessories }/>
					<optionInput data={ this.accessories[i].subOptions[0] } click={ this.modifyAccessories }/>
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