<script>
	import { mapGetters } from 'vuex';

	import optionRange from './../utils/range.vue';
	import optionInput from './../utils/input.vue';
	import optionColor from './../utils/color.vue';

	import { send } from './../../../../utils/lib.js';

	export default {
		name: 'bodyFeatures',
		components: {
			optionRange, optionInput, optionColor
		},
		computed: {
			...mapGetters('skincreator', {
				bodyFeatures: 'getBodyFeatures'
			})
		},
		methods: {
			modifyBodyFeature: function(index, isMain) {
				let bodyFeature = this.bodyFeatures.find(element => element.id == index), data = { index: Number(index), value: Number(bodyFeature.value) };

				if (index != -1) {
					data.secondValue = Number(bodyFeature.subOptions[0].value), data.isMain = isMain;
				}

				send('modifyBodyFeature', data).then(hairTextureTotal => {
					if (index == 0 && isMain) {
						bodyFeature.subOptions[0].maxValue = hairTextureTotal - 1, bodyFeature.subOptions[0].value = 0;
					}
				});
			},
			modifyFeatureColor: function(index) {
				const bodyFeature = this.bodyFeatures.find(element => element.id == index);

				let data = { index: index, firstColor: bodyFeature.subOptions[1].value, colorType: bodyFeature.colorType };

				if (bodyFeature.subOptions[2]) {
					data.secondColor = bodyFeature.subOptions[2].value;
				}

				send('modifyFeatureColor', data);
			}
		},
		render (h) {
			let options = [], bodyFeatures = this.bodyFeatures;

			for (let i = 0; i < bodyFeatures.length; i++) {
				let data;

				if (i != 1) {
					data = <div class={ 'container-' + (bodyFeatures[i].subOptions.length > 2 ? 'four' : 'three') }>
						<optionInput data={ bodyFeatures[i] } click={ this.modifyBodyFeature }/>
							{ i == 0 ?
								<optionInput data={ bodyFeatures[i].subOptions[0] } click={ this.modifyBodyFeature }/>
									:
								<optionRange data={ bodyFeatures[i].subOptions[0] } click={ this.modifyBodyFeature }/>
							}
						<optionColor data={ bodyFeatures[i].subOptions[1] } click={ this.modifyFeatureColor }/>
						{ bodyFeatures[i].subOptions[2] ?
							<optionColor data={ bodyFeatures[i].subOptions[2] } click={ this.modifyFeatureColor }/> : ''
						}
					</div>
				} else {
					data = <div class='container'>
						<optionInput data={ bodyFeatures[1] } click={ this.modifyBodyFeature }/>
					</div>
				}

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