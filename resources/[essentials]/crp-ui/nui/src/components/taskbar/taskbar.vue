<template>
    <v-container fluid>
        <transition name='fade'>
            <div class='progress-container' v-if='taskbarInfo.status'>
                <div class='progress' v-bind:style='{ width: taskbarInfo.progress + "%" }'></div>
                <div class='text'>{{ taskbarInfo.text }}</div>
            </div>
        </transition>
        <transition name='fade'>
            <div class='skillbar-container' ref='skillbar'>
                <div class='stick' v-bind:style='{ left: skillbarInfo.left + "px" }'></div>
                <div class='rectangle' ref='rectangle'></div>
                <!-- <div class='text'>{{ taskbarInfo.text }}</div> -->
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
                skillbarInfo: state => state.taskbar.skillbarInfo,
            })
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.$store.dispatch('taskbar/setSkillbarWidth', { skillbarWidth: this.$refs.skillbar.clientWidth, rectangleWidth: this.$refs.rectangle.clientWidth });

            this.listener = window.addEventListener('keypress', (event) => {
                if (event.keyCode == 97) {
                    console.log('teste123')
                    this.$store.dispatch('taskbar/moveStick', 'left');
                } else if (event.keyCode == 100) {
                    console.log('pqp')
                    this.$store.dispatch('taskbar/moveStick', 'right');
                }
            }, false);
        }
    };
</script>

<style scoped lang='scss'>
    @import './taskbar.scss';
</style>