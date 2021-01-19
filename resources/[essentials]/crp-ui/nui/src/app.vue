<script>
	import { send } from './utils/lib.js';

	import userInterface from './components/interface/interface.vue';

	export default {
		name: 'app',
		components: {
			userInterface
		},
		methods: {
			closeMenu: function(appName) {
				this.changeRouter({ path: '/' });

                send('closeMenu', appName);
			},
			changeRouter: function(data) {
				this.$router.push(data).catch(error => {
					if (error.name !== 'NavigationDuplicated' && !error.message.includes('Avoided redundant navigation to current location')) {
						console.log(error);
					}
				});
			}
		},
		destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('message', (event) => {
				const info = event.data;

				if (info.app == 'sound') {
					let audio = new Audio(require('./assets/sounds/' + info.data.soundName + '.ogg'));

					audio.volume = info.data.volume;

   					audio.play();
				} else {
					if (info.event != undefined) {
						this.$store.dispatch(info.app + '/' + info.event, info.data);
					}

					if (info.state != undefined) {
						if (!info.state) {
							this.closeMenu(info.app);
						} else {
							this.changeRouter({ path: info.app });
						}
					}
				}
			});
        },
		render(h) {
			return (
				<v-app>
					<userInterface/>
					<router-view closeMenu={ this.closeMenu }/>
				</v-app>
			);
		}
	}
</script>

<style lang='scss'>
    @import './plugins/vue2-animate.min.css';
	@import 'https://fonts.googleapis.com/css2?family=Quantico&display=swap';

	html, body {
		font-family: 'Quantico', sans-serif;

        background-color: transparent;
        user-select: none;
		overflow: hidden;

		height: 100%;
		margin: 0;
    }
</style>