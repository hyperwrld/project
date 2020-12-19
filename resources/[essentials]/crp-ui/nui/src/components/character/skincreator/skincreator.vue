<script>
	import headBlend from './modules/headBlend.vue';
	import ped from './modules/ped.vue';
	import faceFeatures from './modules/faceFeatures.vue';
	import headOverlays from './modules/headOverlays.vue';
	import bodyFeatures from './modules/bodyFeatures.vue';
	import clothing from './modules/clothing.vue';
	import accessories from './modules/accessories.vue';

	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faAngleLeft, faAngleRight, faFlushed, faGlasses, faHatCowboy, faSocks, faTshirt, faUserTie } from '@fortawesome/free-solid-svg-icons';
	import { faRedhat } from '@fortawesome/free-brands-svg-icons';

	library.add(faAngleLeft, faAngleRight, faHatCowboy, faGlasses, faTshirt, faFlushed, faUserTie, faSocks);

	export default {
		name: 'skincreator',
		components: {
			ped, headBlend, faceFeatures, headOverlays, bodyFeatures,clothing, accessories
		},
		computed: {
			...mapGetters('skincreator', {
				categories: 'getCategories'
			})
		},
		methods: {
            handleSwitchCategory: function(appName) {
				this.currentCategory = appName;

				this.$router.push('/skincreator/' + appName).catch(error => {
					if (error.name !== 'NavigationDuplicated' && !error.message.includes('Avoided redundant navigation to current location')) {
						console.log(error);
					}
				});
            }
        },
		data() {
			return {
				currentCategory: ''
			}
		},
		mounted() {
			this.handleSwitchCategory(this.categories[0].name);
		},
		render (h) {
			return (
				<div class='skincreator'>
					<div class='categories'>
						{ this.categories.map((menu, index) => {
							return (
								<button class={ this.currentCategory == menu.name ? 'active' : '' } onClick ={ () => this.handleSwitchCategory(menu.name) }>{ menu.title }</button>
							)
						})}
					</div>
					<div class='container'>
						<router-view/>
						<div class='camera'>
							<font-awesome-icon icon='hat-cowboy'/>
							<font-awesome-icon icon='glasses'/>
							<font-awesome-icon icon='tshirt'/>
							<font-awesome-icon icon='flushed'/>
							<font-awesome-icon icon='user-tie'/>
							<font-awesome-icon icon='socks'/>
						</div>
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
	@import './skincreator.scss';
</style>