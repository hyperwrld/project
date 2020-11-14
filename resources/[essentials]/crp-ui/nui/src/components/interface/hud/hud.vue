<script>
	import { mapGetters } from 'vuex';
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
			return (
				<div class='hud' style={{ top: this.minimapData.top, left: this.minimapData.left, width: this.minimapData.width, height: this.minimapData.height }}>
					<div class='character-data'>
						{ this.characterData.map((data, index) => {
							return (
								<div class={ data[1] + '-container' }>
									<font-awesome-icon icon={ data[2] }/>
									{ data[1] == 'health' || data[1] == 'armour' ?
										<div class={ data[1] + (data[3] <= 15 ? ' low' : '') } style={{ width: (data[3] + '%') }}/>
									:
										<div class={ data[1] + (data[3] <= 15 ? ' low' : '') } style={{ height: data[3], top: (100 - data[3]) + '%' }}/>
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