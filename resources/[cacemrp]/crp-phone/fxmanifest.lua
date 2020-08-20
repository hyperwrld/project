fx_version 'bodacious'

game 'gta5'

client_scripts {
	'@crp-base/client/modules/rpc.lua',
	'client/main.lua',
	'client/apps/*.lua'
}

server_scripts {
	'@crp-base/server/modules/rpc.lua',
	'@crp-base/server/modules/database.lua',
	'server/main.lua',
	'server/apps/*.lua'
}