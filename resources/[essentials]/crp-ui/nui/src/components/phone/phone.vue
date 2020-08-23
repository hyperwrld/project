<template>
    <v-container fluid>
        <div class='phone'>
            <div class='phone-inner'></div>
            <div class='phone-overflow'>
                <div class='shadow'></div>
            </div>
            <div class='phone-camera'></div>
            <div class='phone-content' :class='{ onApp: phoneData.currentApp != "home" }'>
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
                    <component class='screen' :is='phoneData.currentApp'></component>
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
    import { mapState } from 'vuex';

    import home from './home/home.vue';
    import history from './history/history.vue';
	import contacts from './contacts/contacts.vue';
	import messages from './messages/messages.vue';
	import message from './messages/message/message.vue';
	import twitter from './twitter/twitter.vue';
	import adverts from './adverts/adverts.vue';

	import dialogs from './dialogs/dialogs.vue';

    export default {
        name: 'phone',
        components: {
			home, history,
			contacts, dialogs,
			messages, message,
			twitter, adverts
        },
        computed: {
            ...mapState({
                phoneData: state => state.phone
            })
		},
		methods: {
            handleBack: function() {
				this.$store.dispatch('phone/setCurrentApp', 'home');
            }
        }
    };
</script>

<style scoped lang='scss'>
    @import './phone.scss';
</style>