<script>
	import { mapGetters } from 'vuex';

	export default {
		name: 'hud',
		computed: {
			...mapGetters('hud', {
				hudData: 'getHudData',
			}),
		},
		data() {
			return {
				icons: {
					health: 'heart',
					armour: 'shield-alt',
					hunger: 'hamburger',
					thirst: 'tint',
					breath: 'lungs',
					stress: 'brain',
				},
			};
		},
		render() {
			let data = this.hudData,
				characterData = [];

			if (!data.hideState) {
				Object.keys(this.icons).map((key) => {
					const value = data[key];

					characterData.push(
						<div class={key + '-container'}>
							<q-icon name={`fas fa-${this.icons[key]}`} />
							<div
								class={key + (value <= 15 ? ' low' : '')}
								style={
									key == 'health' || key == 'armour'
										? { width: value + '%' }
										: { height: value + '%', top: 100 - value + '%' }
								}
							/>
						</div>
					);
				});
			}

			return (
				<transition appear name='fade'>
					{!data.hideState && (
						<div
							class='hud'
							style={{
								top: data.top + 'px',
								left: data.left + 'px',
								width: data.width + 'px',
								height: data.height + 'px',
							}}
						>
							<div class='character-data'>{characterData}</div>
							{(data.isOnVehicle || data.isWatchOn) && (
								<transition appear name='fade'>
									<div class='vehicle-data'>
										<div class='top'>
											<span class={!data.isOnVehicle ? 'center' : ''}>
												{data.time}
											</span>
										</div>
										{data.isOnVehicle && (
											<div class='middle'>
												<span>{data.zoneName}</span>
												<span>{data.streetName}</span>
											</div>
										)}
										<div class='bottom'>
											<div class='direction'>
												<div
													class='image'
													style={{
														transform:
															'translate3d(' + data.direction + 'px, 0px, 0px)',
													}}
												/>
											</div>
											{data.isOnVehicle && (
												<div class='vehicle-info'>
													<div class='fuel'>
														<span class={data.fuel <= 15 ? 'low' : ''}>
															{data.fuel}
														</span>
														<span>Gasolina</span>
													</div>
													<div class='speed'>
														<span>{data.speed}</span>
														<span>km/h</span>
													</div>
													<div class='warnings'>
														{data.fuel < 15 && (
															<q-icon name='fas fa-gas-pump' />
														)}
														{!data.hasSeatbelt && (
															<img
																src={require('./../../../assets/seatbelt.svg')}
															/>
														)}
														{data.isSpeedLimiterOn && (
															<q-icon name='fas fa-tachometer-alt' />
														)}
													</div>
												</div>
											)}
										</div>
									</div>
								</transition>
							)}
						</div>
					)}
				</transition>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './hud.scss';
</style>
