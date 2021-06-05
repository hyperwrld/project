<script>
	import { mapGetters } from 'vuex';
	import notifications from './modules/notifications/notifications.vue';

	export default {
		name: 'phone',
		props: ['closeMenu'],
		components: {
			notifications,
		},
		computed: {
			...mapGetters('phone', {
				compactMode: 'getCompactMode',
			}),
		},
		methods: {
			changeApp: function() {
				if (this.$route.name != 'home') {
					this.$router.push({ path: '/phone' });
				}
			},
			closeEvent: function(event) {
				if (event.keyCode == 27) {
					this.closeMenu({ appName: 'phone' });

					event.preventDefault();
				}
			},
		},
		destroyed() {
			window.removeEventListener('keydown', this.closeEvent, false);
		},
		mounted() {
			window.addEventListener('keydown', this.closeEvent, false);
		},
		render() {
			var isOnApp = this.$route.name != 'home' ? true : false;

			return (
				<transition
					appear
					enter-active-class='animated fadeInUp'
					leave-active-class='animated fadeOutDown'
				>
					<div class={`phone ${this.compactMode ? 'compactMode' : ''}`}>
						<div class='inner' />
						<div class='overflow'>
							<div class='shadow' />
						</div>
						<div class='screen'>
							<div class={`content ${isOnApp ? 'onApp' : ''}`}>
								<div class='header'>
									<div class='left'>
										<q-icon name='fas fa-signal' />
										<q-icon name='fas fa-volume-up' />
									</div>
									<div class='camera' />
									<div class='right'>
										<div class='time'>19:20</div>
										<q-icon name='fas fa-sun' />
									</div>
								</div>
								<notifications />
								<transition name='component-fade' mode='out-in'>
									<router-view class='app-screen' />
								</transition>
								<div class={`footer ${isOnApp ? 'onApp' : ''}`}>
									<q-icon name='fa fa-camera'>
										<q-tooltip
											anchor='top middle'
											self='bottom middle'
											transition-show='scale'
											transition-hide='scale'
											offset={[10, 10]}
											content-style={{
												backgroundColor: 'rgba(97, 97, 97, 0.9)',
												padding: '2px 5px',
											}}
										>
											Câmera
										</q-tooltip>
									</q-icon>
									<q-icon
										name='far fa-circle'
										class='main'
										onClick={this.changeApp}
									>
										<q-tooltip
											anchor='top middle'
											self='bottom middle'
											transition-show='scale'
											transition-hide='scale'
											offset={[10, 10]}
											content-style={{
												backgroundColor: 'rgba(97, 97, 97, 0.9)',
												padding: '2px 5px',
											}}
										>
											Home
										</q-tooltip>
									</q-icon>
									<q-icon name='fa fa-bell'>
										<q-tooltip
											anchor='top middle'
											self='bottom middle'
											transition-show='scale'
											transition-hide='scale'
											offset={[10, 10]}
											content-style={{
												backgroundColor: 'rgba(97, 97, 97, 0.9)',
												padding: '2px 5px',
											}}
										>
											Notificações
										</q-tooltip>
									</q-icon>
								</div>
							</div>
						</div>
					</div>
				</transition>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './phone.scss';
</style>
