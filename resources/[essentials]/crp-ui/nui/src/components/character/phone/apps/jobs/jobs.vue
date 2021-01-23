<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faBriefcase, faSignInAlt } from '@fortawesome/free-solid-svg-icons';
	import { fragment } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';

	library.add(faBriefcase, faSignInAlt);

	export default {
		name: 'jobs',
		computed: {
			...mapGetters('jobs', {
				jobGroup: 'getJobGroup', jobList: 'getJobList'
			})
		},
		methods: {

		},
		render(h) {
			let hasGroup = this.jobGroup.length > 0 ? true : false;

			return (
				<div class='jobs'>
					<div class='top'>
						<font-awesome-icon icon={ ['fas', 'briefcase'] }/>
						{ !hasGroup ?
							'Trabalhos' : 'Grupo de Trabalho'
						}
					</div>
					<div class={`app ${ hasGroup ? '' : 'empty'}`}>
						{ hasGroup ?
							<fragment>
								<div class='content'>
									<div class='members'>
										{ this.jobGroup.members.map((member, index) => {
											return (
												<div class='member'>
													<div class='name'>
														<span class='name'>{ member.name }</span>
													</div>
													<span class='money'>{ member.money + '€'}</span>

													{ this.jobGroup.isLeader ?
														<button class='kick'>Expulsar</button>
													: member.isMember ?
														<button>Membro</button> : <button>Líder</button>
													}
												</div>
											)
										})}
									</div>
									<div class='informations'>
										<span>Informações</span>
										<div class='information'>
											<span>{ this.jobGroup.members.length + '/4' }</span>
											<span>Código: { this.jobGroup.code }</span>
											<span>Valor total: { this.jobGroup.totalMoney + '€'}</span>
										</div>
									</div>
								</div>
								<div class='bottom'>
									<button>Sair do grupo</button>
								</div>
							</fragment>
							:
							<fragment>
								<div class='list'>
									{ this.jobList.map((job, index) => {
										return (
											<div class='job'>
												<span>{ job.label }</span>
												<font-awesome-icon icon={ ['fas', 'sign-in-alt'] }/>
											</div>
										)
									})}
								</div>
								<button>Entrar num grupo</button>
							</fragment>
						}
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './jobs.scss';
</style>