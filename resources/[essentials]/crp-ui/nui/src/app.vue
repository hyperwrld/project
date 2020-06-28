<template>
    <v-app>
        <cash/><hud/><notifications/><taskbar ref='teste'/>
        <component :is='currentComponent' v-if='isEnabled'/>
        <dialogs v-if='isEnabled'/>
    </v-app>
</template>

<script>
    import nui from './utils/nui';
    import { mapState } from 'vuex';

    import dialogs from './components/dialogs.vue';
    import character from './components/character/character.vue';

    import cash from './components/cash/cash.vue';
    import hud from './components/hud/hud.vue';
    import notifications from './components/notifications/notifications.vue';
    import taskbar from './components/taskbar/taskbar.vue';

    export default {
        name: 'app',
        components: {
            character, dialogs, cash, hud, notifications, taskbar
        },
        computed: {
            ...mapState({
                charactersData: state => state.character.userCharacters
            }),
        },
        data() {
            return {
                isEnabled: false, currentComponent: 'character'
            }
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('message', (event) => {
                switch (event.data.eventName) {
                    case 'toggleMenu':
                        if (event.data.component == 'character') {
                            this.$store.dispatch('character/setUserCharacters');
                        }

                        this.isEnabled = event.data.status, this.currentComponent = event.data.component;
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
                    case 'closeMenu':
                        this.isEnabled = false;
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
</style>