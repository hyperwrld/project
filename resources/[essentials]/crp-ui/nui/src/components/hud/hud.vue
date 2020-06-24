<template>
    <v-container fluid>
        <div class='minimap' v-bind:style='{ top: top, left: left, width: width, height: height }'>
    		<div class='bar'>
    			<div class='health status'>
                    <font-awesome-icon icon='heart'></font-awesome-icon>
    				<div class='sub-health' v-bind:style='{ width: characterData["health"] }'></div>
    			</div>
                <div class='armour status'>
                    <font-awesome-icon icon='shield-alt'></font-awesome-icon>
                    <div class='sub-armour' v-bind:style='{ width: characterData["armour"] }'></div>
                </div>
                <div class='hunger status'>
                    <font-awesome-icon icon='hamburger'></font-awesome-icon>
                    <div class='sub-hunger' v-bind:style='{ height: characterData["hunger"].value, top: characterData["hunger"].leftOver }'></div>
                </div>
                <div class='thirst status'>
                    <font-awesome-icon icon='tint'></font-awesome-icon>
                    <div class='sub-thirst' v-bind:style='{ height: characterData["thirst"].value, top: characterData["thirst"].leftOver }'></div>
                </div>
                <div class='breath status'>
                    <font-awesome-icon icon='lungs'></font-awesome-icon>
                    <div class='sub-breath' v-bind:style='{ height: characterData["breath"].value, top: characterData["breath"].leftOver }'></div>
                </div>
                <div class='stress status'>
                    <font-awesome-icon icon='brain'></font-awesome-icon>
                    <div class='sub-stress' v-bind:style='{ height: characterData["stress"].value, top: characterData["stress"].leftOver }'></div>
                </div>
            </div>
            <div class='vehicle-info'>
                <div class='top'>
                    <p>{{ currentTime }}</p>
                </div>
                <div class='middle'>
                    <div class='fuel'>
                        <p>{{ currentFuel }}</p><p>Combustível</p>
                    </div>
                    <div class='speed'>
                        <p>{{ currentSpeed }}</p><p>km/h</p>
                    </div>
                    <div class='seatbelt'>
                        <img src='../../assets/seatbelt.svg'>
                    </div>
                </div>
                <div class='bottom'>
                    <div class='direction'><div class='image' v-bind:style='{ transform: "translate3d(" + direction + "px, 0px, 0px)" }'></div></div>
                    <p>{{ locationText }}</p>
                </div>
            </div>
        </div>
    </v-container>
</template>

<script>
    import nui from '../../utils/nui';
    import { mapState } from 'vuex'

    export default {
        name: 'hud',
        computed: {
            ...mapState({
                characterData: state => state.hud.characterData
            })
        },
        methods: {
        },
        data() {
            return {
                top: '0px', left: '0px', width: '0px', height: '0px', direction: 0, locationText: '', currentFuel: 15, currentSpeed: 150, currentTime: '12:30'
            }
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('message', (event) => {
                switch (event.data.eventName) {
                    case 'setHudPosition':
                        const width = window.innerWidth, height = window.innerHeight;
                        const x = event.data.topX, y = event.data.topY;

                        this.top = (y * height) + 'px', this.left = (x * width) + 'px';
                        this.width = (0.18888 * height * 1.41) + 'px';
                        this.height = (0.18888 * height) + 'px';
                        break;
                    case 'updateData':
                        this.$store.dispatch('hud/setCharacterData', event.data.status);
                        break;
                    case 'updateVehicleInfo':
                        this.locationText = event.data.vehicleData.location;
                        break;
                    case 'updateCompassInfo':
                        this.direction = event.data.vehicleData.direction;
                        break;
                    default:
                        break;
                }
            }, false);
        },
    };
</script>


<style scoped lang='scss'>
    @import './hud.scss';
</style>