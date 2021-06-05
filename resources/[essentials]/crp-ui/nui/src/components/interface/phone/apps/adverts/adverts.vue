<script>
	import { mapGetters } from 'vuex';
	import { fragment, convertTime } from './../../../../../utils/lib.js';

	export default {
		name: 'adverts',
		computed: {
			...mapGetters('adverts', {
				data: 'getData',
			}),
		},
		data() {
			return {
				searchInput: '',
			};
		},
		methods: {
			filterItems: function() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.data;
				}

				if (isNaN(this.searchInput)) {
					return this.data.filter(
						(c) => c.name.toLowerCase().indexOf(search) > -1
					);
				}

				return this.data.filter(
					(c) =>
						c.name
							.toString()
							.toLowerCase()
							.indexOf(search) > -1
				);
			},
		},
		render() {
			const isNotEmpty = this.filterItems().length > 0 ? true : false;

			return (
				<div class='adverts'>
					<q-toolbar>
						<q-input
							v-model={this.searchInput}
							debounce='500'
							filled
							placeholder='Procurar...'
							dark
							dense
						>
							<template slot='append'>
								<q-icon name='fas fa-search' />
							</template>
						</q-input>
						<q-icon name='fas fa-plus-circle'>
							<q-tooltip
								anchor='center left'
								self='center right'
								transition-show='scale'
								transition-hide='scale'
								offset={[10, 10]}
								content-style={{
									backgroundColor: 'rgba(97, 97, 97, 0.9)',
									padding: '2px 5px',
								}}
							>
								Publicar anúncio
							</q-tooltip>
						</q-icon>
					</q-toolbar>
					<div class={`content ${isNotEmpty ? '' : 'empty'}`}>
						{isNotEmpty ? (
							<q-list dense dark>
								{this.filterItems().map((advert) => {
									return (
										<q-expansion-item group='contacts' dark>
											<template slot='header'>
												<span class='message'>
													🔧Hayes Auto Repair🔧 Top Quality Repairs | Lock picks
													| Buying Materials
												</span>
												<span class='name'>Tiago Guerreiro</span>
											</template>
											<q-card dark>
												<q-card-actions align='around'>
													<q-icon name='fas fa-phone-alt'>
														<q-tooltip
															anchor='bottom middle'
															self='top middle'
															transition-show='scale'
															transition-hide='scale'
															offset={[10, 10]}
															content-style={{
																backgroundColor: 'rgba(97, 97, 97, 0.9)',
																padding: '2px 5px',
															}}
														>
															Telefonar
														</q-tooltip>
													</q-icon>
													<q-icon name='fas fa-comment-alt'>
														<q-tooltip
															anchor='bottom middle'
															self='top middle'
															transition-show='scale'
															transition-hide='scale'
															offset={[10, 10]}
															content-style={{
																backgroundColor: 'rgba(97, 97, 97, 0.9)',
																padding: '2px 5px',
															}}
														>
															Mandar mensagem
														</q-tooltip>
													</q-icon>
													<q-icon name='fas fa-clipboard'>
														<q-tooltip
															anchor='bottom middle'
															self='top middle'
															transition-show='scale'
															transition-hide='scale'
															offset={[10, 10]}
															content-style={{
																backgroundColor: 'rgba(97, 97, 97, 0.9)',
																padding: '2px 5px',
															}}
														>
															Copiar número
														</q-tooltip>
													</q-icon>
												</q-card-actions>
											</q-card>
										</q-expansion-item>
									);
								})}
							</q-list>
						) : (
							<fragment>
								<q-icon name='fas fa-sad-tear' />
								<span>Não foi encontrado nenhum anúncio.</span>
							</fragment>
						)}
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './adverts.scss';
</style>
