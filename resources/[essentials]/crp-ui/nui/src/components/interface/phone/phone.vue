<script>
	import { mapGetters } from 'vuex';

	export default {
		name: 'phone',
		props: ['closeMenu'],
		computed: {
			...mapGetters('phone', {
				compactMode: 'getCompactMode',
			}),
		},
		methods: {
			changeApp: function() {
				if (this.$route.name != 'home') {
					this.$router.push({ path: '/phone/' });
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
			return (
				<transition
					appear
					enter-active-class='fadeInUp'
					leave-active-class='fadeOutDown'
				>
					<div class={`phone ${this.compactMode ? 'compactMode' : ''}`}>
						<div class='inner' />
						<div class='overflow'>
							<div class='shadow' />
						</div>
						<div class='screen'>
							<div
								class={`content ${this.$route.name != 'home' ? 'onApp' : ''}`}
							>
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
								<div class='notifications'></div>
								<router-view class='app-screen' />
								<div class='footer'>
									<q-icon name='fa fa-camera' />
									<q-icon
										name='fa far-circle'
										class='main'
										onClick={this.changeApp}
									/>
									<q-icon name='fa fa-bell' />
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
