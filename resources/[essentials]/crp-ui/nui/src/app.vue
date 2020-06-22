<template>
    <v-app>
        <cash/><hud/>
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

    export default {
        name: 'app',
        components: {
            character, dialogs, cash, hud
        },
        computed: {
            ...mapState({
                charactersData: state => state.character.userCharacters
            }),
        },
        data() {
            return {
                isEnabled: true, currentComponent: 'character'
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
                        this.$store.dispatch('cash/setMoney', event.data.status);
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