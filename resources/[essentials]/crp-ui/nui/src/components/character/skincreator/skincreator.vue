<script>
	import headBlend from './modules/headBlend.vue';
	import ped from './modules/ped.vue';
	import faceFeatures from './modules/faceFeatures.vue';
	import headOverlays from './modules/headOverlays.vue';
	import bodyFeatures from './modules/bodyFeatures.vue';
	import clothing from './modules/clothing.vue';
	import accessories from './modules/accessories.vue';

	import { mapGetters } from 'vuex';
	import { send } from './../../../utils/lib.js';
	import { camera, footerButtons } from './../../../utils/data.js';

	import optionRange from './utils/range.vue';

	import dialog from './dialog/dialog.js';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faAngleLeft, faAngleRight, faFlushed, faSocks, faTshirt, faChild } from '@fortawesome/free-solid-svg-icons';
	import { faRedhat } from '@fortawesome/free-brands-svg-icons';

	library.add(faAngleLeft, faAngleRight, faTshirt, faFlushed, faSocks, faChild);

	export default {
		name: 'skincreator',
		props: ['closeMenu'],
		components: {
			ped, headBlend, faceFeatures, headOverlays, bodyFeatures,clothing, accessories
		},
		computed: {
			...mapGetters('skincreator', {
				categories: 'getCategories', camera: 'getCameraData'
			})
		},
		methods: {
            handleSwitchCategory(appName) {
				this.currentCategory = appName;

				this.$router.push('/skincreator/' + appName).catch(error => {
					if (error.name !== 'NavigationDuplicated' && !error.message.includes('Avoided redundant navigation to current location')) {
						console.log(error);
					}
				});
			},
			modifyCameraValue(index) {
				send('modifyCameraValue', { type: camera[index].id, value: Number(camera[index].value) });
			},
			toggleClothing(type) {
				send('toggleClothing', type);
			},
			toggleAnimation() {
				send('toggleAnimation');
			},
			openDialog(event) {
				if (event.keyCode == 27 && !this.isDialogOpen) {
					this.isDialogOpen = true;

					dialog.createDialog().then(response => {
						send('saveSkin', response);

						this.closeMenu({ appName: 'skincreator' });
					}).catch(error => {
						this.isDialogOpen = false;
					});
                }
			}
        },
		data() {
			return {
				currentCategory: '', isDialogOpen: false
			}
		},
		destroyed() {
            window.removeEventListener('keydown', this.openDialog);
        },
        mounted() {
            window.addEventListener('keydown', this.openDialog, false);

			this.handleSwitchCategory(this.categories[0].name);
        },
		render (h) {
			return (
				<div class='skincreator'>
					<div class='categories'>
						{ this.categories.map((menu, index) => {
							return (
								<button class={ this.currentCategory == menu.name ? 'active' : '' } onClick={ () => this.handleSwitchCategory(menu.name) }>{ menu.title }</button>
							)
						})}
					</div>
					<div class='container'>
						<router-view/>
						<div class='buttons'>
							<font-awesome-icon icon='flushed' onClick={ () =>  this.toggleClothing(1) }/>
							<font-awesome-icon icon='tshirt'  onClick={ () =>  this.toggleClothing(2) }/>
							<font-awesome-icon icon='socks'   onClick={ () =>  this.toggleClothing(3) }/>
							<font-awesome-icon icon='child'   onClick={ () =>  this.toggleAnimation() }/>
						</div>
					</div>
					<div class='footer'>
						{ this.camera.map((buttonData, index) => {
							return (
								<div class='footer-container'>
									<optionRange data={ buttonData } click={ this.modifyCameraValue }/>
								</div>
							)
						})}
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
	@import './skincreator.scss';
</style>