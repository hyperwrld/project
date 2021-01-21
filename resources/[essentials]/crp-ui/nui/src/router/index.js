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

import inventory from './../components/character/inventory/inventory.vue';
import actionbar from './../components/character/actionbar/actionbar.vue';

import phone from './../components/character/phone/phone.vue';
import home from './../components/character/phone/apps/home/home.vue';
import history from './../components/character/phone/apps/history/history.vue';
import messages from './../components/character/phone/apps/messages/messages.vue';
import contacts from './../components/character/phone/apps/contacts/contacts.vue';
import twitter from './../components/character/phone/apps/twitter/twitter.vue';
import adverts from './../components/character/phone/apps/adverts/adverts.vue';
import jobs from './../components/character/phone/apps/jobs/jobs.vue';

Vue.use(VueRouter);

export default new VueRouter({
	routes: [
		{
			path: '/selection', name: 'selection', component: selection
		},
		{
			path: '/skincreator', name: 'skincreator', component: skincreator, children: [
				{
					path: 'ped', name: 'ped', component: ped
				},
				{
					path: 'headBlend', name: 'headBlend', component: headBlend
				},
				{
					path: 'faceFeatures', name: 'faceFeatures', component: faceFeatures
				},
				{
					path: 'headOverlays', name: 'headOverlays', component: headOverlays
				},
				{
					path: 'bodyFeatures', name: 'bodyFeatures', component: bodyFeatures
				},
				{
					path: 'clothing', name: 'clothing', component: clothing
				},
				{
					path: 'accessories', name: 'accessories', component: accessories
				}
			]
		},
		{
			path: '/inventory', name: 'inventory', component: inventory
		},
		{
			path: '/actionbar', name: 'actionbar', component: actionbar
		},
		{
			path: '/phone', name: 'phone', component: phone, children: [
				{
					path: '', name: 'home', component: home
				},
				{
					path: 'history', name: 'history', component: history
				},
				{
					path: 'messages', name: 'messages', component: messages
				},
				{
					path: 'contacts', name: 'contacts', component: contacts
				},
				{
					path: 'twitter', name: 'twitter', component: twitter
				},
				{
					path: 'adverts', name: 'adverts', component: adverts
				},
				{
					path: 'jobs', name: 'jobs', component: jobs
				}
			]
		}
	]
})