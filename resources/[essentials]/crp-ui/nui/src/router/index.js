import Vue from 'vue';
import VueRouter from 'vue-router';

import character from './../components/character/character.vue';
import intro from './../components/character/intro/intro.vue';
import selection from './../components/character/selection/selection.vue';
import spawn from './../components/spawn/spawn.vue';
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
			path: '/character',
			name: 'character',
			component: character,
			children: [
				{ path: 'intro', name: 'intro', component: intro }, { path: 'selection', name: 'selection', component: selection }
			]
		},
		{
			path: '/spawn',
			name: 'spawn',
			component: spawn
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