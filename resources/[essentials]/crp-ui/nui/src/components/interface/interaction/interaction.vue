<script>
	import { mapGetters } from 'vuex';

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
					{ interactionData.status &&
						<v-alert class='inner-container' dark prominent icon='fa-info-circle'>
							{ interactionData.message }
						</v-alert>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './currency.scss';
</style>