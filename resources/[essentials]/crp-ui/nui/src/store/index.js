import Vue from 'vue';
import Vuex from 'vuex';

import app from './modules/app';
import dialogs from './modules/dialogs';

import character from './modules/character';
import spawnSelection from './modules/spawnSelection';
import inventory from './modules/inventory';
import vehicleshop from './modules/vehicleshop';

import cash from './modules/cash';
import hud from './modules/hud';
import notifications from './modules/notifications';
import taskbar from './modules/taskbar';

Vue.use(Vuex);

export default new Vuex.Store({
    modules: {
        app, dialogs,
        character, spawnSelection, inventory, vehicleshop,
        cash, hud, notifications, taskbar
    }
})