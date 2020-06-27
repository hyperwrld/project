<template>
    <v-container fluid>
        <transition name='fade'>
            <div class='progress-container' v-if='taskbarInfo.status'>
                    <div class='progress' v-bind:style='{ width: taskbarInfo.progress + "%" }'></div>
                <div class='text'>{{ taskbarInfo.text }}</div>
            </div>
        </transition>
    </v-container>
</template>

<script>
    import { mapState } from 'vuex'

    export default {
        name: 'taskbar',
        computed: {
            ...mapState({
                taskbarInfo: state => state.taskbar.taskbarInfo,
            })
        },
    };
</script>


<style scoped lang='scss'>
    @import './taskbar.scss';
</style>