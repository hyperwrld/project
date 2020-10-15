const state = () => ({
    userCharacters: [{ firstname: 'Lewis', lastname: 'Hamilton', dob: '08/03/1999', gender: 'Masculino', job: 'Polícia'}, {}] //  { firstname: 'Lewis', lastname: 'Hamilton', dob: '08/03/1999', gender: 'Masculino', job: 'Polícia'}
})

const getters = {
    getCharactersData: state => {
        return state.userCharacters;
    }
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
    setData(state, data) {
		state.userCharacters = data

		for (var i = state.userCharacters.length; i < 5; i++) {
			state.userCharacters.push({});
		}
    }
}

export default { namespaced: true, state, getters, actions, mutations }