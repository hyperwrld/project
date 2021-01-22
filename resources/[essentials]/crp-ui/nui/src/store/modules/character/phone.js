const state = () => ({
	currentNumber: undefined, history: [], messages: [], contacts: [], tweets: [], adverts: [], jobList: [], jobGroup: {}
})

const getters = {
	getHistory: state => {
		for (let i = 0; i < state.history.length; i++) {
			let contact = state.contacts.find(element => element.number === state.history[i].number)

			state.history[i].name = contact ? contact.name : state.history[i].number;
		}

        return state.history;
	},
	getMessages: state => {
		for (let i = 0; i < state.messages.length; i++) {
			let name = state.currentNumber != state.messages[i].sender ? state.messages[i].sender : state.messages[i].receiver;
			let contact = state.contacts.find(element => element.number === name);

			state.messages[i].name = contact ? contact.name : name;
		}

		return state.messages;
	},
	getContacts: state => {
		return state.contacts.sort((a, b) => a.name.localeCompare(b.name));
	},
	getTweets: state => {
		return state.tweets.sort(function(a, b) {
			return b.id - a.id;
		});
	},
	getAdverts: state => {
		return state.adverts.sort((a, b) => b.id - a.id);
	},
	getJobList: state => {
		return state.jobList;
	},
	getJobGroup: state => {
		return state.jobGroup;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
	},
	setJobList(state, data) {
        state.commit('setJobList', data);
    },
}

const mutations = {
	setData(state, data) {

	},
	setJobList(state, data) {
		state.jobList = data;
	}
}

export default { namespaced: true, getters, state, actions, mutations }