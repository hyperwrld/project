<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../../utils/lib.js';

	import optionInput from './../utils/input.vue';
	import optionRange from './../utils/range.vue';

	export default {
		name: 'headBlend',
		components: {
			optionInput, optionRange
		},
		computed: {
			...mapGetters('skincreator', {
				headBlend: 'getHeadBlend'
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
		render() {
			let inputs = [], headBlend = this.headBlend;

			for (var i = 0; i < 9; i++) {
				let data = i < 6 ? '' : <div class='container'><optionRange data={ headBlend[i] } click={ this.modifyHeadBlend }/></div>;

				if (i < 3) {
					data = <div class='container'>
						<optionInput data={ headBlend[i] } click={ this.modifyHeadBlend }/><optionInput data={ headBlend[i + 3] } click={ this.modifyHeadBlend }/>
					</div>;
				}

				inputs.push(data);
			}

			return (
				<div class='options'>
					{ inputs }
				</div>
			);
		}
	}
</script>