<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faBriefcase, faSignInAlt } from '@fortawesome/free-solid-svg-icons';
	import { fragment, send } from './../../../../../utils/lib.js';

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
			createGroup(identifier) {
				send('createGroup', identifier).then(data => {
					if (data.state) {
						this.$store.dispatch('jobs/setGroupData', data.group);
					}
				});
			},
			joinGroup() {
				dialogs.createDialog({
					attach: '.app', title: 'Entrar num grupo',
					choices: [
						{ key: 'code', type: 'text', placeholder: 'Código', max: 4, errorText: 'Insira um código com 4 caracteres.' }
					],
					sendText: 'Entrar', nuiType: 'joinGroup'
				}).then(response => {
					if (response) {
						this.$store.dispatch('jobs/setGroupData', response.data.group);
					}
      			})
			},
			leaveGroup() {
				dialogs.createDialog({
					attach: '.app', title: 'Tens a certeza?', sendText: 'Sair', nuiType: 'leaveGroup', data: { code: this.jobGroup.code }
				}).then(response => {
					if (response) {
						this.$store.dispatch('jobs/setGroupData', {});
					}
      			})
			},
			kickMember(source) {
				if (!this.jobGroup.isLeader) return

				dialogs.createDialog({
					attach: '.app', title: 'Tens a certeza?', sendText: 'Sair', nuiType: 'kickMember', data: { code: this.jobGroup.code, member: source }
				}).then(response => {
					console.log(response)
					if (response) {
						this.$store.dispatch('jobs/setGroupData', response.data.group);
					}
      			})
			}
		},
		render(h) {
			let hasGroup = Object.keys(this.jobGroup).length > 0 ? true : false;

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
										{ this.jobGroup.members.map((member) => {
											return (
												<div class='member'>
													<div class='name'>
														<span class='name'>{ member.name }</span>
													</div>
													<span class='money'>
														{ member.value + '€'}
													</span>
													{ !member.isMember ?
														<button>Líder</button> : this.jobGroup.isLeader ? <button class='kick' onClick={ () => this.kickMember(member.source) }>Expulsar</button> : <button>Membro</button>
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
											<span>Valor total: { this.jobGroup.value + '€'}</span>
										</div>
									</div>
								</div>
								<div class='bottom'>
									<button onClick={ this.leaveGroup }>Sair do grupo</button>
								</div>
							</fragment>
							:
							<fragment>
								<div class='list'>
									{ this.jobList.map((job) => {
										return (
											<div class='job'>
												<span>{ job.label }</span>
												<font-awesome-icon icon={ ['fas', 'sign-in-alt'] } onClick={ () => this.createGroup(job.name) }/>
											</div>
										)
									})}
								</div>
								<button onClick={ this.joinGroup }>Entrar num grupo</button>
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