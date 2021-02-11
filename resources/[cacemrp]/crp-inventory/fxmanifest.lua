fx_version 'cerulean'

game 'gta5'

dependecies {
	'crp-ui',
	'crp-lib'
}

shared_scripts {
	'@crp-lib/shared/util.lua',
	'shared/items.lua'
}

client_scripts {
	'@crp-lib/client/main.lua',
	'@crp-lib/client/rpc.lua',
    'client/*.lua'
}

server_scripts {
	'@crp-lib/shared/array.lua',
	'@crp-lib/server/database.lua',
	'@crp-lib/server/rpc.lua',
	'server/classes/inventory.lua',
	'server/*.lua'
}