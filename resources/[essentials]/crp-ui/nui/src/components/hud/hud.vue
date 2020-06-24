<template>
    <v-container fluid>
        <div class='minimap' v-bind:style='{ top: minimapData.top, left: minimapData.left, width: minimapData.width, height: minimapData.height }'>
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
                    <p>{{ vehicleData.time }}</p>
                </div>
                <div class='middle'>
                    <div class='fuel'>
                        <p>{{ vehicleData.fuel }}</p><p>Combustível</p>
                    </div>
                    <div class='speed'>
                        <p>{{ vehicleData.speed }}</p><p>km/h</p>
                    </div>
                    <div class='seatbelt'>
                        <img src='../../assets/seatbelt.svg'>
                    </div>
                </div>
                <div class='bottom'>
                    <div class='direction'><div class='image' v-bind:style='{ transform: "translate3d(" + vehicleData.direction + "px, 0px, 0px)" }'></div></div>
                    <p>{{ vehicleData.location }}</p>
                </div>
            </div>
        </div>
    </v-container>
</template>

<script>
    import { mapState } from 'vuex'

    export default {
        name: 'hud',
        computed: {
            ...mapState({
                minimapData: state => state.hud.minimapData,
                characterData: state => state.hud.characterData,
                vehicleData: state => state.hud.vehicleData,
            })
        }
    };
</script>


<style scoped lang='scss'>
    @import './hud.scss';
</style>