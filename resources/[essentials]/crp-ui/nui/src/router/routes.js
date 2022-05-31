const routes = [
	{
		path: '/selection',
		name: 'selection',
		component: () =>
			import('./../components/interface/selection/selection.vue'),
	},
	{
		path: '/skincreator',
		name: 'skincreator',
		component: () =>
			import('./../components/interface/skincreator/skincreator.vue'),
		children: [
			{
				path: 'ped',
				name: 'ped',
				component: () =>
					import('./../components/interface/skincreator/modules/ped.vue'),
			},
			{
				path: 'headBlend',
				name: 'headBlend',
				component: () =>
					import('./../components/interface/skincreator/modules/headBlend.vue'),
			},
			{
				path: 'faceFeatures',
				name: 'faceFeatures',
				component: () =>
					import(
						'./../components/interface/skincreator/modules/faceFeatures.vue'
					),
			},
			{
				path: 'headOverlays',
				name: 'headOverlays',
				component: () =>
					import(
						'./../components/interface/skincreator/modules/headOverlays.vue'
					),
			},
			{
				path: 'bodyFeatures',
				name: 'bodyFeatures',
				component: () =>
					import(
						'./../components/interface/skincreator/modules/bodyFeatures.vue'
					),
			},
			{
				path: 'clothing',
				name: 'clothing',
				component: () =>
					import('./../components/interface/skincreator/modules/clothing.vue'),
			},
			{
				path: 'accessories',
				name: 'accessories',
				component: () =>
					import(
						'./../components/interface/skincreator/modules/accessories.vue'
					),
			},
		],
	},
	{
		path: '/inventory',
		name: 'inventory',
		component: () =>
			import('./../components/interface/inventory/inventory.vue'),
	},
	{
		path: '/actionbar',
		name: 'actionbar',
		component: () =>
			import('./../components/interface/actionbar/actionbar.vue'),
	},
	{
		path: '/phone',
		name: 'phone',
		component: () => import('./../components/interface/phone/phone.vue'),
		children: [
			{
				path: '',
				name: 'home',
				component: () =>
					import('./../components/interface/phone/apps/home/home.vue'),
			},
			{
				path: 'history',
				name: 'history',
				component: () =>
					import('./../components/interface/phone/apps/history/history.vue'),
			},
			{
				path: 'messages',
				name: 'messages',
				component: () =>
					import('./../components/interface/phone/apps/messages/messages.vue'),
			},
			{
				path: 'contacts',
				name: 'contacts',
				component: () =>
					import('./../components/interface/phone/apps/contacts/contacts.vue'),
			},
			{
				path: 'twitter',
				name: 'twitter',
				component: () =>
					import('./../components/interface/phone/apps/twitter/twitter.vue'),
			},
			{
				path: 'adverts',
				name: 'adverts',
				component: () =>
					import('./../components/interface/phone/apps/adverts/adverts.vue'),
			},
			{
				path: 'jobs',
				name: 'jobs',
				component: () =>
					import('./../components/interface/phone/apps/jobs/jobs.vue'),
			},
			{
				path: '*',
				component: () =>
					import('./../components/interface/phone/apps/default/default.vue'),
			},
		],
	},
	{
		path: '/banking',
		name: 'banking',
		component: () => import('./../components/interface/banking/banking.vue'),
	},
	// {
	// 	path: '/',
	// 	component: () => import('layouts/MainLayout.vue'),
	// 	children: [
	//   		{ path: '', component: () => import('pages/Index.vue') }
	// 	]
	// },
	// Always leave this as last one,
	// but you can also remove it
	// {
	// 	path: '*',
	// 	component: () => import('pages/Error404.vue')
	// }
];

export default routes;
