import Vue from 'vue';
import Vuex from 'vuex';

import dialogs from './modules/dialogs';
import character from './modules/character';
import cash from './modules/cash';
import hud from './modules/hud';

Vue.use(Vuex);

export default new Vuex.Store({
    modules: {
        dialogs,
        character,
        cash,
        hud
    }
})