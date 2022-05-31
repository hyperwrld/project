<script>
	import { mapGetters } from 'vuex';

	export default {
		name: 'taskbar',
		computed: {
			...mapGetters('taskbar', {
				taskbarData: 'getTaskbarData',
			}),
		},
		render() {
			let data = this.taskbarData;

			return (
				<transition appear name='fade'>
					{data.state && (
						<div class='taskbar'>
							<span>{data.message}</span>
							<div style={{ width: data.progress + '%' }}></div>
						</div>
					)}
				</transition>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './taskbar.scss';
</style>
