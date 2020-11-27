<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../../utils/lib.js';

	import optionRange from './../utils/range.vue';

	export default {
		name: 'face',
		components: {
			optionRange
		},
		computed: {
			...mapGetters('skincreator', {
				faceFeatures: 'getFaceFeatures'
			})
		},
		methods: {
			modifyFaceFeature: function(index) {
				send('modifyFaceFeature', { index: index, scale: this.faceFeatures[index].value });
            }
        },
		render (h) {
			let ranges = [], faceFeatures = this.faceFeatures;

			for (let i = 1; i < faceFeatures.length; i += 2) {
				let data = <div class='container'>
					<optionRange data={faceFeatures[i-1]} click={this.modifyFaceFeature}/><optionRange data={faceFeatures[i]} click={this.modifyFaceFeature}/>
				</div>;

				ranges.push(data);
			}

			return (
				<div class='options'>
					{ ranges }
				</div>
			);
		}
	}
</script>