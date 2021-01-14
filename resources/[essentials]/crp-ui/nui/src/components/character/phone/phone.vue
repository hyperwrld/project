<script>
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faVolumeUp, faSignal, faCamera, faAngleLeft, faBatteryThreeQuarters } from '@fortawesome/free-solid-svg-icons';
	import { faCircle } from '@fortawesome/free-regular-svg-icons';

	library.add(faVolumeUp, faSignal, faCamera, faCircle, faAngleLeft, faBatteryThreeQuarters);

	export default {
		name: 'phone',
		methods: {
			changeApp: function() {
				if (this.$route.name != 'home') {
					this.$router.push({ path: '/phone/' });
				}
			}
		},
		render(h) {
			return (
				<transition appear name='slideUp'>
					<div class='phone'>
						<div class='inner'/>
						<div class='overflow'>
                			<div class='shadow'/>
						</div>
						<div class='camera'/>
						<div class='screen'>
							<div class={ `content ${ this.$route.name != 'home' ? 'onApp' : ''}` }>
								<div class='header'>
									<div class='left'>
										<div class='time'>19:20</div>
									</div>
									<div class='right'>
										<font-awesome-icon icon='volume-up'/>
										<font-awesome-icon icon='signal'/>
									</div>
								</div>
								<router-view class='app-screen'/>
								<div class='footer'>
									<div class='back' onClick={ this.changeApp }/>
								</div>
							</div>
						</div>
					</div>
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './phone.scss';
</style>