<script>
	import { mapGetters } from 'vuex';
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump, faTachometerAlt } from '@fortawesome/free-solid-svg-icons';

	library.add(faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump, faTachometerAlt);

	export default {
		name: 'hud',
		computed: {
			...mapGetters('hud', {
				hudData: 'getHudData'
			})
		},
		data() {
            return {
				icons: {
					health: 'heart', armour: 'shield-alt', hunger: 'hamburger', thirst: 'tint', breath: 'lungs', stress: 'brain'
				}
            }
        },
		render (h) {
			let data = this.hudData, characterData = [];

			if (!data.hideState) {
				Object.keys(this.icons).map((key, index) => {
					const value = data[key];

					characterData.push(
						<div class={ key + '-container' }>
							<font-awesome-icon icon={ this.icons[key] }/>
							<div class={ key + (value <= 15 ? ' low' : '') } style={(key == 'health' || key == 'armour') ? { width: (value + '%') } : { height: value + '%', top: (100 - value) + '%' }}/>
						</div>
					)
				})
			}

			return (
				<transition appear name='fade'>
					{ !data.hideState &&
						<div class='hud' style={{ top: data.top + 'px', left: data.left + 'px', width: data.width + 'px', height: data.height + 'px' }}>
							<div class='character-data'>
								{ characterData }
							</div>
							{ (data.isOnVehicle || data.isCompassOn) &&
								<div class='vehicle-data'>
									<div class='top'>
										<span>{ data.time }</span>
									</div>
									{ data.isOnVehicle &&
										<div class='middle'>
											<span>{ data.zoneName }</span>
											<span>{ data.streetName }</span>
										</div>
									}
									<div class='bottom'>
										<div class='direction'>
											<div class='image' style={{ transform: 'translate3d(' + data.direction + 'px, 0px, 0px)' }}/>
										</div>
										{ data.isOnVehicle &&
											<div class='vehicle-info'>
												<div class='fuel'>
													<span class={ data.fuel <= 15 ? 'low' : '' }>{ data.fuel }</span><span>Gasolina</span>
												</div>
												<div class='speed'>
													<span>{ data.speed }</span><span>km/h</span>
												</div>
												<div class='warnings'>
													{ data.fuel < 15 &&
														<font-awesome-icon icon='gas-pump'/>
													}
													{ !data.hasSeatbelt &&
														<img src={ require('./../../../assets/seatbelt.svg') }/>
													}
													{ data.isSpeedLimiterOn &&
														<font-awesome-icon icon='tachometer-alt'/>
													}
												</div>
											</div>
										}
									</div>
								</div>
							}
						</div>
					}
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './hud.scss';
</style>