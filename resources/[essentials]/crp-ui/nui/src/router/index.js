import Vue from 'vue';
import VueRouter from 'vue-router';

import selection from './../components/character/selection/selection.vue';

import skincreator from './../components/character/skincreator/skincreator.vue';
import ped from './../components/character/skincreator/modules/ped.vue';
import headBlend from './../components/character/skincreator/modules/headBlend.vue';
import faceFeatures from './../components/character/skincreator/modules/faceFeatures.vue';
import headOverlays from './../components/character/skincreator/modules/headOverlays.vue';
import bodyFeatures from './../components/character/skincreator/modules/bodyFeatures.vue';
import clothing from './../components/character/skincreator/modules/clothing.vue';
import accessories from './../components/character/skincreator/modules/accessories.vue';

import inventory from './../components/inventory/main/inventory.vue';
import actionbar from './../components/inventory/actionbar/actionbar.vue';

import phone from './../components/phone/phone.vue';
import home from './../components/phone/home/home.vue';
import history from './../components/phone/history/history.vue';
import contacts from './../components/phone/contacts/contacts.vue';
import messages from './../components/phone/messages/messages.vue';
import message from './../components/phone/messages/message/message.vue';
import twitter from './../components/phone/twitter/twitter.vue';
import adverts from './../components/phone/adverts/adverts.vue';

import menu from './../components/menu/menu.vue';

import vehicleshop from './../components/vehicleshop/vehicleshop.vue';

Vue.use(VueRouter);

export default new VueRouter({
	routes: [
		{
			path: '/selection', component: selection
		},
		{
			path: '/skincreator', component: skincreator,
			children: [
				{ path: 'ped', name: 'ped', component: ped }, { path: 'headBlend', name: 'headBlend', component: headBlend },
				{ path: 'faceFeatures', name: 'faceFeatures', component: faceFeatures }, { path: 'headOverlays', name: 'headOverlays', component: headOverlays },
				{ path: 'bodyFeatures', name: 'bodyFeatures', component: bodyFeatures }, { path: 'clothing', name: 'clothing', component: clothing },
				{ path: 'accessories', name: 'accessories', component: accessories }
			]
		},
		{
			path: '/inventory',
			name: 'inventory',
			component: inventory
		},
		{
			path: '/actionbar',
			name: 'actionbar',
			component: actionbar
		},
		{
			path: '/phone',
			name: 'phone',
			component: phone,
			children: [
				{ path: '',         name: 'home',     component: home     }, { path: 'history',  name: 'history',  component: history  },
				{ path: 'contacts', name: 'contacts', component: contacts }, { path: 'messages', name: 'messages', component: messages },
				{ path: 'message',  name: 'message',  component: message  }, { path: 'twitter',  name: 'twitter',  component: twitter  },
				{ path: 'adverts',  name: 'adverts',  component: adverts  }
			]
		},
		{
			path: '/menu',
			name: 'menu',
			component: menu,
		},
		{
			path: '/vehicleshop',
			name: 'vehicleshop',
			component: vehicleshop
		}
	]
})