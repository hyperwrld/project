<script>
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faPhoneAlt, faCommentAlt, faUser, faCar, faAd, faCog, faMapPin, faCamera } from '@fortawesome/free-solid-svg-icons';
	import { faTwitter } from '@fortawesome/free-brands-svg-icons';

	library.add(faPhoneAlt, faCommentAlt, faUser, faCar, faTwitter, faAd, faCog, faMapPin, faCamera);

	export default {
		name: 'home',
		data() {
			return {
				apps: [
        			{
						code: 'history',
						name: 'Telefone',
						color: '#13b86c',
						icon: 'phone-alt',
						iconType: 'fas'
					},
					{
						code: 'messages',
						name: 'Mensagens',
						color: '#0191e7',
						icon: 'comment-alt',
						iconType: 'fas'
					},
        			{
						code: 'contacts',
						name: 'Contactos',
						color: '#fc7b20',
						icon: 'user',
						iconType: 'fas'
					},
					{
						code: 'garage',
						name: 'Garagem',
						color: '#ef1443',
						icon: 'car',
						iconType: 'fas'
					},
        			{
						code: 'twitter',
						name: 'Twitter',
						color: '#1DA1F2',
						icon: 'twitter',
						iconType: 'fab'
					},
					{
						code: 'adverts',
						name: 'Páginas amarelas',
						color: '#ffd300',
						icon: 'ad',
						iconType: 'fas'
					},
					{
						code: 'maps',
						name: 'Mapas',
						color: '#ff0000',
						icon: 'map-pin',
						iconType: 'fas'
					},
					{
						code: 'email',
						name: 'Email',
						color: '#2d8400',
						icon: 'envelope',
						iconType: 'fas'
					},
					{
						code: 'camera',
						name: 'Câmera',
						color: '#313131',
						icon: 'camera',
						iconType: 'fas'
					},
					{
						code: 'settings',
						name: 'Definições',
						color: '#868686',
						icon: 'cog',
						iconType: 'fas'
					}
    			],
			}
		},
		methods: {
			openApp(appName) {
				this.$router.push({ path: '/phone/' + appName });
			}
		},
		render(h) {
			return (
				<div class='home'>
					{ this.apps.map((app, index) => {
						return (
							<div class='app' style={{ backgroundColor: app.color }} onClick={ () => this.openApp(app.code) }>
								<v-tooltip top content-class='tooltip' scopedSlots={{ activator: ({on}) => <font-awesome-icon {...{ on }} icon={ [app.iconType, app.icon ] }/> }}>
									<span>{ app.name }</span>
								</v-tooltip>
							</div>
						)
					})}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './home.scss';
</style>