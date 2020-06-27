<template>
    <v-container fluid>
        <div class='notificationsList'>
            <transition name='fade' v-for='(notification, index) in notificationsList' :item='notification' :key='index'>
                <div class='notification' :class='notification.type'>
                    {{ notification.text }}
                </div>
            </transition>
        </div>
    </v-container>
</template>

<script>
    import { mapState } from 'vuex'

    export default {
        name: 'notifications',
        computed: {
            ...mapState({
                notificationsList: state => state.notifications.notificationsList,
            })
        },
    };
</script>

<style scoped lang='scss'>
    @import './notifications.scss';
</style>