<script>
	import hud from './hud/hud.vue';
	import interactions from './interactions/interactions.vue';
	import notifications from './notifications/notifications.vue';

	export default {
		name: 'interface',
		components: {
			hud, interactions, notifications
		},
		render (h) {
			return (
				<div class='interface'>
					<hud/><interactions/><notifications/>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
	.interface {
		font-family: 'Quantico', sans-serif;
		position: absolute;

		max-width: 100%;
		width: 100%;
		height: 100%;

		padding: 12px;
		margin-right: auto;
		margin-left: auto;
	}
</style>