<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faFeatherAlt, faReply, faRetweet, faSadTear, faSignInAlt, faUserSlash } from '@fortawesome/free-solid-svg-icons';
	import { faTwitter } from '@fortawesome/free-brands-svg-icons';

	import { fragment, convertTime, processMessage } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';

	library.add(faTwitter, faFeatherAlt, faSadTear, faRetweet, faUserSlash, faSignInAlt);

	export default {
		name: 'jobs',
		computed: {
			...mapGetters('phone', {
				tweets: 'getTweets'
			})
		},
		methods: {

		},
		render(h) {
			let hasGroup = false;

			return (
				<div class='jobs'>
					<div class='top'>
						<font-awesome-icon icon={ ['fas', 'briefcase'] }/>
						{ !hasGroup ?
							'Trabalhos'
							:
							'Grupo de Trabalho'
						}
					</div>
					<div class={`app ${ hasGroup ? '' : 'empty'}`}>
						{ hasGroup ?
							<fragment>
								<div class='content'>
									<div class='members'>
										<div class='member'>
											<div class='name'>
												<span class='name'>Lewis Hamilton</span>
											</div>
											<span class='money'>+300€</span>
											<button>Líder</button>
										</div>
										<div class='member'>
											<span class='name'>Joao Carvalho</span>
											<span class='money'>+1500€</span>
											<button class='kick'>Expulsar</button>
										</div>
										<div class='member'>
											<span class='name'>Tiago Guerreiro</span>
											<span class='money'>+500€</span>
											<button class='kick'>Expulsar</button>
										</div>
										<div class='member'>
											<span class='name'>Lewis Hamilton</span>
											<span class='money'>+3000€</span>
											<button class='kick'>Expulsar</button>
										</div>
									</div>
									<div class='informations'>
										<span>Informações</span>
										<div class='information'>
											<span>Membros: 3/4</span>
											<span>Código: 3DTV6</span>
											<span>Valor total: 3000€</span>
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
									<div class='job'>
										<span>Lixeiro</span><font-awesome-icon icon={ ['fas', 'sign-in-alt'] }/>
									</div>
									<div class='job'>
										<span>Camionista</span><font-awesome-icon icon={ ['fas', 'sign-in-alt'] }/>
									</div>
									<div class='job'>
										<span>Agricultor</span><font-awesome-icon icon={ ['fas', 'sign-in-alt'] }/>
									</div>
									<div class='job'>
										<span>Eletrecista</span><font-awesome-icon icon={ ['fas', 'sign-in-alt'] }/>
									</div>
									<div class='job'>
										<span>Lenhador</span><font-awesome-icon icon={ ['fas', 'sign-in-alt'] }/>
									</div>
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