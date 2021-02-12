<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faEye } from '@fortawesome/free-solid-svg-icons';

	import { fragment } from '../../../utils/lib';

	library.add(faEye);

	export default {
		name: 'target',
		computed: {
			...mapGetters('target', {
				data: 'getData'
			})
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
											<fragment>
												<font-awesome-icon icon={ this.icons[option.icon] }/><span>{ option.label }</span>
											</fragment>
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