import nui from '../../utils/nui';

const state = {
    apps: [
        { code: 'history', name: 'Telefone', color: '#13b86c', icon: 'phone-alt', iconType: 'fas' }, { code: 'messages', name: 'Mensagens', color: '#0191e7', icon: 'comment-alt', iconType: 'fas' },
        { code: 'contacts', name: 'Contactos', color: '#fc7b20', icon: 'user', iconType: 'fas' }, { code: 'garage', name: 'Garagem', color: '#ef1443', icon: 'car', iconType: 'fas' },
        { code: 'twitter', name: 'Twitter', color: '#1DA1F2', icon: 'twitter', iconType: 'fab' }
    ],
	currentApp: 'home', phoneNumber: 966831664,
	callHistory: [{ number: 967301022, incoming: true, time: 1584110467 }, { number: 967301223, incoming: false, time: 55 }], conversations: [ { sender: 966831664, receiver: 967301023, message: 'éeee', time: 1574110367 }, { sender: 967301223, receiver: 966831664, message: 'ddddd', time: 1597066616 } ], contacts: [ { id: 2, name: "andre32", number: 967301223} ],
	dialogs: { status: false, isLoading: false, currentState: 'loading', currentDialog: '', dialogsData: {}, errorsList: [] }
}

const getters = {
	getCurrentApp: state => {
		return state.currentApp;
	},
	getCallHistory: state => {
		for (let i = 0; i < state.callHistory.length; i++) {
			let contact = state.contacts.find(element => element.number === state.callHistory[i].number)

			state.callHistory[i].name = contact ? contact.name : state.callHistory[i].number;
		}

        return state.callHistory;
	},
	getConversations: state => {
		for (let i = 0; i < state.conversations.length; i++) {
			let name = state.phoneNumber != state.conversations[i].sender ? state.conversations[i].sender : state.conversations[i].receiver;
			let contact = state.contacts.find(element => element.number === name)

			state.conversations[i].name = contact ? contact.name : name;
		}

		return state.conversations;
    },
    getContacts: state => {
        return state.contacts;
	},
	getDialogs: state => {
		return state.dialogs;
	}
}

const actions = {
	updatePhone(state, data) {
		state.commit('updatePhone', data);
	},
    setCurrentApp(state, appName) {
        state.commit('setCurrentApp', appName);
	},
	setDialogStatus(state, data) {
		state.commit('setDialogStatus', data);
    },
    setMessages(state, number) {
        state.commit('setMessages', number);
    },
	addContact(state) {
		state.commit('addContact');
	},
	submitDialog(state, data) {
		state.commit('submitDialog', data);
	}
}

const mutations = {
	updatePhone(state, data) {
		console.log(data)
		if (data.phoneNumber != null) {
			state.phoneNumber = data.phoneNumber;
		}

		if (data.history != null) {
			state.callHistory = data.history;
		}

		if (data.conversations != null) {
			state.conversations = data.conversations;
		}

		if (data.contacts != null) {
			state.contacts = data.contacts;
		}
	},
    setCurrentApp(state, appName) {
		state.currentApp = appName;

		if (appName == 'home') {
			state.dialogs.status = false;
		}
	},
	setDialogStatus(state, data) {
		state.dialogs.status = data.status;

		if (data.status) {
			state.dialogs.currentDialog = data.name, state.dialogs.status = data.status;
		}

		if (data.status) {
			if (data.dialogData.name) {
				state.dialogs.dialogData.name = data.dialogData.name;
			}

			if (data.dialogData.number) {
				state.dialogs.dialogData.number = data.dialogData.number;
			}

			if (data.dialogData.message) {
				state.dialogs.dialogData.message = data.dialogData.message;
			}

			if (data.dialogData.id) {
				state.dialogs.dialogData.id = data.dialogData.id;
			}
		}
    },
    setMessages(state, number) {
        nui.send('getMessages', { number: number }).then(data => {
			console.log(number)
        });
    },
	addContact(state) {
		state.dialogs.errorsList = [];

		if (!state.dialogs.name || (state.dialogs.name.length > 20 || state.dialogs.name.length == 0)) {
			state.dialogs.errorsList.push('Escolha um nome com o máximo de 20 caracteres.');
		}

		if (!state.dialogs.number || (state.dialogs.number.length != 9)) {
			state.dialogs.errorsList.push('Insira um número com 9 números.');
		}

		if (!state.dialogs.errorsList.length) {
			state.dialogs.currentState = 'loading', state.dialogs.isLoading = true;

			nui.send('addContact', { contactName: state.dialogs.name, contactNumber: state.dialogs.number }).then(data => {
				if (data.state) {
					state.dialogs.currentState = 'done';

					state.contactsList.push({ id: data.id, name: state.dialogs.name, number: state.dialogs.number })
				} else {
					state.dialogs.currentState = 'failure';
				}

				setTimeout(() => {
					state.dialogs.status = false;
				}, 1000);
			});
		}
	},
	submitDialog(state, data) {
		state.dialogs.errorsList = [];

		switch (data.name) {
			case 'callNumber':
				if (!data.submitData.callNumber || (data.submitData.callNumber.length != 9)) {
					state.dialogs.errorsList.push('Insira um número com 9 números.');
				}

				break;
			case 'sendMessage':
				if (!data.submitData.messageNumber || (data.submitData.messageNumber.length != 9)) {
					state.dialogs.errorsList.push('Insira um número com 9 números.');
				}

				if (!data.submitData.messageText || data.submitData.messageText.length == 0) {
					state.dialogs.errorsList.push('Insira uma mensagem para mandar a um número.');
				}

				break;
			case 'addContact':
				if (!data.submitData.contactName || (data.submitData.contactName.length > 20 || data.submitData.contactName.length == 0)) {
					state.dialogs.errorsList.push('Escolha um nome com o máximo de 20 caracteres.');
				}

				if (!data.submitData.contactNumber || (data.submitData.contactNumber.length != 9)) {
					state.dialogs.errorsList.push('Insira um número com 9 números.');
				}
				break;
			default:
				break;
		}

		if (!state.dialogs.errorsList.length) {
			state.dialogs.currentState = 'loading', state.dialogs.isLoading = true;

			nui.send(data.name, data.submitData).then(data => {
				if (data.status) {
					state.dialogs.currentState = 'done';
				} else {
					state.dialogs.currentState = 'failure';
				}

				state.dialogs.currentState = '';
			});
		}
	}
}

export default { namespaced: true, getters, state, actions, mutations }