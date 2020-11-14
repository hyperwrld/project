<template>
	<v-app>
		<hud/><notifications/><taskbar/><actionbar/>
		<router-view :closeMenu='closeMenu'/>
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
				this.changeRouter({ path: '/' });

                nui.send('closeMenu', appName);
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
				var module = event.data.app, path = event.data.app;

				switch(event.data.app) {
					case 'selection':
					case 'intro':
						module = 'character', path = 'character/' + event.data.app;
						break;
					default:
						break;
				}

				if (event.data.event != undefined) {
					this.$store.dispatch(module + '/' + event.data.event, event.data.eventData);
				}

				if (event.data.status != undefined) {
					if (!event.data.status) {
						closeMenu(event.data.app);
					} else {
						changeRouter({ path: path });
					}
				}
			});
        }
    };
</script>

<style lang='scss'>
    @import 'https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css';
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