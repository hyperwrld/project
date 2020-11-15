<script>
	export default {
		name: 'intro',
		props: ['closeMenu'],
		render (h) {
			return (
				<transition name='fade' appear>
					<div class='intro'>
						CACEM ROLEPLAY <span>APRESENTA</span>
						<p>THE NEXT BIG THING</p>
					</div>
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './intro.scss';
</style>