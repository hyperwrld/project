<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../utils/lib';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump } from '@fortawesome/free-solid-svg-icons';

	library.add(faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump);

	export default {
		name: 'hud',
		computed: {
			...mapGetters('interface', {
				minimapData: 'getMinimapData', characterData: 'getCharacterData', vehicleData: 'getVehicleData'
			})
		},
		render (h) {
			this.characterData.map((data, index) => {
							console.log(data)
			})
			return (
				<div class='hud' style={{ top: this.minimapData.top, left: this.minimapData.left, width: this.minimapData.width, height: this.minimapData.height }}>
					<div class='character-data'>
						{ this.characterData.map((data, index) => {
							return (
								<div class={ data.name + '-container' }>
									<font-awesome-icon icon={ data.icon }/>
									{ data.name == 'health' || data.name == 'armour' ?
										<div class={ data.name + (data.value <= 15 ? ' low' : '') } style={{ width: (data.value + '%') }}/>
									:
										<div class={ data.name + (data.value <= 15 ? ' low' : '') } style={{ height: data.value, top: (100 - data.value) + '%' }}/>
									}
								</div>
							)
						})}
					</div>
					{ vehicleData.isOnVehicle || vehicleData.isCompassOn &&
						<div class='vehicle-data'>
							<div class={ 'top' + (vehicleData.isOnVehicle ? '' : 'compass') }>
								<span>{ vehicleData.time }</span>
							</div>
							{ vehicleData.isOnVehicle &&
								<div class='middle'>
									<div class='fuel'>
										<span class={ vehicleData.fuel <= 15 ? 'low' : '' }>{ vehicleData.fuel }</span>
										<font-awesome-icon icon='gas-pump'/>
									</div>
									<div class='speed'>
										<span>{ vehicleData.speed } <p>km/h</p></span>
									</div>
									{ !vehicleData.hasSeatBelt &&
										<div class='seatbelt'>
											<img src='./../../../assets/seatbelt.svg'/>
										</div>
									}
									{ vehicleData.isSpeedLimiterOn &&
										<div class='speed-limiter'>
											<img src='./../../../assets/speed-limiter.svg'/>
										</div>
									}
								</div>
							}
							<div class='bottom'>
								<div class='direction'>
									<div class='image' style={{ transform: 'translate3d(' + vehicleData.direction + 'px, 0px, 0px)' }}/>
								</div>
								{ vehicleData.isOnVehicle &&
									<span>{ vehicleData.location }</span>
								}
							</div>
						</div>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './hud.scss';
</style>