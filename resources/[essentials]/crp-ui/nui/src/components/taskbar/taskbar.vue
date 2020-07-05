<template>
    <v-container fluid>
        <transition name='fade'>
            <div class='progress-container' v-if='taskbarInfo.status'>
                <div class='progress' v-bind:style='{ width: taskbarInfo.progress + "%" }'></div>
                <div class='text'>{{ taskbarInfo.text }}</div>
            </div>
        </transition>
        <transition name='fade'>
            <div class='skillbar-container' ref='skillbar' v-if='skillbarInfo.status'>
                <div class='stick' v-bind:style='{ left: skillbarInfo.left + "px" }'></div>
                <div class='rectangle' ref='rectangle' v-bind:style='{ width: skillbarInfo.rectangle.width + "px", left: skillbarInfo.rectangle.left + "px" }'>
                    <p>{{ (skillbarInfo.counter) + 's' }}</p>
                </div>
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
        data() {
            return {
                isDown: false
            }
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('keydown', (event) => {
                if (this.isDown || !this.skillbarInfo.status) return;

                this.isDown = true;

                if (event.keyCode == 65) {
                    this.$store.dispatch('taskbar/moveStick', 'left');
                } else if (event.keyCode == 68) {
                    this.$store.dispatch('taskbar/moveStick', 'right');
                }
            }, false);

            window.addEventListener('keyup', (event) => {
                this.isDown = false;
            }, false);
        }
    };
</script>

<style scoped lang='scss'>
    @import './taskbar.scss';
</style>