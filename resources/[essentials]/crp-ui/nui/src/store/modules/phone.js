import nui from '../../utils/nui';

const state = {
    apps: [
        { code: 'history', name: 'Telefone', color: '#13b86c', icon: 'phone-alt', iconType: 'fas' }, { code: 'messages', name: 'Mensagens', color: '#0191e7', icon: 'comment-alt', iconType: 'fas' },
        { code: 'contacts', name: 'Contactos', color: '#fc7b20', icon: 'user', iconType: 'fas' }, { code: 'garage', name: 'Garagem', color: '#ef1443', icon: 'car', iconType: 'fas' },
        { code: 'twitter', name: 'Twitter', color: '#1DA1F2', icon: 'twitter', iconType: 'fab' }, { code: 'adverts', name: 'Páginas amarelas', color: '#fddb3a', icon: 'ad', iconType: 'fas' }
    ],
	currentApp: 'home', phoneNumber: 966831664,
	history: [], conversations: [], contacts: [], tweets: [], adverts: [],
	dialogs: { status: false, isLoading: false, currentState: 'loading', currentDialog: '', dialogsData: {}, errorsList: [] }
}

const getters = {
	getCurrentApp: state => {
		return state.currentApp;
	},
	getHistory: state => {
		for (let i = 0; i < state.history.length; i++) {
			let contact = state.contacts.find(element => element.number === state.history[i].number)

			state.history[i].name = contact ? contact.name : state.history[i].number;
		}

        return state.history;
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
	getTweets: state => {
		return state.tweets.sort(function(a, b) {
			return b.id - a.id;
		});
	},
	getAdverts: state => {
		return state.adverts.sort(function(a, b) {
			return b.id - a.id;
		});
	},
	getDialogs: state => {
		return state.dialogs;
	}
}

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
    setCurrentApp(state, appName) {
        state.commit('setCurrentApp', appName);
	},
	receiveTweet(state, data) {
		state.commit('receiveTweet', data);
	},
    setMessages(state, number) {
        state.commit('setMessages', number);
    }
}

const mutations = {
	setData(state, data) {
		state.phoneNumber = data.phoneNumber ? data.phoneNumber : [];
		state.history = data.history ? data.history : [];
		state.conversations = data.conversations ? data.conversations : [];
		state.conversations = data.conversations ? data.conversations : [];
		state.contacts = data.contacts ? data.contacts : [];
		state.tweets = data.tweets ? data.tweets : [];

		state.currentApp = 'home';
	},
    setCurrentApp(state, appName) {
		state.currentApp = appName;

		if (appName == 'home') {
			state.dialogs.status = false;
		}
	},
	receiveTweet(state, data) {
		state.tweets.push(data);
	},
    setMessages(state, number) {
        nui.send('getMessages', { number: number }).then(data => {
			console.log(number)
        });
    }
}

export default { namespaced: true, getters, state, actions, mutations }