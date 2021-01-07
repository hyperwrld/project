fx_version 'cerulean'

game 'gta5'

dependecies {
	'crp-ui',
	'crp-lib'
}

client_scripts {
	'@crp-lib/client/main.lua',
	'@crp-lib/client/rpc.lua',
    'client/*.lua'
}

shared_scripts {
	'@crp-lib/shared/util.lua',
	'shared/items.lua'
}

server_scripts {
	'@crp-lib/server/database.lua',
	'@crp-lib/server/rpc.lua',
	'server/classes/inventory.lua',
	'server/*.lua'
}