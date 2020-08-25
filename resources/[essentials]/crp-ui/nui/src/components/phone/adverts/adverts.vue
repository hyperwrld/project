<template>
    <v-container fluid>
        <div class='top-bar'>
			<div class='search-wrapper'>
                <input type='text' v-model='searchInput' placeholder='Procurar...'/>
                <font-awesome-icon :icon='["fas", "search"]'></font-awesome-icon>
            </div>
            <font-awesome-icon :icon='["fas", "plus-circle"]' @click='postAdvert'></font-awesome-icon>
        </div>
        <div class='adverts-list'>
            <div v-if='filterAdverts().length > 0'>
				<div class='advert' v-for='advert in filterAdverts()'>
					<advert :advert='advert'/>
				</div>
            </div>
        	<div v-else class='empty-list'>
				<font-awesome-icon :icon='["fas", "sad-tear"]'></font-awesome-icon>
				<span>Não foi encontrado nenhum anúncio.</span>
			</div>
        </div>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';
	import { processMessage, convertTime } from './../../../utils/lib.js';

	import dialogs from './../dialogs/dialogs.js';

	const advert = {
		props: ['advert'],
		methods: {
			removeAdvert: function(advertId) {
				dialogs.createDialog({
					attach: '.adverts-list', title: 'Tens a certeza que queres apagar o anúncio?',
					sendButton: 'Remover', nuiType: 'removeAdvert', additionalData: { advertId: advertId }
				});
			}
		},
		render (h) {
			return (
				<div class='advert-square'>
					<div class='content'>
						<div class='text'>{this.advert.message}</div>
					</div>
					<div class='info'>
						<div class='name'>
							<font-awesome-icon icon={['fas', 'user']}></font-awesome-icon>
							{this.advert.name}
						</div>
						<div class='number'>
							<font-awesome-icon icon={['fas', 'phone-alt']}></font-awesome-icon>
							{this.advert.number}
						</div>
					</div>
				</div>
			);
		}
	};

    export default {
		name: 'adverts',
		components: {
            advert
        },
        data() {
            return {
				searchInput: ''
            }
        },
        computed: {
            ...mapGetters('phone', {
				adverts: 'getAdverts'
			})
        },
        methods: {
			postAdvert: function() {
				dialogs.createDialog({
					attach: '.adverts-list', title: 'Insira um anúncio',
					choices: [
						{ key: 'message', placeholder: 'Mensagem', errorText: 'Escolha uma mensagem para colocar no anúncio.' }
					],
					sendButton: 'Enviar', nuiType: 'postAdvert'
				}).then(response => {
					if (response) {
						this.adverts.push({
							id: response.data.advertData.id, name: response.data.advertData.name,
							number: response.data.advertData.number, message: response.data.advertData.message
						});
					}
      			});
			},
			filterAdverts: function() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.adverts;
				}

				if (isNaN(this.searchInput)) {
					return this.adverts.filter(c => c.message.toLowerCase().indexOf(search) > -1);
				} else {
					return this.adverts.filter(c => c.number.toString().toLowerCase().indexOf(search) > -1);
				}
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './adverts.scss';
</style>