<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faBriefcase, faEye, faShoppingBasket } from '@fortawesome/free-solid-svg-icons';

	import { fragment, send} from '../../../utils/lib';

	library.add(faEye, faShoppingBasket, faBriefcase);

	export default {
		name: 'target',
		computed: {
			...mapGetters('target', {
				data: 'getData'
			})
		},
		data() {
            return {
				icons: [
					'shopping-basket', 'briefcase'
				]
            }
        },
		methods: {
			startEvent: function(id) {
				send('startEvent', id);
			}
		},
		render() {
			const data = this.data;

			return (
				<div class='target'>
					{ data.hideState &&
						<fragment>
							<font-awesome-icon class={ data.activeState ? 'active' : '' } icon='eye' />
							{ data.activeState &&
								<div class='options'>
									{ data.options.map(option => {
										return (
											<div class='option'>
												<font-awesome-icon icon={ this.icons[option.type - 1] }/>
												<span onClick={ () => this.startEvent(option.id) }>{ option.label }</span>
											</div>
										)
									})}
								</div>
							}
						</fragment>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './target.scss';
</style>