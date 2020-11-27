<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../../utils/lib.js';

	import optionInput from './../utils/input.vue';
	import optionRange from './../utils/range.vue';

	export default {
		name: 'face',
		components: {
			optionInput, optionRange
		},
		computed: {
			...mapGetters('skincreator', {
				skinFeatures: 'getSkinFeatures'
			})
		},
		methods: {
			modifyHeadOverlay: function(index) {
				const option = (option.title == 'Opacidade') ? this.skinFeatures[index - 1] : this.skinFeatures[index];

				send('modifyHeadOverlay', { index: option.id, value: option.value, opacity: this.skinFeatures[option.id + 1].value });
            }
        },
		render (h) {
			let options = [], skinFeatures = this.skinFeatures;

			for (let i = 1; i < skinFeatures.length; i += 2) {
				let data = <div class='container'>
					<optionInput data={skinFeatures[i-1]} click={this.modifyHeadOverlay}/><optionRange data={skinFeatures[i]} click={this.modifyHeadOverlay}/>
				</div>;

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