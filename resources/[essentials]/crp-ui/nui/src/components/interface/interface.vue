<script>
	import currency from './currency/currency.vue';
	import hud from './hud/hud.vue';
	import interaction from './interaction/interaction.vue';

	export default {
		name: 'interface',
		components: {
			currency, hud, interaction
		},
		render (h) {
			return (
				<div class='interface'>
					<currency/><hud/><interaction/>
					<router-view/>
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