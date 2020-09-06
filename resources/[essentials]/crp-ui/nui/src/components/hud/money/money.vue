<template>
	<div class='money-container'>
		<transition name='fade' v-if='data.canShow'>
			<div class='money'><span>€ </span>{{ formatNumber(data.currentMoney) }}</div>
		</transition>
		<transition name='fade'>
			<div class='changedMney' v-if='data.canShow && data.changedMoney.status'>
				<span :class='data.changedMoney.type == "add" ? "add" : "remove"'>{{ (data.changedMoney.type == 'add' ? '+' : '-') +  ' €' }}</span>

				{{ formatNumber(data.changedMoney.quantity) }}
			</div>
		</transition>
	</div>
</template>

<script>
	import { mapGetters } from 'vuex';

    export default {
        name: 'money',
        computed: {
            ...mapGetters('hud', {
				data: 'GET_MONEY_DATA'
			})
		}
    };
</script>

<style scoped lang='scss'>
    @import './money.scss';
</style>