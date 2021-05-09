const state = () => ({
	tweets: [],
});

const getters = {
	getTweets: (state) => {
		return state.tweets.sort((a, b) => b.id - a.id);
	},
};

const actions = {
	setData(state, data) {
		state.commit('setData', data);
	},
};

const mutations = {
	setData(state, data) {
		state.tweets = data;
	},
};

export default { namespaced: true, getters, state, actions, mutations };
