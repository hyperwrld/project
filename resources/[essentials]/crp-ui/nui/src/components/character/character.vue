<script>
	export default {
		name: 'character',
		render (h) {
			return (
				<div class='character'>
					<router-view/>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './character.scss';
</style>