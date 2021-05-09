<script>
	import { send } from './utils/lib.js';

	import essentials from './components/essentials/essentials.vue';

	export default {
		name: 'app',
		components: {
			essentials
		},
		methods: {
			closeMenu: function(appName) {
				this.changeRouter({ path: '/' });

				send('closeMenu', appName);
			},
			changeRouter: function(data) {
				this.$router.push(data).catch((error) => {
					if (
						error.name !== 'NavigationDuplicated' &&
						!error.message.includes(
							'Avoided redundant navigation to current location'
						)
					) {
						console.log(error);
					}
				});
			},
		},
		destroyed() {
			window.removeEventListener('message', this.listener);
		},
		mounted() {
			this.listener = window.addEventListener('message', (event) => {
				const info = event.data;

				if (info.app == 'sound') {
					let audio = new Audio(
						require('./assets/sounds/' + info.data.soundName + '.ogg')
					);

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
		render() {
			return (
				<div id='q-app'>
					<essentials/>
					<router-view closeMenu={this.closeMenu} />
				</div>
			);
		},
	};
</script>

<style lang="scss">
	@import 'https://fonts.googleapis.com/css2?family=Quantico&display=swap';

	html,
	body {
		background: transparent;
		user-select: none;
		overflow: hidden;

		height: 100%;
		margin: 0;
	}
</style>
