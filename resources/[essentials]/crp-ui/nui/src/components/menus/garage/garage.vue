<script>
	import { mapGetters } from 'vuex';
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faAngleDoubleRight } from '@fortawesome/free-solid-svg-icons';

	library.add(faAngleDoubleRight);

	export default {
		name: 'garage',
		props: ['closeMenu'],
		computed: {
			...mapGetters('selection', {
				charactersData: 'getCharactersData'
			})
		},
		methods: {
			closeEvent: function(event) {
                if (event.keyCode == 27)  {
					this.closeMenu({ appName: 'garage' });

					event.preventDefault();
				}
			},
			spawnVehice: function(event) {
				event.stopPropagation();
			}
		},
		destroyed() {
			window.removeEventListener('keydown', this.closeEvent, false);
        },
        mounted() {
            window.addEventListener('keydown', this.closeEvent, false);
        },
		render() {
			return (
				<transition appear name='fade'>
					<div class='garage'>
						<v-expansion-panels dark accordion>
							<v-expansion-panel>
								<v-expansion-panel-header hide-actions>
									<div class='information'>
										<span>Kuruma, Karin</span>
										<span>MATRÍCULA: JL5N4EJ5</span>
									</div>
									<v-tooltip top content-class='tooltip' nudge-top={ 2 } scopedSlots={{ activator: ({on}) => <font-awesome-icon {...{ on }} onClick={ (event) => this.spawnVehice(event) } icon='angle-double-right'/> }}>
										<span>Spawnar</span>
									</v-tooltip>
								</v-expansion-panel-header>
								<v-expansion-panel-content>
									<div class='information'>
										<span class='title'>Combustivel</span>
										<div><div></div></div>
									</div>
									<div></div>
								</v-expansion-panel-content>
							</v-expansion-panel>
						</v-expansion-panels>
					</div>
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './garage.scss';
</style>