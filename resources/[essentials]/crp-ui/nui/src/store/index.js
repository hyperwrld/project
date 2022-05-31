import Vue from 'vue';
import Vuex from 'vuex';
import camelCase from 'lodash/camelCase';

const files = require.context('.', true, /\.js$/),
	modules = {};

files.keys().forEach((fileName) => {
	if (fileName === './index.js' || fileName.includes('data.js')) {
		return;
	}

	const moduleName = camelCase(fileName.match(/[ \w-]+?(?=\.)/)[0]);

	modules[moduleName] = files(fileName).default;
});

Vue.use(Vuex);

export default new Vuex.Store({ modules });
