import camelCase from 'lodash/camelCase';

const files = require.context('.', true, /\.js$/), modules = {};

files.keys().forEach(fileName => {
  	if (fileName === './index.js') {
		return;
	}

	const moduleName = camelCase(fileName.match(/[ \w-]+?(?=\.)/)[0]);

  	modules[moduleName] = files(fileName).default;
});

export default modules;