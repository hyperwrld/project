<script>
	import currency from './currency/currency.vue';
	import hud from './hud/hud.vue';
	import interaction from './interaction/interaction.vue';
	import notifications from './notifications/notifications.vue';

	export default {
		name: 'interface',
		components: {
			currency, hud, interaction, notifications
		},
		render (h) {
			return (
				<div class='interface'>
					<currency/><hud/><interaction/><notifications/>
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