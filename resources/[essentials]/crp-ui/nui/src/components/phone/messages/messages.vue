<template>
    <v-container fluid>
        <div class='top-bar'>
            <div class='search-wrapper'>
                <input type='text' v-model='searchInput' placeholder='Procurar...'/>
                <font-awesome-icon :icon='["fas", "search"]'></font-awesome-icon>
            </div>
            <font-awesome-icon :icon='["fas", "envelope"]' @click='sendMessage'></font-awesome-icon>
        </div>
        <div class='messages-list'>
			<div v-if='filterItems().length > 0'>
				<div class='message-square' v-for='call in filterItems()' :key='call.name'>
					<div class='avatar'>
						<v-avatar v-bind:style='{ background: getMessageColor((call.name).toString().substring(0, 2)) }' size='30'>
							<span v-if='isNaN(call.name)'>{{ (call.name).substring(0, 2).toUpperCase() }}</span>
							<font-awesome-icon :icon='["fas", "user"]' v-else></font-awesome-icon>
						</v-avatar>
					</div>
					<div class='message-info' @click='openMessage(call.number)'>
						<div class='name'>{{ call.name }}</div>
						<div class='message'>{{ call.message }}</div>
						<div class='time'>{{ getTime(call.time) }}</div>
					</div>
				</div>
			</div>
			<div v-else class='empty-list'>
				<font-awesome-icon :icon='["fas", "sad-tear"]'></font-awesome-icon>
				<span>Não foi encontrada nenhuma mensagem.</span>
			</div>
        </div>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';
	import { convertTime } from './../../../utils/time.js';
	import dialogs from './../dialogs/dialogs.js';

    export default {
		name: 'messages',
        data() {
            return {
				searchInput: ''
            }
        },
        computed: {
            ...mapGetters('phone', {
				conversations: 'getConversations'
            })
        },
        methods: {
			getTime: function(time) {
				return convertTime(time);
			},
            sendMessage: function() {
				dialogs.createDialog({
					attach: '.messages-list', title: 'Enviar mensagem',
					choices: [
						{ key: 'number', type: 'number', min: 9, max: 9, placeholder: 'Número', errorText: 'Insira um número com 9 números.' },
						{ key: 'message', min: 0, max: 255, placeholder: 'Mensagem', errorText: 'Insira uma mensagem com até 255 caracteres.' }
					],
					sendButton: 'Enviar', nuiType: 'sendMessage'
				}).then(response => {
					// if (response) {
					// 	this.getContactsList.push({ id: response.data.id, name: response.choiceData.name, number: Number(response.choiceData.number) });
					// }
      			})
			},
			filterItems: function() {
				const search = this.searchInput.toLowerCase().trim();

				if (!search) {
					return this.conversations;
				}

				if (isNaN(this.searchInput)) {
					return this.conversations.filter(c => c.name.toLowerCase().indexOf(search) > -1);
				} else {
					return this.conversations.filter(c => c.name.toString().toLowerCase().indexOf(search) > -1);
				}
			},
			getMessageColor: function(string) {
				var hash = 0;

    			for (var i = 0; i < string.length; i++) {
      				hash = string.charCodeAt(i) + ((hash << 5) - hash);
				}

    			return 'hsl(' + hash % 360 + ', 30%, 70%)';
			},
			openMessage: function(number) {
				this.$store.dispatch('phone/setMessages', number);
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './messages.scss';
</style>