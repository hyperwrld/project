import Vue from 'vue'

import app from './app.vue'
import vuetify from './plugins/vuetify';
import store from './store'

import { library } from '@fortawesome/fontawesome-svg-core'
import { faAngleUp, faAngleDown, faHeart, faShieldAlt, faHamburger, faTint, faBrain, faLungs } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

library.add(faAngleUp, faAngleDown, faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain)

Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.config.productionTip = false

new Vue({
    vuetify,
    store,
    render: h => h(app)
}).$mount('#app')