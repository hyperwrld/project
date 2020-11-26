<script>
	import parents from './modules/parents.vue';
	import ped from './modules/ped.vue';
	import face from './modules/face.vue';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faAngleLeft, faAngleRight, faFlushed, faGlasses, faHatCowboy, faSocks, faTshirt, faUserTie } from '@fortawesome/free-solid-svg-icons';
	import { faRedhat } from '@fortawesome/free-brands-svg-icons';

	library.add(faAngleLeft, faAngleRight, faHatCowboy, faGlasses, faTshirt, faFlushed, faUserTie, faSocks);

	export default {
		name: 'skincreator',
		components: {
			ped, parents, face
		},
		render (h) {
			return (
				<div class='skincreator'>
					<div class='categories'>
						<button>Roupas</button>
						<button>Acessórios</button>
						<button>Ped</button>
					</div>
					<div class='container'>
						<face/>
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