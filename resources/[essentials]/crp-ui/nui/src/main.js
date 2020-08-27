import Vue from 'vue';

import app from './app.vue';
import vuetify from './plugins/vuetify';
import store from './store';
import router from './router';

import { library } from '@fortawesome/fontawesome-svg-core';
import { faAngleUp, faAngleDown } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

library.add(faAngleUp, faAngleDown);

Vue.component('font-awesome-icon', FontAwesomeIcon);

Vue.config.productionTip = false;

new Vue({
    vuetify, store, router, render: h => h(app)
}).$mount('#app')