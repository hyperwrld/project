<script>
	import { mapGetters } from 'vuex';
	import { fragment, convertTime } from './../../../../../utils/lib.js';

	export default {
		name: 'twitter',
		computed: {
			...mapGetters('twitter', {
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
				<div class='twitter'>
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
						<q-icon name='fas fa-feather-alt'>
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
								Tweetar
							</q-tooltip>
						</q-icon>
					</q-toolbar>
					<div class={`content ${isNotEmpty ? '' : 'empty'}`}>
						{isNotEmpty ? (
							<q-list dense dark>
								{this.filterItems().map((tweet) => {
									return (
										<div class='tweet'>
											<div class='information'>
												<span class='name'>Tiago Guerreiro</span>
												<span class='time'> • há 5 dias</span>
											</div>
											<div class='message'>Bom dia Los Santos</div>
											<div class='footer'>
												<q-icon name='fas fa-reply'>
													<q-tooltip
														anchor='top middle'
														self='bottom middle'
														transition-show='scale'
														transition-hide='scale'
														offset={[10, 10]}
														content-style={{
															backgroundColor: 'rgba(97, 97, 97, 0.9)',
															padding: '2px 5px',
														}}
													>
														Responder
													</q-tooltip>
												</q-icon>
												<q-icon name='fas fa-retweet'>
													<q-tooltip
														anchor='top middle'
														self='bottom middle'
														transition-show='scale'
														transition-hide='scale'
														offset={[10, 10]}
														content-style={{
															backgroundColor: 'rgba(97, 97, 97, 0.9)',
															padding: '2px 5px',
														}}
													>
														Retweetar
													</q-tooltip>
												</q-icon>
												<div class='likes'>
													<q-icon name='fas fa-heart'>
														<q-tooltip
															anchor='top middle'
															self='bottom middle'
															transition-show='scale'
															transition-hide='scale'
															offset={[10, 10]}
															content-style={{
																backgroundColor: 'rgba(97, 97, 97, 0.9)',
																padding: '2px 5px',
															}}
														>
															Like
														</q-tooltip>
													</q-icon>
													<span>50</span>
												</div>
											</div>
										</div>
									);
								})}
							</q-list>
						) : (
							<fragment>
								<q-icon name='fas fa-sad-tear' />
								<span>Não foi encontrado nenhum tweet.</span>
							</fragment>
						)}
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './twitter.scss';
</style>
