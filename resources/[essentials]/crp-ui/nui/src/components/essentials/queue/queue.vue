<script>
	import { mapGetters } from 'vuex';

	export default {
		name: 'queue',
		computed: {
			...mapGetters('inventory', {
				queueData: 'getQueueData',
			}),
		},
		render() {
			return (
				<div class='queue'>
					{this.queueData.map((item) => {
						return (
							<transition appear name='fade'>
								<div class='slot'>
									<div class='message'>{item.message}</div>
									<div class='item'>
										<img src={require('./../../../assets/' + item.image)} />
										<div class='name'>{item.name}</div>
									</div>
								</div>
							</transition>
						);
					})}
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './queue.scss';
</style>
