<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../../utils/lib.js';

	import optionInput from './../utils/input.vue';
	import optionRange from './../utils/range.vue';

	export default {
		name: 'headOverlays',
		components: {
			optionInput, optionRange
		},
		computed: {
			...mapGetters('skincreator', {
				headOverlays: 'getHeadOverlays'
			})
		},
		methods: {
			modifyHeadOverlay: function(index) {
				const arrayIndex = this.headOverlays.findIndex(element => element.id == index), data = this.headOverlays;

				send('modifyHeadOverlay', { index: index, value: data[arrayIndex].value, opacity: data[arrayIndex + 1].value });
            }
        },
		render() {
			let options = [], headOverlays = this.headOverlays;

			for (let i = 0; i < headOverlays.length; i += 2) {
				let data = <div class='container'>
					<optionInput data={ headOverlays[i] } click={ this.modifyHeadOverlay }/><optionRange data={ headOverlays[i + 1] } click={ this.modifyHeadOverlay }/>
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