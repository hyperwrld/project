<script>
	import hud from './hud/hud.vue';
	import interactions from './interactions/interactions.vue';
	import notifications from './notifications/notifications.vue';
	import taskbar from './taskbar/taskbar.vue';
	import queue from './queue/queue.vue';
	import target from './target/target.vue';

	export default {
		name: 'interface',
		components: {
			hud, interactions, notifications, taskbar, queue, target
		},
		render() {
			return (
				<div class='interface'>
					<hud/><interactions/><notifications/><taskbar/><queue/><target/>
				</div>
			);
		}
	}
</script>