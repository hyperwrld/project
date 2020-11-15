<script>
	import { mapGetters } from 'vuex';
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump } from '@fortawesome/free-solid-svg-icons';

	library.add(faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump);

	export default {
		name: 'hud',
		computed: {
			...mapGetters('hud', {
				hudData: 'getHudData'
			})
		},
		render (h) {
			return (
				<div class='hud' style={{ top: this.hudData.top + 'px', left: this.hudData.left + 'px', width: this.hudData.width + 'px', height: this.hudData.height + 'px' }}>
					<div class='character-data'>
						{ Object.keys(this.hudData.characterData).map((key, index) => {
							const data = this.hudData.characterData[key];

							return (
								<div class={ key + '-container' }>
									<font-awesome-icon icon={ data[0] }/>
									{ key == 'health' || key == 'armour' ?
										<div class={ key + (data[1] <= 15 ? ' low' : '') } style={{ width: (data[1] + '%') }}/>
									:
										<div class={ key + (data[1] <= 15 ? ' low' : '') } style={{ height: data[1], top: (100 - data[1]) + '%' }}/>
									}
								</div>
							)
						})}
					</div>
					{ this.hudData.isOnVehicle || this.hudData.isCompassOn &&
						<transition name='fade' appear>
							<div class='vehicle-data'>
								<div class={ 'top' + (this.hudData.isOnVehicle ? '' : 'compass') }>
									<span>{ this.hudData.time }</span>
								</div>
								{ this.hudData.isOnVehicle &&
									<div class='middle'>
										<div class='fuel'>
											<span class={ this.hudData.fuel <= 15 ? 'low' : '' }>{ this.hudData.fuel }</span>
											<font-awesome-icon icon='gas-pump'/>
										</div>
										<div class='speed'>
											<span>{ this.hudData.speed } <p>km/h</p></span>
										</div>
										{ !this.hudData.hasSeatBelt &&
											<div class='seatbelt'>
												<img src='./../../../assets/seatbelt.svg'/>
											</div>
										}
										{ this.hudData.isSpeedLimiterOn &&
											<div class='speed-limiter'>
												<img src='./../../../assets/speed-limiter.svg'/>
											</div>
										}
									</div>
								}
								<div class='bottom'>
									<div class='direction'>
										<div class='image' style={{ transform: 'translate3d(' + this.hudData.direction + 'px, 0px, 0px)' }}/>
									</div>
									{ this.hudData.isOnVehicle &&
										<span>{ this.hudData.location }</span>
									}
								</div>
							</div>
						</transition>
					}
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './hud.scss';
</style>