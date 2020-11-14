<template>
    <v-container fluid>
        <div class='phone'>
            <div class='phone-inner'></div>
            <div class='phone-overflow'>
                <div class='shadow'></div>
            </div>
            <div class='phone-camera'></div>
            <div class='phone-content' :class='{ onApp: $route.name != "home" }'>
                <div class='header'>
                    <div class='left'>
                        <div class='time'>19:20</div>
                    </div>
                    <div class='right'>
                        <font-awesome-icon icon='volume-up'></font-awesome-icon>
                        <font-awesome-icon icon='signal'></font-awesome-icon>
                    </div>
                </div>
                <div class='screen'>
					<router-view/>
                </div>
                <div class='footer'>
                    <font-awesome-icon icon='camera' size='xs'></font-awesome-icon>
                    <font-awesome-icon :icon='["far", "circle"]' size='xs' @click='handleBack'></font-awesome-icon>
                    <font-awesome-icon icon='angle-left' size='xs'></font-awesome-icon>
                </div>
            </div>
        </div>
    </v-container>
</template>

<script>
	import dialogs from './dialogs/dialogs.vue';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faVolumeUp, faSignal, faCamera, faAngleLeft } from '@fortawesome/free-solid-svg-icons';
	import { faCircle } from '@fortawesome/free-regular-svg-icons';

	library.add(faVolumeUp, faSignal, faCamera, faCircle, faAngleLeft);

    export default {
        name: 'phone',
        components: {
			dialogs
        },
		methods: {
            handleBack: function() {
				this.$store.dispatch('phone/setCurrentApp', '/phone');
            }
		}
    };
</script>

<style scoped lang='scss'>
    @import './phone.scss';
</style>