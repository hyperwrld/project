<script>
	import { mapGetters } from 'vuex';

	export default {
		computed: {
			...mapGetters('phone', {
				compactMode: 'getCompactMode',
			}),
		},
		render() {
			return (
				<div class='notifications'>
					<transition
						appear
						enter-active-class='fadeInDown'
						leave-active-class='fadeOutUp'
					>
						<div class='notification'>
							<div class='information'>
								<q-icon name='fab fa-twitter-square' />
								<span>Twitter</span>
							</div>
							<span class='time'>há 5 horas</span>
							<span class='message'>Bom dia los santos</span>
						</div>
					</transition>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './notifications.scss';
</style>
