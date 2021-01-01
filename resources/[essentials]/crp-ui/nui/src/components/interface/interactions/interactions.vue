<script>
	import { mapGetters } from 'vuex';

	export default {
		name: 'interactions',
		computed: {
			...mapGetters('interactions', {
				interactionsData: 'getInteractionsData'
			})
		},
		methods: {
            processMessage: function(message) {
				const match = message.match(/\[(.*?)\]/g);

				message = message.replace(match[0], "<span class='text'>" + match[0].replace(/[[\]']+/g, '') + "</span>");

				return '<span>' + message.trim() + '</span>';
			}
        },
		render (h) {
			let data = this.interactionsData;

			return (
				<transition appear name='fade'>
					{ data.status &&
						<div class='interactions'>
							<div class='interaction' domPropsInnerHTML={ this.processMessage(data.firstMessage) }/>
							{ data.secondMessage &&
								<div class='interaction' domPropsInnerHTML={ this.processMessage(data.secondMessage) }/>
							}
						</div>
					}
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './interactions.scss';
</style>