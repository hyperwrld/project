<template>
    <v-container fluid>
		<transition name='fade' :duration='1000'>
			<v-alert v-if='interactions.status' class='interaction' dark prominent icon='fa-info-circle'>
				{{ interactions.message }}
			</v-alert>
		</transition>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faInfoCircle } from '@fortawesome/free-solid-svg-icons';

    export default {
        name: 'interactions',
        computed: {
            ...mapGetters('app', ['interactions'])
		}
    };
</script>

<style scoped lang='scss'>
    @import './interactions.scss';
</style>