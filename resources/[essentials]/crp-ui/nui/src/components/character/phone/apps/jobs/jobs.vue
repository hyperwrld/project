<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faFeatherAlt, faReply, faRetweet, faSadTear, faUserSlash } from '@fortawesome/free-solid-svg-icons';
	import { faTwitter } from '@fortawesome/free-brands-svg-icons';

	import { fragment, convertTime, processMessage } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';

	library.add(faTwitter, faFeatherAlt, faSadTear, faRetweet, faUserSlash);

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
			let hasGroup = true;

			return (
				<div class={`jobs ${ hasGroup ? '' : 'empty'}`}>
					{ hasGroup ?
						<fragment>
							<div class='top'>
								<span>Grupo de Trabalho</span><span>3DT7</span>
							</div>
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
										<span>Total: 3000€</span>
									</div>
								</div>
							</div>
							<div class='bottom'>
								<button>Sair do grupo</button>
							</div>
						</fragment>
						:
						<fragment>
							<font-awesome-icon icon={ ['fas', 'sad-tear'] }/>
							<span>Não estás em nenhum grupo.</span>
							<font-awesome-icon class='button' icon={ ['fas', 'plus-circle'] }/>
						</fragment>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './jobs.scss';
</style>