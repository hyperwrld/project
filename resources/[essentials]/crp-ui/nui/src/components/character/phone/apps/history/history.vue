<script>
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faPhoneAlt, faCommentAlt, faUser, faCar, faAd, faCog, faMapPin, faCamera } from '@fortawesome/free-solid-svg-icons';
	import { faTwitter } from '@fortawesome/free-brands-svg-icons';

	import { fragment, convertTime } from './../../../../../utils/lib.js';

	library.add(faPhoneAlt, faCommentAlt, faUser, faCar, faTwitter, faAd, faCog, faMapPin, faCamera);

	export default {
		name: 'history',
		data() {
			return {
				searchInput: ''
			}
		},
		methods: {
			filterItems(appName) {
				return [{ name: 9666, time: 333 }, { name: 'Tiago Guerreiro', time: 33354545}];
			}
		},
		render(h) {
			return (
				<div class='history'>
					<div class='top'>
					    <div class='search-wrapper'>
							<input type='text' v-model={ this.searchInput } placeholder='Procurar...'/>
							<font-awesome-icon icon={ ['fas', 'search'] }/>
						</div>
						<font-awesome-icon icon={ ['fas', 'phone-alt'] }/>
					</div>
					<div class={`list ${ this.filterItems().length > 0 ? '' : 'empty'}`}>
						{ this.filterItems().length > 0 ?
							<v-expansion-panels flat accordion>
								{ this.filterItems().map((call, index) => {
									return (
										<v-expansion-panel class='history-square'>
											<v-expansion-panel-header>
												<div class='number-info'>
													<div class='name'>{ call.name }</div>
													<div class='time'>{ convertTime(call.time) }</div>
												</div>
											</v-expansion-panel-header>
											<v-expansion-panel-content>
												<font-awesome-icon icon={ ['fas', 'phone-alt'] }/>
												<font-awesome-icon icon={ ['fas', 'comment-alt'] }/>
												{ !isNaN(call.name) &&
													<font-awesome-icon icon={ ['fas', 'user-plus'] }/>
												}
											</v-expansion-panel-content>
										</v-expansion-panel>
									)
								})}
            				</v-expansion-panels>
							:
							<fragment>
								<font-awesome-icon icon={ ['fas', 'sad-tear'] }/>
								<span>Não foi encontrado nenhum registo de chamadas.</span>
							</fragment>
						}
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './history.scss';
</style>