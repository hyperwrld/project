import Vue from 'vue';

import app from './app.vue';
import vuetify from './plugins/vuetify';
import store from './store';

import { library } from '@fortawesome/fontawesome-svg-core';
import { faAngleUp, faAngleDown, faHeart, faShieldAlt, faHamburger, faTint, faBrain, faLungs, faGasPump, faVolumeUp, faSignal, faPhoneAlt, faUser, faCommentAlt, faAngleLeft, faCar, faAlignJustify, faCamera, faSearch, faClipboard, faUserPlus, faUserEdit, faTrash, faSadTear, faExclamationCircle, faEnvelope, faRetweet, faReply, faEye, faFeatherAlt } from '@fortawesome/free-solid-svg-icons';
import { faCircle } from '@fortawesome/free-regular-svg-icons';
import { faTwitter } from '@fortawesome/free-brands-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

library.add(faAngleUp, faAngleDown, faHeart, faShieldAlt, faHamburger, faTint, faLungs, faBrain, faGasPump, faVolumeUp, faSignal, faPhoneAlt, faCommentAlt, faUser, faAngleLeft, faCircle , faCar, faAlignJustify, faTwitter, faCamera, faSearch, faClipboard, faUserPlus, faUserEdit, faTrash, faSadTear, faExclamationCircle, faEnvelope, faRetweet, faReply, faEye, faFeatherAlt);

Vue.component('font-awesome-icon', FontAwesomeIcon);

Vue.config.productionTip = false;

new Vue({
    vuetify, store, render: h => h(app)
}).$mount('#app')