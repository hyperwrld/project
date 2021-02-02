import Vue from 'vue';

import './plugins/fontawesome';

import app from './app.vue';
import vuetify from './plugins/vuetify';
import store from './store';
import router from './router';

Vue.config.productionTip = false;

new Vue({
    vuetify, store, router, render: h => h(app)
}).$mount('#app')