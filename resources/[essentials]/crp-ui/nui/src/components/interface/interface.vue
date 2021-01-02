<script>
	import hud from './hud/hud.vue';
	import interactions from './interactions/interactions.vue';
	import notifications from './notifications/notifications.vue';
	import taskbar from './taskbar/taskbar.vue';

	export default {
		name: 'interface',
		components: {
			hud, interactions, notifications, taskbar
		},
		render (h) {
			return (
				<div class='interface'>
					<hud/><interactions/><notifications/><taskbar/>
				</div>
			);
		}
	}
</script>