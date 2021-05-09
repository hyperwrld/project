<script>
	export default {
		name: 'home',
		data() {
			return {
				apps: [
					{
						code: 'history',
						name: 'Telefone',
						color: '#13b86c',
						icon: 'fas fa-phone-alt',
					},
					{
						code: 'messages',
						name: 'Mensagens',
						color: '#0191e7',
						icon: 'fas fa-comment-alt',
					},
					{
						code: 'contacts',
						name: 'Contactos',
						color: '#fc7b20',
						icon: 'fas fa-user',
					},
					{
						code: 'garage',
						name: 'Garagem',
						color: '#ef1443',
						icon: 'fas fa-car',
					},
					{
						code: 'twitter',
						name: 'Twitter',
						color: '#1DA1F2',
						icon: 'fab fa-twitter',
					},
					{
						code: 'adverts',
						name: 'Anúncios',
						color: '#ffd300',
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
						color: '#ff0000',
						icon: 'fas fa-map-pin',
					},
					{
						code: 'email',
						name: 'Email',
						color: '#2d8400',
						icon: 'fas fa-envelope',
					},
					{
						code: 'camera',
						name: 'Câmera',
						color: '#313131',
						icon: 'fas fa-camera',
					},
					{
						code: 'settings',
						name: 'Definições',
						color: '#868686',
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
					{this.apps.map((app) => {
						return (
							<div
								class='app'
								style={{ backgroundColor: app.color }}
								onClick={() => this.openApp(app.code)}
							>
								<v-tooltip
									top
									content-class='tooltip'
									nudge-top={2}
									scopedSlots={{
										activator: ({ on }) => (
											<q-icon {...{ on }} name={app.icon} />
										),
									}}
								>
									<span>{app.name}</span>
								</v-tooltip>
							</div>
						);
					})}
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './home.scss';
</style>
