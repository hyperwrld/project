<script>
	import { mapGetters } from 'vuex';
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faInfoCircle } from '@fortawesome/free-solid-svg-icons';

	library.add(faInfoCircle);

	export default {
		name: 'interaction',
		computed: {
			...mapGetters('interaction', {
				interactionData: 'getInteractionData'
			})
		},
		render (h) {
			return (
				<div class='interaction'>
					{ this.interactionData.status &&
						<transition name='fade' appear>
							<div class='inner-container'>
								<font-awesome-icon icon='info-circle'/>
								<span>{ this.interactionData.message }</span>
							</div>
						</transition>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './interaction.scss';
</style>