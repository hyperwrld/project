fx_version 'adamant'

game 'gta5'

client_scripts {
    '@crp-lib/client/main.lua',
	'@crp-lib/client/rpc.lua',
	'client/main.lua'
}

shared_script '@crp-lib/shared/util.lua'

server_script {
	'@crp-lib/server/rpc.lua',
	'server/*.lua'
}