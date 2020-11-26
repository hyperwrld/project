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
				faceFeatures: 'getFaceFeatures'
			})
		},
		methods: {
			modifyHeadBlend: function() {
				let data = [];

				for (let i = 0; i < this.headBlend.length; i++) {
					const value = this.headBlend[i].value;

					data.push(value);
				}

                send('modifyHeadBlend', data);
            }
        },
		render (h) {
			let ranges = [], faceFeatures = this.faceFeatures;

			for (let i = 0; i < faceFeatures.length; i++) {
				if (i % 2) {
					let data = <div class='container'>
						<optionRange data={faceFeatures[i-1]} click={this.modifyHeadBlend}/><optionRange data={faceFeatures[i]} click={this.modifyHeadBlend}/>
					</div>;

					ranges.push(data);
				}
			}

			return (
				<div class='options'>
					{ ranges }
				</div>
			);
		}
	}
</script>