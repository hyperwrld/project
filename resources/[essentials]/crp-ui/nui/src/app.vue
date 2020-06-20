<template>
    <v-app v-if='isEnabled'>
        <component :is='currentComponent'/>

        <dialogs/>
    </v-app>
</template>

<script>
    import nui from './utils/nui';
    import { mapState } from 'vuex';

    import dialogs from './components/dialogs.vue';
    import characterList from './components/base/characterList.vue';

    export default {
        name: 'app',
        components: {
            characterList,
            dialogs
        },
        computed: {
            ...mapState({
                charactersData: state => state.characterList.userCharacters,
            }),
        },
        data() {
            return {
                isEnabled: true,
                currentComponent: 'characterList'
            }
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('message', (event) => {
                switch (event.data.eventName) {
                    case 'toggleMenu':
                        if (event.data.component == 'characterList') {
                            this.$store.dispatch('characterList/setUserCharacters');
                        }

                        this.isEnabled = event.data.status, this.currentComponent = event.data.component;
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