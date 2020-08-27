<template>
	<v-app>
		<hud/><notifications/><taskbar/>
		<router-view></router-view>
    </v-app>
</template>

<script>
	import { mapState } from 'vuex';

    import hud from './components/hud/hud.vue';
    import notifications from './components/notifications/notifications.vue';
	import taskbar from './components/taskbar/taskbar.vue';

    export default {
		name: 'app',
		components: {
			hud, notifications, taskbar
		},
        computed: {
            ...mapState({
                appData: state => state.app
            }),
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('message', (event) => {
				if (event.data.eventName == 'toggleMenu')  {
					if (event.data.component) {
						switch(event.data.component) {
							case 'character':
								this.$store.dispatch('character/setUserCharacters');
								break;
							case 'inventory':
								this.$store.dispatch('inventory/setInventory', event.data.menuData);
								break;
							case 'actionbar':
								this.$store.dispatch('inventory/setActionBar', event.data.menuData);
								break;
							case 'spawnSelection':
								this.$store.dispatch('spawnSelection/setSpawnSelection', event.data.menuData);
								break;
							case 'phone':
								// this.$store.dispatch('phone/')
								break;
							default:
								break;
						}
					}
					this.$store.dispatch('app/setAppData', { status: event.data.status, component: event.data.component });
				} else {
					this.$store.dispatch(event.data.eventName, event.data.eventData);
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