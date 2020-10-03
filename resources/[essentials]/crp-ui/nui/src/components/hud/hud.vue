<template>
    <v-container fluid>
		<money/>
        <div class='minimap' :style='{ top: minimapData.top, left: minimapData.left, width: minimapData.width, height: minimapData.height }'>
			<interactions/>
    		<div class='bar'>
    			<div class='health status'>
                    <font-awesome-icon icon='heart'></font-awesome-icon>
    				<div class='sub-health' :class='{ low: parseInt(minimapData.health) <= 15 }' :style='{ width: minimapData.health }'></div>
    			</div>
                <div class='armour status'>
                    <font-awesome-icon icon='shield-alt'></font-awesome-icon>
                    <div class='sub-armour' :style='{ width: minimapData.armour }'></div>
                </div>
                <div class='hunger status'>
                    <font-awesome-icon icon='hamburger'></font-awesome-icon>
                    <div class='sub-hunger' :class='{ low: parseInt(minimapData.hunger) <= 15 }' :style='{ height: minimapData.hunger, top: convertNumber(minimapData.hunger) }'></div>
                </div>
                <div class='thirst status'>
                    <font-awesome-icon icon='tint'></font-awesome-icon>
                    <div class='sub-thirst' :class='{ low: parseInt(minimapData.thirst) <= 15 }' :style='{ height: minimapData.thirst, top: convertNumber(minimapData.thirst) }'></div>
                </div>
                <div class='breath status'>
                    <font-awesome-icon icon='lungs'></font-awesome-icon>
                    <div class='sub-breath' :style='{ height: minimapData.breath, top: convertNumber(minimapData.breath) }'></div>
                </div>
                <div class='stress status'>
                    <font-awesome-icon icon='brain'></font-awesome-icon>
                    <div class='sub-stress' :style='{ height: minimapData.stress, top: convertNumber(minimapData.stress) }'></div>
                </div>
            </div>
            <div class='vehicle-info' v-if='vehicleData.isOnVehicle || vehicleData.isCompassOn'>
                <div class='top' :class='{ "compass": vehicleData.isCompassOn == true && !vehicleData.isOnVehicle }'>
                    <p>{{ vehicleData.time }}</p>
                </div>
                <div class='middle' v-if='vehicleData.isOnVehicle'>
                    <div class='fuel'>
                        <p :class='{ "low": vehicleData.fuel <= 15 }'>{{ vehicleData.fuel }}</p>
                        <font-awesome-icon icon='gas-pump'></font-awesome-icon>
                    </div>
                    <div class='speed'>
                        <p>{{ vehicleData.speed }}</p><p>km/h</p>
                    </div>
                    <div class='seatbelt' v-if='!vehicleData.hasSeatBelt'>
                        <img src='../../assets/seatbelt.svg'>
                    </div>
                    <div class='speed-limiter' v-if='vehicleData.isSpeedLimiterOn'>
                        <img src='../../assets/speed-limiter.svg'>
                    </div>
                </div>
                <div class='bottom'>
                    <div class='direction'><div class='image' :style='{ transform: "translate3d(" + vehicleData.direction + "px, 0px, 0px)" }'></div></div>
                    <p v-if='vehicleData.isOnVehicle'>{{ vehicleData.location }}</p>
                </div>
            </div>
        </div>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump } from '@fortawesome/free-solid-svg-icons';

	library.add(faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump);

	import interactions from './interactions/interactions.vue';
	import money from './money/money.vue';

    export default {
		name: 'hud',
		components: {
			interactions, money
		},
        computed: {
			...mapGetters('hud', {
				minimapData: 'GET_MINIMAP_DATA',
				vehicleData: 'GET_VEHICLE_DATA'
			})
		},
		methods: {
			formatNumber: function(number) {
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
			},
			convertNumber: function(number) {
				return ((100 - parseInt(number)) + '%');
			}
		}
    };
</script>

<style scoped lang='scss'>
    @import './hud.scss';
</style>