<template>
    <div id='app'>
        <v-app id='inspire'>
            <v-content>
                <v-container class='fill-height' fluid v-if='canShow'>
                    <component :is='currentComponent' :charactersData='charactersData' transition='fade' transition-mode='out-in'></component>
                </v-container>
            </v-content>
        </v-app>
    </div>
</template>

<script>
    import mainMenu from './components/mainMenu';
    import nui from './utils/nui';

    export default {
        name: 'app',
        components: {
            mainMenu,
        },
        props: {
        },
        data() {
            return {
                canShow: true,
                isLoading: false,
                currentComponent: 'mainMenu',
                charactersData: []
            }
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            // this.charactersData.push({ option: 'create', name: '...' })
            // this.charactersData.push({ option: 'create', name: '...' })
            // this.charactersData.push({ option: 'create', name: '...' })
            // this.charactersData.push({ option: 'create', name: '...' })
            // this.charactersData.push({ option: 'create', name: '...' })

            this.listener = window.addEventListener('message', (event) => {
                switch (event.data.eventName) {
                    case 'toggleMenu':
                        this.canShow = event.data.status, this.currentComponent = event.data.component;

                        if (this.currentComponent == 'mainMenu') {
                            // eslint-disable-next-line no-console
                            console.log('qq??')
                            nui.send({ fetchCharacters: true }).then(data => {

                                // eslint-disable-next-line no-console
                                console.log(data)
                                this.charactersData = data;

                                for (var i = this.charactersData.length; i < 5; i++) {
                                    this.charactersData.push({ option: 'create', name: '...' })
                                }

                                // eslint-disable-next-line no-console
                                console.log(JSON.stringify(this.charactersData))

                                setTimeout(function () {
                                    this.isLoading = false;
                                }, 5000)
                            });
                        }
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
        overflow: hidden;
    }

    #inspire {
        background-color: transparent !important;
    }
</style>