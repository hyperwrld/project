<template>
    <v-container fluid>
        <div class='spawnList'>
            <div class='button' v-for='(spawnPoint, index) in spawnSelection.spawnPoints' :item='spawnPoint' :key='index' @click='handleClick(index)'>
                {{ spawnPoint.info }}
            </div>
            <div class='button spawn' @click='handleSpawn'>SPAWN</div>
        </div>
    </v-container>
</template>

<script>
    import { mapState } from 'vuex'

    export default {
        name: 'spawnSelection',
        computed: {
            ...mapState({
                spawnSelection: state => state.spawnSelection
            }),
        },
        methods: {
            handleClick: function(index) {
                this.$store.dispatch('spawnSelection/changeSelection', index);
            },
            handleSpawn: function() {
                this.$store.dispatch('spawnSelection/confirmSpawn');
            }
        }
    };
</script>

<style scoped lang='scss'>
    @import './spawnSelection.scss';
</style>