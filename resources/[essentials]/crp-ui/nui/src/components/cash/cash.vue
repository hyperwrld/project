<template>
    <v-container fluid>
        <transition name='fade' v-if='canShow'>
            <div class='money'><span>€ </span>{{ formatNumber(currentMoney) }}</div>
        </transition>
        <transition name='fade'>
            <div class='changedMney' v-if='canShow && changedMoney.status'>
                <span :class='changedMoney.type == "add" ? "add" : "remove"'>{{ (changedMoney.type == 'add' ? '+' : '-') +  ' €' }}</span>

                {{ formatNumber(changedMoney.quantity) }}
            </div>
        </transition>
    </v-container>
</template>

<script>
    import { mapState } from 'vuex'

    export default {
        name: 'cash',
        computed: {
            ...mapState({
                canShow: state => state.cash.canShow,
                currentMoney: state => state.cash.currentMoney,
                changedMoney: state => state.cash.changedMoney
            }),
        },
        methods: {
            formatNumber: function(number) {
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
            }
        }
    };
</script>


<style scoped lang='scss'>
    @import './cash.scss';
</style>