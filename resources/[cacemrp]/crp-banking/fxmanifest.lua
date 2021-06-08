fx_version 'cerulean'

game 'gta5'

client_scripts {
	'@crp-lib/client/main.js',
	'dist/client/*.js'
}

server_scripts {
	'@crp-lib/server/database.js',
	'@crp-lib/server/main.js',
	'dist/server/*.js'
}
