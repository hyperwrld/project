<script>
	export default {
		name: 'interface',
		render (h) {
			return (
				<div class='interface'>
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