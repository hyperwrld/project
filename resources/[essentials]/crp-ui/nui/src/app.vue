<template>
	<v-app>
		<hud/><notifications/><taskbar/><actionbar/>
		<router-view :closeMenu='closeMenu'></router-view>
    </v-app>
</template>

<script>
	import { mapState } from 'vuex';

    import hud from './components/hud/hud.vue';
    import notifications from './components/notifications/notifications.vue';
	import taskbar from './components/taskbar/taskbar.vue';
	import actionbar from './components/inventory/actionbar/actionbar.vue';

	import nui from './utils/nui.js';

    export default {
		name: 'app',
		components: {
			hud, notifications, taskbar, actionbar
		},
		methods: {
			closeMenu: function(appName) {
				this.$router.push({ path: '/' }).catch(error => {
					if (error.name !== 'NavigationDuplicated' && !error.message.includes('Avoided redundant navigation to current location')) {
						console.log(error);
					}
				});

                nui.send('closeMenu', appName);
            },
		},
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('message', (event) => {
				if (event.data.event != undefined) {
					var module = event.data.app;

					switch (event.data.app) {
						case 'selection':
							module = 'character';
							break;
						default:
							break;
					}

					this.$store.dispatch(module + '/' + event.data.event, event.data.eventData);
				}

				if (event.data.status != undefined) {
					const data = event.data.status ? { path: event.data.app } : { path: '/' };

					this.$router.push(data).catch(error => {
    					if (error.name !== 'NavigationDuplicated' && !error.message.includes('Avoided redundant navigation to current location')) {
      						console.log(error);
						}
					});

					if (!event.data.status) {
						nui.send('closeMenu', event.data.app);
					}
				}
			});
        }
    };
</script>

<style lang='scss'>
    @import 'https://unpkg.com/vue2-animate/dist/vue2-animate.min.css';
    @import 'https://fonts.googleapis.com/css2?family=Quantico&display=swap';

    html, body {
        background-color: transparent;
        user-select: none;
        overflow: hidden;
        height: 100%;
    }

    #app {
        background-color: transparent;
	}

	.v-application .error {
		background-color: transparent !important;
		border-color: #ff5252 !important;
	}

	.errors {
		padding: 0 5% 5%;

		#error {
			display: flex;
			align-items: center;
			justify-content: center;
			span {
				display: flex;
				width: 85%;
				font-size: 0.6rem;
				align-items: center;
				color: #fc9403;
				svg {
					margin-right: 5%;
					font-size: 0.9rem;
					width: 10%;
				}
			}
			margin-bottom: 2%;
		}

		& > :last-child {
			margin-bottom: 0 !important;
		}
	}
</style>