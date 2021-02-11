fx_version 'cerulean'

game 'gta5'

client_scripts {
	'@crp-lib/client/main.lua',
	'@crp-lib/client/rpc.lua',
	'client/modules/*.lua',
	'client/main.lua'
}

shared_script '@crp-lib/shared/util.lua'

server_scripts {
	'@crp-lib/server/rpc.lua',
	'server/*.lua'
}