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
    import { mapState } from 'vuex';

    export default {
        name: 'home',
        computed: {
            ...mapState({
                appsData: state => state.phone.apps
            })
        },
        methods: {
            handleAppClick: function(appName) {
                this.$store.dispatch('phone/setCurrentApp', appName);
            }
        },
    };
</script>

<style scoped lang='scss'>
    @import './home.scss';
</style>