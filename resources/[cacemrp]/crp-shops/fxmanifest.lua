fx_version 'cerulean'

game 'gta5'

dependecie 'crp-lib'

client_scripts {
	'@crp-lib/client/main.lua',
	'@crp-lib/client/rpc.lua',
	'client/*.lua',
}

shared_scripts {
	'@crp-lib/shared/util.lua'
}

server_scripts {
	'@crp-lib/server/rpc.lua'
}