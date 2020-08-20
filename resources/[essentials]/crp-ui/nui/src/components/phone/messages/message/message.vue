<template>
    <v-container fluid>
        <div class='top-bar'>
			<font-awesome-icon :icon='["fas", "angle-left"]'></font-awesome-icon>
            <div class='contact-info'>
				<div class='name'>Lewis Hamiltonddd</div>
				<div class='number'>(967301022)</div>
			</div>
			<font-awesome-icon :icon='["fas", "phone-alt"]'></font-awesome-icon>
        </div>
        <div class='messages'>
			<div class='message-square' v-for='call in filterItems()' :key='call.displayData'>
				<div class='number-info'>
					<div class='name'>{{ call.displayData }}</div>
					<div class='message'>

						Muito bom dia, está tudo bem?
						</div>
					<div class='time'>{{ moment(call.time).fromNow() }}</div>
				</div>
			</div>
        </div>
		<div class='bottom-bar'>
            <input type='text' v-model='searchInput' placeholder='Enviar mensagem...' v-on:keyup.enter='sendMessage'/>
		</div>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';
	import dialogs from './../../dialogs/dialogs.vue';

	var moment = require('moment');

	moment.locale('pt');

    export default {
		name: 'callhistory',
		components: {
            dialogs
        },
        data() {
            return {
				moment: moment,
				searchInput: ''
            }
        },
        computed: {
            ...mapGetters('phone', {
                getCallHistory: 'getCallHistory'
            })
        },
        methods: {
            sendMessage: function() {
                this.$store.dispatch('phone/setDialogStatus', { name: 'sendMessage', status: true });
			},
			filterItems: function() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.getCallHistory;
				}

				if (isNaN(this.searchInput)) {
					return this.getCallHistory.filter(c => c.displayData.toLowerCase().indexOf(search) > -1);
				} else {
					return this.getCallHistory.filter(c => c.number.toString().toLowerCase().indexOf(search) > -1);
				}
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './message.scss';
</style>