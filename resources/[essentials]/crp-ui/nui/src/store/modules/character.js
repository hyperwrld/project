import nui from '../../utils/nui';

const state = () => ({
    userCharacters: [] //  { firstname: 'Lewis', lastname: 'Hamilton', dob: '08/03/1999', gender: 'Masculino', job: 'Polícia'}
})

const getters = {
    getCharactersData: state => {
        return state.userCharacters;
    }
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    },
    setCurrentItem(state, data) {
        state.commit('setCurrentItem', data);
    },
    addCharacter(state, data) {
        state.commit('addCharacter', data);
    },
    deleteCharacter(state, data) {
        state.commit('deleteCharacter', data);
    },
    selectCharacter(state, data) {
        state.commit('selectCharacter', data);
    }
}

const mutations = {
    setData(state, data) {
		state.userCharacters = data

		for (var i = state.userCharacters.length; i < 5; i++) {
			state.userCharacters.push({});
		}
    },
    setCurrentItem(state, data) {
        state.currentItem = data;
    },
    addCharacter(state, data) {
        const charactersArray = state.userCharacters.map(element => element.length == 0);

        state.userCharacters[charactersArray.indexOf('create')] = data;
    },
    deleteCharacter(state) {
        nui.send('deleteCharacter', state.userCharacters[state.currentItem].id).then(data => {
            if (data.status) state.userCharacters[state.currentItem] = {};
        });
    },
    selectCharacter(state, characterId) {
        nui.send('selectCharacter', characterId).then(data => {
			// if (data.status) - remove menu from screen.
        });
    }
}

export default { namespaced: true, state, getters, actions, mutations }