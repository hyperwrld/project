import nui from '../../utils/nui';

const state = () => ({
    userCharacters: [],
    currentItem: 0,
    loading: { status: false, message: 'Aguarde...' }
})

const getters = {
    getCharactersData: state => {
        return state.userCharacters;
    },
}

const actions = {
    setLoading(state, data) {
        setTimeout(() => {
            state.commit('setLoading', data);
        }, data.time);
    },
    setUserCharacters(state) {
        state.commit('setUserCharacters');
    },
    setCurrentItem(state, data) {
        state.commit('setCurrentItem', data);
    },
    addCharacter(state, data) {
        state.commit('addCharacter', data);
    },
    removeCharacter(state) {
        state.commit('removeCharacter');
    },
    selectCharacter(state) {
        state.commit('selectCharacter');
    }
}

const mutations = {
    setLoading(state, data) {
        state.loading = { status: data.status, message: data.message };
    },
    setUserCharacters(state) {
        state.loading = { status: true, message: 'Aguarde enquanto carregamos os seus personagens...' };

        nui.send('fetchCharacters').then(data => {
            state.userCharacters = data

            for (var i = state.userCharacters.length; i < 5; i++) {
                state.userCharacters.push({ option: 'create', name: '...' });
            }

            setTimeout(() => {
                state.loading = { status: false };
            }, 5000);
        });
    },
    setCurrentItem(state, data) {
        state.currentItem = data;
    },
    addCharacter(state, data) {
        state.loading = { status: true, message: 'Aguarde enquanto criamos o seu personagem...' };

        const charactersArray = state.userCharacters.map(element => element.option);

        state.userCharacters[charactersArray.indexOf('create')] = data;

        setTimeout(() => {
            state.loading = { status: false };
        }, 3000);
    },
    removeCharacter(state) {
        state.loading = { status: true, message: 'Aguarde enquanto tentamos eliminar o seu personagem...' };

        nui.send('deleteCharacter', state.userCharacters[state.currentItem].id).then(data => {
            if (data.status) {
                state.userCharacters[state.currentItem] = { option: 'create', name: '...' };
            }

            setTimeout(() => {
                state.loading = { status: false };
            }, 3000);
        });
    },
    selectCharacter(state) {
        state.loading = { status: true, message: 'Aguarde enquanto carregamos o seu personagem...' };

        nui.send('selectCharacter', state.userCharacters[state.currentItem].id).then(() => {
            setTimeout(() => {
                state.loading = { status: false };
            }, 2500);
        });
    }
}

export default { namespaced: true, state, getters, actions, mutations }