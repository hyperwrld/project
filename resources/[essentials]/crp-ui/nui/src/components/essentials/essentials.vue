<script>
	import hud from './hud/hud.vue';
	import interactions from './interactions/interactions.vue';
	import notifications from './notifications/notifications.vue';
	import taskbar from './taskbar/taskbar.vue';
	import queue from './queue/queue.vue';

	export default {
		name: 'essentials',
		components: {
			hud,
			interactions,
			notifications,
			taskbar,
			queue,
		},
		render() {
			return (
				<div class='essentials'>
					<hud />
					<interactions />
					<notifications />
					<taskbar />
					<queue />
				</div>
			);
		},
	};
</script>
