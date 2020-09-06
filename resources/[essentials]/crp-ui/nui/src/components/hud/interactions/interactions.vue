<template>
	<div class='interaction-container'>
		<transition name='fade' :duration='1000'>
			<v-alert v-if='data.status' class='interaction' dark prominent icon='fa-info-circle'>
				{{ data.message }}
			</v-alert>
		</transition>
	</div>
</template>

<script>
	import { mapGetters } from 'vuex';
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faInfoCircle } from '@fortawesome/free-solid-svg-icons';

    export default {
        name: 'interactions',
        computed: {
            ...mapGetters('hud', {
				data: 'GET_INTERACTIONS_DATA'
			})
		}
    };
</script>

<style scoped lang='scss'>
    @import './interactions.scss';
</style>