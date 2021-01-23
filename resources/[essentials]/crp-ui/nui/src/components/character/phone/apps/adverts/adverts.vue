<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faPlusCircle, faSadTear, faSearch } from '@fortawesome/free-solid-svg-icons';

	import { fragment } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';

	library.add(faSearch, faPlusCircle, faSadTear);

	export default {
		name: 'adverts',
		data() {
			return {
				searchInput: ''
			}
		},
		computed: {
			...mapGetters('adverts', {
				adverts: 'getAdverts'
			})
		},
		methods: {
			filterItems() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.adverts;
				}

				if (isNaN(this.searchInput)) {
					return this.adverts.filter(c => c.name.toLowerCase().indexOf(search) > -1);
				} else {
					return this.adverts.filter(c => c.name.toString().toLowerCase().indexOf(search) > -1);
				}
			},
			postAdvert() {
				dialogs.createDialog({
					attach: '.list', title: 'Insira um anúncio',
					choices: [
						{ key: 'message', placeholder: 'Mensagem', errorText: 'Escolha uma mensagem para colocar no anúncio.' }
					],
					sendText: 'Enviar', nuiType: 'postAdvert'
				}).then(response => {
					if (response) {
						this.adverts.push({
							id: response.data.advertData.id, name: response.data.advertData.name,
							number: response.data.advertData.number, message: response.data.advertData.message
						});
					}
      			});
			},
			removeAdvert(advertId) {
				dialogs.createDialog({
					attach: '.list', title: 'Queres apagar o anúncio?', sendText: 'Remover', nuiType: 'removeAdvert', data: { advertId: advertId }
				});
			}
		},
		render(h) {
			const isNotEmpty = this.filterItems().length > 0 ? true : false;

			return (
				<div class='adverts'>
					<div class='top'>
					    <div class='search-wrapper'>
							<input type='text' v-model={ this.searchInput } placeholder='Procurar...'/>
							<font-awesome-icon icon={ ['fas', 'search'] }/>
						</div>
						<font-awesome-icon icon={ ['fas', 'plus-circle'] } onClick={ this.postAdvert }/>
					</div>
					<div class={`list ${ isNotEmpty ? '' : 'empty'}`}>
						{ isNotEmpty ?
							<fragment>
								{ this.filterItems().map((advert, index) => {
									return (
										<div class='advert' onClick={ () => this.removeAdvert(advert.id) }>
											<div class='content'>
												{ advert.message }
											</div>
											<div class='information'>
												<span>{ advert.name }</span><span>{ advert.number }</span>
											</div>
										</div>
									)
								})}
							</fragment>
							:
							<fragment>
								<font-awesome-icon icon={ ['fas', 'sad-tear'] }/>
								<span>Não foi encontrado nenhum anúncio.</span>
							</fragment>
						}
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './adverts.scss';
</style>