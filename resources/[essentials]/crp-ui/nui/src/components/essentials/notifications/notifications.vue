<script>
	import { mapGetters } from 'vuex';

	export default {
		name: 'notifications',
		computed: {
			...mapGetters('notifications', {
				notificationsData: 'getNotifications',
			}),
		},
		render() {
			return (
				<div class='notifications'>
					{this.notificationsData.map((notification) => {
						return (
							<transition name='fade' appear>
								<div class={'notification ' + notification.type}>
									{notification.text}
								</div>
							</transition>
						);
					})}
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './notifications.scss';
</style>
