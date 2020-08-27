<template>
    <v-container fluid>
		<v-tooltip top content-class='tooltip' v-for='(app, index) in appsData' :item='app' :key='index'>
      		<template v-slot:activator='{ on, attrs }'>
				<div class='app' v-bind:style='{ backgroundColor: app.color }' @click='handleAppClick(app.code)'>
					<font-awesome-icon :icon='[app.iconType, app.icon]' v-bind='attrs' v-on='on' @click='handleAppClick(app.code)'></font-awesome-icon>
				</div>
			</template>
			<span>{{ app.name }}</span>
		</v-tooltip>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faPhoneAlt, faCommentAlt, faUser, faCar, faAd } from '@fortawesome/free-solid-svg-icons';
	import { faTwitter } from '@fortawesome/free-brands-svg-icons';

	library.add(faPhoneAlt, faCommentAlt, faUser, faCar, faTwitter, faAd);

    export default {
        name: 'home',
        computed: {
            ...mapGetters('phone', ['appsData'])
        },
        methods: {
            handleAppClick: function(appName) {
                this.$store.dispatch('phone/setCurrentApp', '/phone/' + appName);
            }
        },
    };
</script>

<style scoped lang='scss'>
    @import './home.scss';
</style>