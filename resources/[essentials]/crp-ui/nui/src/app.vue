<template>
    <v-app>
        <cash/><hud/><notifications/><taskbar ref='teste'/>
        <keep-alive>
            <component :is='appData.currentComponent' v-if='appData.isEnabled'></component>
        </keep-alive>
        <dialogs v-if='appData.isEnabled'/>
    </v-app>
</template>

<script>
    import { mapState } from 'vuex';

    import dialogs from './components/dialogs.vue';

    import character from './components/character/character.vue';
    import spawnSelection from './components/spawnSelection/spawnSelection.vue';
    import inventory from './components/inventory/main/inventory.vue';
    import actionbar from './components/inventory/actionbar/actionbar.vue';
    import phone from './components/phone/phone.vue';
    import home from './components/phone/home/home.vue';
    import vehicleshop from './components/vehicleshop/vehicleshop.vue';

    import cash from './components/cash/cash.vue';
    import hud from './components/hud/hud.vue';
    import notifications from './components/notifications/notifications.vue';
    import taskbar from './components/taskbar/taskbar.vue';

    export default {
        name: 'app',
        components: {
            dialogs, character, spawnSelection, inventory, actionbar, phone, vehicleshop, cash, hud, notifications, taskbar
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
                switch (event.data.eventName) {
                    case 'toggleMenu':
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
                        break;
                    case 'setMoneyStatus':
                        this.$store.dispatch('cash/setMoneyStatus', event.data.data);
                        break;
                    case 'setMoney':
                        this.$store.dispatch('cash/setMoney', event.data.money);
                        break;
                    case 'removeMoney':
                        this.$store.dispatch('cash/removeMoney', event.data.quantity);
                        break;
                    case 'addMoney':
                        this.$store.dispatch('cash/addMoney', event.data.quantity);
                        break;
                    case 'setVehicleStatus':
                        this.$store.dispatch('hud/setVehicleStatus', event.data.status)
                        break;
                    case 'setCompassStatus':
                        this.$store.dispatch('hud/setCompassStatus', event.data.status)
                        break;
                    case 'setHudPosition':
                        this.$store.dispatch('hud/setMinimapData', event.data.minimapData)
                        break;
                    case 'updateCharacterData':
                        this.$store.dispatch('hud/setCharacterData', event.data.status);
                        break;
                    case 'updateVehicleData':
                        this.$store.dispatch('hud/setVehicleData', event.data.vehicleData);
                        break;
                    case 'updateCompassData':
                        this.$store.dispatch('hud/setCompassDirection', event.data.direction);
                        break;
                    case 'setAlert':
                        this.$store.dispatch('notifications/setAlert', event.data.alertData);
                        break;
                    case 'setCustomAlert':
                        this.$store.dispatch('notifications/setCustomAlert', event.data.alertData);
                        break;
                    case 'setTaskbar':
                        this.$store.dispatch('taskbar/setTaskbar', event.data.taskbarData);
                        break;
                    case 'stopTaskbar':
                        this.$store.dispatch('taskbar/stopTaskbar');
                        break;
                    case 'setSkillbar':
                        this.$store.dispatch('taskbar/setSkillbar', event.data.skillbarData);
                        break;
					case 'updatePhone':
						this.$store.dispatch('phone/updatePhone', event.data.phoneData);
						break;
                    default:
                        break;
                }
            }, false);
        },
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