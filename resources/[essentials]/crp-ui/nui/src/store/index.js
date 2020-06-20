import Vue from 'vue';
import Vuex from 'vuex';

import dialogs from './modules/dialogs';
import characterList from './modules/characterList';

Vue.use(Vuex);

export default new Vuex.Store({
    modules: {
        dialogs,
        characterList,
    }
})