<script>
	import { mapGetters } from 'vuex';
	import { send } from './../../../utils/lib.js';
	import { camera } from './../../../utils/data.js';

	import optionRange from './utils/range.vue';

	import dialogs from './dialogs/dialogs.vue';

	export default {
		name: 'skincreator',
		props: ['closeMenu'],
		computed: {
			...mapGetters('skincreator', {
				categories: 'getCategories',
				camera: 'getCameraData',
			}),
		},
		methods: {
			handleSwitchCategory: function(appName) {
				this.currentCategory = appName;

				this.$router.push('/skincreator/' + appName).catch((error) => {
					if (
						error.name !== 'NavigationDuplicated' &&
						!error.message.includes(
							'Avoided redundant navigation to current location'
						)
					) {
						console.log(error);
					}
				});
			},
			modifyCameraValue: function(index) {
				send('modifyCameraValue', {
					type: camera[index].id,
					value: Number(camera[index].value),
				});
			},
			toggleClothing: function(type) {
				send('toggleClothing', type);
			},
			toggleAnimation: function() {
				send('toggleAnimation');
			},
			openDialog: function(event) {
				if (event.keyCode == 27 && !this.isDialogOpen) {
					this.isDialogOpen = true;

					this.$q
						.dialog({
							component: dialogs,
							parent: this,
						})
						.onOk((state) => {
							send('saveSkin', state);

							this.closeMenu({ appName: 'skincreator' });
						})
						.onDismiss(() => {
							this.isDialogOpen = false;
						});
				}

				event.preventDefault();
			},
		},
		data() {
			return {
				currentCategory: '',
				isDialogOpen: false,
			};
		},
		destroyed() {
			window.removeEventListener('keydown', this.openDialog);
		},
		mounted() {
			window.addEventListener('keydown', this.openDialog, false);

			if (this.categories[0]) {
				this.handleSwitchCategory(this.categories[0].name);
			}
		},
		render() {
			return (
				<transition
					appear
					enter-active-class='animated fadeIn'
					leave-active-class='animated fadeOut'
				>
					<div class='skincreator'>
						<div class='categories'>
							{this.categories.map((menu) => {
								return (
									<button
										class={this.currentCategory == menu.name ? 'active' : ''}
										onClick={() => this.handleSwitchCategory(menu.name)}
									>
										{menu.title}
									</button>
								);
							})}
						</div>
						<div class='container'>
							<router-view />
							<div class='buttons'>
								<q-icon
									name='fas fa-flushed'
									onClick={() => this.toggleClothing(1)}
								/>
								<q-icon
									name='fas fa-tshirt'
									onClick={() => this.toggleClothing(2)}
								/>
								<q-icon
									name='fas fa-socks'
									onClick={() => this.toggleClothing(3)}
								/>
								<q-icon
									name='fas fa-child'
									onClick={() => this.toggleAnimation()}
								/>
							</div>
						</div>
						<div class='footer'>
							{this.camera.map((data) => {
								return (
									<div class='footer-container'>
										<optionRange data={data} click={this.modifyCameraValue} />
									</div>
								);
							})}
						</div>
					</div>
				</transition>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './skincreator.scss';
</style>
