<script>
	export default {
		name: 'home',
		data() {
			return {
				apps: [
					{
						code: 'contacts',
						name: 'Contactos',
						color: '#FF7B22',
						icon: 'fas fa-user',
					},
					{
						code: 'garage',
						name: 'Garagem',
						color: '#6445E5',
						icon: 'fas fa-car',
					},
					{
						code: 'adverts',
						name: 'Life Invader',
						color: '#EF1346',
						icon: 'fas fa-ad',
					},
					{
						code: 'jobs',
						name: 'Trabalhos',
						color: '#0737a2',
						icon: 'fas fa-briefcase',
					},
					{
						code: 'maps',
						name: 'Mapas',
						color: '#0C967C',
						icon: 'fas fa-map-pin',
					},
					{
						code: 'email',
						name: 'Email',
						color: '#D30051',
						icon: 'fas fa-envelope',
					},
					{
						code: 'settings',
						name: 'Definições',
						color: '#597D95',
						icon: 'fas fa-cog',
					},
				],
			};
		},
		methods: {
			openApp: function(appName) {
				this.$router.push({ path: '/phone/' + appName });
			},
		},
		render() {
			return (
				<div class='home'>
					<div class='apps'>
						{this.apps.map((app) => {
							return (
								<div class='container'>
									<div
										class='app'
										style={{ backgroundColor: app.color }}
										onClick={() => this.openApp(app.code)}
									>
										<q-icon name={app.icon} />
									</div>
									<span>{app.name}</span>
								</div>
							);
						})}
					</div>
					<div class='essentials'>
						<div class='app history' onClick={() => this.openApp('history')}>
							<q-icon name='fas fa-phone-alt' />
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
								Chamadas
							</q-tooltip>
						</div>
						<div class='app messages' onClick={() => this.openApp('messages')}>
							<q-icon name='fas fa-comment-alt' />
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
								Mensagens
							</q-tooltip>
						</div>
						<div class='app twitter' onClick={() => this.openApp('twitter')}>
							<q-icon name='fab fa-twitter' />
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
								Twitter
							</q-tooltip>
						</div>
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './home.scss';
</style>
