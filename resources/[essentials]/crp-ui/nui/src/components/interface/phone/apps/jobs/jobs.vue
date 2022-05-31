<script>
	import { mapGetters } from 'vuex';
	import { fragment, convertTime } from './../../../../../utils/lib.js';

	import dialogs from './../../modules/dialogs/dialogs.js';

	export default {
		name: 'jobs',
		computed: {
			...mapGetters('jobs', {
				jobGroup: 'getJobGroup',
				jobList: 'getJobList',
			}),
		},
		methods: {},
		render() {
			let isNotEmpty = this.jobList.length > 0 ? true : false,
				hasGroup = Object.keys(this.jobGroup).length > 0 ? true : false;

			(hasGroup = true), (isNotEmpty = true);

			return (
				<div class='jobs'>
					<div class={`content ${isNotEmpty ? '' : 'empty'}`}>
						{isNotEmpty ? (
							<fragment>
								<q-list dense dark>
									{hasGroup ? (
										<fragment>
											<div class='group'>
												<div class='loader'>
													<q-spinner-rings size='85px' />
													<span>O seu grupo ainda não está pronto.</span>
												</div>
												<span class='title'>Membros:</span>
												<div class='members'>
													{this.jobGroup.members.map((member) => {
														let iconName = member.isLeader
															? 'fas fa-user-crown'
															: 'fas fa-user';
														let isReady = member.isReady ? 'green' : 'red';

														return (
															<q-item>
																<q-item-section avatar>
																	<q-icon name={iconName} />
																</q-item-section>

																<q-item-section>{member.name}</q-item-section>
																<q-badge rounded floating color={isReady} />
															</q-item>
														);
													})}
												</div>
												<div class='actions'>
													<q-btn
														color='primary'
														size='sm'
														text-color='white'
														label='Pronto'
													/>
													<q-btn
														color='negative'
														size='sm'
														text-color='white'
														label='Apagar o grupo'
													/>
												</div>
											</div>
										</fragment>
									) : (
										<fragment>
											{this.jobList.map((job) => {
												<div class='job'>
													<span class='name'>{job.name}</span>
													<q-icon class='icon' name='fas fa-sign-in-alt'>
														<q-tooltip
															anchor='center left'
															self='center right'
															transition-show='scale'
															transition-hide='scale'
															offset={[5, 5]}
															content-style={{
																backgroundColor: 'rgba(97, 97, 97, 0.9)',
																padding: '2px 5px',
															}}
														>
															Criar grupo
														</q-tooltip>
													</q-icon>
												</div>;
											})}
											<q-btn
												color='white'
												text-color='black'
												label='Entrar num grupo'
											/>
										</fragment>
									)}
								</q-list>
							</fragment>
						) : (
							<fragment>
								<q-icon name='fas fa-flushed' />
								<span>Opps, aconteceu alguma coisa!</span>
							</fragment>
						)}
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './jobs.scss';
</style>
